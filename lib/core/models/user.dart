import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String role;
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  @JsonKey(name: 'total_catches', fromJson: _toInt)
  final int totalCatches;
  @JsonKey(name: 'total_weight', fromJson: _toDouble)
  final double totalWeight;

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
  final int level;
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool isActive;
  @JsonKey(name: 'google_id')
  final String? googleId;

  User({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneNumber,
    this.role = 'fisher',
    this.profileImageUrl,
    this.totalCatches = 0,
    this.totalWeight = 0.0,
    this.level = 1,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.isActive = true,
    this.googleId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
