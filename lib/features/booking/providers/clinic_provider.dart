import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/api/api_client.dart';
import '../../../data/models/clinic_model.dart';
import '../../../data/repositories/api_clinic_repo.dart';
import '../../../data/repositories/clinic_repo.dart';

/// Provider instance [ClinicRepo] untuk data cabang PetCare.
final clinicRepoProvider = Provider<ClinicRepo>((ref) {
  return ApiClinicRepo(ref.watch(apiClientProvider));
});

/// FutureProvider untuk mengambil semua daftar cabang klinik PetCare.
final clinicsListProvider = FutureProvider<List<Clinic>>((ref) async {
  final repo = ref.watch(clinicRepoProvider);
  return repo.getClinics();
});

/// Provider untuk mengambil data detail klinik berdasarkan [id].
final clinicByIdProvider = FutureProvider.family<Clinic?, int>((ref, id) async {
  return ref.read(clinicRepoProvider).getClinicById(id);
});
