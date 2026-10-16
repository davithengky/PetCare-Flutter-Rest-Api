import '../models/article_model.dart';

/// Kontrak repository untuk artikel edukasi Pet Care Tips.
abstract class ArticleRepo {
  /// Mendapatkan daftar artikel dengan filter pencarian dan kategori opsional.
  Future<List<Article>> getArticles({String? search, String? category});

  /// Mengambil detail artikel berdasarkan ID.
  Future<Article?> getArticleById(int id);

  /// Mengambil daftar kategori artikel yang tersedia.
  Future<List<String>> getCategories();
}
