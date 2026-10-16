import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import 'order_repo.dart';

/// Implementasi [OrderRepo] yang terhubung ke REST API PetCare.
class ApiOrderRepo implements OrderRepo {
  ApiOrderRepo(this._client);

  final ApiClient _client;

  @override
  Future<Order> createOrder({
    required int userId,
    required List<CartItem> items,
    required String shippingAddress,
  }) async {
    final res = await _client.post(
      '/orders',
      body: {
        'shipping_address': shippingAddress,
        'items': items
            .map((item) => {
                  'product_id': item.product.id,
                  'quantity': item.quantity,
                })
            .toList(),
      },
    );

    return Order.fromJson(apiMap(res));
  }

  @override
  Future<List<Order>> getUserOrders(int userId) async {
    final res = await _client.get('/orders');
    return apiList(res).map(Order.fromJson).toList();
  }

  @override
  Future<Order?> getOrderById(int id) async {
    final res = await _client.get('/orders/$id');
    final map = apiMap(res);
    return map.isEmpty ? null : Order.fromJson(map);
  }

  @override
  Future<void> cancelOrder(int id) async {
    await _client.patch('/orders/$id/cancel');
  }
}
