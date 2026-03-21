import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/features/home/screens/home_screen.dart';

class AppPermissionsScreen extends StatefulWidget {
  const AppPermissionsScreen({super.key});

  @override
  State<AppPermissionsScreen> createState() => _AppPermissionsScreenState();
}

class _AppPermissionsScreenState extends State<AppPermissionsScreen> {
  bool _notificationsPermission = false;
  bool _locationPermission = false;
  // default permissions should be off until user explicitly enables them

  // NOTE: actual platform permission dialogs should be triggered separately;
  // these toggles control the in-app preference only.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: const Color(0xFF0F3950),
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'App Permissions',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F3950),
                ),
              ),
              const SizedBox(height: 20),

              // Subtitle
              Text(
                'To fully activate and enjoy the features, the app requires the following permissions. These ensure accurate data access and support responsible, conservation-focused fishing practices',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: const Color(0xFF0F3950),
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Notifications Permission Card
              _buildPermissionCard(
                title: 'Notifications',
                description:
                    'We use your location to provide area-specific fishing regulations, protected zone alerts, and species protection guidance to help you fish responsibly.',
                value: _notificationsPermission,
                onChanged: (value) {
                  setState(() {
                    _notificationsPermission = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Location Permission Card
              _buildPermissionCard(
                title: 'Location',
                description:
                    'Get real-time updates on wildlife protection rules, conservation warnings, and regulation changes in your area.',
                value: _locationPermission,
                onChanged: (value) {
                  setState(() {
                    _locationPermission = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 80),

              // Done Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to home screen
                    //  Navigator.pushReplacement(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => AppPermissionsScreen()),
                    //     );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F3950),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required String title,
    required String description,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE7), // Beige/cream background
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F3950),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0F3950),
                inactiveTrackColor: Colors.grey.shade300,
                inactiveThumbColor: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: const Color(0xFF0F3950),
              fontWeight: FontWeight.w500,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
