import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import 'order_repo.dart';

/// Implementasi in-memory mock repository untuk pengelolaan pesanan Pet Shop.
class MockOrderRepo implements OrderRepo {
  final List<Order> _orders = [
    // Dummy riwayat pesanan untuk demo (ditampilkan di semua akun).
    Order(
      id: 101,
      userId: 1,
      items: const [
        OrderItem(
          productId: 2,
          productName: 'Whiskas Tuna 1.2kg',
          quantity: 2,
          priceAtPurchase: 85000,
          imageUrl:
              'https://images.pexels.com/photos/28824163/pexels-photo-28824163.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
        OrderItem(
          productId: 13,
          productName: 'Tongkat Bulu Kucing Interaktif',
          quantity: 1,
          priceAtPurchase: 35000,
          imageUrl:
              'https://images.pexels.com/photos/26706493/pexels-photo-26706493.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
      ],
      totalAmount: 205000,
      shippingAddress: 'Jl. Raya Darmo No. 88, Surabaya, 081234567890',
      status: 'shipped',
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
    ),
    Order(
      id: 102,
      userId: 1,
      items: const [
        OrderItem(
          productId: 5,
          productName: 'Royal Canin Kitten 2kg',
          quantity: 1,
          priceAtPurchase: 110000,
          imageUrl:
              'https://images.pexels.com/photos/34719941/pexels-photo-34719941.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
        OrderItem(
          productId: 20,
          productName: 'Pasir Kucing Gumpal 10L',
          quantity: 2,
          priceAtPurchase: 45000,
          imageUrl:
              'https://images.pexels.com/photos/13705506/pexels-photo-13705506.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
      ],
      totalAmount: 200000,
      shippingAddress: 'Jl. Raya Darmo No. 88, Surabaya, 081234567890',
      status: 'waiting_payment',
      createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 2)),
    ),
  ];
  int _nextId = 103;

  @override
  Future<Order> createOrder({
    required int userId,
    required List<CartItem> items,
    required String shippingAddress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Hitung total nilai belanjaan
    final totalAmount = items.fold<double>(
      0.0,
      (sum, item) => sum + item.subtotal,
    );

    // Konversi CartItem menjadi OrderItem
    final orderItems = items.map((cartItem) {
      return OrderItem(
        productId: cartItem.product.id,
        productName: cartItem.product.name,
        quantity: cartItem.quantity,
        priceAtPurchase: cartItem.product.price,
        imageUrl: cartItem.product.imageUrl,
      );
    }).toList();

    final newOrder = Order(
      id: _nextId++,
      userId: userId,
      items: orderItems,
      totalAmount: totalAmount,
      shippingAddress: shippingAddress,
      status: 'waiting_payment',
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    return newOrder;
  }

  @override
  Future<List<Order>> getUserOrders(int userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mode demo: seluruh riwayat mock ditampilkan untuk akun mana pun.
    final list = List<Order>.from(_orders);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<Order?> getOrderById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cancelOrder(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _orders.indexWhere((o) => o.id == id);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: 'cancelled');
    }
  }
}
