import '../models/health_record_model.dart';
import 'health_repo.dart';

/// Implementasi Mock in-memory repository untuk rekam medis.
class MockHealthRepo implements HealthRepo {
  final List<HealthRecord> _records = [
    HealthRecord(
      id: 1,
      petId: 1,
      date: DateTime.now().subtract(const Duration(days: 14)),
      diagnosis: 'Vaksinasi Feline Tricat Rutin & Pemeriksaan Fisik',
      medication: 'Vitamin Imunovit Gel, Obat Cacing Drontal Cat',
      notes: 'Kondisi suhu tubuh 38.5 C normal, nafsu makan baik, berat 3.8 kg.',
    ),
    HealthRecord(
      id: 2,
      petId: 1,
      date: DateTime.now().subtract(const Duration(days: 45)),
      diagnosis: 'Pembersihan Telinga & Kontrol Jamur Kulit (Ear Mites)',
      medication: 'Tetes Telinga Otopet 2x sehari selama 5 hari',
      notes: 'Telinga kanan terdapat kotoran cokelat, kulit leher sudah membaik.',
    ),
    HealthRecord(
      id: 3,
      petId: 2,
      date: DateTime.now().subtract(const Duration(days: 20)),
      diagnosis: 'Vaksinasi Rabies & Cek Gigi',
      medication: 'Spray Pembersih Karang Gigi',
      notes: 'Gigi taring bersih, tidak ada plak berbahaya, anjing aktif.',
    ),
  ];

  int _nextId = 4;

  @override
  Future<List<HealthRecord>> getRecordsByPet(int petId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final result = _records.where((record) => record.petId == petId).toList();
    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  @override
  Future<HealthRecord> createRecord(HealthRecord record) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newRecord = record.copyWith(id: _nextId++);
    _records.add(newRecord);
    return newRecord;
  }

  @override
  Future<void> deleteRecord(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _records.removeWhere((record) => record.id == id);
  }
}
