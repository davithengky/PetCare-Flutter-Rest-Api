import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/article_model.dart';
import 'article_repo.dart';

/// Implementasi [ArticleRepo] yang terhubung ke REST API PetCare.
class ApiArticleRepo implements ArticleRepo {
  ApiArticleRepo(this._client);

  final ApiClient _client;

  @override
  Future<List<Article>> getArticles({String? search, String? category}) async {
    final res = await _client.get(
      '/articles',
      query: {
        'search': search,
        'category': _normalizeFilter(category),
      },
    );
    return apiList(res).map(Article.fromJson).toList();
  }

  @override
  Future<Article?> getArticleById(int id) async {
    final res = await _client.get('/articles/$id');
    final map = apiMap(res);
    return map.isEmpty ? null : Article.fromJson(map);
  }

  @override
  Future<List<String>> getCategories() async {
    // Backend tidak menyediakan endpoint kategori artikel; daftar tetap
    // disamakan dengan filter yang dipakai pada UI.
    return const [
      'Semua',
      'Makanan',
      'Perawatan',
      'Penyakit',
      'Perilaku',
      'Tips',
    ];
  }

  /// Mengabaikan filter kategori "Semua"/kosong agar tidak dikirim ke server.
  String? _normalizeFilter(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'semua') return null;
    return trimmed;
  }
}
