// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  fullName: json['full_name'] as String,
  email: json['email'] as String?,
  phoneNumber: json['phone_number'] as String?,
  role: json['role'] as String? ?? 'fisher',
  profileImageUrl: json['profile_image_url'] as String?,
  totalCatches: json['total_catches'] == null
      ? 0
      : User._toInt(json['total_catches']),
  totalWeight: json['total_weight'] == null
      ? 0.0
      : User._toDouble(json['total_weight']),
  level: (json['level'] as num?)?.toInt() ?? 1,
  emailVerified: json['email_verified'] as bool? ?? false,
  phoneVerified: json['phone_verified'] as bool? ?? false,
  isActive: json['is_active'] as bool? ?? true,
  googleId: json['google_id'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'email': instance.email,
  'phone_number': instance.phoneNumber,
  'role': instance.role,
  'profile_image_url': instance.profileImageUrl,
  'total_catches': instance.totalCatches,
  'total_weight': instance.totalWeight,
  'level': instance.level,
  'email_verified': instance.emailVerified,
  'phone_verified': instance.phoneVerified,
  'is_active': instance.isActive,
  'google_id': instance.googleId,
};
