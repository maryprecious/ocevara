import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:ocevara/core/models/restricted_zone.dart';
import 'package:ocevara/features/map/repositories/map_repository.dart';
import 'package:ocevara/features/map/viewmodels/map_state.dart';
import 'package:vibration/vibration.dart';

final mapViewModelProvider = StateNotifierProvider<MapViewModel, MapState>((
  ref,
) {
  return MapViewModel(ref.read(mapRepositoryProvider));
});

class MapViewModel extends StateNotifier<MapState> {
  final MapRepository _repository;
  StreamSubscription<Position>? _positionSubscription;

  MapViewModel(this._repository) : super(MapState()) {
    _init();
  }

  Future<void> _init() async {
    final status = await _checkPermissions();
    if (status) {
      print('OCE_MAP: Permissions OK, fetching initial position...');
      await _loadInitialData();
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        print(
          'OCE_MAP: Initial position obtained: ${position.latitude}, ${position.longitude}',
        );
        _updateLocation(
          LatLng(position.latitude, position.longitude),
          position.heading,
        );
      } catch (e) {
        print('OCE_MAP: Initial fetch failed/timed out: $e');
        // Fallback to stream if direct fetch fails
      }
      _startLocationUpdates();
    } else {
      print('OCE_MAP: Permissions DENIED.');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> _checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    final zones = await _repository.getZones();
    final hotspots = await _repository.getHotspots();
    final catches = await _repository.getCatchLogs();
    state = state.copyWith(
      zones: zones,
      hotspots: hotspots,
      catchLogs: catches,
      isLoading: false,
    );
  }

  void _startLocationUpdates() {
    _positionSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          final userLoc = LatLng(position.latitude, position.longitude);
          _updateLocation(userLoc, position.heading);
        });
    }

  void _updateLocation(LatLng location, double? heading) {
    print(
      'OCE_MAP: Updating location: ${location.latitude}, ${location.longitude}, heading: $heading',
    );
    final updatedHistory = List<LatLng>.from(state.locationHistory ?? [])
      ..add(location);

    state = state.copyWith(
      userLocation: location,
      locationHistory: updatedHistory,
      userHeading: heading,
    );
    _checkDangerZones(location);
    _geocodeLocation(location);
  }

  Future<void> _geocodeLocation(LatLng location) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      ).timeout(const Duration(seconds: 5));
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((s) => s != null && s.isNotEmpty).join(', ');
        if (mounted) {
          state = state.copyWith(currentAddress: address);
        }
      }
    } catch (e) {
      if (mounted) {
        // Fallback to coordinates if geocoding fails or times out
        state = state.copyWith(
          currentAddress:
              '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
        );
      }
    }
  }

  void _checkDangerZones(LatLng userLoc) {
    MapSafetyStatus worstStatus = MapSafetyStatus.safe;
    RestrictedZone? worstZone;
    double? minDistance;

    for (final zone in state.zones) {
      if (zone.severity == 'DANGER' || zone.severity == 'CLOSED') {
        final distance = Geolocator.distanceBetween(
          userLoc.latitude,
          userLoc.longitude,
          zone.centerLat,
          zone.centerLng,
        );

        final radiusInMeters = zone.radiusKm * 1000;
        if (distance <= radiusInMeters) {
          worstStatus = MapSafetyStatus.danger;
          worstZone = zone;
          minDistance = distance;
          break; // Already in danger
        } else if (distance <= radiusInMeters + 1000) {
          if (worstStatus != MapSafetyStatus.danger) {
            worstStatus = MapSafetyStatus.warning;
            worstZone = zone;
            minDistance = distance;
          }
        }
      }
    }

    if (state.safetyStatus != worstStatus) {
      _triggerAlertFeedback(worstStatus);
    }

    state = state.copyWith(
      safetyStatus: worstStatus,
      activeWarningZone: worstZone,
      distanceToDanger: minDistance,
    );
  }

  Future<void> _triggerAlertFeedback(MapSafetyStatus status) async {
    if (status == MapSafetyStatus.warning) {
      Vibration.vibrate(duration: 500);
    } else if (status == MapSafetyStatus.danger) {
      Vibration.vibrate(pattern: [500, 200, 500, 200, 500]);
    }
  }

  void toggleHotspots() {
    state = state.copyWith(showHotspots: !state.showHotspots);
  }

  void toggleCatches() {
    state = state.copyWith(showCatches: !state.showCatches);
  }
  
  void toggleFollowUser() {
    state = state.copyWith(isFollowingUser: !state.isFollowingUser);
  }

  void updateZoom(double zoom) {
    state = state.copyWith(currentZoom: zoom.clamp(1.0, 20.0));
  }

  void selectLocation(LatLng location) {
    state = state.copyWith(selectedLocation: location, isFollowingUser: false);
    _geocodeLocation(location);
  }

  void clearSelection() {
    state = state.copyWith(selectedLocation: null);
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: [], isSearching: false);
      return;
    }

    state = state.copyWith(isSearching: true);
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final first = locations.first;
        final latLng = LatLng(first.latitude, first.longitude);
        selectLocation(latLng);
        
        // Update search results with a simple string for now
        // In a real app, we'd use a more sophisticated autocomplete API
        state = state.copyWith(
          searchResults: [query], 
          isSearching: false,
        );
      }
    } catch (e) {
      print('OCE_MAP: Search failed: $e');
      state = state.copyWith(isSearching: false);
    }
  }

  void clearSearch() {
    state = state.copyWith(searchResults: [], isSearching: false);
  }

  Future<bool> sendSOS() async {
    if (state.userLocation == null) return false;

    state = state.copyWith(isSOSActive: true);
    final success = await _repository.sendSOS(
      state.userLocation!.latitude,
      state.userLocation!.longitude,
    );

    if (success) {
      // Keep it active for visual effect
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) state = state.copyWith(isSOSActive: false);
      });
    } else {
      state = state.copyWith(isSOSActive: false);
    }
    return success;
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
