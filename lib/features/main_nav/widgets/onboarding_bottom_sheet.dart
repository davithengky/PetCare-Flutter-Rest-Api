import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../pets/providers/pets_provider.dart';

/// Menampilkan bottom sheet ajakan mendaftarkan anabul pertama kali (Hybrid Onboarding).
Future<void> showOnboardingBottomSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final count = ref.read(petsCountProvider);
  if (count > 0) return;

  await showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.xl),
      ),
    ),
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // Icon
            const Icon(
              Icons.pets,
              size: 64,
              color: AppColors.primaryTeal,
            ),
            const SizedBox(height: AppSizes.lg),

            // Greeting
            const Text(
              'Halo! 👋',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: AppSizes.sm),

            // Deskripsi
            Text(
              'Yuk daftarkan anabul pertamamu supaya bisa pakai semua fitur PetCare',
              style: AppTextStyles.body.copyWith(
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xxl),

            // Tombol Daftarkan Anabul
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.push('/pets/add?isOnboarding=true');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: const Text('Daftarkan Anabul'),
            ),
            const SizedBox(height: AppSizes.md),

            // Tombol Nanti Saja
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Nanti saja',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
