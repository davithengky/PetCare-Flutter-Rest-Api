import '../models/product_model.dart';

/// Kontrak repositori untuk data produk katalog Pet Shop.
abstract class ProductRepo {
  /// Mengambil daftar produk dengan filter opsional pencarian [search] dan kategori [category].
  Future<List<Product>> getProducts({String? search, String? category});

  /// Mengambil detail produk berdasarkan [id].
  Future<Product?> getProductById(int id);

  /// Mengambil daftar nama kategori produk yang tersedia.
  Future<List<String>> getCategories();
}
