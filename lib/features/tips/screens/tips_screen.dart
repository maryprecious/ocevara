import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/features/profile/screens/regulations_screen.dart';
import 'package:ocevara/features/profile/screens/location_services_screen.dart';
import 'package:ocevara/features/profile/screens/fishing_gear_screen.dart';
import 'package:ocevara/features/map/screens/fishing_zones_screen.dart';
import 'package:ocevara/features/catch_log/screens/catch_log_screen.dart';
import 'package:ocevara/features/profile/screens/achievements_screen.dart';
import 'package:ocevara/features/profile/screens/feedback_screen.dart';
import 'package:ocevara/features/tips/screens/topic_detail_screen.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class TipItem {
  final String title;
  final String category;
  final IconData icon;
  final Color color;
  final String imagePath;

  TipItem({
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
    required this.imagePath,
  });
}

class _TipsScreenState extends State<TipsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TipItem> _filteredTips = [];

  @override
  void initState() {
    super.initState();
    _filteredTips = _allTips;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTips = _allTips.where((tip) {
        final title = tip.title.toLowerCase();
        final category = tip.category.toLowerCase();
        return title.contains(query) || category.contains(query);
      }).toList();
    });
  }

  final List<TipItem> _allTips = [
    TipItem(
      title: 'Check Weather Before You Go',
      category: 'Safety',
      icon: Icons.wb_sunny_outlined,
      color: const Color(0xFFFF8B71),
      imagePath: 'https://images.unsplash.com/photo-1504370805625-d32c54b16100?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Know Size and Reg Limits',
      category: 'Sustainable Fishing',
      icon: Icons.shield_outlined,
      color: const Color(0xFF1CB5AC),
      imagePath: 'https://images.unsplash.com/photo-1511216335778-7cb8f49fa7a3?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Enable Location Services',
      category: 'Using ocevara',
      icon: Icons.location_on_outlined,
      color: const Color(0xFFFFB347),
      imagePath: 'https://images.unsplash.com/photo-1500051638674-ff996a0ec29e?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Leave No Trace',
      category: 'Conservation',
      icon: Icons.waves,
      color: const Color(0xFF4A90E2),
      imagePath: 'https://images.unsplash.com/photo-1618477461853-cf6ed80fbe5a?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Target Abundant Species',
      category: 'Sustainable Fishing',
      icon: Icons.trending_up,
      color: const Color(0xFF1CB5AC),
      imagePath: 'https://images.unsplash.com/photo-1491609154219-ffd3fffaa927?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Wear Sun Protection',
      category: 'Safety',
      icon: Icons.wb_sunny_outlined,
      color: const Color(0xFFFF8B71),
      imagePath: 'https://images.unsplash.com/photo-1456574824048-c44bca28c935?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Protect Marine Habitats',
      category: 'Conservation',
      icon: Icons.anchor_outlined,
      color: const Color(0xFF4A90E2),
      imagePath: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Take Clear Photos',
      category: 'Using ocevara',
      icon: Icons.camera_alt_outlined,
      color: const Color(0xFFFFB347),
      imagePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Tell Someone Your Plans',
      category: 'Safety',
      icon: Icons.near_me_outlined,
      color: const Color(0xFFFF8B71),
      imagePath: 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Use Biodegradable Gear',
      category: 'Conservation',
      icon: Icons.favorite_border,
      color: const Color(0xFF4A90E2),
      imagePath: 'https://images.unsplash.com/photo-1613254026312-6379555c4786?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Avoid Spawning Seasons',
      category: 'Sustainable Fishing',
      icon: Icons.set_meal_outlined,
      color: const Color(0xFF1CB5AC),
      imagePath: 'https://images.unsplash.com/photo-1534043464124-3be32fe000c9?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Log Catches Immediately',
      category: 'Using ocevara',
      icon: Icons.phone_android_outlined,
      color: const Color(0xFFFFB347),
      imagePath: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Know Your Limits',
      category: 'Safety',
      icon: Icons.report_problem_outlined,
      color: const Color(0xFFFF8B71),
      imagePath: 'https://images.unsplash.com/photo-1505751172676-4e9221235499?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Report Marine Issues',
      category: 'Conservation',
      icon: Icons.report_outlined,
      color: const Color(0xFF4A90E2),
      imagePath: 'https://images.unsplash.com/photo-1532187863486-abf9d39766cc?q=80&w=400&auto=format&fit=crop',
    ),
    TipItem(
      title: 'Track Your Progress',
      category: 'Using ocevara',
      icon: Icons.emoji_events_outlined,
      color: const Color(0xFFFFB347),
      imagePath: 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?q=80&w=400&auto=format&fit=crop',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0F3950);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 16),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.getCardBackground(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBorder.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Tips...',
                    hintStyle: GoogleFonts.lato(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: AppColors.primaryNavy, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard('Total Tips', _filteredTips.length.toString(), Icons.import_contacts_outlined),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard('New Today', '3', Icons.auto_awesome_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Featured Section
            _buildSectionLabel('Featured Today', showIcon: true),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _handleTipTap(
                context,
                'Practice Catch and Release',
                'Sustainable Fishing',
                ['Maintain healthy populations', 'Handle fish with care', 'Use barbless hooks'],
                'https://images.unsplash.com/photo-1516939884455-1445c8652f83?q=80&w=1000&auto=format&fit=crop',
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryTeal, Color(0xFF2DAA9E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryTeal.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.favorite, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sustainable Fishing',
                                  style: GoogleFonts.lato(color: Colors.white.withOpacity(0.9), fontSize: 12),
                                ),
                                Text(
                                  'Practice Catch and Release',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time, color: Colors.white, size: 14),
                                  const SizedBox(width: 4),
                                  Text('2 min read', style: GoogleFonts.lato(color: Colors.white, fontSize: 11)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Release fish you don\'t need to maintain healthy populations',
                        style: GoogleFonts.lato(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // All Tips Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Tips',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                  Text(
                    '${_filteredTips.length} tips',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredTips.length,
              itemBuilder: (context, index) {
                final tip = _filteredTips[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _handleTipTap(context, tip.title, tip.category, [], tip.imagePath),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              tip.imagePath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 60,
                                height: 60,
                                color: const Color(0xFFF1F6F7),
                                child: Icon(tip.icon,
                                    color: tip.color, size: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip.title,
                                  style: GoogleFonts.lato(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(tip.icon, color: tip.color, size: 12),
                                    const SizedBox(width: 6),
                                    Text(
                                      tip.category,
                                      style: GoogleFonts.lato(
                                        fontSize: 12,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey.shade300, size: 14),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
            // Footer Submission Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.blueGrey.shade900 : const Color(0xFFE8F3F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lightbulb_outline, color: Color(0xFF4A90E2), size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Have a Tip to Share?',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Help other fishers learn sustainable practices',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showSubmitTipDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Submit Your Tip',
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  void _showSubmitTipDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String? category = 'Conservation';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Submit a Tip',
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryNavy,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share your knowledge with the community. Our team will review and publish it.',
                style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tip Title',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Use circle hooks',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['Conservation', 'Safety', 'Sustainable Fishing', 'Using ocevara']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => category = v,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Tip Details',
                  border: OutlineInputBorder(),
                  hintText: 'Provide a brief explanation...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.lato(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Thank you! Your tip has been submitted for review.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    final brandingColor = AppColors.getBrandingContainerColor(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brandingColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: brandingColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.7), size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.lato(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, {bool showIcon = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (showIcon) ...[
            const Icon(Icons.star_outline, color: Color(0xFFE67E22), size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTipTap(BuildContext context, String title, String category, List<String> bullets, String imagePath) {
    if (title.contains('Reg Limits') || title.contains('Know Your Limits')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RegulationsScreen()));
    } else if (title.contains('Location Services')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationServicesScreen()));
    } else if (title.contains('Biodegradable Gear')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const FishingGearScreen()));
    } else if (title.contains('Spawning Seasons')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const FishingZonesScreen()));
    } else if (title.contains('Log Catches')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TopicDetailScreen(
            title: 'Log Catches Immediately',
            bullets: [
              'Fresh data is more accurate',
              'Ensures real-time monitoring',
              'Helps update your Steward Status'
            ],
            imagePath: imagePath,
            sections: [
              TopicSection(
                icon: Icons.timer_outlined,
                title: 'Why log immediately?',
                content:
                    'Logging while your catch is still on deck ensures you capture the exact weight, location, and species details before they are forgotten. This precision is vital for conservation researchers.',
              ),
              TopicSection(
                icon: Icons.map_outlined,
                title: 'GPS Accuracy',
                content:
                    'The app captures your current coordinate automatically. By logging immediately, you provide the most accurate mapping of where specific species are currently active.',
              ),
              TopicSection(
                icon: Icons.sync_outlined,
                title: 'Offline Syncing',
                content:
                    'Don\'t worry about signal strength. Log your catch even in deep waters; the app will securely store the data offline and sync it automatically once you return to range.',
              ),
            ],
            actionButtonText: 'Log a Catch Now',
            onActionPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CatchLogScreen()),
            ),
          ),
        ),
      );
    } else if (title.contains('Track Your Progress')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen()));
    } else if (title.contains('Report Marine Issues')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TopicDetailScreen(
            title: title,
            bullets: bullets.isNotEmpty ? bullets : ['Learn more about $title', 'Part of $category', 'Follow sustainable practices'],
            imagePath: imagePath,
          ),
        ),
      );
    }
  }
}

