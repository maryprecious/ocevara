import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(
        title: 'Send Feedback',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryNavy, AppColors.primaryNavy.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "We'd Love to Hear From You",
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your feedback helps us improve Ocevara and protect our oceans together",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What would you like to share?',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Feedback Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildFeedbackTypeCard(
                  'Bug Report',
                  'Something\nisn\'t working',
                  Icons.bug_report_outlined,
                  const Color(0xFFFDE8E4),
                  const Color(0xFFE57373),
                ),
                _buildFeedbackTypeCard(
                  'Feature Request',
                  'Suggest a\nnew feature',
                  Icons.lightbulb_outline,
                  const Color(0xFFFFF3E0),
                  const Color(0xFFFFB74D),
                ),
                _buildFeedbackTypeCard(
                  'Improvement',
                  'How we can do better',
                  Icons.star_outline,
                  const Color(0xFFE3F2FD),
                  const Color(0xFF64B5F6),
                ),
                _buildFeedbackTypeCard(
                  'Appreciation',
                  'Share what you love',
                  Icons.favorite_border,
                  const Color(0xFFE8F5E9),
                  const Color(0xFF81C784),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Bottom Info
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.getCardBackground(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.chat_bubble_outline, color: primaryBlue, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Select a feedback type above to get started',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: primaryBlue.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackTypeCard(String title, String subtitle, IconData icon, Color bgColor, Color iconColor) {
    bool isSelected = _selectedType == title;
    const Color primaryBlue = Color(0xFF0F3950);

    return GestureDetector(
      onTap: () => setState(() => _selectedType = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryBlue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
