import 'package:ocevara/core/models/restricted_zone.dart';

/// Abstract contract for the Fishing Zone data source.
/// ViewModels depend on this interface, not on the concrete implementation.
/// This satisfies the Dependency Inversion Principle (SOLID).
abstract class IZoneRepository {
  /// Fetches all restricted/fishing zones.
  /// Falls back to local cache if the API is unreachable.
  Future<List<RestrictedZone>> getZones();
}
