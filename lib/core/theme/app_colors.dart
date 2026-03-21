import 'package:flutter/material.dart';

class AppColors {
  // Branding Colors
  static const Color primaryNavy = Color(0xFF0F3950);
  static const Color primaryTeal = Color(0xFF1CB5AC);
  static const Color accentBlue = Color(0xFF2463EB);
  static const Color navy = primaryNavy;
  static const Color tealAccent = primaryTeal;
  static const Color primaryBlue = primaryNavy;
  
  // States
  static const Color danger = Color(0xFFE53E3E);
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFD69E2E);
  
  // Light Mode Palette
  static const Color lightScaffold = Color(0xFFFFF5F6);
  static const Color lightCard = Colors.white;
  static const Color lightTextPrimary = Color(0xFF0F3950);
  static const Color lightTextSecondary = Color(0xFF718096);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Mode Palette
  static const Color darkScaffold = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFF7FBFD);
  static const Color darkTextSecondary = Color(0xFFA0AEC0);
  static const Color darkBorder = Color(0xFF2D3748);

  static Color getScaffoldBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkScaffold : lightScaffold;
  }

  static Color getCardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextPrimary : lightTextPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkTextSecondary : lightTextSecondary;
  }

  static Color getBrandingContainerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? Color(0xFF1A3A4A) : primaryNavy;
  }
}
