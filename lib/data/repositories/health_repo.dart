import '../models/health_record_model.dart';

/// Kontrak repository untuk data rekam medis hewan.
abstract class HealthRepo {
  /// Mendapatkan daftar rekam medis berdasarkan ID hewan.
  Future<List<HealthRecord>> getRecordsByPet(int petId);

  /// Menambahkan rekam medis baru.
  Future<HealthRecord> createRecord(HealthRecord record);

  /// Menghapus rekam medis berdasarkan ID rekam medis.
  Future<void> deleteRecord(int id);
}
