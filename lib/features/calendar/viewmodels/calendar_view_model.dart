import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ocevara/core/models/calendar_day.dart';
import 'package:ocevara/features/calendar/repositories/calendar_repository.dart';
import 'package:ocevara/features/calendar/viewmodels/calendar_state.dart';

final calendarViewModelProvider = StateNotifierProvider<CalendarViewModel, CalendarState>((ref) {
  return CalendarViewModel(ref.read(calendarRepositoryProvider));
});

class CalendarViewModel extends StateNotifier<CalendarState> {
  final CalendarRepository _repository;

  CalendarViewModel(this._repository)
      : super(CalendarState(selectedMonth: DateFormat('yyyy-MM').format(DateTime.now()))) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    final regions = await _repository.getRegions();
    if (regions.isNotEmpty) {
      state = state.copyWith(regions: regions, selectedRegion: regions.first);
      await loadCalendar();
    } else {
      state = state.copyWith(isLoading: false, error: 'No regions found');
    }
  }

  Future<void> loadCalendar() async {
    if (state.selectedRegion == null) return;
    
    state = state.copyWith(isLoading: true);
    final data = await _repository.getMonthlyCalendar(
      regionId: state.selectedRegion!.id,
      month: state.selectedMonth,
    );

    if (data.containsKey('calendar')) {
      final List<dynamic> calData = data['calendar'];
      final days = calData.map((json) => CalendarDay.fromJson(json)).toList();
      
      final Map<String, dynamic> sumData = data['summary'];
      final summary = {
        'low': sumData['low_days'] as int,
        'medium': sumData['medium_days'] as int,
        'high': sumData['high_days'] as int,
        'critical': sumData['critical_days'] as int,
      };

      state = state.copyWith(
        days: days,
        summary: summary,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false, error: 'Failed to load calendar');
    }
  }

  void changeRegion(String regionId) {
    final region = state.regions.firstWhere((r) => r.id == regionId);
    state = state.copyWith(selectedRegion: region);
    loadCalendar();
  }

  void changeMonth(DateTime dateTime) {
    state = state.copyWith(selectedMonth: DateFormat('yyyy-MM').format(dateTime));
    loadCalendar();
  }
}
