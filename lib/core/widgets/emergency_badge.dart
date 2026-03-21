import 'package:flutter/material.dart';
import 'package:ocevara/core/widgets/emergency_alert_overlay.dart';

/// emergency badge that displays emergency alerts as an overlay
class EmergencyBadge extends StatelessWidget {
  const EmergencyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmergencyAlertOverlay();
  }
}

