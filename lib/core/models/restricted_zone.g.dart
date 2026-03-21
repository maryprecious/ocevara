// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restricted_zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestrictedZone _$RestrictedZoneFromJson(Map<String, dynamic> json) =>
    RestrictedZone(
      id: json['id'] as String,
      name: json['name'] as String,
      reason: json['reason'] as String,
      centerLat: (json['center_lat'] as num).toDouble(),
      centerLng: (json['center_lng'] as num).toDouble(),
      radiusKm: (json['radius_km'] as num).toDouble(),
      severity: json['severity'] as String,
    );

Map<String, dynamic> _$RestrictedZoneToJson(RestrictedZone instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reason': instance.reason,
      'center_lat': instance.centerLat,
      'center_lng': instance.centerLng,
      'radius_km': instance.radiusKm,
      'severity': instance.severity,
    };
