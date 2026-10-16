import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/clinic_model.dart';
import 'clinic_repo.dart';

/// Implementasi [ClinicRepo] yang terhubung ke REST API PetCare.
class ApiClinicRepo implements ClinicRepo {
  ApiClinicRepo(this._client);

  final ApiClient _client;

  @override
  Future<List<Clinic>> getClinics({String? search, String? service}) async {
    final res = await _client.get(
      '/clinics',
      query: {'search': search, 'service': service},
    );
    return apiList(res).map(Clinic.fromJson).toList();
  }

  @override
  Future<Clinic?> getClinicById(int id) async {
    final res = await _client.get('/clinics/$id');
    final map = apiMap(res);
    return map.isEmpty ? null : Clinic.fromJson(map);
  }
}
