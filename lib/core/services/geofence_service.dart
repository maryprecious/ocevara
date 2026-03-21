import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ocevara/core/models/restricted_zone.dart';
import 'package:ocevara/core/services/location_service.dart';
import 'package:ocevara/core/services/zone_repository.dart';
import 'package:ocevara/core/services/emergency_alert_service.dart';

final geofenceServiceProvider = Provider((ref) => GeofenceService(ref));

class GeofenceService {
  final Ref _ref;
  StreamSubscription<Position>? _positionSubscription;
  List<RestrictedZone> _activeZones = [];
  final Set<String> _insideZones = {};

  GeofenceService(this._ref);

  Future<void> startMonitoring() async {
    //Loading zones
    _activeZones = await _ref.read(zoneRepositoryProvider).getZones();
    
    //starting position stream
    final locationService = LocationService();
    _positionSubscription = locationService.getPositionStream().listen((position) {
      _checkGeofences(position);
    });
  }

  void stopMonitoring() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  void _checkGeofences(Position position) {
    for (final zone in _activeZones) {
      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        zone.centerLat,
        zone.centerLng,
      );

      final isInside = distanceInMeters <= (zone.radiusKm * 1000);

      if (isInside && !_insideZones.contains(zone.id)) {
        // just entered
        _insideZones.add(zone.id);
        _triggerAlert(zone);
      } else if (!isInside && _insideZones.contains(zone.id)) {
        // just exited
        _insideZones.remove(zone.id);
      }
    }
  }

  void _triggerAlert(RestrictedZone zone) {
    EmergencyAlertService.instance.show(
      EmergencyAlert(
        title: 'RESTRICTED AREA: ${zone.name}',
        message: 'You have entered a ${zone.severity} priority zone: ${zone.reason}. Please vacate the area.',
        critical: zone.severity == 'high',
        zoneName: zone.name,
        zoneLatitude: zone.centerLat,
        zoneLongitude: zone.centerLng,
        zoneRadiusKm: zone.radiusKm,
      ),
    );
  }
}
