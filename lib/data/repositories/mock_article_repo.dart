import '../mocks/mock_articles.dart';
import '../models/article_model.dart';
import 'article_repo.dart';

/// Implementasi mock repository untuk artikel tips perawatan hewan.
class MockArticleRepo implements ArticleRepo {
  final List<Article> _articles = List<Article>.from(mockArticles);

  @override
  Future<List<Article>> getArticles({String? search, String? category}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var results = List<Article>.from(_articles);

    if (category != null &&
        category.isNotEmpty &&
        category.toLowerCase() != 'semua') {
      results = results
          .where((a) => a.category.toLowerCase() == category.toLowerCase())
          .toList();
    }

    if (search != null && search.trim().isNotEmpty) {
      final query = search.trim().toLowerCase();
      results = results
          .where((a) =>
              a.title.toLowerCase().contains(query) ||
              a.content.toLowerCase().contains(query) ||
              a.author.toLowerCase().contains(query))
          .toList();
    }

    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  @override
  Future<Article?> getArticleById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _articles.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      'Semua',
      'Makanan',
      'Perawatan',
      'Penyakit',
      'Perilaku',
      'Tips',
    ];
  }
}
