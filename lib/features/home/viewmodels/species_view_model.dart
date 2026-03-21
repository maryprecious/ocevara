import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/fish_species.dart';
import 'package:ocevara/features/home/repositories/species_repository.dart';

final speciesViewModelProvider = StateNotifierProvider<SpeciesViewModel, List<FishSpecies>>((ref) {
  return SpeciesViewModel(ref.read(speciesRepositoryProvider));
});

class SpeciesViewModel extends StateNotifier<List<FishSpecies>> {
  final SpeciesRepository _repository;

  SpeciesViewModel(this._repository) : super([]) {
    loadSpecies();
  }

  Future<void> loadSpecies() async {
    final species = await _repository.getAllSpecies();
    state = species;
  }
}
