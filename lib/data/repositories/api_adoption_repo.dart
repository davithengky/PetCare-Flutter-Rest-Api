import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/adoption_model.dart';
import 'adoption_repo.dart';

/// Implementasi [AdoptionRepo] yang terhubung ke REST API PetCare.
class ApiAdoptionRepo implements AdoptionRepo {
  ApiAdoptionRepo(this._client);

  final ApiClient _client;

  @override
  Future<List<Adoption>> getAdoptions({String? search, String? species}) async {
    final res = await _client.get(
      '/adoptions',
      query: {
        'search': search,
        'species': _normalizeFilter(species),
      },
    );
    return apiList(res).map(Adoption.fromJson).toList();
  }

  @override
  Future<Adoption?> getAdoptionById(int id) async {
    final res = await _client.get('/adoptions/$id');
    final map = apiMap(res);
    return map.isEmpty ? null : Adoption.fromJson(map);
  }

  /// Mengabaikan filter spesies "Semua"/kosong agar tidak dikirim ke server.
  String? _normalizeFilter(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'semua') return null;
    return trimmed;
  }
}
