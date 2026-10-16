import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

/// Halaman untuk mengubah informasi profil pengguna (Nama, Telepon, Alamat).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final user = ref.read(authProvider).value?.user;
      _nameController = TextEditingController(text: user?.name ?? '');
      _phoneController = TextEditingController(text: user?.phone ?? '');
      _addressController = TextEditingController(text: user?.address ?? '');
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value?.user;
    final editState = ref.watch(editProfileProvider);
    final isLoading = editState.isLoading;

    final initial = (user?.name.isNotEmpty ?? false)
        ? user!.name.substring(0, 1).toUpperCase()
        : 'U';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Stack dengan tombol kamera
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryTeal,
                      child: Text(
                        initial,
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.white,
                          fontSize: 36,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          SnackbarHelper.info(
                            context,
                            'Fitur upload foto segera hadir',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryTeal,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),

              // Form Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap *',
                  hintText: 'Masukkan nama Anda',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Nama harus minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.lg),

              // Form Email (Disabled)
              TextFormField(
                initialValue: user?.email ?? '',
                enabled: false,
                style: AppTextStyles.body.copyWith(color: AppColors.grey500),
                decoration: InputDecoration(
                  labelText: 'Email (Tidak dapat diubah)',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: AppColors.grey100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.grey300),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Form Telepon
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  hintText: 'Contoh: 081234567890',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: AppSizes.lg),

              // Form Alamat
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Alamat Rumah',
                  hintText: 'Contoh: Jl. Raya Darmo No. 12, Surabaya',
                  prefixIcon: Icon(Icons.home_outlined),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: AppSizes.xxxl),

              // Tombol Simpan Perubahan
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.btn),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          final router = GoRouter.of(context);

                          final success = await ref
                              .read(editProfileProvider.notifier)
                              .updateProfile(
                                name: _nameController.text.trim(),
                                phone: _phoneController.text.trim(),
                                address: _addressController.text.trim(),
                              );

                          if (!mounted) return;

                          if (success) {
                            SnackbarHelper.success(context, 'Profil berhasil diperbarui');
                            router.pop();
                          } else {
                            SnackbarHelper.error(
                              context,
                              'Gagal memperbarui profil. Silakan coba lagi.',
                            );
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: AppTextStyles.button,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
