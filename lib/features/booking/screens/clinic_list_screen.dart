import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/clinic_model.dart';
import '../providers/clinic_provider.dart';

/// Layar daftar cabang klinik resmi PetCare Vet Clinic dengan pencarian dan filter layanan.
class ClinicListScreen extends ConsumerStatefulWidget {
  final String? initialBookingType;

  const ClinicListScreen({
    super.key,
    this.initialBookingType,
  });

  @override
  ConsumerState<ClinicListScreen> createState() => _ClinicListScreenState();
}

class _ClinicListScreenState extends ConsumerState<ClinicListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedService = 'all';

  final List<({String label, String value})> _filterOptions = const [
    (label: 'Semua', value: 'all'),
    (label: 'Konsultasi', value: 'consultation'),
    (label: 'Grooming', value: 'grooming'),
    (label: 'Vaksinasi', value: 'vaccination'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialBookingType == 'grooming') {
      _selectedService = 'grooming';
    } else if (widget.initialBookingType == 'consultation') {
      _selectedService = 'consultation';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clinicsAsync = ref.watch(clinicsListProvider);

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(
          'Pilih Klinik',
          style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.md,
              AppSizes.screenPadding,
              AppSizes.sm,
            ),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.grey300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari cabang PetCare...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.grey500,
                    size: 22,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.grey500,
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.md,
                  ),
                ),
              ),
            ),
          ),

          // Section Filter Chip Layanan
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
                vertical: AppSizes.xs,
              ),
              itemCount: _filterOptions.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
              itemBuilder: (context, index) {
                final option = _filterOptions[index];
                final isSelected = _selectedService == option.value;

                return ChoiceChip(
                  label: Text(
                    option.label,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.white : AppColors.grey700,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primaryTeal,
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryTeal
                          : AppColors.grey300,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedService = option.value;
                      });
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          // Label jumlah cabang
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(
              'Menampilkan 6 cabang PetCare Vet Clinic',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.grey500,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // List Cabang Klinik
          Expanded(
            child: clinicsAsync.when(
              loading: () =>
                  const LoadingWidget(message: 'Memuat cabang klinik...'),
              error: (err, _) => CustomErrorWidget(
                message: 'Gagal memuat cabang: $err',
                onRetry: () => ref.refresh(clinicsListProvider),
              ),
              data: (clinics) {
                final filtered = clinics.where((c) {
                  // Filter pencarian
                  if (_searchQuery.isNotEmpty) {
                    final matchBranch =
                        c.branchName.toLowerCase().contains(_searchQuery);
                    final matchAddress =
                        c.address.toLowerCase().contains(_searchQuery);
                    final matchCity =
                        c.city.toLowerCase().contains(_searchQuery);
                    if (!matchBranch && !matchAddress && !matchCity) {
                      return false;
                    }
                  }

                  // Filter tipe layanan
                  if (_selectedService != 'all') {
                    if (!c.services.contains(_selectedService)) {
                      return false;
                    }
                  }

                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.location_off_outlined,
                    title: 'Cabang Tidak Ditemukan',
                    subtitle: 'Coba ganti kata kunci atau filter layanan',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.screenPadding,
                    0,
                    AppSizes.screenPadding,
                    AppSizes.lg,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSizes.listItemGap),
                  itemBuilder: (context, index) {
                    final clinic = filtered[index];
                    final targetBookingType = _selectedService == 'all'
                        ? (widget.initialBookingType == 'grooming'
                            ? 'grooming'
                            : 'consultation')
                        : _selectedService;

                    return _buildClinicCard(context, clinic, targetBookingType);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicCard(
    BuildContext context,
    Clinic clinic,
    String bookingType,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () {
            context.push('/booking/form/${clinic.id}?bookingType=$bookingType');
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            child: Row(
              children: [
                // Foto Klinik
                AppImage(
                  url: clinic.photoUrl,
                  width: 56,
                  height: 56,
                  fallbackIcon: Icons.local_hospital_outlined,
                  fallbackColor: AppColors.accentGreen,
                  backgroundColor:
                      AppColors.accentGreen.withValues(alpha: 0.15),
                  fallbackIconSize: 28,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(width: 12),

                // Detail Klinik
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic.branchName,
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.grey900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${clinic.address}, ${clinic.city}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.accentYellow,
                            size: 14,
                          ),
                          Text(
                            ' ${clinic.rating.toStringAsFixed(1)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ' • ',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                          const Icon(
                            Icons.access_time,
                            color: AppColors.grey500,
                            size: 12,
                          ),
                          Text(
                            ' ${clinic.operatingHours}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: AppColors.grey500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
