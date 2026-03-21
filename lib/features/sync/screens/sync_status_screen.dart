import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/features/profile/screens/data_storage_screen.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class SyncStatusScreen extends StatelessWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;
    final tealAccent = AppColors.primaryTeal;
    final bgColor = AppColors.getScaffoldBackground(context);
    final cardBorder = AppColors.darkBorder.withOpacity(0.1);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: OcevaraAppBar(
        title: 'Sync Status',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.getTextPrimary(context)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE6FFFA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFB2F5EA)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1CB5AC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cloud_done, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connected & Synced',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF234E52),
                          ),
                        ),
                        Text(
                          'Last synced 2 minutes ago',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: const Color(0xFF285E61),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.wifi, color: Color(0xFF1CB5AC)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Metrics Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    Icons.upload_outlined,
                    'Uploaded',
                    '399',
                    'items today',
                    const Color(0xFFEBF8FF),
                    const Color(0xFF3182CE),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    Icons.download_outlined,
                    'Downloaded',
                    '156',
                    'updates today',
                    const Color(0xFFF0FFF4),
                    const Color(0xFF38A169),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Sync Details
            Text(
              'Sync Details',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            _buildSyncDetailItem(
              Icons.set_meal_outlined,
              'Fishing Catches',
              '127 items  •  2.3 MB',
              'Synced 2 min ago',
              true,
            ),
            _buildSyncDetailItem(
              Icons.emoji_events_outlined,
              'Achievements',
              '18 items  •  0.5 MB',
              'Synced 2 min ago',
              true,
            ),
            _buildSyncDetailItem(
              Icons.location_on_outlined,
              'Location Data',
              '245 items  •  1.8 MB',
              'Synced 2 min ago',
              true,
            ),
            _buildSyncDetailItem(
              Icons.image_outlined,
              'Photos & Media',
              '8 items  •  12.4 MB',
              'Synced 15 min ago',
              false,
              isWarning: true,
            ),
            _buildSyncDetailItem(
              Icons.settings_outlined,
              'App Settings',
              '1 items  •  0.1 MB',
              'Synced 2 min ago',
              true,
            ),
            const SizedBox(height: 32),

            // Device Storage
            Text(
              'Device Storage',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cardBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF8FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.smartphone, color: Color(0xFF3182CE)),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Local Storage',
                            style: GoogleFonts.lato(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                          Text(
                            '17.1 MB of 2.9 GB used',
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: const Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.05,
                      minHeight: 8,
                      backgroundColor: Color(0xFFEDF2F7),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3182CE)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DataStorageScreen()),
                      );
                    },
                    child: Text(
                      'Manage Storage',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3182CE),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Auto-Sync Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF8FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF3182CE), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Auto-Sync Enabled',
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C5282),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Next automatic sync in 13 minutes. Data syncs when connected to Wi-Fi to save mobile data.',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: const Color(0xFF2C5282),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'Sync Now',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getCardBackground(context),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DataStorageScreen()),
                  );
                },
                icon: Icon(Icons.settings_outlined, color: AppColors.primaryNavy),
                label: Text(
                  'Sync Settings',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String label, String value, String sub, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 16),
          Text(
            label,
            style: GoogleFonts.lato(fontSize: 13, color: const Color(0xFF718096)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          Text(
            sub,
            style: GoogleFonts.lato(fontSize: 11, color: const Color(0xFFA0AEC0)),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncDetailItem(IconData icon, String title, String stats, String time, bool isSynced, {bool isWarning = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isWarning ? const Color(0xFFFFF5F5) : const Color(0xFFF0FFF4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: isWarning ? const Color(0xFFE53E3E) : const Color(0xFF38A169), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                Text(
                  stats,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    color: const Color(0xFFA0AEC0),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isWarning ? CupertinoIcons.clock : Icons.check_circle_outline,
            color: isWarning ? const Color(0xFFE53E3E) : const Color(0xFF38A169),
            size: 20,
          ),
        ],
      ),
    );
  }
}

