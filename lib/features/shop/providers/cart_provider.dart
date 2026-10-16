import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/api/api_client.dart';
import '../../../data/api/api_helpers.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/product_model.dart';

/// Notifier pengelola keranjang belanja (Cart).
///
/// Strategi hybrid:
/// * Keranjang lokal (SharedPreferences) dipakai sebagai sumber utama UI dan
///   cadangan ketika server tidak tersedia / pengguna belum login.
/// * Setiap perubahan juga dicerminkan ke keranjang server (`/api/cart`) secara
///   best-effort, dan keranjang server digabungkan saat aplikasi dimulai.
class CartNotifier extends Notifier<List<CartItem>> {
  static const String _storageKey = 'cart_items';

  /// Pemetaan product_id -> id item keranjang di server (untuk update/hapus).
  final Map<int, int> _serverItemIds = {};

  @override
  List<CartItem> build() {
    // Membaca data tersimpan di SharedPreferences secara asinkron saat pertama kali build
    _bootstrap();
    return const [];
  }

  /// Memuat keranjang lokal lebih dulu, lalu menggabungkannya dengan server.
  Future<void> _bootstrap() async {
    await _loadFromPrefs();
    await _syncFromServer();
  }

  /// Membaca keranjang belanja dari SharedPreferences.
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        state = decoded
            .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Abaikan error format data lokal korup
    }
  }

  /// Menyimpan keranjang belanja saat ini ke SharedPreferences.
  Future<void> _saveToPrefs(List<CartItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (_) {}
  }

  /// Mengambil keranjang dari server dan menggabungkannya dengan keranjang lokal.
  ///
  /// Bila server tidak tersedia (atau pengguna belum login), keranjang lokal
  /// tetap dipakai tanpa perubahan.
  Future<void> _syncFromServer() async {
    try {
      final res = await ref.read(apiClientProvider).get('/cart');

      final serverItems = <int, CartItem>{};
      _serverItemIds.clear();

      for (final row in apiList(res)) {
        final productId = row['product_id'];
        final itemId = row['id'];
        final productJson = row['product'];

        if (productId is int && itemId is int) {
          _serverItemIds[productId] = itemId;
        }
        if (productId is int && productJson is Map<String, dynamic>) {
          serverItems[productId] = CartItem(
            product: Product.fromJson(productJson),
            quantity: (row['quantity'] as num).toInt(),
          );
        }
      }

      // Gabungkan: item server diutamakan, item lokal yang belum ada di server
      // dipertahankan lalu dikirim ke server.
      final merged = <CartItem>[];
      final localOnly = <CartItem>[];

      for (final item in state) {
        final serverItem = serverItems.remove(item.product.id);
        if (serverItem != null) {
          merged.add(serverItem);
        } else {
          merged.add(item);
          localOnly.add(item);
        }
      }
      merged.addAll(serverItems.values);

      state = merged;
      await _saveToPrefs(merged);

      for (final item in localOnly) {
        await _pushAdd(item.product.id, item.quantity);
      }
    } catch (_) {
      // Server tidak tersedia / belum login -> pakai keranjang lokal.
    }
  }

  /// Mengirim penambahan produk ke keranjang server (best-effort).
  Future<void> _pushAdd(int productId, int quantity) async {
    if (!await _hasToken()) return;
    try {
      final res = await ref.read(apiClientProvider).post(
            '/cart',
            body: {'product_id': productId, 'quantity': quantity},
          );
      final itemId = apiMap(res)['id'];
      if (itemId is int) {
        _serverItemIds[productId] = itemId;
      }
    } catch (_) {
      // Diabaikan; keranjang lokal tetap valid.
    }
  }

  /// Menjalankan aksi sinkronisasi ke server tanpa mengganggu UI.
  Future<void> _push(Future<void> Function() action) async {
    if (!await _hasToken()) return;
    try {
      await action();
    } catch (_) {
      // Diabaikan; keranjang lokal tetap valid.
    }
  }

  /// Memeriksa ketersediaan token login sebelum menyentuh keranjang server.
  Future<bool> _hasToken() async {
    final token = await ref.read(secureStorageProvider).getToken();
    return token != null && token.isNotEmpty;
  }

  /// Menambahkan produk ke keranjang belanja.
  void addItem(Product product, {int quantity = 1}) {
    final existingIndex =
        state.indexWhere((item) => item.product.id == product.id);

    List<CartItem> updated;
    if (existingIndex != -1) {
      final current = state[existingIndex];
      final newQty = current.quantity + quantity;
      updated = List.of(state);
      updated[existingIndex] = current.copyWith(quantity: newQty);
    } else {
      updated = [
        ...state,
        CartItem(product: product, quantity: quantity),
      ];
    }

    state = updated;
    _saveToPrefs(updated);
    _pushAdd(product.id, quantity);
  }

  /// Menghapus item produk dari keranjang berdasarkan [productId].
  void removeItem(int productId) {
    final updated =
        state.where((item) => item.product.id != productId).toList();
    state = updated;
    _saveToPrefs(updated);

    final itemId = _serverItemIds.remove(productId);
    if (itemId != null) {
      _push(() => ref.read(apiClientProvider).delete('/cart/$itemId'));
    }
  }

  /// Memperbarui kuantitas produk dalam keranjang belanja.
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final updated = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = updated;
    _saveToPrefs(updated);

    final itemId = _serverItemIds[productId];
    if (itemId != null) {
      _push(
        () => ref
            .read(apiClientProvider)
            .put('/cart/$itemId', body: {'quantity': quantity}),
      );
    }
  }

  /// Mengosongkan keranjang belanja (setelah checkout berhasil).
  void clear() {
    state = const [];
    _saveToPrefs(const []);
    _serverItemIds.clear();
    _push(() => ref.read(apiClientProvider).delete('/cart'));
  }

  /// Menghitung total harga seluruh isi keranjang belanja.
  double get totalPrice {
    return state.fold<double>(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Menghitung total jumlah seluruh barang dalam keranjang belanja.
  int get totalItems {
    return state.fold<int>(0, (sum, item) => sum + item.quantity);
  }
}

/// Provider state keranjang belanja.
final cartProvider =
    NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

/// Provider pembantu untuk menghitung total kuantitas barang di keranjang belanja.
final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold<int>(0, (sum, item) => sum + item.quantity);
});
