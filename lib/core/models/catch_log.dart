import 'package:json_annotation/json_annotation.dart';
import 'package:ocevara/core/models/bool_converter.dart';

part 'catch_log.g.dart';

@JsonSerializable()
class CatchLog {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'species_id')
  final String speciesId;
  @JsonKey(name: 'species_name')
  final String? speciesName;
  final double quantity;
  @JsonKey(name: 'avg_weight')
  final double? avgWeight;
  final String unit; 
  final double lat;
  final double lng;
  final DateTime date;
  @JsonKey(name: 'image_path')
  final String? imagePath;
  
  @BoolConverter()
  final bool synced;

  final Map<String, dynamic>? metadata;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final String? displayDate;
  final String? displayTime;
  final String? displayTimestamp;

  CatchLog({
    required this.id,
    required this.userId,
    required this.speciesId,
    this.speciesName,
    required this.quantity,
    this.avgWeight,
    this.unit = 'count',
    required this.lat,
    required this.lng,
    required this.date,
    this.imagePath,
    this.synced = false,
    this.metadata,
    this.createdAt,
    this.displayDate,
    this.displayTime,
    this.displayTimestamp,
  });

  factory CatchLog.fromJson(Map<String, dynamic> json) => _$CatchLogFromJson(json);
  Map<String, dynamic> toJson() => _$CatchLogToJson(this);

  CatchLog copyWith({
    String? id,
    String? userId,
    String? speciesId,
    String? speciesName,
    double? quantity,
    double? avgWeight,
    String? unit,
    double? lat,
    double? lng,
    DateTime? date,
    String? imagePath,
    bool? synced,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    String? displayDate,
    String? displayTime,
    String? displayTimestamp,
  }) {
    return CatchLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      speciesId: speciesId ?? this.speciesId,
      speciesName: speciesName ?? this.speciesName,
      quantity: quantity ?? this.quantity,
      avgWeight: avgWeight ?? this.avgWeight,
      unit: unit ?? this.unit,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
      synced: synced ?? this.synced,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      displayDate: displayDate ?? this.displayDate,
      displayTime: displayTime ?? this.displayTime,
      displayTimestamp: displayTimestamp ?? this.displayTimestamp,
    );
  }
}
