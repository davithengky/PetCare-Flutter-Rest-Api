import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/pet_model.dart';
import 'pet_repo.dart';

/// Implementasi [PetRepo] yang terhubung ke REST API PetCare.
class ApiPetRepo implements PetRepo {
  ApiPetRepo(this._client);

  final ApiClient _client;

  @override
  Future<List<Pet>> getPets() async {
    final res = await _client.get('/pets');
    return apiList(res).map(Pet.fromJson).toList();
  }

  @override
  Future<Pet?> getPetById(int id) async {
    final res = await _client.get('/pets/$id');
    final map = apiMap(res);
    return map.isEmpty ? null : Pet.fromJson(map);
  }

  @override
  Future<Pet> createPet(Pet pet) async {
    final res = await _client.post('/pets', body: _body(pet));
    return Pet.fromJson(apiMap(res));
  }

  @override
  Future<Pet> updatePet(Pet pet) async {
    final res = await _client.put('/pets/${pet.id}', body: _body(pet));
    return Pet.fromJson(apiMap(res));
  }

  @override
  Future<void> deletePet(int id) async {
    await _client.delete('/pets/$id');
  }

  /// Menyusun body permintaan sesuai aturan validasi backend.
  Map<String, dynamic> _body(Pet pet) {
    return {
      'name': pet.name,
      'species': pet.species,
      'breed': pet.breed,
      'gender': pet.gender,
      'age_months': pet.ageMonths,
      'weight_kg': pet.weightKg,
      'photo_url': pet.photoUrl,
    };
  }
}
