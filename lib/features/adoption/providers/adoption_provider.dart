import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/api/api_client.dart';
import '../../../data/models/adoption_model.dart';
import '../../../data/repositories/adoption_repo.dart';
import '../../../data/repositories/api_adoption_repo.dart';

/// Provider repository adopsi hewan.
final adoptionRepoProvider = Provider<AdoptionRepo>((ref) {
  return ApiAdoptionRepo(ref.watch(apiClientProvider));
});

/// State untuk filter adopsi (spesies & pencarian).
class AdoptionFilter {
  final String search;
  final String species;

  const AdoptionFilter({
    this.search = '',
    this.species = 'Semua',
  });

  AdoptionFilter copyWith({
    String? search,
    String? species,
  }) {
    return AdoptionFilter(
      search: search ?? this.search,
      species: species ?? this.species,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdoptionFilter &&
        other.search == search &&
        other.species == species;
  }

  @override
  int get hashCode => Object.hash(search, species);
}

class AdoptionFilterNotifier extends Notifier<AdoptionFilter> {
  @override
  AdoptionFilter build() => const AdoptionFilter();

  void setSearch(String query) {
    state = state.copyWith(search: query);
  }

  void setSpecies(String species) {
    state = state.copyWith(species: species);
  }

  void reset() {
    state = const AdoptionFilter();
  }
}

/// Provider filter adopsi.
final adoptionFilterProvider =
    NotifierProvider<AdoptionFilterNotifier, AdoptionFilter>(
  AdoptionFilterNotifier.new,
);

/// Notifier daftar hewan adopsi.
class AdoptionsNotifier extends AsyncNotifier<List<Adoption>> {
  @override
  Future<List<Adoption>> build() async {
    final filter = ref.watch(adoptionFilterProvider);
    final repo = ref.watch(adoptionRepoProvider);
    return repo.getAdoptions(
      search: filter.search,
      species: filter.species,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final filter = ref.read(adoptionFilterProvider);
    state = await AsyncValue.guard(
      () => ref.read(adoptionRepoProvider).getAdoptions(
            search: filter.search,
            species: filter.species,
          ),
    );
  }
}

/// Provider daftar hewan adopsi.
final adoptionsProvider =
    AsyncNotifierProvider<AdoptionsNotifier, List<Adoption>>(
  AdoptionsNotifier.new,
);

/// Provider detail adopsi per ID.
final adoptionByIdProvider = FutureProvider.family<Adoption?, int>((ref, id) {
  return ref.watch(adoptionRepoProvider).getAdoptionById(id);
});
