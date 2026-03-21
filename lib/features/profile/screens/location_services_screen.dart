import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class LocationServicesScreen extends StatefulWidget {
  const LocationServicesScreen({super.key});

  @override
  State<LocationServicesScreen> createState() => _LocationServicesScreenState();
}

class _LocationServicesScreenState extends State<LocationServicesScreen> {
  String _selectedPermission = 'Always Allow';

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;
    final secondaryBlue = AppColors.primaryNavy.withOpacity(0.8);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(
        title: 'Location Access',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Enable Location Services',
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ocevara uses your location to provide accurate fishing data, weather alerts, and conservation insights.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('How We Use Location'),
            const SizedBox(height: 12),
            _buildUsageTile(Icons.set_meal_outlined, 'Catch Logging', 'Automatically record where you caught fish'),
            _buildUsageTile(Icons.tsunami_outlined, 'Weather Alerts', 'Get severe weather warnings for your area'),
            _buildUsageTile(Icons.waves, 'Tide Information', 'Real-time tides and best fishing times'),
            _buildUsageTile(Icons.explore_outlined, 'Hotspot Discovery', 'Find popular fishing spots nearby'),

            const SizedBox(height: 32),
            _buildSectionLabel('Choose Your Preference'),
            const SizedBox(height: 16),
            _buildDetailedPreference(
              'Always Allow',
              'Best fishing experience',
              Icons.check_circle_outline,
              [
                'Automatic catch location logging',
                'Background weather alerts',
                'Real-time tide notifications',
                'Optimal fishing time alerts',
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailedPreference(
              'While Using the App',
              'Manual location access',
              Icons.access_time,
              [
                'Manual catch location logging',
                'Weather when app is open',
                'Location-based features available',
                'No background tracking',
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailedPreference(
              'Never',
              'No location tracking',
              Icons.cancel_outlined,
              [
                'Manual location entry only',
                'No automatic features',
                'Limited weather data',
                'Maximum privacy',
              ],
            ),

            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, color: Color(0xFF2C5282), size: 22),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Privacy is Protected',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your location data is encrypted and never sold to third parties. You can change these settings anytime.',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: primaryBlue.withOpacity(0.7),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 14, color: Color(0xFF1CB5AC)),
                              const SizedBox(width: 4),
                              Text('Encrypted', style: GoogleFonts.lato(fontSize: 12, color: const Color(0xFF1CB5AC))),
                              const SizedBox(width: 16),
                              const Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF1CB5AC)),
                              const SizedBox(width: 4),
                              Text('You control access', style: GoogleFonts.lato(fontSize: 12, color: const Color(0xFF1CB5AC))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildActionCard(Icons.info_outline, 'Why does ocevara need location?', 'Learn more about location usage'),

            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9E9F0),
                        foregroundColor: const Color(0xFF0F3950),
                        elevation: 1,
                        shadowColor: Colors.black.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text('Select a Permission Level', style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(color: Colors.grey.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: Text('Not Now', style: GoogleFonts.lato(color: Colors.grey.shade500, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.settings_outlined, size: 18, color: primaryBlue),
                label: Text('Open iOS Settings', style: GoogleFonts.lato(color: primaryBlue, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildUsageTile(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFFF1F6F7), shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF0F3950), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F3950)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedPreference(String title, String subtitle, IconData mainIcon, List<String> features) {
    bool isSelected = _selectedPermission == title;
    const Color primaryBlue = Color(0xFF0F3950);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => setState(() => _selectedPermission = title),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.getCardBackground(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? primaryBlue : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? primaryBlue : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Icon(mainIcon, color: isSelected ? const Color(0xFF1CB5AC) : Colors.grey.shade400, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.lato(fontSize: 17, fontWeight: FontWeight.bold, color: primaryBlue),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.lato(fontSize: 13, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(left: 40, bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      title == 'Never' ? Icons.cancel_outlined : Icons.check_circle_outline, 
                      size: 16, 
                      color: isSelected ? const Color(0xFF1CB5AC) : Colors.grey.shade300
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: GoogleFonts.lato(
                          fontSize: 13, 
                          color: isSelected ? primaryBlue.withOpacity(0.8) : Colors.grey.shade400
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFFF1F6F7), shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF0F3950), size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF0F3950)),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}
