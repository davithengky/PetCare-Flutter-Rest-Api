import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/pet_photos.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/health_record_model.dart';
import '../../../data/models/reminder_model.dart';
import '../providers/health_provider.dart';
import '../providers/pets_provider.dart';
import '../providers/reminder_provider.dart';

/// Layar detail profil hewan peliharaan dengan 3 Tab: Profil, Rekam Medis, Pengingat.
class PetDetailScreen extends ConsumerStatefulWidget {
  final int petId;

  const PetDetailScreen({
    super.key,
    required this.petId,
  });

  @override
  ConsumerState<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends ConsumerState<PetDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pets = ref.watch(petsProvider).value;
    final pet = pets?.where((p) => p.id == widget.petId).firstOrNull;

    if (pet == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Anabul'),
        ),
        body: const Center(
          child: Text('Data anabul tidak ditemukan'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profil Anabul',
            onPressed: () => context.push('/pets/edit/${widget.petId}'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: AppColors.grey500,
          indicatorColor: AppColors.primaryTeal,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.bodyMedium,
          tabs: const [
            Tab(text: 'Profil'),
            Tab(text: 'Rekam Medis'),
            Tab(text: 'Pengingat'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Profil
          _buildProfileTab(pet),

          // TAB 2: Rekam Medis
          _buildHealthRecordsTab(pet.id),

          // TAB 3: Pengingat
          _buildRemindersTab(pet.id),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          if (_tabController.index == 1) {
            return FloatingActionButton.extended(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: AppColors.white,
              icon: const Icon(Icons.add),
              label: const Text('Catat Medis'),
              onPressed: () => _showAddHealthRecordSheet(context, pet.id),
            );
          } else if (_tabController.index == 2) {
            return FloatingActionButton.extended(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: AppColors.white,
              icon: const Icon(Icons.alarm_add),
              label: const Text('Tambah Pengingat'),
              onPressed: () => _showAddReminderSheet(context, pet.id),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Tampilan Tab Profil Hewan
  Widget _buildProfileTab(dynamic pet) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Column(
              children: [
                AppImage(
                  url: pet.photoUrl ?? defaultPetPhotoUrl(pet.species),
                  width: 92,
                  height: 92,
                  fallbackIcon: Icons.pets,
                  fallbackColor: AppColors.primaryTeal,
                  backgroundColor: AppColors.primaryLight,
                  fallbackIconSize: 46,
                  borderRadius: BorderRadius.circular(46),
                ),
                const SizedBox(height: AppSizes.md),
                Text(pet.name, style: AppTextStyles.h2),
                const SizedBox(height: AppSizes.xs),
                Text(
                  '${pet.species} • ${pet.breed ?? 'Domestik'}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                const Divider(),
                const SizedBox(height: AppSizes.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(
                      'Jenis Kelamin',
                      pet.gender == 'jantan' ? 'Jantan' : 'Betina',
                    ),
                    _buildInfoItem(
                      'Berat Badan',
                      '${pet.weightKg ?? '-'} kg',
                    ),
                    _buildInfoItem(
                      'Usia / Lahir',
                      pet.birthDate != null
                          ? DateFormat('dd/MM/yyyy').format(pet.birthDate!)
                          : '-',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sectionGap),
          if (pet.notes != null && (pet.notes as String).isNotEmpty) ...[
            Text(
              'Catatan Khusus',
              style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(AppSizes.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Text(
                pet.notes as String,
                style: AppTextStyles.body.copyWith(color: AppColors.grey700),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  /// Tampilan Tab Rekam Medis
  Widget _buildHealthRecordsTab(int petId) {
    final recordsAsync = ref.watch(petHealthRecordsProvider(petId));

    return recordsAsync.when(
      loading: () => const LoadingWidget(message: 'Memuat rekam medis...'),
      error: (e, _) => CustomErrorWidget(
        message: e.toString(),
        onRetry: () => ref.refresh(petHealthRecordsProvider(petId)),
      ),
      data: (records) {
        if (records.isEmpty) {
          return const EmptyState(
            icon: Icons.medical_services_outlined,
            title: 'Belum Ada Rekam Medis',
            subtitle: 'Tekan tombol "Catat Medis" di bawah untuk menambahkan.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding,
            AppSizes.screenPadding,
            AppSizes.screenPadding,
            88,
          ),
          itemCount: records.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSizes.md),
          itemBuilder: (context, index) {
            final record = records[index];
            return Container(
              padding: const EdgeInsets.all(AppSizes.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.primaryTeal,
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Text(
                            DateFormat('dd MMMM yyyy', 'id')
                                .format(record.date),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.accentRed,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _confirmDeleteHealthRecord(record),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    record.diagnosis,
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.grey900,
                    ),
                  ),
                  if (record.medication != null &&
                      record.medication!.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.xs),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.medication_outlined,
                          size: 16,
                          color: AppColors.accentOrange,
                        ),
                        const SizedBox(width: AppSizes.xs),
                        Expanded(
                          child: Text(
                            'Resep/Obat: ${record.medication}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (record.notes != null && record.notes!.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      record.notes!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Tampilan Tab Pengingat
  Widget _buildRemindersTab(int petId) {
    final remindersAsync = ref.watch(petRemindersProvider(petId));

    return remindersAsync.when(
      loading: () => const LoadingWidget(message: 'Memuat data pengingat...'),
      error: (e, _) => CustomErrorWidget(
        message: e.toString(),
        onRetry: () => ref.refresh(petRemindersProvider(petId)),
      ),
      data: (reminders) {
        if (reminders.isEmpty) {
          return const EmptyState(
            icon: Icons.alarm_off_outlined,
            title: 'Belum Ada Pengingat Aktif',
            subtitle: 'Tekan tombol "Tambah Pengingat" untuk menjadwalkan.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.screenPadding,
            AppSizes.screenPadding,
            AppSizes.screenPadding,
            88,
          ),
          itemCount: reminders.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSizes.md),
          itemBuilder: (context, index) {
            final reminder = reminders[index];

            IconData typeIcon;
            Color typeColor;
            String typeName;
            switch (reminder.type) {
              case 'vaccine':
                typeIcon = Icons.vaccines_outlined;
                typeColor = AppColors.accentBlue;
                typeName = 'Vaksinasi';
                break;
              case 'medicine':
                typeIcon = Icons.medical_information_outlined;
                typeColor = AppColors.accentOrange;
                typeName = 'Minum Obat';
                break;
              default:
                typeIcon = Icons.content_cut_outlined;
                typeColor = AppColors.accentPurple;
                typeName = 'Grooming';
            }

            return Container(
              padding: const EdgeInsets.all(AppSizes.cardPadding),
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
                      color: typeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 22),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeName.toUpperCase(),
                          style: AppTextStyles.overline.copyWith(
                            color: typeColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          reminder.title,
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.grey500,
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Text(
                              DateFormat('dd MMM yyyy, HH:mm', 'id')
                                  .format(reminder.scheduledTime),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.accentRed,
                      size: 20,
                    ),
                    onPressed: () => _confirmDeleteReminder(reminder),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Dialog konfirmasi hapus rekam medis
  void _confirmDeleteHealthRecord(HealthRecord record) async {
    final confirmed = await DialogHelper.confirm(
      context,
      title: 'Hapus Rekam Medis',
      message: 'Apakah Anda yakin ingin menghapus catatan rekam medis ini?',
      confirmLabel: 'Hapus',
      isDangerous: true,
    );

    if (confirmed && mounted) {
      final success = await ref
          .read(deleteHealthRecordProvider.notifier)
          .deleteRecord(record.id, record.petId);
      if (mounted && success) {
        SnackbarHelper.success(context, 'Rekam medis berhasil dihapus');
      }
    }
  }

  /// Dialog konfirmasi hapus pengingat
  void _confirmDeleteReminder(Reminder reminder) async {
    final confirmed = await DialogHelper.confirm(
      context,
      title: 'Hapus Pengingat',
      message: 'Batalkan pengingat "${reminder.title}"?',
      confirmLabel: 'Hapus',
      cancelLabel: 'Kembali',
      isDangerous: true,
    );

    if (confirmed && mounted) {
      final success = await ref
          .read(deleteReminderProvider.notifier)
          .deleteReminder(reminder);
      if (mounted && success) {
        SnackbarHelper.success(context, 'Pengingat telah dibatalkan');
      }
    }
  }

  /// Bottom Sheet Form Tambah Rekam Medis
  void _showAddHealthRecordSheet(BuildContext context, int petId) {
    final diagnosisCtrl = TextEditingController();
    final medicationCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: AppSizes.screenPadding,
                right: AppSizes.screenPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Catat Rekam Medis',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    // Input Tanggal
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primaryTeal,
                      ),
                      title: const Text('Tanggal Pemeriksaan'),
                      subtitle: Text(
                        DateFormat('dd MMMM yyyy', 'id').format(selectedDate),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const Divider(),
                    TextField(
                      controller: diagnosisCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Diagnosis / Tindakan Medis *',
                        hintText: 'Contoh: Vaksin Rabies, Flu Kucing',
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    TextField(
                      controller: medicationCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Resep / Obat (Opsional)',
                        hintText: 'Contoh: Amoxicillin syrup 2x1',
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Catatan Dokter / Perawatan',
                        hintText: 'Suhu 38.5, kondisi stabil',
                      ),
                    ),
                    const SizedBox(height: AppSizes.xl),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (diagnosisCtrl.text.trim().isEmpty) {
                          SnackbarHelper.warning(context, 'Diagnosis wajib diisi!');
                          return;
                        }

                        final newRecord = HealthRecord(
                          id: 0,
                          petId: petId,
                          date: selectedDate,
                          diagnosis: diagnosisCtrl.text.trim(),
                          medication: medicationCtrl.text.trim().isEmpty
                              ? null
                              : medicationCtrl.text.trim(),
                          notes: notesCtrl.text.trim().isEmpty
                              ? null
                              : notesCtrl.text.trim(),
                        );

                        Navigator.pop(ctx);
                        final success = await ref
                            .read(addHealthRecordProvider.notifier)
                            .addRecord(newRecord);
                        if (!mounted) return;
                        if (success) {
                          SnackbarHelper.success(context, 'Rekam medis berhasil disimpan!');
                        }
                      },
                      child: const Text('Simpan Rekam Medis'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Bottom Sheet Form Tambah Pengingat
  void _showAddReminderSheet(BuildContext context, int petId) {
    final titleCtrl = TextEditingController();
    String selectedType = 'vaccine';
    DateTime selectedDateTime = DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: AppSizes.screenPadding,
                right: AppSizes.screenPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Buat Pengingat Anabul',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.grey900,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    // Pilihan Tipe
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Vaksin')),
                            selected: selectedType == 'vaccine',
                            onSelected: (val) {
                              if (val) {
                                setModalState(() => selectedType = 'vaccine');
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Obat')),
                            selected: selectedType == 'medicine',
                            onSelected: (val) {
                              if (val) {
                                setModalState(() => selectedType = 'medicine');
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('Grooming')),
                            selected: selectedType == 'grooming',
                            onSelected: (val) {
                              if (val) {
                                setModalState(() => selectedType = 'grooming');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Judul Pengingat *',
                        hintText: 'Contoh: Vaksin Tricat Tahunan',
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.alarm,
                        color: AppColors.primaryTeal,
                      ),
                      title: const Text('Waktu Pengingat'),
                      subtitle: Text(
                        DateFormat('dd MMM yyyy, HH:mm', 'id')
                            .format(selectedDateTime),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null && context.mounted) {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                          );
                          if (pickedTime != null) {
                            setModalState(() {
                              selectedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: AppSizes.xl),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (titleCtrl.text.trim().isEmpty) {
                          SnackbarHelper.warning(context, 'Judul pengingat wajib diisi!');
                          return;
                        }

                        final newReminder = Reminder(
                          id: 0,
                          petId: petId,
                          title: titleCtrl.text.trim(),
                          type: selectedType,
                          scheduledTime: selectedDateTime,
                          isActive: true,
                        );

                        Navigator.pop(ctx);
                        final success = await ref
                            .read(addReminderProvider.notifier)
                            .addReminder(newReminder);
                        if (!mounted) return;
                        if (success) {
                          SnackbarHelper.success(
                            context,
                            'Pengingat berhasil dijadwalkan dengan notifikasi lokal!',
                          );
                        }
                      },
                      child: const Text('Simpan & Pasang Pengingat'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
