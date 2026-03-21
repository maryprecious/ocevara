import 'package:json_annotation/json_annotation.dart';

part 'restricted_zone.g.dart';

@JsonSerializable()
class RestrictedZone {
  final String id;
  final String name;
  final String reason;
  @JsonKey(name: 'center_lat')
  final double centerLat;
  @JsonKey(name: 'center_lng')
  final double centerLng;
  @JsonKey(name: 'radius_km')
  final double radiusKm;
  final String severity; // SAFE | ADVISORY | DANGER | CLOSED

  RestrictedZone({
    required this.id,
    required this.name,
    required this.reason,
    required this.centerLat,
    required this.centerLng,
    required this.radiusKm,
    required this.severity,
  });

  factory RestrictedZone.fromJson(Map<String, dynamic> json) => _$RestrictedZoneFromJson(json);
  Map<String, dynamic> toJson() => _$RestrictedZoneToJson(this);
}
