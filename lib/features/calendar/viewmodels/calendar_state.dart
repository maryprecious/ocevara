import 'package:ocevara/core/models/calendar_day.dart';
import 'package:ocevara/core/models/region.dart';

class CalendarState {
  final List<Region> regions;
  final Region? selectedRegion;
  final List<CalendarDay> days;
  final Map<String, int> summary; // low_days, medium_days, etc.
  final bool isLoading;
  final String? error;
  final String selectedMonth; // YYYY-MM

  CalendarState({
    this.regions = const [],
    this.selectedRegion,
    this.days = const [],
    this.summary = const {},
    this.isLoading = false,
    this.error,
    required this.selectedMonth,
  });

  CalendarState copyWith({
    List<Region>? regions,
    Region? selectedRegion,
    List<CalendarDay>? days,
    Map<String, int>? summary,
    bool? isLoading,
    String? error,
    String? selectedMonth,
  }) {
    return CalendarState(
      regions: regions ?? this.regions,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      days: days ?? this.days,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }
}
