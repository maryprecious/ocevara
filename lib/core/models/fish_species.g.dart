// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fish_species.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FishSpecies _$FishSpeciesFromJson(Map<String, dynamic> json) => FishSpecies(
  id: json['id'] as String,
  commonName: json['common_name'] as String,
  scientificName: json['scientific_name'] as String,
  description: json['description'] as String,
  habitats: (json['habitats'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  imageUrl: json['image_url'] as String?,
  howToCatch: json['how_to_catch'] as String,
  isProtected: json['is_protected'] as bool? ?? false,
  category: json['category'] as String? ?? 'fish',
  conservationStatus: json['conservation_status'] as String?,
  identificationTips:
      (json['identification_tips'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  sizeLimits: json['size_limits'] as String?,
  bestSeasons:
      (json['best_seasons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  nutritionalValue: json['nutritional_value'] as String?,
  catchTechniques:
      (json['catch_techniques'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$FishSpeciesToJson(FishSpecies instance) =>
    <String, dynamic>{
      'id': instance.id,
      'common_name': instance.commonName,
      'scientific_name': instance.scientificName,
      'description': instance.description,
      'habitats': instance.habitats,
      'image_url': instance.imageUrl,
      'how_to_catch': instance.howToCatch,
      'is_protected': instance.isProtected,
      'category': instance.category,
      'conservation_status': instance.conservationStatus,
      'identification_tips': instance.identificationTips,
      'size_limits': instance.sizeLimits,
      'best_seasons': instance.bestSeasons,
      'nutritional_value': instance.nutritionalValue,
      'catch_techniques': instance.catchTechniques,
    };
