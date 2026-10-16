import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/api/api_client.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/api_product_repo.dart';
import '../../../data/repositories/product_repo.dart';

/// Provider singleton repositori produk Pet Shop.
final productRepoProvider = Provider<ProductRepo>((ref) {
  return ApiProductRepo(ref.watch(apiClientProvider));
});

/// Model data kondisi filter dan pencarian katalog produk.
class ProductFilter {
  final String search;
  final String? category;

  const ProductFilter({
    required this.search,
    this.category,
  });

  ProductFilter copyWith({
    String? search,
    String? category,
    bool clearCategory = false,
  }) {
    return ProductFilter(
      search: search ?? this.search,
      category: clearCategory ? null : (category ?? this.category),
    );
  }
}

/// Notifier pengelola state filter pencarian dan kategori produk.
class ProductFilterNotifier extends Notifier<ProductFilter> {
  @override
  ProductFilter build() => const ProductFilter(search: '', category: null);

  void setSearch(String s) {
    state = state.copyWith(search: s);
  }

  void setCategory(String? c) {
    if (c == null || c == 'Semua') {
      state = state.copyWith(clearCategory: true);
    } else {
      state = state.copyWith(category: c);
    }
  }

  void reset() {
    state = const ProductFilter(search: '', category: null);
  }
}

/// Provider state filter produk.
final productFilterProvider =
    NotifierProvider<ProductFilterNotifier, ProductFilter>(
  ProductFilterNotifier.new,
);

/// AsyncNotifier untuk memuat daftar produk berdasarkan filter aktif.
class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final filter = ref.watch(productFilterProvider);
    final repo = ref.watch(productRepoProvider);
    return repo.getProducts(search: filter.search, category: filter.category);
  }
}

/// Provider daftar produk aktif.
final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

/// Provider daftar kategori produk yang tersedia.
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  return ref.read(productRepoProvider).getCategories();
});

/// Provider untuk mengambil detail produk spesifik berdasarkan [id].
final productByIdProvider =
    FutureProvider.family<Product?, int>((ref, id) async {
  return ref.read(productRepoProvider).getProductById(id);
});
