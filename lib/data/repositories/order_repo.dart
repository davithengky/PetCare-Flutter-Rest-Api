import '../models/cart_item_model.dart';
import '../models/order_model.dart';

/// Kontrak repositori untuk transaksi dan riwayat pesanan (Order) Pet Shop.
abstract class OrderRepo {
  /// Membuat pesanan baru dari daftar item keranjang belanja.
  Future<Order> createOrder({
    required int userId,
    required List<CartItem> items,
    required String shippingAddress,
  });

  /// Mengambil daftar seluruh pesanan milik [userId].
  Future<List<Order>> getUserOrders(int userId);

  /// Mengambil detail pesanan berdasarkan [id].
  Future<Order?> getOrderById(int id);

  /// Membatalkan pesanan berdasarkan [id].
  Future<void> cancelOrder(int id);
}
