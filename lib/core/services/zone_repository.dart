import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/restricted_zone.dart';
import 'package:ocevara/core/services/api_service.dart';
import 'package:ocevara/core/services/database_service.dart';

final zoneRepositoryProvider = Provider((ref) => ZoneRepository(ref.read(apiServiceProvider)));

class ZoneRepository {
  final ApiService _api;

  ZoneRepository(this._api);

  /// this will fetch all restricted zones. this will try API first, then fall back to local DB cache.
  Future<List<RestrictedZone>> getZones() async {
    try {
      final response = await _api.get('/zones');
      final List<dynamic> data = response.data;
      final zones = data.map((json) => RestrictedZone.fromJson(json)).toList();

      // Sync with local DB
      await _cacheZones(zones);
      return zones;
    } catch (e) {
      // fallback to local cache
      final cached = await DatabaseService.instance.getAllZones();
      return cached.map((json) => RestrictedZone.fromJson(json)).toList();
    }
  }

  Future<void> _cacheZones(List<RestrictedZone> zones) async {
    await DatabaseService.instance.clearZones();
    for (final zone in zones) {
      await DatabaseService.instance.insertZone(zone.toJson());
    }
  }
}
