import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/features/profile/screens/data_storage_screen.dart';
import 'package:ocevara/features/profile/screens/help_support_screen.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class SyncErrorScreen extends StatelessWidget {
  const SyncErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color dangerRed = Color(0xFFE53E3E);
    const Color orangeAccent = Color(0xFFDD6B20);
    const Color bgColor = Color(0xFFF9FAFB);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: OcevaraAppBar(
        title: 'Sync Error',
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: AppColors.getTextPrimary(context)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Error Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFAF0),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFFEEBC8)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: orangeAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sync Failed',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7B341E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3 out of 5 categories failed to sync. Your data is safe and stored locally.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF9C4221),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBadgeCard('Failed', '26 items', dangerRed),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBadgeCard('Synced', '2 items', const Color(0xFF38A169)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Failed Items
            Text(
              'Failed Items',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            _buildFailedItem(
              context,
              Icons.image_outlined,
              'Photos & Media',
              '8 items  •  5 min ago',
              'Connection Issue',
              'Upload failed due to weak connection',
            ),
            _buildFailedItem(
              context,
              Icons.set_meal_outlined,
              'Fishing Catches',
              '3 items  •  12 min ago',
              'Server Error',
              'Server temporarily unavailable',
            ),
            _buildFailedItem(
              context,
              Icons.location_on_outlined,
              'Location Data',
              '15 items  •  20 min ago',
              'Permission Required',
              'Location access required',
              isFixable: true,
            ),
            const SizedBox(height: 32),

            // Troubleshooting Tips
            Text(
              'Troubleshooting Tips',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            _buildTipItem(context, Icons.wifi, 'Check your connection', 'Ensure you have a stable internet connection'),
            _buildTipItem(context, Icons.refresh, 'Try again later', 'Server issues usually resolve within minutes'),
            _buildTipItem(context, Icons.settings_outlined, 'Review permissions', 'Grant necessary app permissions in settings'),
            const SizedBox(height: 32),

            // Data Safe Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF8FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_off, color: Color(0xFF3182CE), size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your data is safe',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C5282),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'All your fishing data is stored locally on your device. We\'ll automatically retry syncing when conditions improve.',
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
                  'Retry All Failed Items',
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
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                child: Text(
                  'Contact Support',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            label == 'Failed' ? Icons.cancel_outlined : Icons.check_circle_outline,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(fontSize: 11, color: color, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: GoogleFonts.lato(fontSize: 14, color: color, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFailedItem(BuildContext context, IconData icon, String title, String stats, String errorTitle, String errorMsg, {bool isFixable = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFFE53E3E), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 16,
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
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFixable ? Icons.cancel : Icons.block,
                  color: const Color(0xFFE53E3E),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFFC53030), size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        errorTitle,
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC53030),
                        ),
                      ),
                      Text(
                        errorMsg,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: const Color(0xFFC53030).withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                  if (isFixable) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DataStorageScreen()),
                    );
                  }
                },
                icon: Icon(isFixable ? Icons.settings_outlined : Icons.refresh, size: 16),
                label: Text(isFixable ? 'Fix Settings' : 'Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              if (!isFixable) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: const Text('Skip', style: TextStyle(color: Color(0xFF718096))),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, IconData icon, String title, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF3182CE), size: 20),
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
                  sub,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
            child: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E0), size: 20),
          ),
        ],
      ),
    );
  }
}

