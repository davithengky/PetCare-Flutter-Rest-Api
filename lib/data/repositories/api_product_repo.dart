import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/product_model.dart';
import 'product_repo.dart';

/// Implementasi [ProductRepo] yang terhubung ke REST API PetCare.
class ApiProductRepo implements ProductRepo {
  ApiProductRepo(this._client);

  final ApiClient _client;

  @override
  Future<List<Product>> getProducts({String? search, String? category}) async {
    final res = await _client.get(
      '/products',
      query: {
        'search': search,
        'category': _normalizeFilter(category),
      },
    );
    return apiList(res).map(Product.fromJson).toList();
  }

  @override
  Future<Product?> getProductById(int id) async {
    final res = await _client.get('/products/$id');
    final map = apiMap(res);
    return map.isEmpty ? null : Product.fromJson(map);
  }

  @override
  Future<List<String>> getCategories() async {
    final res = await _client.get('/product-categories');
    return apiList(res)
        .map((json) => json['name'])
        .whereType<String>()
        .toList();
  }

  /// Mengabaikan filter kategori "Semua"/kosong agar tidak dikirim ke server.
  String? _normalizeFilter(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'semua') return null;
    return trimmed;
  }
}
