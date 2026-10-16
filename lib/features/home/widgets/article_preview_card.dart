import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../data/models/article_model.dart';

/// Card preview besar untuk artikel di layar Beranda (Opsi C).
class ArticlePreviewCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticlePreviewCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.grey300),
          ),
          padding: const EdgeInsets.all(AppSizes.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppImage(
                    url: article.coverUrl,
                    width: 48,
                    height: 48,
                    fallbackIcon: Icons.article_outlined,
                    fallbackColor: AppColors.accentGreen,
                    backgroundColor:
                        AppColors.accentGreen.withValues(alpha: 0.15),
                    fallbackIconSize: 24,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.category.toUpperCase(),
                          style: AppTextStyles.overline.copyWith(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.w700,
                          ),
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    article.author,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    '•',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  const Icon(
                    Icons.schedule,
                    size: 14,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    '${article.readTimeMinutes} min',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
