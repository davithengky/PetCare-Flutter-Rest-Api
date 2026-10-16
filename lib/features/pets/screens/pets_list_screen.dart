import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/pet_photos.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/pets_provider.dart';

/// Halaman daftar anabul milik pengguna.
class PetsListScreen extends ConsumerWidget {
  const PetsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anabul Saya'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: petsAsync.when(
        loading: () => const LoadingWidget(message: 'Memuat data anabul...'),
        error: (err, stack) => CustomErrorWidget(
          message: err.toString(),
          onRetry: () => ref.refresh(petsProvider),
        ),
        data: (pets) {
          if (pets.isEmpty) {
            return EmptyState(
              icon: Icons.pets,
              title: 'Belum Ada Anabul',
              subtitle: 'Yuk tambah anabul pertamamu untuk menggunakan fitur lengkap',
              actionLabel: 'Tambah Anabul',
              onAction: () => context.push('/pets/add'),
            );
          }


          return ListView.separated(
            padding: const EdgeInsets.all(AppSizes.screenPadding),
            itemCount: pets.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSizes.listItemGap),
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(AppSizes.md),
                  leading: AppImage(
                    url: pet.photoUrl ?? defaultPetPhotoUrl(pet.species),
                    width: 48,
                    height: 48,
                    fallbackIcon: Icons.pets,
                    fallbackColor: AppColors.primaryTeal,
                    backgroundColor: AppColors.primaryLight,
                    fallbackIconSize: 24,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  title: Text(
                    pet.name,
                    style: AppTextStyles.h4,
                  ),
                  subtitle: Text(
                    '${pet.species} ${pet.breed != null ? '• ${pet.breed}' : ''}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.grey500,
                  ),
                  onTap: () => context.push('/pets/${pet.id}'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pets/add'),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
