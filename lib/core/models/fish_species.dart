import 'package:json_annotation/json_annotation.dart';

part 'fish_species.g.dart';

@JsonSerializable()
class FishSpecies {
  final String id;
  @JsonKey(name: 'common_name')
  final String commonName;
  @JsonKey(name: 'scientific_name')
  final String scientificName;
  final String description;
  final List<String> habitats;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'how_to_catch')
  final String howToCatch;
  @JsonKey(name: 'is_protected')
  final bool isProtected;
  final String category;
  @JsonKey(name: 'conservation_status')
  final String? conservationStatus;
  @JsonKey(name: 'identification_tips')
  final List<String> identificationTips;
  @JsonKey(name: 'size_limits')
  final String? sizeLimits;
  @JsonKey(name: 'best_seasons')
  final List<String> bestSeasons;
  @JsonKey(name: 'nutritional_value')
  final String? nutritionalValue;
  @JsonKey(name: 'catch_techniques')
  final List<String> catchTechniques;

  FishSpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.habitats,
    this.imageUrl,
    required this.howToCatch,
    this.isProtected = false,
    this.category = 'fish',
    this.conservationStatus,
    this.identificationTips = const [],
    this.sizeLimits,
    this.bestSeasons = const [],
    this.nutritionalValue,
    this.catchTechniques = const [],
  });

  factory FishSpecies.fromJson(Map<String, dynamic> json) => _$FishSpeciesFromJson(json);
  Map<String, dynamic> toJson() => _$FishSpeciesToJson(this);
}
