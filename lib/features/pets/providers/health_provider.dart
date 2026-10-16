import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/api/api_client.dart';
import '../../../data/models/health_record_model.dart';
import '../../../data/repositories/api_health_repo.dart';
import '../../../data/repositories/health_repo.dart';

/// Provider singleton untuk repository rekam medis.
final healthRepoProvider = Provider<HealthRepo>((ref) {
  return ApiHealthRepo(ref.watch(apiClientProvider));
});

/// Provider family daftar rekam medis hewan per petId.
final petHealthRecordsProvider =
    FutureProvider.family<List<HealthRecord>, int>((ref, petId) {
  return ref.watch(healthRepoProvider).getRecordsByPet(petId);
});

/// Notifier aksi menambah rekam medis.
class AddHealthRecordNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> addRecord(HealthRecord record) async {
    state = const AsyncLoading();
    try {
      await ref.read(healthRepoProvider).createRecord(record);
      ref.invalidate(petHealthRecordsProvider(record.petId));
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final addHealthRecordProvider =
    AsyncNotifierProvider<AddHealthRecordNotifier, void>(
  AddHealthRecordNotifier.new,
);

/// Notifier aksi menghapus rekam medis.
class DeleteHealthRecordNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> deleteRecord(int id, int petId) async {
    state = const AsyncLoading();
    try {
      await ref.read(healthRepoProvider).deleteRecord(id);
      ref.invalidate(petHealthRecordsProvider(petId));
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final deleteHealthRecordProvider =
    AsyncNotifierProvider<DeleteHealthRecordNotifier, void>(
  DeleteHealthRecordNotifier.new,
);
