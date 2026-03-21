import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/utils/image_utils.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/services/auth_service.dart';
import 'package:ocevara/features/catch_log/services/catch_log_service.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProvider);
    final catches = ref.watch(catchLogServiceProvider);
    
    // Improved impact score logic:
    // Each catch is worth 100 points. (0 catches = 0 points)
    final userImpactScore = catches.length * 100;

    // Mock data for others
    final rankings = [
      {
        'name': 'James Wilson',
        'impact': '1,820',
        'rank': 2,
        'image':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100&h=100&auto=format&fit=crop',
      },
      {
        'name': 'Sarah Chen',
        'impact': '1,650',
        'rank': 3,
        'image':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&h=100&auto=format&fit=crop',
      },
      {
        'name': 'David Okoro',
        'impact': '1,420',
        'rank': 4,
        'image':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=100&h=100&auto=format&fit=crop',
      },
      {
        'name': 'Chidi Azikiwe',
        'impact': '1,280',
        'rank': 5,
        'image':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=100&h=100&auto=format&fit=crop',
      },
      {
        'name': 'Grace Mensah',
        'impact': '1,150',
        'rank': 6,
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=100&h=100&auto=format&fit=crop',
      },
    ];

    // Dynamic user entry
    final userEntry = {
      'name': user?.fullName ?? 'Fisher',
      'impact': userImpactScore.toString(),
      'rank': userImpactScore > 2000 ? 1 : (userImpactScore > 1820 ? 2 : 12), 
      'image': user?.profileImageUrl ?? '',
      'isCurrentUser': true,
    };

    // Sort to see where user fits (simplified)
    if (userImpactScore > 2000) {
      rankings.insert(0, userEntry);
    } else if (userImpactScore > 1820) {
      rankings.insert(1, userEntry);
    } else {
      rankings.add(userEntry);
    }

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      body: Stack(
        children: [
          // Semi-transparent background image
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/sign-up.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.getTextPrimary(context),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Leaderboard',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),

                // Top 3 Podium Section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Rank 2
                      _buildPodiumItem(
                        rankings[1],
                        100,
                        Colors.grey.shade400,
                        context,
                      ),
                      const SizedBox(width: 16),
                      // Rank 1 (Amaka)
                      _buildPodiumItem(
                        rankings[0],
                        130,
                        const Color(0xFFFFD700),
                        context,
                        isFirst: true,
                      ),
                      const SizedBox(width: 16),
                      // Rank 3
                      _buildPodiumItem(
                        rankings[2],
                        90,
                        const Color(0xFFCD7F32),
                        context,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Rankings List
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: rankings.length - 3,
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey.withOpacity(0.1)),
                      itemBuilder: (context, index) {
                        final rankUser = rankings[index + 3];
                        final isCurrentUser = rankUser['rank'] == 12;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrentUser
                                ? AppColors.primaryTeal.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${rankUser['rank']}',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 16),
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    isCurrentUser &&
                                        user?.profileImageUrl == null
                                    ? Colors.white24
                                    : Colors.transparent,
                                backgroundImage: isCurrentUser
                                    ? ImageUtils.getProfileImageProvider(
                                        user?.profileImageUrl ?? '',
                                      )
                                    : NetworkImage(rankUser['image'] as String),
                                child: isCurrentUser &&
                                        (user?.profileImageUrl == null ||
                                            user!.profileImageUrl!.isEmpty)
                                    ? Text(
                                        (user?.fullName != null &&
                                                    user!.fullName.isNotEmpty
                                                ? user.fullName[0]
                                                : 'U')
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: AppColors.primaryNavy,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  '${rankUser['name']}${isCurrentUser ? ' (You)' : ''}',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: isCurrentUser
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                ),
                              ),
                              Text(
                                '${rankUser['impact']} pts',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    Map<String, dynamic> user,
    double height,
    Color crownColor,
    BuildContext context, {
    bool isFirst = false,
  }) {
    return Column(
      children: [
        if (isFirst)
          Icon(Icons.workspace_premium, color: crownColor, size: 32)
        else
          const SizedBox(height: 32),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: crownColor, width: 2),
              ),
              child: CircleAvatar(
                radius: isFirst ? 45 : 35,
                backgroundImage: ImageUtils.getProfileImageProvider(
                  user['image'] as String,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: crownColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${user['rank']}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          user['name'] as String,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
            fontSize: isFirst ? 16 : 14,
          ),
        ),
        Text(
          '${user['impact']} pts',
          style: GoogleFonts.lato(
            color: AppColors.primaryTeal,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
