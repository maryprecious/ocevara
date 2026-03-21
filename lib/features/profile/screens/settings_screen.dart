import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/providers/theme_provider.dart';
import 'package:ocevara/core/services/auth_service.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/logout_dialog.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';
import 'package:ocevara/features/profile/screens/edit_profile_screen.dart';
import 'package:ocevara/features/notifications/screens/notification_settings_screen.dart';
import 'package:ocevara/features/profile/screens/data_storage_screen.dart';
import 'package:ocevara/features/profile/screens/help_support_screen.dart';
import 'package:ocevara/features/profile/screens/about_screen.dart';
import 'package:ocevara/features/profile/screens/privacy_screen.dart';
import 'package:ocevara/features/profile/screens/location_services_screen.dart';
import 'package:ocevara/features/profile/screens/appearance_screen.dart';
import 'package:ocevara/features/profile/screens/feedback_screen.dart';
import 'package:ocevara/features/profile/screens/profile_screen.dart';
import 'package:ocevara/features/home/screens/leaderboard_screen.dart';
import 'package:ocevara/features/sync/screens/sync_status_screen.dart';
import 'package:ocevara/core/utils/image_utils.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LogoutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final primaryBlue = AppColors.primaryNavy;
    final sectionTitleColor = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Profile Header Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(20),
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
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: user?.profileImageUrl != null 
                                  ? ImageUtils.getProfileImageProvider(user!.profileImageUrl!)
                                  : const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&h=200&auto=format&fit=crop'),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryTeal,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.fullName ?? 'Austin James',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Steward Status',
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileScreen()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: _buildMetricItem('127', 'Catches', Icons.set_meal_outlined)),
                        _buildMetricVerticalDivider(),
                        Expanded(child: _buildMetricItem('18', 'Achievements', Icons.workspace_premium_outlined)),
                        _buildMetricVerticalDivider(),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                              );
                            },
                            child: _buildMetricItem('#12', 'Rank', Icons.emoji_events_outlined),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('Account', sectionTitleColor),
            const SizedBox(height: 12),
            _buildSettingsContainer(context, [
              _buildSettingsTile(
                context,
                icon: Icons.person_outline,
                title: 'Profile',
                subtitle: 'Edit your personal information',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                ),
                isLast: true,
              ),
            ]),

            const SizedBox(height: 32),
            _buildSectionLabel('Preferences', sectionTitleColor),
            const SizedBox(height: 12),
            _buildSettingsContainer(context, [
              _buildSettingsTile(
                context,
                icon: isDark ? Icons.nightlight_round : Icons.wb_sunny_outlined,
                title: 'Appearance',
                subtitle: isDark ? 'Dark Mode' : 'Light Mode',
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).state =
                        val ? ThemeMode.dark : ThemeMode.light;
                  },
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primaryTeal,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppearanceScreen()),
                ),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.notifications_none,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                ),
                isLast: true,
              ),
            ]),

            const SizedBox(height: 32),
            _buildSectionLabel('Data & Privacy', sectionTitleColor),
            const SizedBox(height: 12),
            _buildSettingsContainer(context, [
              _buildSettingsTile(
                context,
                icon: Icons.storage_outlined,
                title: 'Device Storage',
                subtitle: 'Manage local storage and app cache',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataStorageScreen()),
                ),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.cloud_upload_outlined,
                title: 'Cloud Sync & Backup',
                subtitle: 'Manage data backup and sync status',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SyncStatusScreen()),
                ),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.shield_outlined,
                title: 'Privacy',
                subtitle: 'Control your data and privacy',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                ),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.location_on_outlined,
                title: 'Location Services',
                subtitle: 'Always',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LocationServicesScreen()),
                ),
                isLast: true,
              ),
            ]),

            const SizedBox(height: 32),
            _buildSectionLabel('Support', sectionTitleColor),
            const SizedBox(height: 12),
            _buildSettingsContainer(context, [
              _buildSettingsTile(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'FAQs, guides, and contact us',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                ),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.info_outline,
                title: 'About ocevara',
                subtitle: 'Version 2.4.1',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                ),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.mail_outline,
                title: 'Send Feedback',
                subtitle: 'Help us improve the app',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                ),
                isLast: true,
              ),
            ]),

            const SizedBox(height: 48),
            // Log Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => showLogoutDialog(context),
                  icon: const Icon(Icons.logout, color: AppColors.danger, size: 18),
                  label: Text(
                    'Log Out',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.danger,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? AppColors.darkBorder : const Color(0xFFFFEBEE)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 48),
            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'ocevara for iOS',
                    style: GoogleFonts.lato(fontSize: 12, color: AppColors.getTextSecondary(context), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 2.4.1 (Build 2026048)',
                    style: GoogleFonts.lato(fontSize: 11, color: AppColors.getTextSecondary(context)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© 2026 ocevara Foundation',
                    style: GoogleFonts.lato(fontSize: 11, color: AppColors.getTextSecondary(context)),
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

  Widget _buildSectionLabel(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMetricItem(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.lato(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: GoogleFonts.lato(color: Colors.white.withOpacity(0.5), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricVerticalDivider() {
    return const SizedBox(width: 8);
  }

  Widget _buildSettingsContainer(BuildContext context, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool isLast = false,
  }) {
    final primaryBlue = AppColors.getTextPrimary(context);

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: isLast 
            ? const BorderRadius.vertical(bottom: Radius.circular(20))
            : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
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
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.lato(
                          fontSize: 11,
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ?? Icon(Icons.arrow_forward_ios, color: AppColors.getTextSecondary(context).withOpacity(0.3), size: 14),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(height: 1, color: AppColors.darkBorder.withOpacity(0.1)),
          ),
      ],
    );
  }
}



