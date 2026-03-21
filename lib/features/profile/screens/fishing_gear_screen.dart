import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class FishingGearScreen extends StatelessWidget {
  const FishingGearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;
    final tealAccent = AppColors.primaryTeal;
    final sectionTitleColor = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(
        title: 'My Fishing Gear',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header Card
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
                    child: const Icon(Icons.anchor_outlined, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sustainable Gear',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your equipment choices directly impact\nmarine conservation efforts.',
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
            _buildSectionLabel(context, 'Equipment Categories', sectionTitleColor),
            const SizedBox(height: 12),
            _buildGearCategory(
              context,
              'Standard Hooks',
              [
                'Circle Hooks (Recommended)',
                'J-Hooks',
                'Treble Hooks',
              ],
              Icons.adjust_outlined,
              primaryBlue,
            ),
            const SizedBox(height: 16),
            _buildGearCategory(
              context,
              'Fishing Lines',
              [
                'Monofilament',
                'Fluorocarbon',
                'Braided Line',
              ],
              Icons.linear_scale_outlined,
              primaryBlue,
            ),
            const SizedBox(height: 16),
            _buildGearCategory(
              context,
              'Rods & Reels',
              [
                'Spinning Rod',
                'Baitcasting Reel',
                'Fly Fishing Setup',
              ],
              Icons.hardware_outlined,
              primaryBlue,
            ),

            const SizedBox(height: 32),
            // Sustainability Tip
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF8FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: tealAccent.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.eco_outlined, color: tealAccent, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sustainability Tip',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Using circle hooks significantly increases the survival rate of released fish by reducing deep-hooking. It\'s the choice of ethical anglers worldwide.',
                          style: GoogleFonts.lato(
                            fontSize: 13,
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
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildGearCategory(BuildContext context, String title, List<String> items, IconData icon, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F6F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          ...items.map((item) {
            final isLast = item == items.last;
            final isRecommended = item.contains('(Recommended)');
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  title: Text(
                    item,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: isRecommended ? AppColors.primaryTeal : AppColors.getTextPrimary(context).withOpacity(0.8),
                      fontWeight: isRecommended ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(
                    isRecommended ? Icons.check_circle : Icons.check_circle_outline,
                    color: isRecommended ? AppColors.primaryTeal : Colors.grey.shade300,
                    size: 20,
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Divider(height: 1, color: Colors.grey.shade50),
                  ),
              ],
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
