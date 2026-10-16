import '../mocks/mock_adoptions.dart';
import '../models/adoption_model.dart';
import 'adoption_repo.dart';

/// Implementasi mock repository untuk program adopsi hewan.
class MockAdoptionRepo implements AdoptionRepo {
  final List<Adoption> _adoptions = List<Adoption>.from(mockAdoptions);

  @override
  Future<List<Adoption>> getAdoptions({String? search, String? species}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    var results = List<Adoption>.from(_adoptions);

    if (species != null &&
        species.isNotEmpty &&
        species.toLowerCase() != 'semua') {
      results = results
          .where((item) => item.species.toLowerCase() == species.toLowerCase())
          .toList();
    }

    if (search != null && search.trim().isNotEmpty) {
      final query = search.trim().toLowerCase();
      results = results
          .where((item) =>
              item.name.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query) ||
              item.species.toLowerCase().contains(query))
          .toList();
    }

    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  @override
  Future<Adoption?> getAdoptionById(int id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _adoptions.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }
}
