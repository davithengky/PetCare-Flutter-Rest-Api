import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_sizes.dart';
import '../theme/text_styles.dart';

/// Helper untuk menampilkan dialog konfirmasi dan dialog sukses standar.
class DialogHelper {
  DialogHelper._();

  /// Menampilkan dialog konfirmasi dengan tombol cancel dan confirm.
  /// Mengembalikan `true` jika dikonfirmasi, `false` jika dibatalkan.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Ya',
    String cancelLabel = 'Batal',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        title: Text(
          title,
          style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
        ),
        content: Text(
          message,
          style: AppTextStyles.body.copyWith(color: AppColors.grey700),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              cancelLabel,
              style: AppTextStyles.button.copyWith(color: AppColors.grey700),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDangerous ? AppColors.accentRed : AppColors.primaryTeal,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.btn),
              ),
            ),
            child: Text(
              confirmLabel,
              style: AppTextStyles.button.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Menampilkan dialog sukses dengan icon centang hijau.
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'OK',
    VoidCallback? onClose,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.md),
            const Icon(
              Icons.check_circle,
              size: 64,
              color: AppColors.accentGreen,
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(
                color: AppColors.grey900,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              message,
              style: AppTextStyles.body.copyWith(
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onClose?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.btn),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                ),
                child: Text(
                  buttonLabel,
                  style: AppTextStyles.button.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

