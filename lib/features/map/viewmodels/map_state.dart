import 'package:latlong2/latlong.dart';
import 'package:ocevara/core/models/restricted_zone.dart';
import 'package:ocevara/core/models/fishing_hotspot.dart';
import 'package:ocevara/core/models/catch_log.dart';

enum MapSafetyStatus { safe, warning, danger }
class MapState {
  final LatLng? userLocation;
  final List<RestrictedZone> zones;
  final List<FishingHotspot> hotspots;
  final List<CatchLog> catchLogs;
  final bool showHotspots;
  final bool showCatches;
  final MapSafetyStatus safetyStatus;
  final RestrictedZone? activeWarningZone;
  final double? distanceToDanger;
  final bool isSOSActive;
  final bool isLoading;
  final String? currentAddress;
  final List<LatLng> locationHistory;
  final double? userHeading;
  final bool isFollowingUser;
  final double currentZoom;
  final LatLng? selectedLocation;
  final List<String> searchResults;
  final bool isSearching;

  MapState({
    this.userLocation,
    this.zones = const [],
    this.hotspots = const [],
    this.catchLogs = const [],
    this.showHotspots = true,
    this.showCatches = true,
    this.safetyStatus = MapSafetyStatus.safe,
    this.activeWarningZone,
    this.distanceToDanger,
    this.isSOSActive = false,
    this.isLoading = true,
    this.currentAddress = 'Locating...',
    this.locationHistory = const [],
    this.userHeading,
    this.isFollowingUser = true,
    this.currentZoom = 15.0,
    this.selectedLocation,
    this.searchResults = const [],
    this.isSearching = false,
  });

  MapState copyWith({
    LatLng? userLocation,
    List<RestrictedZone>? zones,
    List<FishingHotspot>? hotspots,
    List<CatchLog>? catchLogs,
    bool? showHotspots,
    bool? showCatches,
    MapSafetyStatus? safetyStatus,
    RestrictedZone? activeWarningZone,
    double? distanceToDanger,
    bool? isSOSActive,
    bool? isLoading,
    String? currentAddress,
    List<LatLng>? locationHistory,
    double? userHeading,
    bool? isFollowingUser,
    double? currentZoom,
    LatLng? selectedLocation,
    List<String>? searchResults,
    bool? isSearching,
  }) {
    return MapState(
      userLocation: userLocation ?? this.userLocation,
      zones: zones ?? this.zones,
      hotspots: hotspots ?? this.hotspots,
      catchLogs: catchLogs ?? this.catchLogs,
      showHotspots: showHotspots ?? this.showHotspots,
      showCatches: showCatches ?? this.showCatches,
      safetyStatus: safetyStatus ?? this.safetyStatus,
      activeWarningZone: activeWarningZone ?? this.activeWarningZone,
      distanceToDanger: distanceToDanger ?? this.distanceToDanger,
      isSOSActive: isSOSActive ?? this.isSOSActive,
      isLoading: isLoading ?? this.isLoading,
      currentAddress: currentAddress ?? this.currentAddress,
      locationHistory: locationHistory ?? this.locationHistory,
      userHeading: userHeading ?? this.userHeading,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
      currentZoom: currentZoom ?? this.currentZoom,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
