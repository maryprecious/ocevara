// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catch_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CatchLog _$CatchLogFromJson(Map<String, dynamic> json) => CatchLog(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  speciesId: json['species_id'] as String,
  speciesName: json['species_name'] as String?,
  quantity: (json['quantity'] as num).toDouble(),
  avgWeight: (json['avg_weight'] as num?)?.toDouble(),
  unit: json['unit'] as String? ?? 'count',
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  imagePath: json['image_path'] as String?,
  synced: json['synced'] == null
      ? false
      : const BoolConverter().fromJson((json['synced'] as num).toInt()),
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$CatchLogToJson(CatchLog instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'species_id': instance.speciesId,
  'species_name': instance.speciesName,
  'quantity': instance.quantity,
  'avg_weight': instance.avgWeight,
  'unit': instance.unit,
  'lat': instance.lat,
  'lng': instance.lng,
  'date': instance.date.toIso8601String(),
  'image_path': instance.imagePath,
  'synced': const BoolConverter().toJson(instance.synced),
  'metadata': instance.metadata,
};
