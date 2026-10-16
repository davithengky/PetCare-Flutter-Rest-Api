import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/api/api_client.dart';
import '../../../data/models/pet_model.dart';
import '../../../data/repositories/api_pet_repo.dart';
import '../../../data/repositories/pet_repo.dart';

/// Provider dependency injection untuk repository anabul
final petRepoProvider = Provider<PetRepo>(
  (ref) => ApiPetRepo(ref.watch(apiClientProvider)),
);

/// Notifier untuk mengelola daftar hewan peliharaan (Pet)
class PetsNotifier extends AsyncNotifier<List<Pet>> {
  @override
  Future<List<Pet>> build() {
    return ref.read(petRepoProvider).getPets();
  }

  /// Menambahkan anabul baru
  Future<void> addPet(Pet pet) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(petRepoProvider);
      await repo.createPet(pet);
      return repo.getPets();
    });
  }

  /// Memperbarui informasi anabul
  Future<void> updatePet(Pet pet) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(petRepoProvider);
      await repo.updatePet(pet);
      return repo.getPets();
    });
  }

  /// Menghapus data anabul
  Future<void> deletePet(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(petRepoProvider);
      await repo.deletePet(id);
      return repo.getPets();
    });
  }
}

/// Provider global untuk PetsNotifier
final petsProvider =
    AsyncNotifierProvider<PetsNotifier, List<Pet>>(PetsNotifier.new);

/// Provider untuk menghitung jumlah anabul yang dimiliki pengguna
final petsCountProvider = Provider<int>((ref) {
  return ref.watch(petsProvider).value?.length ?? 0;
});
