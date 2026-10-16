import '../mocks/mock_clinics.dart';
import '../models/clinic_model.dart';
import 'clinic_repo.dart';

/// Implementasi in-memory mock repository untuk cabang PetCare Vet Clinic.
class MockClinicRepo implements ClinicRepo {
  final List<Clinic> _clinics = List.from(mockClinics);

  @override
  Future<List<Clinic>> getClinics({String? search, String? service}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _clinics.where((clinic) {
      // Filter search berdasarkan nama cabang atau alamat
      if (search != null && search.trim().isNotEmpty) {
        final query = search.trim().toLowerCase();
        final matchBranch = clinic.branchName.toLowerCase().contains(query);
        final matchAddress = clinic.address.toLowerCase().contains(query);
        final matchCity = clinic.city.toLowerCase().contains(query);
        if (!matchBranch && !matchAddress && !matchCity) {
          return false;
        }
      }

      // Filter jenis layanan
      if (service != null && service.isNotEmpty && service != 'all') {
        if (!clinic.services.contains(service)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Future<Clinic?> getClinicById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _clinics.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
