import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/services/auth_service.dart';
import 'package:ocevara/features/profile/screens/settings_screen.dart';
import 'package:ocevara/features/profile/screens/edit_profile_screen.dart';
import 'package:ocevara/features/profile/screens/fishing_gear_screen.dart';
import 'package:ocevara/features/profile/screens/regulations_screen.dart';
import 'package:ocevara/features/profile/screens/achievements_screen.dart';
import 'package:ocevara/features/profile/screens/data_storage_screen.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';
import 'package:ocevara/features/home/screens/leaderboard_screen.dart';
import 'package:ocevara/core/utils/image_utils.dart';
import 'package:ocevara/features/catch_log/services/catch_log_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _service = CatchLogService.instance;
  late final void Function() _removeListener;

  @override
  void initState() {
    super.initState();
    _removeListener = _service.addListener((state) => setState(() {}));
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: const OcevaraAppBar(
        title: 'My Profile',
        actions: [
          // Settings icon moved to actions
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Summary Header
            Center(
              child: Column(
                children: [
                   Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryTeal, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: user?.profileImageUrl != null 
                        ? ImageUtils.getProfileImageProvider(user!.profileImageUrl!)
                        : const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&h=200&auto=format&fit=crop'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.fullName ?? 'Austin James',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryTeal, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_user, color: Color(0xFF1CB5AC), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              'Steward Status',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1CB5AC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Change Profile Photo',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            // Impact Dashboard
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Impact Dashboard',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildImpactCard(context, '${_service.totalLogs}', 'Catches', Icons.set_meal_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildImpactCard(context, '18', 'Achievements', Icons.workspace_premium_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildImpactCard(context, '#12', 'Rank', Icons.emoji_events_outlined)),
              ],
            ),

            const SizedBox(height: 32),
            // Recent Sustainable Catches
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Sustainable Catches',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCatchCard(context, 'Tilapia', 'Feb 18'),
                  _buildCatchCard(context, 'Catfish', 'Feb 15'),
                  _buildCatchCard(context, 'Croaker', 'Feb 12'),
                  _buildCatchCard(context, 'Snapper', 'Feb 10'),
                ],
              ),
            ),

            const SizedBox(height: 32),
            
            // Utility Options List Header
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account Settings',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Utility Options List
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(context),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.getBrandingContainerColor(context).withOpacity(0.1), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildUtilityTile(context, Icons.anchor_outlined, 'My Fishing Gear', 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FishingGearScreen()))),
                  _buildUtilityTile(context, Icons.settings_outlined, 'Data & Storage Settings', isSelected: true, 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DataStorageScreen()))),
                  _buildUtilityTile(context, Icons.menu_book_outlined, 'Local Fishing Regulations', 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegulationsScreen()))),
                  _buildUtilityTile(context, Icons.workspace_premium_outlined, 'Stewardship Achievements', isLast: true, 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AchievementsScreen()))),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactCard(BuildContext context, String value, String label, IconData icon) {
    return GestureDetector(
      onTap: (label == 'Rank' || label.contains('Community')) ? () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
        );
      } : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.getCardBackground(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.getBrandingContainerColor(context).withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE0FBFD),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.getTextPrimary(context), size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 10,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatchCard(BuildContext context, String name, String date) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getBrandingContainerColor(context).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE0FBFD),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.set_meal_outlined, color: AppColors.getTextPrimary(context), size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(context),
            ),
          ),
          Text(
            date,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 3,
            backgroundColor: AppColors.primaryTeal,
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityTile(BuildContext context, IconData icon, String title, {bool isSelected = false, bool isLast = false, VoidCallback? onTap}) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryTeal.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryNavy : AppColors.primaryTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon, 
                      color: isSelected ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? AppColors.primaryTeal : AppColors.primaryNavy), 
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right, 
                    color: Colors.grey.shade400, 
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (!isLast && !isSelected)
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(height: 1, color: AppColors.getBrandingContainerColor(context).withOpacity(0.05)),
          ),
      ],
    );
  }

  }


