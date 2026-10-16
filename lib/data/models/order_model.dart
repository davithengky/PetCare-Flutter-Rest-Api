/// Model item produk di dalam pesanan (Order).
class OrderItem {
  final int productId;
  final String productName;
  final int quantity;
  final double priceAtPurchase;
  final String? imageUrl;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceAtPurchase,
    this.imageUrl,
  });

  /// Menghitung subtotal dari item pesanan ini.
  double get subtotal => priceAtPurchase * quantity;

  /// Membuat instance [OrderItem] dari Map JSON.
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
      priceAtPurchase: (json['price_at_purchase'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
    );
  }

  /// Mengonversi instance [OrderItem] ke Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price_at_purchase': priceAtPurchase,
      'image_url': imageUrl,
    };
  }

  /// Membuat salinan objek dengan nilai yang diperbarui secara opsional.
  OrderItem copyWith({
    int? productId,
    String? productName,
    int? quantity,
    double? priceAtPurchase,
    String? imageUrl,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      priceAtPurchase: priceAtPurchase ?? this.priceAtPurchase,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

/// Model pesanan pembelian produk dari Pet Shop PetCare.
class Order {
  final int id;
  final int userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String shippingAddress;
  /// Status pesanan: 'waiting_payment' | 'processing' | 'shipped' | 'delivered' | 'cancelled'
  final String status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.status,
    required this.createdAt,
  });

  /// Membuat instance [Order] dari Map JSON.
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      shippingAddress: json['shipping_address'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Mengonversi instance [Order] ke Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((i) => i.toJson()).toList(),
      'total_amount': totalAmount,
      'shipping_address': shippingAddress,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Membuat salinan objek dengan nilai yang diperbarui secara opsional.
  Order copyWith({
    int? id,
    int? userId,
    List<OrderItem>? items,
    double? totalAmount,
    String? shippingAddress,
    String? status,
    DateTime? createdAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, userId: $userId, itemsCount: ${items.length}, total: $totalAmount, status: $status)';
  }
}
