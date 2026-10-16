import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/pet_photos.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/clinic_model.dart';
import '../../../data/models/pet_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../pets/providers/pets_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/clinic_provider.dart';

/// Layar formulir pendaftaran booking layanan cabang PetCare Vet Clinic.
class BookingFormScreen extends ConsumerStatefulWidget {
  final int clinicId;
  final String? initialBookingType;

  const BookingFormScreen({
    super.key,
    required this.clinicId,
    this.initialBookingType,
  });

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  String? _selectedService;
  Pet? _selectedPet;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _timeSlots = const [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '19:00',
  ];

  static const Map<String, String> _serviceLabels = {
    'consultation': 'Konsultasi',
    'grooming': 'Grooming',
    'vaccination': 'Vaksinasi',
  };

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialBookingType ?? 'consultation';
    if (_timeSlots.isNotEmpty) {
      _selectedTime = _timeSlots.first;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = ref.read(authProvider).value?.user;
    if (user == null) {
      SnackbarHelper.warning(context, 'Silakan login terlebih dahulu');
      return;
    }

    if (_selectedService == null) {
      SnackbarHelper.warning(context, 'Silakan pilih jenis layanan');
      return;
    }

    if (_selectedPet == null) {
      SnackbarHelper.warning(context, 'Silakan pilih anabul');
      return;
    }

    if (_selectedTime == null) {
      SnackbarHelper.warning(context, 'Silakan pilih jam kedatangan');
      return;
    }

    // Gabungkan tanggal dan jam
    final timeParts = _selectedTime!.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final scheduleDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      minute,
    );

    final booking =
        await ref.read(createBookingProvider.notifier).submitBooking(
              clinicId: widget.clinicId,
              petId: _selectedPet!.id,
              bookingType: _selectedService!,
              scheduleDate: scheduleDate,
              notes: _notesController.text.trim().isNotEmpty
                  ? _notesController.text.trim()
                  : null,
            );

