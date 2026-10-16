import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/health_record_model.dart';
import 'health_repo.dart';

/// Implementasi [HealthRepo] yang terhubung ke REST API PetCare.
class ApiHealthRepo implements HealthRepo {
  ApiHealthRepo(this._client);

  final ApiClient _client;

  @override
  Future<List<HealthRecord>> getRecordsByPet(int petId) async {
    final res = await _client.get('/pets/$petId/health-records');
    return apiList(res).map(HealthRecord.fromJson).toList();
  }

  @override
  Future<HealthRecord> createRecord(HealthRecord record) async {
    final res = await _client.post(
      '/pets/${record.petId}/health-records',
      body: {
        'date': record.date.toIso8601String(),
        'diagnosis': record.diagnosis,
        'medication': record.medication,
        'notes': record.notes,
      },
    );

    return HealthRecord.fromJson(apiMap(res));
  }

  @override
  Future<void> deleteRecord(int id) async {
    await _client.delete('/health-records/$id');
  }
}
