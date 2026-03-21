import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;
    final tealAccent = AppColors.primaryTeal;
    final sectionTitleColor = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(
        title: 'Stewardship Achievements',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTrophyIcon(context, Icons.emoji_events, Colors.amber),
                      const SizedBox(width: 12),
                      _buildTrophyIcon(context, Icons.workspace_premium, tealAccent),
                      const SizedBox(width: 12),
                      _buildTrophyIcon(context, Icons.military_tech, const Color(0xFFFBBF24)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Level 12 Steward',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have earned 18 achievements\nfor your conservation efforts.',
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
            _buildSectionLabel(context, 'Recent Badges', sectionTitleColor),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildBadgeCard(context, 'Green Heart', '100% Release Rate', Icons.favorite_outline, true),
                _buildBadgeCard(context, 'Expert ID', 'Identified 50 Fish', Icons.auto_awesome, true),
                _buildBadgeCard(context, 'Night Owl', 'Fished after 10 PM', Icons.nights_stay_outlined, false),
                _buildBadgeCard(context, 'Rescue Pro', 'Released a Snapper', Icons.medical_services_outlined, true),
                _buildBadgeCard(context, 'Clean Coast', 'Reported Pollution', Icons.cleaning_services_outlined, false),
                _buildBadgeCard(context, 'Local Legend', '1 year membership', Icons.workspace_premium_outlined, true),
              ],
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
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTrophyIcon(BuildContext context, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildBadgeCard(BuildContext context, String title, String description, IconData icon, bool isUnlocked) {
    const Color primaryBlue = Color(0xFF0F3950);
    const Color tealAccent = Color(0xFF1CB5AC);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.getCardBackground(context) : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : const Color(0xFFF7FAFC)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked ? tealAccent.withOpacity(0.2) : Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: tealAccent.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUnlocked ? const Color(0xFFEBF8FA) : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: isUnlocked ? tealAccent : Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isUnlocked ? AppColors.getTextPrimary(context) : Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              fontSize: 10,
              color: Colors.grey.shade500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          if (!isUnlocked)
            Icon(Icons.lock_outline, size: 12, color: Colors.grey.shade400)
          else
            const Icon(Icons.check_circle, size: 12, color: tealAccent),
        ],
      ),
    );
  }
}
