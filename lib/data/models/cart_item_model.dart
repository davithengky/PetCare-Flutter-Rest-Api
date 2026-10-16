import 'product_model.dart';

/// Model item keranjang belanja untuk Pet Shop.
class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  /// Menghitung subtotal harga item berdasarkan kuantitas.
  double get subtotal => product.price * quantity;

  /// Membuat salinan objek dengan nilai yang diperbarui secara opsional.
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Membuat instance [CartItem] dari Map JSON.
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  /// Mengonversi instance [CartItem] ke Map JSON untuk persistensi lokal.
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'CartItem(product: ${product.name}, quantity: $quantity, subtotal: $subtotal)';
  }
}
