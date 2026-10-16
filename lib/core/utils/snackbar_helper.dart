import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';

/// Helper untuk menampilkan berbagai jenis SnackBar konsisten di seluruh aplikasi.
class SnackbarHelper {
  SnackbarHelper._();

  /// Menampilkan SnackBar sukses (hijau).
  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.successText,
      icon: Icons.check_circle,
    );
  }

  /// Menampilkan SnackBar error (merah).
  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.accentRed,
      icon: Icons.error_outline,
    );
  }

  /// Menampilkan SnackBar info (teal).
  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.primaryTeal,
      icon: Icons.info_outline,
    );
  }

  /// Menampilkan SnackBar peringatan (oranye/warning).
  static void warning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.warningText,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

