import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/api/api_client.dart';
import '../../../data/models/article_model.dart';
import '../../../data/repositories/api_article_repo.dart';
import '../../../data/repositories/article_repo.dart';

/// Provider repository artikel PetCare.
final articleRepoProvider = Provider<ArticleRepo>((ref) {
  return ApiArticleRepo(ref.watch(apiClientProvider));
});

/// State untuk filter pencarian dan kategori artikel.
class ArticleFilter {
  final String search;
  final String category;

  const ArticleFilter({
    this.search = '',
    this.category = 'Semua',
  });

  ArticleFilter copyWith({
    String? search,
    String? category,
  }) {
    return ArticleFilter(
      search: search ?? this.search,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ArticleFilter &&
        other.search == search &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(search, category);
}

/// Provider state filter artikel.
final articleFilterProvider =
    NotifierProvider<ArticleFilterNotifier, ArticleFilter>(
  ArticleFilterNotifier.new,
);

class ArticleFilterNotifier extends Notifier<ArticleFilter> {
  @override
  ArticleFilter build() => const ArticleFilter();

  void setSearch(String query) {
    state = state.copyWith(search: query);
  }

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void reset() {
    state = const ArticleFilter();
  }
}

/// Notifier untuk daftar artikel yang reaktif terhadap filter.
class ArticlesNotifier extends AsyncNotifier<List<Article>> {
  @override
  Future<List<Article>> build() async {
    final filter = ref.watch(articleFilterProvider);
    final repo = ref.watch(articleRepoProvider);
    return repo.getArticles(
      search: filter.search,
      category: filter.category,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final filter = ref.read(articleFilterProvider);
    state = await AsyncValue.guard(
      () => ref.read(articleRepoProvider).getArticles(
            search: filter.search,
            category: filter.category,
          ),
    );
  }
}

/// Provider daftar artikel.
final articlesProvider =
    AsyncNotifierProvider<ArticlesNotifier, List<Article>>(
  ArticlesNotifier.new,
);

/// Provider detail artikel per ID.
final articleByIdProvider = FutureProvider.family<Article?, int>((ref, id) {
  return ref.watch(articleRepoProvider).getArticleById(id);
});

/// Provider 5 artikel terbaru untuk preview.
final recentArticlesProvider = FutureProvider<List<Article>>((ref) async {
  final articles = await ref.watch(articleRepoProvider).getArticles();
  final sorted = List<Article>.from(articles)
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return sorted.take(5).toList();
});

/// Provider daftar kategori artikel.
final articleCategoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(articleRepoProvider).getCategories();
});
