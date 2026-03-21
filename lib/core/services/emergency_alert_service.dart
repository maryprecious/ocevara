import 'package:flutter/material.dart';

class EmergencyAlert {
  final String title;
  final String message;
  final bool critical; 
  final double? zoneLatitude;  
  final double? zoneLongitude; 
  final double? zoneRadiusKm;  
  final String? zoneName;      

  EmergencyAlert({
    required this.title,
    required this.message,
    this.critical = false,
    this.zoneLatitude,
    this.zoneLongitude,
    this.zoneRadiusKm,
    this.zoneName,
  });
}

class EmergencyAlertService extends ChangeNotifier {
  EmergencyAlertService._private();

  static final EmergencyAlertService instance =
      EmergencyAlertService._private();

  EmergencyAlert? _active;

  EmergencyAlert? get active => _active;

  bool get isActive => _active != null;

  void show(EmergencyAlert alert) {
    _active = alert;
    notifyListeners();
  }

  void hide() {
    _active = null;
    notifyListeners();
  }
}
