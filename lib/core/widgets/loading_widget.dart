import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/text_styles.dart';

/// Widget indikator loading standar aplikasi PetCare.
class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primaryTeal,
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

