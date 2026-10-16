import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/pet_photos.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_image.dart';
import '../../auth/providers/auth_provider.dart';
import '../../pets/providers/pets_provider.dart';
import '../providers/profile_provider.dart';

/// Halaman profil pengguna aplikasi PetCare Vet Clinic.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value?.user;
    final pets = ref.watch(petsProvider).value ?? [];
    final statsAsync = ref.watch(profileStatsProvider);

    final initial = (user?.name.isNotEmpty ?? false)
        ? user!.name.substring(0, 1).toUpperCase()
        : 'U';

    final isGold = user?.membershipTier.toLowerCase() == 'gold';

    return Scaffold(
      backgroundColor: AppBackground.topColor,
      appBar: AppBar(
        title: const Text('Profil Saya'),
        scrolledUnderElevation: 0,
      ),
      body: AppBackground(child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // [1] Header Card dengan Gradient
            Container(
              padding: const EdgeInsets.all(AppSizes.cardPadding),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryTeal,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.white,
                    child: Text(
                      initial,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Pengguna PetCare',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.email ?? '-',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isGold) ...[
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFEF08A), Color(0xFFFDE047)],
                              ),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: Color(0xFFF9C846),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'GOLD MEMBER',
                                  style: AppTextStyles.caption.copyWith(
                                    color: const Color(0xFFE65100),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sectionGap),

            // [3] Statistics Row (3 Card Kecil)
            statsAsync.when(
              loading: () => _buildStatsRow(pets: '-', bookings: '-', orders: '-'),
              error: (_, e) =>
                  _buildStatsRow(pets: '0', bookings: '0', orders: '0'),
              data: (stats) => _buildStatsRow(
                pets: stats.totalPets.toString(),
                bookings: stats.totalBookings.toString(),
                orders: stats.totalOrders.toString(),
              ),
            ),
            const SizedBox(height: AppSizes.sectionGap),

            // [5] Section "Anabul Saya"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Anabul Saya',
                  style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
                ),
                TextButton(
                  onPressed: () => context.push('/pets/add'),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    '+ Tambah',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.primaryTeal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            if (pets.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Belum ada anabul terdaftar',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              )
            else
              SizedBox(
                height: 104,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length,
                  separatorBuilder: (_, i) =>
                      const SizedBox(width: AppSizes.sm),
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return InkWell(
                      onTap: () => context.push('/pets/${pet.id}'),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Container(
                        width: 84,
                        padding: const EdgeInsets.all(AppSizes.sm),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.grey300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImage(
                              url: pet.photoUrl ??
                                  defaultPetPhotoUrl(pet.species),
                              width: 40,
                              height: 40,
                              fallbackIcon: Icons.pets,
                              fallbackColor: AppColors.primaryTeal,
                              backgroundColor: AppColors.primaryLight,
                              fallbackIconSize: 20,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pet.name,
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              pet.breed ?? pet.species,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.grey500,
                                fontSize: 9,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: AppSizes.sectionGap),

            // [7] Section "Menu"
            Text(
              'Menu',
              style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profil',
                    onTap: () => context.push('/profile/edit'),
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.home_outlined,
                    title: 'Alamat Saya',
                    onTap: () => context.push('/profile/edit'),
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Metode Pembayaran',
                    onTap: () {
                      SnackbarHelper.info(context, 'Fitur segera hadir!');
                    },
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifikasi',
                    onTap: () {
                      SnackbarHelper.info(context, 'Fitur segera hadir!');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // [9] Section "Bantuan & Info"
            Text(
              'Bantuan & Info',
              style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan / FAQ',
                    onTap: () => context.push('/profile/help'),
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang PetCare',
                    onTap: () => context.push('/profile/about'),
                  ),
                  const Divider(height: 1),
                  _MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Kebijakan Privasi',
                    onTap: () => context.push('/profile/privacy'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // [11] Keluar Akun
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.grey300),
              ),
              child: _MenuItem(
                icon: Icons.logout,
                title: 'Keluar Akun',
                iconColor: AppColors.accentRed,
                titleColor: AppColors.accentRed,
                onTap: () => _onLogout(context, ref),
              ),
            ),
            const SizedBox(height: AppSizes.xxxl),

            // [13] Versi App
            Center(
              child: Text(
                'PetCare Vet Clinic v1.0.0',
                style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildStatsRow({
    required String pets,
    required String bookings,
    required String orders,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(value: pets, label: 'Anabul'),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: _buildStatCard(value: bookings, label: 'Booking'),
        ),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: _buildStatCard(value: orders, label: 'Pesanan'),
        ),
      ],
    );
  }

  Widget _buildStatCard({required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: AppColors.primaryTeal),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  void _onLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await DialogHelper.confirm(
      context,
      title: 'Keluar Akun?',
      message: 'Kamu yakin ingin keluar dari PetCare?',
      confirmLabel: 'Keluar',
      isDangerous: true,
    );

    if (confirmed) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.cardPadding,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? AppColors.grey700,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: titleColor ?? AppColors.grey900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: titleColor ?? AppColors.grey500,
            ),
          ],
        ),
      ),
    );
  }
}
