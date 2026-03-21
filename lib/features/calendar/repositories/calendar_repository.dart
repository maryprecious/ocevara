import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/calendar_day.dart';
import 'package:ocevara/core/models/region.dart';
import 'package:ocevara/core/services/api_service.dart';

final calendarRepositoryProvider = Provider((ref) => CalendarRepository(ref.read(apiServiceProvider)));

class CalendarRepository {
  final ApiService _api;

  CalendarRepository(this._api);

  Future<List<Region>> getRegions() async {
    try {
      final response = await _api.get('/fish/regions');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Region.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getMonthlyCalendar({
    required String regionId,
    required String month, // YYYY-MM
    String? speciesId,
  }) async {
    try {
      final response = await _api.get('/fish/calendar', queryParameters: {
        'region_id': regionId,
        'month': month,
        if (speciesId != null) 'species_id': speciesId,
      });
      return response.data['data'];
    } catch (e) {
      return {};
    }
  }
}
