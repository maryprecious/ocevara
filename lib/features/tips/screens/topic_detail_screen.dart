import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';

class TopicSection {
  final IconData icon;
  final String title;
  final String content;

  TopicSection({
    required this.icon,
    required this.title,
    required this.content,
  });
}

class TopicDetailScreen extends StatelessWidget {
  final String title;
  final List<String> bullets;
  final String? imagePath;
  final List<TopicSection>? sections;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;

  const TopicDetailScreen({
    super.key,
    required this.title,
    required this.bullets,
    this.imagePath,
    this.sections,
    this.actionButtonText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryBlue = AppColors.primaryNavy;

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: primaryBlue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imagePath ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1000&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.getTextPrimary(context),
                      child: const Icon(Icons.beach_access, color: Colors.white, size: 48),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          primaryBlue.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      title,
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickGuideCard(context, bullets),
                  const SizedBox(height: 32),
                  Text(
                    'Detailed Guidance',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'To ensure the best experience and maintain sustainable practices, please follow these detailed steps for $title. Our community relies on every fisher doing their part.',
                    style: GoogleFonts.lato(
                      color: Colors.grey.shade700,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (sections != null && sections!.isNotEmpty) ...[
                    ...sections!.map((section) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _buildInfoSection(
                            icon: section.icon,
                            title: section.title,
                            content: section.content,
                          ),
                        )),
                  ] else ...[
                    _buildInfoSection(
                      icon: Icons.eco_outlined,
                      title: 'Environmental Impact',
                      content: 'By following these guidelines, you help preserve the local marine ecosystem for future generations.',
                    ),
                  ],
                  if (actionButtonText != null && onActionPressed != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onActionPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          actionButtonText!,
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _buildHelpfulFooter(),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickGuideCard(BuildContext context, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tips_and_updates_outlined, color: AppColors.primaryTeal, size: 20),
              const SizedBox(width: 8),
              Text(
                'QUICK GUIDE',
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryTeal,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, color: AppColors.primaryTeal, size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.lato(
                      color: AppColors.getTextPrimary(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required IconData icon, required String title, required String content}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryTeal, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF0F3950),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: GoogleFonts.lato(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpfulFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        children: [
          Text(
            'Was this guidance helpful?',
            style: GoogleFonts.lato(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLargeIconButton(Icons.thumb_up_outlined, 'Yes'),
              const SizedBox(width: 24),
              _buildLargeIconButton(Icons.thumb_down_outlined, 'No'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeIconButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.grey.shade400, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.lato(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
