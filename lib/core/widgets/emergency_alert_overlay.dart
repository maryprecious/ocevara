import 'package:flutter/material.dart';
import 'package:ocevara/core/services/emergency_alert_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

class EmergencyAlertOverlay extends StatefulWidget {
  const EmergencyAlertOverlay({super.key});

  @override
  State<EmergencyAlertOverlay> createState() => _EmergencyAlertOverlayState();
}

class _EmergencyAlertOverlayState extends State<EmergencyAlertOverlay> {
  final _service = EmergencyAlertService.instance;
  AudioPlayer? _player;
  Timer? _autoStopTimer;
  bool _isVibrating = false;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onChange);
  }

  @override
  void dispose() {
    _service.removeListener(_onChange);
    _stopPlaying();
    _stopVibrating();
    _autoStopTimer?.cancel();
    super.dispose();
  }

  void _onChange() => setState(() {});

  void _ensurePlaying(EmergencyAlert alert) async {
    if (kIsWeb) return; // skip audio on web
    _player ??= AudioPlayer();
    try {
    
      await _player!.setReleaseMode(ReleaseMode.loop);
      await _player!.play(AssetSource('sounds/beep.mp3'));
    } catch (_) {
      
    }

    
    _startVibrating();

    
    _autoStopTimer?.cancel();
    _autoStopTimer = Timer(const Duration(seconds: 30), () {
      if (_service.isActive) {
        _service.hide();
      }
    });
  }

  void _startVibrating() async {
    if (_isVibrating) return;
    _isVibrating = true;
    try {
      final canVibrate = await Vibration.hasVibrator() ?? false;
      if (canVibrate) {
        
        while (_isVibrating && _service.isActive) {
          await Vibration.vibrate(duration: 200);
          await Future.delayed(const Duration(milliseconds: 400));
        }
      }
    } catch (_) {
     
    }
  }

  void _stopVibrating() {
    _isVibrating = false;
  }

  void _stopPlaying() async {
    _stopVibrating();
    if (_player != null) {
      try {
        await _player!.stop();
      } catch (_) {}
    }
    _autoStopTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final alert = _service.active;
    if (alert == null) {
      _stopPlaying();
      return const SizedBox.shrink();
    }
    _ensurePlaying(alert);

    return IgnorePointer(
      ignoring: false,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GestureDetector(
              onTap: () {
                if (alert.critical) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(alert.title),
                      content: Text(alert.message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                } else {
                  
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.title,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(alert.message, style: GoogleFonts.lato()),
                          if (alert.zoneName != null)
                            Column(
                              children: [
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.orange.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.orange.shade700,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Zone: ${alert.zoneName}',
                                          style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange.shade700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          if (alert.zoneLatitude != null &&
                              alert.zoneLongitude != null)
                            Column(
                              children: [
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _openMapToZone(alert);
                                    },
                                    icon: const Icon(Icons.map_outlined),
                                    label: const Text('View on Map'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
              child: AnimatedPulse(
                active: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.dangerous, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.title,
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              alert.message,
                              style: GoogleFonts.lato(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => EmergencyAlertService.instance.hide(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openMapToZone(EmergencyAlert alert) {
    // When user taps "View on Map", navigate to a dedicated map screen
    // and pass coordinates. This is a placeholder - wire to map screen.
    if (alert.zoneLatitude != null && alert.zoneLongitude != null) {
      // e.g Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen(lat: alert.zoneLatitude, lng: alert.zoneLongitude, zoneName: alert.zoneName)));
      // For now, show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Map feature: Focus ${alert.zoneName} at (${alert.zoneLatitude}, ${alert.zoneLongitude})',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

// Simple pulsing wrapper to draw attention when alert is active.
class AnimatedPulse extends StatefulWidget {
  final Widget child;
  final bool active;
  const AnimatedPulse({super.key, required this.child, required this.active});

  @override
  State<AnimatedPulse> createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final scale = 1 + (_ctrl.value * 0.02);
        final blur = 8 + (_ctrl.value * 6);
        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.08 + _ctrl.value * 0.06),
                  blurRadius: blur,
                ),
              ],
              borderRadius: BorderRadius.circular(14),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

