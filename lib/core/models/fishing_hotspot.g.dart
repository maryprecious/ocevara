// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fishing_hotspot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FishingHotspot _$FishingHotspotFromJson(Map<String, dynamic> json) =>
    FishingHotspot(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      topSpecies: json['top_species'] as String,
      activityLevel: (json['activity_level'] as num).toInt(),
      bestLure: json['best_lure'] as String,
    );

Map<String, dynamic> _$FishingHotspotToJson(FishingHotspot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'top_species': instance.topSpecies,
      'activity_level': instance.activityLevel,
      'best_lure': instance.bestLure,
    };
