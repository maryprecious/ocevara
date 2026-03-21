import 'package:json_annotation/json_annotation.dart';

part 'region.g.dart';

@JsonSerializable()
class Region {
  final String id;
  final String name;
  final String? country;
  final String? description;

  Region({
    required this.id,
    required this.name,
    this.country,
    this.description,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);
}
