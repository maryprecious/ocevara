import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class RegulationsScreen extends StatelessWidget {
  const RegulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;
    final tealAccent = AppColors.primaryTeal;
    final sectionTitleColor = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(
        title: 'Fishing Regulations',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header Hero
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.gavel_outlined, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Local Guidelines',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stay informed about current limits and\nprotected zones in your region.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('Key Regulations', sectionTitleColor),
            const SizedBox(height: 12),
            _buildRegCard(
              context,
              'General Limits',
              'Bag limit of 5 fish per day for most coastal species. Minimum size limits apply.',
              Icons.inventory_2_outlined,
              primaryBlue,
            ),
            const SizedBox(height: 16),
            _buildRegCard(
              context,
              'Protected Areas',
              'Fishing is strictly prohibited within 500 meters of the Marine Protected Zone.',
              Icons.map_outlined,
              primaryBlue,
            ),
            const SizedBox(height: 16),
            _buildRegCard(
              context,
              'Gear Restrictions',
              'Use of monofilament nets is prohibited in estuary regions.',
              Icons.warning_amber_rounded,
              primaryBlue,
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('Recent Updates', sectionTitleColor),
            const SizedBox(height: 12),
            _buildUpdatesContainer(context, [
              _buildUpdateItem(context, 'Seasonal closure for Snappers starts March 1st.'),
              _buildUpdateItem(context, 'New catch-and-release mandate for Tilapia in Sector 4.'),
              _buildUpdateItem(context, 'Licensing requirements updated for February 2026.', isLast: true),
            ]),
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

  Widget _buildRegCard(BuildContext context, String title, String description, IconData icon, Color primaryBlue) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFF1F6F7), shape: BoxShape.circle),
            child: Icon(icon, color: primaryBlue, size: 24),
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
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatesContainer(BuildContext context, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder.withOpacity(0.1)),
      ),
      child: Column(children: items),
    );
  }

  Widget _buildUpdateItem(BuildContext context, String text, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: CircleAvatar(radius: 3, backgroundColor: AppColors.primaryTeal),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: AppColors.getTextPrimary(context),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
