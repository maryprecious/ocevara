import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/features/home/screens/leaderboard_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AppColors.getTextPrimary(context);
    const Color unreadDotColor = Color(0xFF3182CE);

    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'New Achievement Unlocked!',
        'subtitle': 'You\'ve reached 100 Safe Days Fished. Keep up the sustainable practices!',
        'time': '2 hours ago',
        'icon': Icons.badge_outlined,
        'iconColor': const Color(0xFF3182CE),
        'isUnread': true,
      },
      {
        'title': 'Protected Species Alert',
        'subtitle': 'Bottlenose dolphins spotted in Imo River Estuary. Avoid nets in zone A3.',
        'time': '5 hours ago',
        'icon': Icons.shield_outlined,
        'iconColor': const Color(0xFF2D8A7F),
        'isUnread': true,
      },
      {
        'title': 'Community Rank Update',
        'subtitle': 'Congratulations! You moved up to #12 in your local fishing community.',
        'time': '1 day ago',
        'icon': Icons.people_outline,
        'iconColor': const Color(0xFF4A5568),
        'isUnread': false,
      },
      {
        'title': 'Weather Advisory',
        'subtitle': 'Strong winds expected tomorrow. Consider postponing fishing activities.',
        'time': '1 day ago',
        'icon': Icons.warning_amber_rounded,
        'iconColor': const Color(0xFFC05621),
        'isUnread': false,
      },
      {
        'title': 'Seasonal Update',
        'subtitle': 'Tilapia fishing season opens March 1st. Review new catch limits.',
        'time': '2 days ago',
        'icon': Icons.set_meal_outlined,
        'iconColor': const Color(0xFF0F3950),
        'isUnread': false,
      },
      {
        'title': 'Local Meeting Reminder',
        'subtitle': 'Fishermen\'s cooperative meeting this Saturday at 9 AM.',
        'time': '3 days ago',
        'icon': Icons.calendar_today_outlined,
        'iconColor': const Color(0xFF4A5568),
        'isUnread': false,
      },
      {
        'title': 'Milestone Reached',
        'subtitle': 'You\'ve aided 40 protected species this year. Thank you for your stewardship!',
        'time': '4 days ago',
        'icon': Icons.trending_up,
        'iconColor': const Color(0xFF2B6CB0),
        'isUnread': false,
      },
      {
        'title': 'Sustainable Catch Logged',
        'subtitle': 'Your recent Catfish catch has been verified as sustainable.',
        'time': '5 days ago',
        'icon': Icons.set_meal_outlined,
        'iconColor': const Color(0xFF2D8A7F),
        'isUnread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getScaffoldBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.lato(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '2 new notifications',
              style: GoogleFonts.lato(
                color: AppColors.getTextSecondary(context),
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all',
              style: GoogleFonts.lato(
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: item['title'].contains('Rank') || item['subtitle'].contains('Rank')
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardScreen(),
                        ),
                      );
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getCardBackground(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.getBrandingContainerColor(context)
                        .withOpacity(0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item['iconColor'].withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'], 
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : item['iconColor'], 
                      size: 24
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['title'],
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                            if (item['isUnread'])
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: unreadDotColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['subtitle'],
                          style: GoogleFonts.lato(
                            fontSize: 13,
                            color: AppColors.getTextSecondary(context),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['time'],
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            color: AppColors.getTextSecondary(context).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
            ),
          );
        },
      ),
    );
  }
}
