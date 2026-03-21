import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/restricted_zone.dart';
import 'package:ocevara/core/repositories/i_zone_repository.dart';
import 'package:ocevara/core/services/api_service.dart';
import 'package:ocevara/core/services/database_service.dart';

/// Provides the concrete [ZoneRepository] to the Riverpod tree.
/// Maps the feature to the [IZoneRepository] abstraction.
final zoneRepositoryProvider = Provider<IZoneRepository>((ref) {
  return ZoneRepository(ref.read(apiServiceProvider));
});

/// Concrete implementation of [IZoneRepository].
/// Fetches zones from the API and caches them locally for offline use.
class ZoneRepository implements IZoneRepository {
  final ApiService _api;

  ZoneRepository(this._api);

  @override
  Future<List<RestrictedZone>> getZones() async {
    try {
      final response = await _api.get('/fish/zones');
      final List<dynamic> data = response.data;
      final zones = data.map((json) => RestrictedZone.fromJson(json)).toList();

      // Persist to local DB for offline fallback
      await _cacheZones(zones);
      return zones;
    } catch (e) {
      // Fallback to local cache when offline
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
