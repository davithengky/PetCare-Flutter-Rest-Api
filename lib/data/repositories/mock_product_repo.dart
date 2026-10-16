import '../mocks/mock_products.dart';
import '../models/product_model.dart';
import 'product_repo.dart';

/// Implementasi in-memory mock repository untuk katalog produk Pet Shop.
class MockProductRepo implements ProductRepo {
  final List<Product> _products = List.from(mockProducts);

  @override
  Future<List<Product>> getProducts({String? search, String? category}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return _products.where((product) {
      // Filter berdasarkan pencarian nama produk
      if (search != null && search.trim().isNotEmpty) {
        final query = search.trim().toLowerCase();
        if (!product.name.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Filter berdasarkan kategori
      if (category != null && category.trim().isNotEmpty && category != 'Semua') {
        if (product.category.toLowerCase() != category.trim().toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Future<Product?> getProductById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const ['Makanan', 'Obat', 'Mainan', 'Aksesoris'];
  }
}
