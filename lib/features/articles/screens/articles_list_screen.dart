import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/article_model.dart';
import '../providers/articles_provider.dart';

/// Halaman daftar artikel Pet Care Tips lengkap dengan pencarian dan filter kategori.
class ArticlesListScreen extends ConsumerStatefulWidget {
  const ArticlesListScreen({super.key});

  @override
  ConsumerState<ArticlesListScreen> createState() => _ArticlesListScreenState();
}

class _ArticlesListScreenState extends ConsumerState<ArticlesListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _categories = const [
    'Semua',
    'Makanan',
    'Perawatan',
    'Penyakit',
    'Perilaku',
    'Tips',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(articleFilterProvider);
    final articlesAsync = ref.watch(articlesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Care Tips'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.sm,
              AppSizes.screenPadding,
              AppSizes.sm,
            ),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cari tips, nutrisi, atau penyakit...',
                prefixIcon: const Icon(Icons.search, color: AppColors.grey500),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref
                              .read(articleFilterProvider.notifier)
                              .setSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
              ),
              onChanged: (val) {
                ref.read(articleFilterProvider.notifier).setSearch(val);
              },
            ),
          ),

          // Horizontal Category Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
                vertical: 6,
              ),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSizes.sm),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = currentFilter.category == cat;

                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: AppColors.primaryTeal,
                  backgroundColor: AppColors.white,
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.white : AppColors.grey700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primaryTeal
                        : AppColors.grey300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(articleFilterProvider.notifier)
                          .setCategory(cat);
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          // Articles List
          Expanded(
            child: articlesAsync.when(
              loading: () =>
                  const LoadingWidget(message: 'Memuat artikel...'),
              error: (e, _) => CustomErrorWidget(
                message: 'Gagal memuat artikel: $e',
                onRetry: () => ref.refresh(articlesProvider),
              ),
              data: (articles) {
                if (articles.isEmpty) {
                  return const EmptyState(
                    icon: Icons.article_outlined,
                    title: 'Tidak Ada Artikel Ditemukan',
                    subtitle: 'Coba ganti kata kunci atau pilih kategori lain.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  itemCount: articles.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.md),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return _buildArticleItem(context, article);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleItem(BuildContext context, Article article) {
    Color catColor;
    IconData catIcon;
    switch (article.category) {
      case 'Makanan':
        catColor = AppColors.accentOrange;
        catIcon = Icons.restaurant_menu;
        break;
      case 'Perawatan':
        catColor = AppColors.accentPink;
        catIcon = Icons.spa_outlined;
        break;
      case 'Penyakit':
        catColor = AppColors.accentRed;
        catIcon = Icons.health_and_safety_outlined;
        break;
      case 'Perilaku':
        catColor = AppColors.accentPurple;
        catIcon = Icons.psychology_outlined;
        break;
      default:
        catColor = AppColors.accentGreen;
        catIcon = Icons.tips_and_updates_outlined;
    }

    return InkWell(
      onTap: () => context.push('/articles/${article.id}'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              url: article.coverUrl,
              width: 52,
              height: 52,
              fallbackIcon: catIcon,
              fallbackColor: catColor,
              backgroundColor: catColor.withValues(alpha: 0.15),
              fallbackIconSize: 26,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: catColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          article.category.toUpperCase(),
                          style: AppTextStyles.caption.copyWith(
                            color: catColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${article.readTimeMinutes} min baca',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    article.title,
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.grey900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    '${article.author} • ${DateFormat('dd MMM yyyy', 'id').format(article.createdAt)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
