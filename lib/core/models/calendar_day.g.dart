// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarDay _$CalendarDayFromJson(Map<String, dynamic> json) => CalendarDay(
  date: json['date'] as String,
  dayOfWeek: json['day_of_week'] as String,
  riskLevel: json['risk_level'] as String,
  applicableRules: (json['applicable_rules'] as List<dynamic>)
      .map((e) => ApplicableRule.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CalendarDayToJson(CalendarDay instance) =>
    <String, dynamic>{
      'date': instance.date,
      'day_of_week': instance.dayOfWeek,
      'risk_level': instance.riskLevel,
      'applicable_rules': instance.applicableRules,
    };

ApplicableRule _$ApplicableRuleFromJson(Map<String, dynamic> json) =>
    ApplicableRule(
      ruleId: json['rule_id'] as String,
      message: json['message'] as String,
      riskLevel: json['risk_level'] as String,
    );

Map<String, dynamic> _$ApplicableRuleToJson(ApplicableRule instance) =>
    <String, dynamic>{
      'rule_id': instance.ruleId,
      'message': instance.message,
      'risk_level': instance.riskLevel,
    };
