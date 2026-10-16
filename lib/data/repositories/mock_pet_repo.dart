import '../mocks/mock_pets.dart';
import '../models/pet_model.dart';
import 'pet_repo.dart';

/// Implementasi mock repository untuk manajemen anabul (in-memory).
class MockPetRepo implements PetRepo {
  final List<Pet> _pets = List.from(mockPets);
  int _nextId = 1;

  @override
  Future<List<Pet>> getPets() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_pets);
  }

  @override
  Future<Pet?> getPetById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _pets.indexWhere((p) => p.id == id);
    if (index == -1) return null;
    return _pets[index];
  }

  @override
  Future<Pet> createPet(Pet pet) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final newPet = pet.copyWith(id: _nextId++);
    _pets.add(newPet);
    return newPet;
  }

  @override
  Future<Pet> updatePet(Pet pet) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _pets.indexWhere((p) => p.id == pet.id);
    if (index != -1) {
      _pets[index] = pet;
    }
    return pet;
  }

  @override
  Future<void> deletePet(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _pets.removeWhere((p) => p.id == id);
  }
}
