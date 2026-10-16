import '../models/pet_model.dart';

/// Kontrak repository untuk manajemen data anabul (Pet).
abstract class PetRepo {
  /// Mengambil daftar semua hewan peliharaan milik pengguna.
  Future<List<Pet>> getPets();

  /// Mengambil detail hewan peliharaan berdasarkan id.
  Future<Pet?> getPetById(int id);

  /// Menambahkan anabul baru.
  Future<Pet> createPet(Pet pet);

  /// Memperbarui informasi anabul.
  Future<Pet> updatePet(Pet pet);

  /// Menghapus data anabul berdasarkan id.
  Future<void> deletePet(int id);
}
