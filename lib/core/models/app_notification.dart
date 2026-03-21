import 'package:json_annotation/json_annotation.dart';

part 'app_notification.g.dart';

@JsonSerializable()
class AppNotification {
  final String id;
  final String? title;
  final String message;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'status')
  final String status; 
  final String severity; 
  final String? type;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isRead => status == 'read';

  AppNotification({
    required this.id,
    this.title,
    required this.message,
    required this.createdAt,
    this.status = 'sent',
    this.severity = 'info',
    this.type,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);
}
