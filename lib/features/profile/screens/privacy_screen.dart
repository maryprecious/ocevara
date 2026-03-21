import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String _locationAccess = 'Always';
  bool _preciseLocation = true;
  bool _usageAnalytics = true;
  bool _crashReports = true;
  bool _photoMetadata = true;
  bool _shareConservationData = true;

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;
    final secondaryBlue = AppColors.primaryNavy.withOpacity(0.8);
    final cardBg = AppColors.getCardBackground(context);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(
        title: 'Data & Privacy',
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
                padding: const EdgeInsets.all(24),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shield_outlined, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Privacy Protected',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your data is secure and encrypted',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildHeaderStatTile(Icons.storage_outlined, 'Local Storage', '24.3 MB'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildHeaderStatTile(Icons.lock_outline, 'Encrypted', 'Yes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            _buildSectionLabel('Location Services'),
            const SizedBox(height: 12),
            _buildInfoTile(
              Icons.location_on_outlined,
              'Location Access',
              'Used for catch logging and weather updates',
            ),
            _buildRadioGroup(),
            _buildToggleTile(
              Icons.location_searching,
              'Precise Location',
              'Exact GPS coordinates',
              _preciseLocation,
              (val) => setState(() => _preciseLocation = val),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('Data Collection'),
            const SizedBox(height: 12),
            _buildToggleTile(
              Icons.bar_chart_outlined,
              'Usage Analytics',
              'Help improve the app',
              _usageAnalytics,
              (val) => setState(() => _usageAnalytics = val),
              showDivider: true,
            ),
            _buildToggleTile(
              Icons.warning_amber_rounded,
              'Crash Reports',
              'Automatic error reporting',
              _crashReports,
              (val) => setState(() => _crashReports = val),
              showDivider: true,
            ),
            _buildToggleTile(
              Icons.camera_alt_outlined,
              'Photo Metadata',
              'Include location & time in photos',
              _photoMetadata,
              (val) => setState(() => _photoMetadata = val),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('Conservation Impact'),
            const SizedBox(height: 12),
            _buildToggleTile(
              Icons.public_outlined,
              'Share Conservation Data',
              'Anonymous data for research',
              _shareConservationData,
              (val) => setState(() => _shareConservationData = val),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF8FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.primaryTeal, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thank you for contributing!',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your anonymized catch data helps marine researchers track fish populations and protect ocean ecosystems.',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: primaryBlue.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('Data Management'),
            const SizedBox(height: 12),
            _buildActionTile(Icons.file_download_outlined, 'Download My Data', 'Export all your data as JSON', showDivider: true),
            _buildActionTile(Icons.cloud_off_outlined, 'Clear Cache', 'Free up 8.4 MB', showDivider: true),
            _buildActionTile(Icons.delete_outline, 'Delete All Data', 'Permanently remove your data', isDestructive: true),

            const SizedBox(height: 32),
            _buildSectionLabel('Legal & Policies'),
            const SizedBox(height: 12),
            _buildActionTile(Icons.description_outlined, 'Privacy Policy', '', showDivider: true),
            _buildActionTile(Icons.description_outlined, 'Terms of Service', '', showDivider: true),
            _buildActionTile(Icons.description_outlined, 'Data Processing Agreement', ''),

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
                    Icon(Icons.info_outline, color: secondaryBlue, size: 22),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Privacy Matters',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: primaryBlue,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ocevara uses end-to-end encryption to protect your data. We never sell your personal information to third parties.',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: primaryBlue.withOpacity(0.7),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
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

  Widget _buildHeaderStatTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.lato(fontSize: 11, color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F6F7),
              borderRadius: BorderRadius.circular(10),
            ),
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
                Text(
                  subtitle,
                  style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioGroup() {
    return Padding(
      padding: const EdgeInsets.only(left: 56, right: 20, top: 4, bottom: 8),
      child: Column(
        children: [
          _buildRadioItem('Always', 'Best for automatic catch logging'),
          _buildRadioItem('While Using App', 'Manual location access only'),
          _buildRadioItem('Never', 'No location tracking'),
        ],
      ),
    );
  }

  Widget _buildRadioItem(String value, String subtitle) {
    bool isSelected = _locationAccess == value;
    return GestureDetector(
      onTap: () => setState(() => _locationAccess = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0F3950) : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(color: Color(0xFF0F3950), shape: BoxShape.circle),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F3950)),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged, {bool showDivider = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6F7),
                  borderRadius: BorderRadius.circular(10),
                ),
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
                    Text(
                      subtitle,
                      style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0F3950),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 76, right: 20),
            child: Divider(height: 1, color: Colors.grey.shade100),
          ),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, String subtitle, {bool showDivider = false, bool isDestructive = false}) {
    Color titleColor = isDestructive ? const Color(0xFFE57373) : const Color(0xFF0F3950);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDestructive ? const Color(0xFFFDE8E4) : const Color(0xFFF1F6F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: titleColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 76, right: 20),
            child: Divider(height: 1, color: Colors.grey.shade100),
          ),
      ],
    );
  }
}
