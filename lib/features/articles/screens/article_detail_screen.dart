import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/articles_provider.dart';

/// Halaman detail artikel edukasi Pet Care Tips.
class ArticleDetailScreen extends ConsumerWidget {
  final int articleId;

  const ArticleDetailScreen({
    super.key,
    required this.articleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleByIdProvider(articleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
      ),
      body: articleAsync.when(
        loading: () =>
            const LoadingWidget(message: 'Memuat artikel...'),
        error: (e, _) => CustomErrorWidget(
          message: 'Gagal memuat artikel: $e',
          onRetry: () => ref.refresh(articleByIdProvider(articleId)),
        ),
        data: (article) {
          if (article == null) {
            return const EmptyState(
              icon: Icons.article_outlined,
              title: 'Artikel Tidak Ditemukan',
            );
          }

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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner (gambar cover artikel)
                AppImage(
                  url: article.coverUrl,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  fallbackIcon: catIcon,
                  fallbackColor: catColor,
                  backgroundColor: catColor.withValues(alpha: 0.15),
                  fallbackIconSize: 72,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                const SizedBox(height: AppSizes.lg),

                // Kategori & Waktu Baca
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                      ),
                      child: Text(
                        article.category.toUpperCase(),
                        style: AppTextStyles.caption.copyWith(
                          color: catColor,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.grey500,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Text(
                          '${article.readTimeMinutes} menit baca',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),

                // Judul Artikel
                Text(
                  article.title,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.grey900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppSizes.md),

                // Info Penulis & Tanggal
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.author,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMMM yyyy', 'id')
                              .format(article.createdAt),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.lg),
                const Divider(),
                const SizedBox(height: AppSizes.md),

                // Isi Konten Multiline
                Text(
                  article.content,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.grey900,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: AppSizes.xxxl),
              ],
            ),
          );
        },
      ),
    );
  }
}
