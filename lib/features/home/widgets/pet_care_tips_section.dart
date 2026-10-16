import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../articles/providers/articles_provider.dart';
import 'article_preview_card.dart';

/// Section artikel edukasi "Pet Care Tips" di Beranda.
class PetCareTipsSection extends ConsumerWidget {
  final VoidCallback? onSeeAll;

  const PetCareTipsSection({
    super.key,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentArticlesProvider);

    return recentAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (articles) {
        if (articles.isEmpty) {
          return const SizedBox.shrink();
        }

        final previewList = articles.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pet Care Tips',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.grey900,
                  ),
                ),
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Lihat Semua',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.primaryTeal,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: AppSizes.xs),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.primaryTeal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: previewList.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.md),
              itemBuilder: (context, index) {
                final article = previewList[index];
                return ArticlePreviewCard(
                  article: article,
                  onTap: () {
                    context.push('/articles/${article.id}');
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
