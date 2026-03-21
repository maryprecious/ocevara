import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Removed circular import of sync_status_screen.dart
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class DataStorageScreen extends StatefulWidget {
  const DataStorageScreen({super.key});

  @override
  State<DataStorageScreen> createState() => _DataStorageScreenState();
}

class _DataStorageScreenState extends State<DataStorageScreen> {
  bool _downloadWifiOnly = true;
  bool _automaticSync = false;

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;
    final tealAccent = AppColors.primaryTeal;
    final sectionTitleColor = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(
        title: 'Device Storage',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Storage Summary Card
            Container(
              width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STORAGE USAGE',
                            style: GoogleFonts.lato(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Colors.white.withOpacity(0.5),
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '3.2 GB of 8 GB',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.storage_outlined, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 8,
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.1),
                      child: Row(
                        children: [
                          Container(
                            width: 140, // Offline Maps
                            color: tealAccent,
                          ),
                          Container(
                            width: 60, // App Cache
                            color: const Color(0xFFFBBF24),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Using route name or untyped navigation to avoid circular dependency
                        Navigator.pushNamed(context, '/sync-status');
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View Sync Details',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('Connectivity', sectionTitleColor),
            const SizedBox(height: 12),
            _buildSettingsContainer([
              _buildSwitchTile(
                icon: Icons.wifi,
                title: 'Download over Wi-Fi only',
                subtitle: 'Prevent mobile data usage',
                value: _downloadWifiOnly,
                onChanged: (val) => setState(() => _downloadWifiOnly = val),
              ),
              _buildSwitchTile(
                icon: Icons.sync,
                title: 'Automatic Data Sync',
                subtitle: 'Keep everything up to date',
                value: _automaticSync,
                onChanged: (val) => setState(() => _automaticSync = val),
                isLast: true,
              ),
            ]),

            const SizedBox(height: 32),
            _buildSectionLabel('Maintenance', sectionTitleColor),
            const SizedBox(height: 12),
            _buildSettingsContainer([
              _buildActionTile(
                icon: Icons.delete_sweep_outlined,
                title: 'Clear Cache',
                subtitle: 'Free up 0.8 GB of storage',
                onTap: () {},
              ),
              _buildActionTile(
                icon: Icons.map_outlined,
                title: 'Manage Offline Areas',
                subtitle: 'Downloaded regions (2.4 GB)',
                onTap: () {},
                isLast: true,
              ),
            ]),

            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDF2F7)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF4A5568), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Optimizing your storage helps ocevara run smoother on your device.',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: AppColors.getTextSecondary(context),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    const Color primaryBlue = Color(0xFF0F3950);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFFF1F6F7), shape: BoxShape.circle),
                child: Icon(icon, color: primaryBlue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.bold, color: primaryBlue),
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
                activeTrackColor: primaryBlue,
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(height: 1, color: Colors.grey.shade50),
          ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    const Color primaryBlue = Color(0xFF0F3950);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(20)) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Color(0xFFF1F6F7), shape: BoxShape.circle),
                  child: Icon(icon, color: primaryBlue, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.bold, color: primaryBlue),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 18),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(height: 1, color: Colors.grey.shade50),
          ),
      ],
    );
  }
}

