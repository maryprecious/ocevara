import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:ocevara/core/models/restricted_zone.dart';
import 'package:ocevara/core/models/fishing_hotspot.dart';
import 'package:ocevara/core/services/auth_service.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/features/map/viewmodels/map_state.dart';
import 'package:ocevara/features/map/viewmodels/map_view_model.dart';
import 'package:ocevara/features/map/widgets/pulse_marker.dart';
import 'package:ocevara/features/home/screens/home_screen.dart';
import 'package:ocevara/core/utils/image_utils.dart';
import 'package:ocevara/features/map/screens/fishing_zones_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final String? zoneName;

  const MapScreen({super.key, this.initialLat, this.initialLng, this.zoneName});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with TickerProviderStateMixin {
  late final MapController _mapController;
  bool _hasCenteredOnUser = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _recenter() {
    final state = ref.read(mapViewModelProvider);
    final userLoc = state.userLocation;
    final viewModel = ref.read(mapViewModelProvider.notifier);

    if (userLoc != null) {
      _animateMapMove(userLoc, state.currentZoom == 18.0 ? 15.0 : 18.0);

      if (!state.isFollowingUser) {
        viewModel.toggleFollowUser();
      }
    }
  }

  void _animateMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: _mapController.camera.center.latitude, 
        end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: _mapController.camera.center.longitude, 
        end: destLocation.longitude);
    final zoomTween = Tween<double>(
        begin: _mapController.camera.zoom, 
        end: destZoom);

    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final animation = CurvedAnimation(
        parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapViewModelProvider);
    final viewModel = ref.read(mapViewModelProvider.notifier);
    final user = ref.watch(userProvider);

    // Listen for selected location changes to animate map
    ref.listen(mapViewModelProvider.select((s) => s.selectedLocation), (previous, next) {
      if (next != null && next != previous) {
        _animateMapMove(next, 15);
      }
    });

    // Listen for user location changes
    ref.listen(mapViewModelProvider.select((s) => s.userLocation), (previous, next) {
      if (next != null) {
        // If this is the first time we get a location, center on it
        if (previous == null && !_hasCenteredOnUser && widget.initialLat == null) {
          _animateMapMove(next, mapState.currentZoom);
          _hasCenteredOnUser = true;
        } 
        // If we are in "follow" mode, keep the map centered
        else if (mapState.isFollowingUser) {
          _mapController.move(next, _mapController.camera.zoom);
        }
      }
    });

    // Auto-center logic for initial load with widget params
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialLat != null && widget.initialLng != null && !_hasCenteredOnUser) {
        _animateMapMove(LatLng(widget.initialLat!, widget.initialLng!), 15);
        _hasCenteredOnUser = true;
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // 1. Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter:
                  mapState.userLocation ?? const LatLng(6.5244, 3.3792),
              initialZoom: mapState.currentZoom,
              onPositionChanged: (pos, hasGesture) {
                if (hasGesture && mapState.isFollowingUser) {
                  viewModel.toggleFollowUser();
                }
                // Sync zoom state if it changed via gesture
                if (hasGesture && pos.zoom != mapState.currentZoom) {
                  viewModel.updateZoom(pos.zoom!);
                }
              },
              onTap: (tapPosition, point) {
                viewModel.selectLocation(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ocevara',
                tileProvider: CancellableNetworkTileProvider(),
              ),

              // Zone circles
              CircleLayer(
                circles: mapState.zones.map((zone) {
                  return CircleMarker(
                    point: LatLng(zone.centerLat, zone.centerLng),
                    radius: zone.radiusKm * 1000,
                    useRadiusInMeter: true,
                    color: _getZoneColor(zone.severity).withOpacity(0.3),
                    borderColor: _getZoneColor(zone.severity),
                    borderStrokeWidth: 2,
                  );
                }).toList(),
              ),

              // Movement Path Line
              if (mapState.locationHistory.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: mapState.locationHistory,
                      color: AppColors.primaryNavy,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),

              if (mapState.showCatches)
                MarkerLayer(
                  markers: mapState.catchLogs.map((log) {
                    return Marker(
                      point: LatLng(log.lat, log.lng),
                      width: 50,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Color(0xFF1CB5AC),
                            size: 40,
                          ),
                          Positioned(
                            top: 4,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              backgroundImage: log.imagePath != null
                                  ? (log.imagePath!.startsWith('http')
                                        ? NetworkImage(log.imagePath!)
                                              as ImageProvider
                                        : FileImage(io.File(log.imagePath!)))
                                  : null,
                              child: log.imagePath == null
                                  ? const Icon(
                                      Icons.set_meal,
                                      size: 14,
                                      color: Color(0xFF1CB5AC),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              // Hotspots (Toggleable)
              if (mapState.showHotspots)
                MarkerLayer(
                  markers: mapState.hotspots.map((spot) {
                    return Marker(
                      point: LatLng(spot.latitude, spot.longitude),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => _showHotspotSheet(context, spot),
                        child: PulseMarker(
                          color: const Color(0xFF1CB5AC),
                          child: const Icon(
                            Icons.waves,
                            color: Color(0xFF1CB5AC),
                            size: 30,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              // Dummy Map Markers (TikTok Style - Relative to User)
              if (mapState.userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        mapState.userLocation!.latitude + 0.012,
                        mapState.userLocation!.longitude + 0.008,
                      ),
                      width: 70,
                      height: 70,
                      child: PulseMarker(
                        color: Colors.blue,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.blue,
                              size: 50,
                            ),
                            const Positioned(
                              top: 5,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200&h=200&auto=format&fit=crop',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Marker(
                      point: LatLng(
                        mapState.userLocation!.latitude - 0.015,
                        mapState.userLocation!.longitude + 0.012,
                      ),
                      width: 70,
                      height: 70,
                      child: PulseMarker(
                        color: Colors.purple,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.purple,
                              size: 50,
                            ),
                            const Positioned(
                              top: 5,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&h=200&auto=format&fit=crop',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Marker(
                      point: LatLng(
                        mapState.userLocation!.latitude + 0.005,
                        mapState.userLocation!.longitude - 0.010,
                      ),
                      width: 70,
                      height: 70,
                      child: PulseMarker(
                        color: Colors.green,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Colors.green,
                              size: 50,
                            ),
                            const Positioned(
                              top: 5,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=200&h=200&auto=format&fit=crop',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              if (mapState.userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: mapState.userLocation!,
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Directional Halo
                          if (mapState.userHeading != null)
                             Transform.rotate(
                                angle: (mapState.userHeading! * (3.14159 / 180)),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.primaryTeal.withOpacity(0.4),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.navigation,
                                    size: 20,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                              ),
                          PulseMarker(
                            color: mapState.safetyStatus == MapSafetyStatus.danger
                                ? Colors.red
                                : mapState.safetyStatus == MapSafetyStatus.warning
                                ? Colors.yellow
                                : AppColors.primaryTeal,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                backgroundImage: user?.profileImageUrl != null
                                    ? ImageUtils.getProfileImageProvider(
                                        user!.profileImageUrl!,
                                      )
                                    : null,
                                child: user?.profileImageUrl == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 24,
                                        color: AppColors.primaryNavy,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              // Selected Location Marker
              if (mapState.selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: mapState.selectedLocation!,
                      width: 60,
                      height: 60,
                      child: GestureDetector(
                        onTap: () => viewModel.clearSelection(),
                        child: PulseMarker(
                          color: Colors.orange,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.orange,
                            size: 45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // 2. Warning UI (Blinking border / Red overlay)
          if (mapState.safetyStatus == MapSafetyStatus.warning)
            _WarningBorder(color: Colors.yellow.withOpacity(0.4)),
          if (mapState.safetyStatus == MapSafetyStatus.danger)
            Container(color: Colors.red.withOpacity(0.2)),

          // 3. Top Controls (Back, Legend, Toggle)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _circularButton(Icons.arrow_back, () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const HomeScreen(initialIndex: 0),
                            ),
                            (route) => false,
                          );
                        }),
                        const SizedBox(width: 10),
                        _circularButton(Icons.format_list_bulleted, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FishingZonesScreen(),
                            ),
                          );
                        }),
                      ],
                    ),
                    Row(
                      children: [
                        _circularButton(
                          mapState.showHotspots
                              ? Icons.layers
                              : Icons.layers_outlined,
                          () => viewModel.toggleHotspots(),
                        ),
                        const SizedBox(width: 12),
                        _circularButton(
                          Icons.info_outline,
                          () => _showLegend(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    onSubmitted: (value) => viewModel.searchLocation(value),
                    decoration: InputDecoration(
                      hintText: mapState.currentAddress ?? 'Search location...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primaryTeal),
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.lato(color: Colors.grey),
                    ),
                  ),
                ),
                if (mapState.isSearching)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
                    ),
                  ),
              ],
            ),
          ),

          // 4. Bottom Warning Banner
          if (mapState.safetyStatus == MapSafetyStatus.warning)
            Positioned(
              bottom: 180,
              left: 20,
              right: 20,
              child: _WarningBanner(
                title: '⚠ Danger zone ahead',
                subtitle:
                    '${(mapState.distanceToDanger! / 1000).toStringAsFixed(1)}km away',
                color: Colors.yellow.shade800,
              ),
            ),

          // 5. Danger Modal (Full Screen Overlay style)
          if (mapState.safetyStatus == MapSafetyStatus.danger)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    const BoxShadow(color: Colors.black26, blurRadius: 20),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'HIGH RISK ZONE',
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You are inside a restricted fishing area. Please leave immediately for your safety.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () => _recenter(),
                        child: const Text(
                          'VIEW SAFE ROUTE',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 6. Right Side Controls
          Positioned(
            bottom: 100,
            right: 20,
            child: Column(
              children: [
                Column(
                  children: [
                    _circularButton(Icons.add, () {
                      final newZoom = mapState.currentZoom + 0.5;
                      viewModel.updateZoom(newZoom);
                      _mapController.move(
                        _mapController.camera.center,
                        newZoom,
                      );
                    }),
                    const SizedBox(height: 8),
                    _circularButton(Icons.remove, () {
                      final newZoom = mapState.currentZoom - 0.5;
                      viewModel.updateZoom(newZoom);
                      _mapController.move(
                        _mapController.camera.center,
                        newZoom,
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                _circularButton(
                  mapState.isFollowingUser ? Icons.my_location : Icons.location_searching,
                  _recenter,
                  active: mapState.isFollowingUser,
                ),
                if (mapState.userLocation == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Locating...',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _sosButton(() async {
                  final success = await viewModel.sendSOS();
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Location shared successfully'),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getZoneColor(String severity) {
    switch (severity) {
      case 'SAFE':
        return Colors.green;
      case 'ADVISORY':
        return Colors.orange;
      case 'DANGER':
        return Colors.red;
      case 'CLOSED':
        return Colors.grey.shade800;
      default:
        return Colors.blue;
    }
  }

  Widget _circularButton(IconData icon, VoidCallback onTap, {bool active = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: active ? AppColors.primaryTeal : Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Icon(icon, color: active ? Colors.white : AppColors.primaryTeal),
      ),
    );
  }

  Widget _sosButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.redAccent, blurRadius: 15)],
        ),
        child: const Center(
          child: Text(
            'SOS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  void _showLegend(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Map Legend',
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _legendItem(Colors.green, 'SAFE', 'Good for fishing'),
            _legendItem(Colors.orange, 'CAREFUL', 'Advisory zone'),
            _legendItem(Colors.red, 'DANGER', 'Restricted area'),
            _legendItem(Colors.grey.shade800, 'CLOSED', 'No fishing allowed'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('GOT IT'),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                desc,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showHotspotSheet(BuildContext context, FishingHotspot spot) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spot.name,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _infoRow(Icons.set_meal, 'Top Species', spot.topSpecies),
            _infoRow(
              Icons.trending_up,
              'Activity Level',
              '${spot.activityLevel}/5',
            ),
            _infoRow(Icons.anchor, 'Best Lure', spot.bestLure),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1CB5AC),
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'SET AS DESTINATION',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _WarningBorder extends StatefulWidget {
  final Color color;
  const _WarningBorder({required this.color});

  @override
  State<_WarningBorder> createState() => _WarningBorderState();
}

class _WarningBorderState extends State<_WarningBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.color.withOpacity(_controller.value),
              width: 10,
            ),
          ),
        );
      },
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  const _WarningBanner({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
