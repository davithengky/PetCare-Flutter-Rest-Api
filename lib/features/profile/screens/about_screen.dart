import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';

/// Halaman informasi tentang aplikasi PetCare Vet Clinic.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang PetCare'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSizes.md),
            const Center(
              child: Icon(
                Icons.pets,
                size: 80,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Center(
              child: Text(
                'PetCare',
                style: AppTextStyles.h1.copyWith(color: AppColors.grey900),
              ),
            ),
            Center(
              child: Text(
                'Versi 1.0.0',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Center(
              child: Text(
                'Aplikasi Mobile Resmi PetCare Vet Clinic',
                style: AppTextStyles.body.copyWith(color: AppColors.grey700),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSizes.xxxl),
            const Divider(),
            const SizedBox(height: AppSizes.lg),
            Text(
              'PetCare Vet Clinic',
              style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Klinik hewan dengan 6 cabang di area Surabaya & sekitarnya. Melayani konsultasi, vaksinasi, grooming, dan operasi dengan standar medis profesional dan penuh kasih sayang terhadap anabul Anda.',
              style: AppTextStyles.body.copyWith(
                color: AppColors.grey700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.sectionGap),
            Text(
              'Kontak',
              style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.sm),
            _buildContactRow(
              icon: Icons.phone_outlined,
              text: '031-5671234',
            ),
            const SizedBox(height: AppSizes.sm),
            _buildContactRow(
              icon: Icons.email_outlined,
              text: 'hello@petcare.id',
            ),
            const SizedBox(height: AppSizes.sm),
            _buildContactRow(
              icon: Icons.public,
              text: 'www.petcare.id',
            ),
            const SizedBox(height: AppSizes.xxxl),
            Center(
              child: Text(
                '© 2025 PetCare Vet Clinic. Hak Cipta Dilindungi.',
                style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryTeal),
        const SizedBox(width: AppSizes.sm),
        Text(
          text,
          style: AppTextStyles.body.copyWith(color: AppColors.grey700),
        ),
      ],
    );
  }
}
