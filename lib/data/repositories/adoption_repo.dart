import '../models/adoption_model.dart';

/// Kontrak repository untuk program adopsi hewan.
abstract class AdoptionRepo {
  /// Mendapatkan daftar hewan adopsi dengan filter pencarian dan jenis hewan.
  Future<List<Adoption>> getAdoptions({String? search, String? species});

  /// Mengambil detail hewan adopsi berdasarkan ID.
  Future<Adoption?> getAdoptionById(int id);
}
