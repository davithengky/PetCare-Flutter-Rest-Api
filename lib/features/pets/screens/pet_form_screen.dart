import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/pet_photos.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/app_image.dart';
import '../../../data/models/pet_model.dart';
import '../providers/pets_provider.dart';

/// Halaman form untuk menambah atau mengedit profil anabul.
class PetFormScreen extends ConsumerStatefulWidget {
  final bool isOnboarding;
  final Pet? existingPet;

  const PetFormScreen({
    super.key,
    this.isOnboarding = false,
    this.existingPet,
  });

  @override
  ConsumerState<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends ConsumerState<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _breedController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;

  String? _selectedSpecies;
  String? _selectedGender;
  String? _selectedPhotoUrl;
  bool _isSubmitting = false;

  final List<String> _speciesList = [
    'Kucing',
    'Anjing',
  ];

  final List<String> _genderList = [
    'jantan',
    'betina',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.existingPet;
    _nameController = TextEditingController(text: p?.name ?? '');
    _breedController = TextEditingController(text: p?.breed ?? '');
    _ageController =
        TextEditingController(text: p != null ? p.ageMonths.toString() : '');
    _weightController =
        TextEditingController(text: p != null ? p.weightKg.toString() : '');
    _selectedSpecies = p?.species;
    _selectedGender = p?.gender;
    _selectedPhotoUrl = p?.photoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final weight =
        double.tryParse(_weightController.text.trim().replaceAll(',', '.')) ??
            0.0;

    final petData = Pet(
      id: widget.existingPet?.id ?? 0,
      userId: widget.existingPet?.userId ?? 1,
      name: _nameController.text.trim(),
      species: _selectedSpecies!,
      breed: _breedController.text.trim().isEmpty
          ? null
          : _breedController.text.trim(),
      gender: _selectedGender!,
      ageMonths: age,
      weightKg: weight,
      photoUrl: _selectedPhotoUrl ?? defaultPetPhotoUrl(_selectedSpecies!),
    );

    try {
      if (widget.existingPet != null) {
        await ref.read(petsProvider.notifier).updatePet(petData);
      } else {
        await ref.read(petsProvider.notifier).addPet(petData);
      }

      if (!mounted) return;

      SnackbarHelper.success(
        context,
        widget.existingPet != null
            ? 'Data anabul berhasil diperbarui'
            : 'Anabul berhasil ditambahkan',
      );

      if (widget.isOnboarding) {
        context.go('/main/home');
      } else {
        context.pop();
      }
    } catch (e) {
      if (!mounted) return;
      SnackbarHelper.error(context, 'Gagal menyimpan anabul: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// Galeri pilihan foto bawaan untuk anabul.
  ///
  /// Opsi pertama adalah foto default sesuai spesies terpilih, diikuti
  /// foto-foto bawaan lain dengan spesies yang sama.
  Widget _buildPhotoPicker() {
    final species = _selectedSpecies ?? 'Kucing';
    final options = <PetPhotoOption>[
      PetPhotoOption(
        url: defaultPetPhotoUrl(species),
        label: 'Default',
        species: species,
      ),
      ...petPhotoPresets.where((p) => p.species == species),
    ];

    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = _selectedPhotoUrl == option.url ||
              (_selectedPhotoUrl == null && index == 0);

          return GestureDetector(
            onTap: () => setState(() => _selectedPhotoUrl = option.url),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryTeal
                          : AppColors.grey300,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                  ),
                  child: AppImage(
                    url: option.url,
                    width: 48,
                    height: 48,
                    fallbackIcon: Icons.pets,
                    fallbackColor: AppColors.primaryTeal,
                    backgroundColor: AppColors.primaryLight,
                    fallbackIconSize: 22,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  option.label,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 9,
                    color: isSelected
                        ? AppColors.primaryTeal
                        : AppColors.grey500,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingPet != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Anabul' : 'Tambah Anabul'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview foto anabul
              Center(
                child: AppImage(
                  url: _selectedPhotoUrl ??
                      defaultPetPhotoUrl(_selectedSpecies ?? 'Kucing'),
                  width: 96,
                  height: 96,
                  fallbackIcon: Icons.pets,
                  fallbackColor: AppColors.primaryTeal,
                  backgroundColor: AppColors.primaryLight,
                  fallbackIconSize: 42,
                  borderRadius: BorderRadius.circular(48),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Text(
                'Pilih Foto Anabul',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              _buildPhotoPicker(),
              const SizedBox(height: AppSizes.xl),

              // Field Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Anabul',
                  hintText: 'Misal: Milo',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama anabul wajib diisi';
                  }
                  if (val.trim().length < 2) {
                    return 'Nama minimal 2 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.listItemGap),

              // Field Spesies
              DropdownButtonFormField<String>(
                initialValue: _selectedSpecies,
                decoration: const InputDecoration(
                  labelText: 'Spesies',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: _speciesList
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedSpecies = val;
                    // Reset pilihan foto bila tidak sesuai spesies baru.
                    if (_selectedPhotoUrl != null) {
                      final stillValid = petPhotoPresets.any(
                        (p) => p.url == _selectedPhotoUrl && p.species == val,
                      );
                      if (!stillValid) _selectedPhotoUrl = null;
                    }
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Pilih spesies anabul';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.listItemGap),

              // Field Ras / Breed
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Ras / Breed (Opsional)',
                  hintText: 'Misal: Golden Retriever, Persia',
                  prefixIcon: Icon(Icons.pets_outlined),
                ),
              ),
              const SizedBox(height: AppSizes.listItemGap),

              // Field Jenis Kelamin
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Jenis Kelamin',
                  prefixIcon: Icon(Icons.transgender_outlined),
                ),
                items: _genderList
                    .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g[0].toUpperCase() + g.substring(1)),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedGender = val;
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Pilih jenis kelamin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.listItemGap),

              // Field Umur
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Umur (Bulan)',
                  hintText: 'Misal: 12',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Umur wajib diisi';
                  }
                  final age = int.tryParse(val.trim());
                  if (age == null || age < 0) {
                    return 'Masukkan umur yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.listItemGap),

              // Field Berat
              TextFormField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Berat (Kg)',
                  hintText: 'Misal: 4.5',
                  prefixIcon: Icon(Icons.scale_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Berat wajib diisi';
                  }
                  final weight = double.tryParse(
                    val.trim().replaceAll(',', '.'),
                  );
                  if (weight == null || weight <= 0) {
                    return 'Masukkan berat yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.xxl),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: AppColors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      )
                    : const Text(
                        'Simpan',
                        style: AppTextStyles.button,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
