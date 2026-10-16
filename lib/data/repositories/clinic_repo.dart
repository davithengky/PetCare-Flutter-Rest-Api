import '../models/clinic_model.dart';

/// Kontrak repositori untuk data cabang PetCare Vet Clinic.
abstract class ClinicRepo {
  /// Mengambil daftar cabang dengan filter [search] kata kunci dan [service] jenis layanan.
  Future<List<Clinic>> getClinics({String? search, String? service});

  /// Mengambil cabang klinik berdasarkan [id].
  Future<Clinic?> getClinicById(int id);
}
