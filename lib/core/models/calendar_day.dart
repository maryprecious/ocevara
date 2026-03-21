import 'package:json_annotation/json_annotation.dart';

part 'calendar_day.g.dart';

@JsonSerializable()
class CalendarDay {
  final String date;
  @JsonKey(name: 'day_of_week')
  final String dayOfWeek;
  @JsonKey(name: 'risk_level')
  final String riskLevel;
  @JsonKey(name: 'applicable_rules')
  final List<ApplicableRule> applicableRules;

  CalendarDay({
    required this.date,
    required this.dayOfWeek,
    required this.riskLevel,
    required this.applicableRules,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) => _$CalendarDayFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarDayToJson(this);
}

@JsonSerializable()
class ApplicableRule {
  @JsonKey(name: 'rule_id')
  final String ruleId;
  final String message;
  @JsonKey(name: 'risk_level')
  final String riskLevel;

  ApplicableRule({
    required this.ruleId,
    required this.message,
    required this.riskLevel,
  });

  factory ApplicableRule.fromJson(Map<String, dynamic> json) => _$ApplicableRuleFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicableRuleToJson(this);
}
