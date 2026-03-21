import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/restricted_zone.dart';
import 'package:ocevara/core/models/fishing_hotspot.dart';
import 'package:ocevara/core/models/catch_log.dart';
import 'package:ocevara/core/services/api_service.dart';

final mapRepositoryProvider = Provider((ref) => MapRepository(ref.read(apiServiceProvider)));

class MapRepository {
  final ApiService _api;

  MapRepository(this._api);

  Future<List<RestrictedZone>> getZones() async {
    try {
      final response = await _api.get('/fish/zones');
      final List<dynamic> data = response.data;
      return data.map((json) => RestrictedZone.fromJson(json)).toList();
    } catch (e) {
      // Fallback or empty list
      return [];
    }
  }

  Future<List<FishingHotspot>> getHotspots() async {
    try {
      final response = await _api.get('/fish/hotspots');
      final List<dynamic> data = response.data;
      return data.map((json) => FishingHotspot.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<CatchLog>> getCatchLogs() async {
    try {
      final response = await _api.get('/fish/catch-logs');
      final List<dynamic> data = response.data;
      return data.map((json) => CatchLog.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> sendSOS(double lat, double lng) async {
    try {
      final response = await _api.post('/fish/sos', data: {
        'latitude': lat,
        'longitude': lng,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