    if (booking != null && mounted) {
      SnackbarHelper.success(context, 'Booking berhasil dikonfirmasi!');
      context.go('/main/activity');
    }
  }

  @override
  Widget build(BuildContext context) {
    final clinicAsync = ref.watch(clinicByIdProvider(widget.clinicId));
    final petsAsync = ref.watch(petsProvider);
    final bookingState = ref.watch(createBookingProvider);

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(
          'Booking Jadwal',
          style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
      ),
      body: clinicAsync.when(
        loading: () =>
            const LoadingWidget(message: 'Memuat data klinik...'),
        error: (err, _) => CustomErrorWidget(
          message: 'Gagal memuat klinik: $err',
          onRetry: () => ref.refresh(clinicByIdProvider(widget.clinicId)),
        ),
        data: (clinic) {
          if (clinic == null) {
            return const Center(child: Text('Data klinik tidak ditemukan'));
          }

          // Sinkronisasi default layanan jika tidak ada di klinik
          if (!clinic.services.contains(_selectedService) &&
              clinic.services.isNotEmpty) {
            _selectedService = clinic.services.first;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Card Klinik
                _buildClinicHeaderCard(clinic),
                const SizedBox(height: AppSizes.lg),

                // Section [1] Pilih Layanan
                Text(
                  'Pilih Layanan',
                  style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
                ),
                const SizedBox(height: AppSizes.sm),
                _buildServiceSelector(clinic.services),
                const SizedBox(height: AppSizes.lg),

                // Section [2] Pilih Anabul
                Text(
                  'Pilih Anabul',
                  style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
                ),
                const SizedBox(height: AppSizes.sm),
                petsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.md),
                      child: CircularProgressIndicator(color: AppColors.primaryTeal),
                    ),
                  ),
                  error: (_, _) => Text(
                    'Gagal memuat anabul',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentRed,
                    ),
                  ),
                  data: (pets) {
                    if (pets.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.grey300),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Kamu belum mendaftarkan anabul',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.grey700,
                              ),
                            ),
                            const SizedBox(height: AppSizes.xs),
                            TextButton(
                              onPressed: () => context.push('/pets/add?isOnboarding=false'),
                              child: const Text('Tambah Anabul'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Auto select pet pertama jika belum terpilih
                    if (_selectedPet == null && pets.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && _selectedPet == null) {
                          setState(() {
                            _selectedPet = pets.first;
                          });
                        }
                      });
                    }

                    return _buildPetSelector(pets);
                  },
                ),
                const SizedBox(height: AppSizes.lg),

                // Section [3] Pilih Tanggal
                Text(
                  'Pilih Tanggal',
                  style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
                ),
                const SizedBox(height: AppSizes.sm),
                _buildDateSelector(),
                const SizedBox(height: AppSizes.lg),

                // Section [4] Pilih Jam
                Text(
                  'Pilih Jam',
                  style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
                ),
                const SizedBox(height: AppSizes.sm),
                _buildTimeSelector(),
                const SizedBox(height: AppSizes.lg),

                // Section [5] Catatan (Opsional)
                Text(
                  'Catatan (Opsional)',
                  style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
                ),
                const SizedBox(height: AppSizes.sm),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan keluhan atau permintaan khusus...',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(AppSizes.md),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),

                // Tombol Konfirmasi Booking
                ElevatedButton(
                  onPressed: bookingState.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.btn),
                    ),
                    elevation: 0,
                  ),
                  child: bookingState.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Konfirmasi Booking',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                ),
                const SizedBox(height: AppSizes.lg),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Header Card Klinik
  Widget _buildClinicHeaderCard(Clinic clinic) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(
            url: clinic.photoUrl,
            width: 52,
            height: 52,
            fallbackIcon: Icons.local_hospital_outlined,
            fallbackColor: AppColors.accentGreen,
            backgroundColor: AppColors.accentGreen.withValues(alpha: 0.15),
            fallbackIconSize: 26,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clinic.branchName,
                  style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
                ),
                Text(
                  clinic.name,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${clinic.address}, ${clinic.city}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey700),
                ),
                Text(
                  'Telp: ${clinic.phone}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Pilih Layanan (Wrap Chip)
  Widget _buildServiceSelector(List<String> availableServices) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: availableServices.map((serviceKey) {
        final label = _serviceLabels[serviceKey] ?? serviceKey;
        final isSelected = _selectedService == serviceKey;

        return ChoiceChip(
          label: Text(
            label,
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
              color: isSelected ? AppColors.primaryTeal : AppColors.grey300,
            ),
          ),
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedService = serviceKey;
              });
            }
          },
        );
      }).toList(),
    );
  }

  /// Section Pilih Anabul
  Widget _buildPetSelector(List<Pet> pets) {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pets.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, index) {
          final pet = pets[index];
          final isSelected = _selectedPet?.id == pet.id;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedPet = pet;
              });
            },
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              width: 140,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryLight
                    : AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryTeal
                      : AppColors.grey300,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  AppImage(
                    url: pet.photoUrl ?? defaultPetPhotoUrl(pet.species),
                    width: 36,
                    height: 36,
                    fallbackIcon: Icons.pets,
                    fallbackColor:
                        isSelected ? AppColors.white : AppColors.grey700,
                    backgroundColor: isSelected
                        ? AppColors.primaryTeal
                        : AppColors.grey100,
                    fallbackIconSize: 18,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.grey900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          pet.species,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Section Pilih Tanggal
  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primaryTeal,
                size: 20,
              ),
              const SizedBox(width: AppSizes.md),
              Text(
                DateFormatter.fullDate(_selectedDate),
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.grey900,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 60)),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: const Text('Ubah'),
          ),
        ],
      ),
    );
  }

  /// Section Pilih Jam
  Widget _buildTimeSelector() {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: _timeSlots.map((time) {
        final isSelected = _selectedTime == time;

        return ChoiceChip(
          label: Text(
            time,
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
              color: isSelected ? AppColors.primaryTeal : AppColors.grey300,
            ),
          ),
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedTime = time;
              });
            }
          },
        );
      }).toList(),
    );
  }
}
