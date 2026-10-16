/// Model data produk yang dijual di Pet Shop PetCare Vet Clinic.
class Product {
  final int id;
  final String name;
  final String category; // 'Makanan' | 'Obat' | 'Mainan' | 'Aksesoris'
  final double price;
  final double? originalPrice;
  final int stock;
  final String? description;
  final String? imageUrl;
  final double rating;
  final int soldCount;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.stock,
    this.description,
    this.imageUrl,
    required this.rating,
    required this.soldCount,
  });

  /// Mengecek apakah produk sedang dalam harga diskon.
  bool get isDiscounted => originalPrice != null && originalPrice! > price;

  /// Menghitung persentase diskon produk.
  double get discountPercent =>
      isDiscounted ? ((originalPrice! - price) / originalPrice! * 100) : 0;

  /// Membuat instance [Product] dari format Map JSON.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: (json['category_name'] as String?) ?? '',
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      stock: json['stock'] as int,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      rating: (json['rating'] as num).toDouble(),
      soldCount: json['sold_count'] as int,
    );
  }

  /// Mengonversi instance [Product] ke format Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'original_price': originalPrice,
      'stock': stock,
      'description': description,
      'image_url': imageUrl,
      'rating': rating,
      'sold_count': soldCount,
    };
  }

  /// Membuat salinan instance [Product] dengan nilai yang diperbarui secara opsional.
  Product copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    double? originalPrice,
    int? stock,
    String? description,
    String? imageUrl,
    double? rating,
    int? soldCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      soldCount: soldCount ?? this.soldCount,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, category: $category, price: $price, stock: $stock, rating: $rating, soldCount: $soldCount)';
  }
}
