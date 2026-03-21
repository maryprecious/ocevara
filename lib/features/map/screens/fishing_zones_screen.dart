import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/features/map/screens/river_delta_detail_screen.dart';
import 'package:ocevara/features/map/screens/coastal_waters_detail_screen.dart';
import 'package:ocevara/features/map/screens/deep_sea_zone_detail_screen.dart';
import 'package:ocevara/features/map/screens/breeding_grounds_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';
import 'package:ocevara/features/map/screens/map_screen.dart';
import 'package:ocevara/features/home/screens/home_screen.dart';

class FishingZonesScreen extends StatelessWidget {
  const FishingZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealHeader = AppColors.primaryTeal;
    final safeGreen = Colors.green.shade600;
    final carefulOrange = Colors.orange.shade700;
    final dangerRed = Colors.red.shade700;
    final closedBlue = AppColors.primaryNavy;
    const Color alertYellow = Color(0xFFFFF9C4);
    const Color alertBorder = Color(0xFFFFF176);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: OcevaraAppBar(
        title: 'Fishing Zones',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.near_me_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zone Status Guide
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: tealHeader.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zone Status Guide',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusMiniCard(
                          'SAFE',
                          'Good\nfishing',
                          Icons.check_circle,
                          safeGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusMiniCard(
                          'CAREFUL',
                          'Be\ncautious',
                          Icons.warning,
                          carefulOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusMiniCard(
                          'DANGER',
                          'Do not go',
                          Icons.cancel,
                          dangerRed,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusMiniCard(
                          'CLOSED',
                          'No\nfishing',
                          Icons.security,
                          closedBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // View Zone Map Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        initialLat: 6.5400, // Near River Delta
                        initialLng: 3.3600,
                        zoneName: 'River Delta',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.near_me, color: Colors.white),
                label: Text(
                  'View Zone Map',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tealHeader,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Zone List
            _buildZoneCard(
              title: 'River Delta',
              subtitle: 'Zone A - River/Estuary',
              status: 'SAFE',
              statusColor: safeGreen,
              distance: '2 km from shore',
              fishTypes: 'Tilapia, Catfish',
              description:
                  'River mouth where fresh water meets the sea. Good for many fish types.',
              icon: Icons.check_circle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiverDeltaDetailScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildZoneCard(
              title: 'Coastal Waters',
              subtitle: 'Zone C - Near Shore Sea',
              status: 'CAREFUL',
              statusColor: carefulOrange,
              distance: '5 km from shore',
              fishTypes: 'Mackerel, Mullet',
              description:
                  'Coastal sea area. Good fishing but watch weather conditions carefully.',
              icon: Icons.warning,
              alertText: 'Wind increasing afternoon',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CoastalWatersDetailScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildZoneCard(
              title: 'Deep Sea Zone',
              subtitle: 'Zone E - Open Ocean',
              status: 'DANGER',
              statusColor: dangerRed,
              distance: '15+ km from shore',
              fishTypes: 'Tuna, Barracuda',
              description:
                  'Far from shore. Only for experienced fishermen with good boats.',
              icon: Icons.cancel,
              alertText: 'STRONG WINDS TODAY',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeepSeaZoneDetailScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildZoneCard(
              title: 'Breeding Grounds',
              subtitle: 'Zone F - Protected Area',
              status: 'CLOSED',
              statusColor: closedBlue,
              distance: '3 km from shore',
              fishTypes: 'All fish breeding here',
              description:
                  'CLOSED AREA - Fish breeding season. No fishing allowed now.',
              icon: Icons.security,
              alertText: 'NO FISHING - CLOSED AREA',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BreedingGroundsDetailScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMiniCard(
    String status,
    String sub,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: GoogleFonts.lato(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
                Text(
                  sub,
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: const Color(0xFF718096),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneCard({
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required String distance,
    required String fishTypes,
    required String description,
    required IconData icon,
    String? alertText,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: statusColor, size: 28),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Color(0xFF718096),
                ),
                const SizedBox(width: 8),
                Text(
                  distance,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.set_meal_outlined,
                  size: 16,
                  color: Color(0xFF718096),
                ),
                const SizedBox(width: 8),
                Text(
                  fishTypes,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            if (alertText != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFF176)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: Color(0xFF856404),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        alertText,
                        style: GoogleFonts.lato(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF856404),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.lato(
                fontSize: 13,
                color: const Color(0xFF718096),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
