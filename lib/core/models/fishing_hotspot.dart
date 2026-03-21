import 'package:json_annotation/json_annotation.dart';

part 'fishing_hotspot.g.dart';

@JsonSerializable()
class FishingHotspot {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'top_species')
  final String topSpecies;
  @JsonKey(name: 'activity_level')
  final int activityLevel; // 1-5
  @JsonKey(name: 'best_lure')
  final String bestLure;

  FishingHotspot({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.topSpecies,
    required this.activityLevel,
    required this.bestLure,
  });

  factory FishingHotspot.fromJson(Map<String, dynamic> json) => _$FishingHotspotFromJson(json);
  Map<String, dynamic> toJson() => _$FishingHotspotToJson(this);
}
