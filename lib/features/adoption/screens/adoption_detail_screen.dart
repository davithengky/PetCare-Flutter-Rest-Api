import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/adoption_provider.dart';

/// Halaman detail anabul yang siap diadopsi serta aksi menghubungi narahubung.
class AdoptionDetailScreen extends ConsumerWidget {
  final int adoptionId;

  const AdoptionDetailScreen({
    super.key,
    required this.adoptionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adoptionAsync = ref.watch(adoptionByIdProvider(adoptionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Adopsi'),
      ),
      body: adoptionAsync.when(
        loading: () =>
            const LoadingWidget(message: 'Memuat detail adopsi...'),
        error: (e, _) => CustomErrorWidget(
          message: 'Gagal memuat info adopsi: $e',
          onRetry: () => ref.refresh(adoptionByIdProvider(adoptionId)),
        ),
        data: (adoption) {
          if (adoption == null) {
            return const EmptyState(
              icon: Icons.pets_outlined,
              title: 'Data Adopsi Tidak Ditemukan',
            );
          }

          final isCat = adoption.species.toLowerCase() == 'kucing';

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Foto Header Anabul
                      AppImage(
                        url: adoption.photoUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        fallbackIcon: isCat ? Icons.pets : Icons.pets_outlined,
                        fallbackColor: isCat
                            ? AppColors.accentOrange
                            : AppColors.accentBlue,
                        backgroundColor: isCat
                            ? AppColors.accentOrange.withValues(alpha: 0.15)
                            : AppColors.accentBlue.withValues(alpha: 0.15),
                        fallbackIconSize: 80,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Nama & Spesies
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            adoption.name,
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.grey900,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryTeal.withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.chip),
                            ),
                            child: Text(
                              adoption.species,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        'Usia: ${adoption.age}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      const Divider(),
                      const SizedBox(height: AppSizes.sm),

                      // Deskripsi Hewan
                      Text(
                        'Tentang ${adoption.name}',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        adoption.description,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.grey700,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: AppSizes.lg),

                      // Kontak Info Card
                      Container(
                        padding: const EdgeInsets.all(AppSizes.cardPadding),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                            color: AppColors.primaryTeal.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone_in_talk,
                              color: AppColors.primaryTeal,
                            ),
                            const SizedBox(width: AppSizes.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kontak Pengasuh',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.grey500,
                                    ),
                                  ),
                                  Text(
                                    adoption.contactInfo,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Bar Tombol Hubungi
              Container(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.btn),
                      ),
                    ),
                    icon: const Icon(Icons.chat),
                    label: Text(
                      'Hubungi Adopter (${adoption.contactInfo})',
                      style: AppTextStyles.button,
                    ),
                    onPressed: () {
                      SnackbarHelper.info(
                        context,
                        'Menghubungi pengasuh ${adoption.name} via ${adoption.contactInfo}',
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
