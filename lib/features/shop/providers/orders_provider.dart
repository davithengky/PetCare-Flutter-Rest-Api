import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/api/api_client.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/api_order_repo.dart';
import '../../../data/repositories/order_repo.dart';

/// Provider singleton repositori pesanan.
final orderRepoProvider = Provider<OrderRepo>((ref) {
  return ApiOrderRepo(ref.watch(apiClientProvider));
});

/// Provider riwayat pesanan berdasarkan [userId].
final userOrdersProvider =
    FutureProvider.family<List<Order>, int>((ref, userId) async {
  return ref.read(orderRepoProvider).getUserOrders(userId);
});

/// AsyncNotifier untuk aksi pembuatan pesanan baru.
class CreateOrderNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Mengirimkan pesanan belanja dan menyegarkan riwayat pesanan.
  Future<Order?> create({
    required int userId,
    required List<CartItem> items,
    required String shippingAddress,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(orderRepoProvider);
      final order = await repo.createOrder(
        userId: userId,
        items: items,
        shippingAddress: shippingAddress,
      );

      // Refresh riwayat order user
      ref.invalidate(userOrdersProvider(userId));

      state = const AsyncData(null);
      return order;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

/// Provider aksi membuat pesanan belanja.
final createOrderProvider =
    AsyncNotifierProvider<CreateOrderNotifier, void>(CreateOrderNotifier.new);
