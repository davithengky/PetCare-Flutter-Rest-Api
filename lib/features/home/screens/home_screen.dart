import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/pet_photos.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/pet_guard.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_image.dart';
import '../widgets/pet_care_tips_section.dart';
import '../../auth/providers/auth_provider.dart';
import '../../main_nav/widgets/onboarding_bottom_sheet.dart';
import '../../pets/providers/pets_provider.dart';

/// Halaman Beranda (Home) utama aplikasi PetCare.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          showOnboardingBottomSheet(context, ref);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value?.user;
    final pets = ref.watch(petsProvider).value ?? [];
    final activePet = pets.isNotEmpty ? pets.first : null;

    final initial = (user?.name.isNotEmpty ?? false)
        ? user!.name.substring(0, 1).toUpperCase()
        : 'U';

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
              vertical: AppSizes.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section [1] Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primaryTeal,
                      child: Text(
                        initial,
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat pagi 👋',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                          Text(
                            user?.name ?? 'Pengguna',
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.grey900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Selamat datang di PetCare Vet Clinic',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.grey700,
                        size: 26,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.lg),

                // Section [2] Search Bar
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: AppColors.grey500,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Text(
                          'Cari dokter atau keluhan anabul...',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.tune,
                        color: AppColors.primaryTeal,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.xl),

                // Section [3] Kartu Anabul ATAU Banner Onboarding
                if (activePet != null)
                  _buildActivePetCard(activePet)
                else
                  _buildOnboardingBanner(),

                const SizedBox(height: AppSizes.sectionGap),

                // Section [4] Layanan PetCare
                Text(
                  'Layanan PetCare',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.grey900,
                  ),
                ),
                const SizedBox(height: AppSizes.listItemGap),
                _buildServicesGrid(),

                const SizedBox(height: AppSizes.sectionGap),

                // Section [5] Promo Spesial
                Text(
                  'Promo Spesial',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.grey900,
                  ),
                ),
                const SizedBox(height: AppSizes.listItemGap),
                _buildPromoSection(),

                const SizedBox(height: AppSizes.sectionGap),

                // Section [6] Layanan Lainnya (2 kolom: Rekam Medis & Adopsi)
                Text(
                  'Layanan Lainnya',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.grey900,
                  ),
                ),
                const SizedBox(height: AppSizes.listItemGap),
                _buildOtherServicesGrid(),

                const SizedBox(height: AppSizes.sectionGap),

                // Section [7] Pet Care Tips
                PetCareTipsSection(
                  onSeeAll: () => context.push('/articles'),
                ),

                // Spacing bawah ekstra agar konten tidak tertutup floating nav bar
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget Kartu Anabul Aktif dengan gradient Teal
  Widget _buildActivePetCard(dynamic pet) {
    return Container(
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
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ANABUL AKTIF',
                style: AppTextStyles.overline.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              InkWell(
                onTap: () => context.push('/pets'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ganti',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.swap_horiz,
                        color: AppColors.white,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              // Foto anabul (fallback: foto default sesuai spesies)
              Container(
                width: 52,
                height: 52,
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: AppImage(
                  url: pet.photoUrl ?? defaultPetPhotoUrl(pet.species),
                  width: 48,
                  height: 48,
                  fallbackIcon: Icons.pets,
                  fallbackColor: AppColors.primaryTeal,
                  backgroundColor: AppColors.primaryLight,
                  fallbackIconSize: 24,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        '${pet.species} • ${pet.ageMonths} Bulan',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Vaksin berikutnya: -',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Banner Onboarding saat belum ada anabul terdaftar
  Widget _buildOnboardingBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.pets,
            size: 48,
            color: AppColors.primaryTeal,
          ),
          const SizedBox(height: AppSizes.sm),
          const Text(
            'Belum Ada Anabul?',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Yuk tambah anabul pertamamu!',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.grey700,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          ElevatedButton(
            onPressed: () => context.push('/pets/add?isOnboarding=false'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: AppColors.white,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: const Text('Tambah Anabul Sekarang'),
          ),
        ],
      ),
    );
  }

  /// Grid 2 kolom Layanan PetCare
  Widget _buildServicesGrid() {
    final services = [
      {
        'title': 'Konsultasi',
        'subtitle': 'Tanya PetBot',
        'icon': Icons.smart_toy_rounded,
        'color': AppColors.accentBlue,
        'action': () => context.push('/consultation/chat-bot'),
      },
      {
        'title': 'Pet Shop',
        'subtitle': 'Belanja hemat',
        'icon': Icons.shopping_bag_outlined,
        'color': AppColors.accentOrange,
        'action': () => context.go('/main/shop'),
      },
      {
        'title': 'Klinik',
        'subtitle': 'Booking jadwal',
        'icon': Icons.local_hospital_outlined,
        'color': AppColors.accentGreen,
        'action': () async {
          final hasPet = await ensureHasPet(context, ref);
          if (hasPet && mounted) {
            context.push('/booking/clinics?type=clinic');
          }
        },
      },
      {
        'title': 'Grooming',
        'subtitle': 'Perawatan pet',
        'icon': Icons.content_cut,
        'color': AppColors.accentPink,
        'action': () async {
          final hasPet = await ensureHasPet(context, ref);
          if (hasPet && mounted) {
            context.push('/booking/clinics?type=grooming');
          }
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.listItemGap,
        mainAxisSpacing: AppSizes.listItemGap,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final item = services[index];
        final color = item['color'] as Color;

        return InkWell(
          onTap: item['action'] as VoidCallback,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        item['subtitle'] as String,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey500,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Carousel / horizontal Promo
  Widget _buildPromoSection() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 260,
            margin: const EdgeInsets.only(right: AppSizes.md),
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.accentYellow),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'TERBATAS',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Diskon 30% Makanan Anabul',
                  style: AppTextStyles.h4,
                ),
                Text(
                  'Gunakan kode: PETHEMAT',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 260,
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.accentBlue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    'VAKSIN',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Paket Vaksin Lengkap',
                  style: AppTextStyles.h4,
                ),
                Text(
                  'Mulai dari Rp 150.000',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Grid 2 kolom Layanan Lainnya (Rekam Medis & Adopsi)
  Widget _buildOtherServicesGrid() {
    final otherServices = [
      {
        'title': 'Rekam Medis',
        'subtitle': 'Riwayat kesehatan',
        'icon': Icons.description_outlined,
        'color': AppColors.accentBlue,
        'action': () async {
          final hasPet = await ensureHasPet(context, ref);
          if (hasPet && mounted) {
            context.push('/pets');
          }
        },
      },
      {
        'title': 'Adopsi',
        'subtitle': 'Cari anabul baru',
        'icon': Icons.favorite_border,
        'color': AppColors.accentPurple,
        'action': () => context.push('/adoption'),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: otherServices.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.listItemGap,
        mainAxisSpacing: AppSizes.listItemGap,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final item = otherServices[index];
        final color = item['color'] as Color;

        return InkWell(
          onTap: item['action'] as VoidCallback,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        item['subtitle'] as String,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.grey500,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
