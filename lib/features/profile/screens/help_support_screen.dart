import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/features/profile/screens/faqs_screen.dart';
import 'package:ocevara/features/profile/screens/report_issue_screen.dart';
import 'package:ocevara/features/profile/screens/feedback_screen.dart';
import 'package:ocevara/features/profile/screens/video_guides_screen.dart';
import 'package:ocevara/features/tips/screens/topic_detail_screen.dart';
import 'package:ocevara/features/profile/screens/contact_detail_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFFF7FBFD);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3950),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search help, topics, FAQs, contact',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 18),

            Text(
              'Quick Actions',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3950),
              ),
            ),
            const SizedBox(height: 12),

            // build action list dynamically so we can filter
            Builder(
              builder: (context) {
                final actions = [
                  {
                    'iconBg': const Color(0xFF0F3950),
                    'icon': Icons.help_outline,
                    'title': 'FAQs',
                    'subtitle': 'Common questions',
                  },
                  {
                    'iconBg': const Color(0xFF2463EB),
                    'icon': Icons.chat_bubble_outline,
                    'title': 'Chat Support',
                    'subtitle': 'Talk to us now',
                  },
                  {
                    'iconBg': const Color(0xFF1CB5AC),
                    'icon': Icons.report_problem_outlined,
                    'title': 'Report Issue',
                    'subtitle': 'Something wrong?',
                  },
                  {
                    'iconBg': const Color(0xFF2DAA9E),
                    'icon': Icons.play_circle_outline,
                    'title': 'Video Guides',
                    'subtitle': 'Watch tutorials',
                  },
                ];

                final filtered = actions.where((a) {
                  if (_query.isEmpty) return true;
                  final t = '${a['title']} ${a['subtitle']}'.toLowerCase();
                  return t.contains(_query);
                }).toList();

                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.05,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: filtered.map((a) {
                    return _buildActionTile(
                      context,
                      iconBg: a['iconBg'] as Color,
                      icon: a['icon'] as IconData,
                      title: a['title'] as String,
                      subtitle: a['subtitle'] as String,
                      onTap: () =>
                          _handleActionTap(a['title'] as String, context),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 24),
            Text(
              'Browse Help Topics',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3950),
              ),
            ),
            const SizedBox(height: 12),

            // Topic list (filterable)
            ..._topicData
                .where((t) {
                  if (_query.isEmpty) return true;
                  final bullets =
                      (t['bullets'] as List<dynamic>?)
                          ?.map((b) => b.toString())
                          .toList() ??
                      [];
                  final hay = '${t['title']} ${bullets.join(' ')}'
                      .toLowerCase();
                  return hay.contains(_query);
                })
                .map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildTopicCard(
                      context,
                      title: t['title'] as String,
                      bullets: List<String>.from(t['bullets'] as List),
                      imagePath: t['imagePath'] as String?,
                      sections: t['sections'] as List<TopicSection>?,
                    ),
                  ),
                )
                .toList(),

            const SizedBox(height: 24),
            Text(
              'Contact Support',
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3950),
              ),
            ),
            const SizedBox(height: 12),
            ..._contactData
                .where((c) {
                  if (_query.isEmpty) return true;
                  final hay = '${c['title']} ${c['subtitle']}'.toLowerCase();
                  return hay.contains(_query);
                })
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildContactCard(
                      context,
                      title: c['title'] as String,
                      subtitle: c['subtitle'] as String,
                      iconBg: c['iconBg'] as Color,
                      onTap: () =>
                          _handleContactTap(c['title'] as String, context),
                    ),
                  ),
                )
                .toList(),

            const SizedBox(height: 24),
            Center(
              child: Text(
                'ocevara App v2.4.1',
                style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                '© 2026 ocevara Foundation',
                style: GoogleFonts.lato(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  void _handleActionTap(String title, BuildContext context) {
    switch (title) {
      case 'FAQs':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FAQsScreen()),
        );
        break;
      case 'Chat Support':
        showModalBottomSheet(
          context: context,
          builder: (_) => const SizedBox(
            height: 500,
            child: Center(child: Text('Chat support coming...')),
          ),
        );
        break;
      case 'Report Issue':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FeedbackScreen()),
        );
        break;
      case 'Video Guides':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VideoGuidesScreen()),
        );
        break;
    }
  }

  void _handleContactTap(String title, BuildContext context) {
    if (title.toLowerCase().contains('response')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ContactDetailScreen(infoType: ContactInfoType.responseTime),
        ),
      );
      return;
    }
    if (title.toLowerCase().contains('email')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ContactDetailScreen(infoType: ContactInfoType.email),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactDetailScreen(infoType: ContactInfoType.phone),
      ),
    );
  }

  final List<Map<String, Object>> _topicData = [
    {
      'title': 'Getting Started',
      'imagePath': 'https://images.unsplash.com/photo-1516939884455-1445c8652f83?q=80&w=1000&auto=format&fit=crop',
      'bullets': [
        'How to log a sustainable catch',
        'Understanding Steward Status',
        'Setting up your fishing profile',
      ],
      'sections': [
        TopicSection(
          icon: Icons.file_present_outlined,
          title: 'How to log a sustainable catch',
          content: 'Recording your catch helps researchers monitor fish populations. Simply tap the "Log Catch" button on the home screen, select the species, enter the weight and quantity, and pin your location. Remember to only keep what you need.',
        ),
        TopicSection(
          icon: Icons.stars_outlined,
          title: 'Understanding Steward Status',
          content: 'Steward Status is our way of recognizing fishers who follow sustainable practices. You earn points by logging varied species, participating in community surveys, and reporting boat activity. Higher statuses unlock exclusive community features.',
        ),
        TopicSection(
          icon: Icons.account_circle_outlined,
          title: 'Setting up your fishing profile',
          content: 'A complete profile helps us provide tailored regulations and zone advice. Add your boat details, commonly used gear and your preferred fishing zones in the Settings menu under \'Fishing Profile\'.',
        ),
      ],
    },
    {
      'title': 'Protected Species',
      'imagePath': 'https://images.unsplash.com/photo-1544923246-77307dd654ca?q=80&w=1000&auto=format&fit=crop',
      'bullets': [
        'Identifying protected species',
        'What to do if you encounter one',
        'Reporting protected species sightings',
      ],
      'sections': [
        TopicSection(
          icon: Icons.visibility_outlined,
          title: 'Identifying protected species',
          content: 'Protected species include several types of Sea Turtles, Hammerhead Sharks, and Giant Manta Rays. These animals are vital to the ecosystem. Use our identification guide to recognize them before they reach your deck.',
        ),
        TopicSection(
          icon: Icons.handyman_outlined,
          title: 'What to do if you encounter one',
          content: 'If a protected species is accidentally hooked, keep it in the water if possible. Carefully remove the hook with long-handled pliers or cut the line as close to the animal as safe. Never pull an animal on board by its tail or gills.',
        ),
        TopicSection(
          icon: Icons.campaign_outlined,
          title: 'Reporting protected species sightings',
          content: 'Every sighting report contributes to global conservation maps. Use the \'Report Sighting\' feature to quickly record the time, species, and location of any protected animal you spot, even if it wasn\'t caught.',
        ),
      ],
    },
    {
      'title': 'Regulations & Guidelines',
      'imagePath': 'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?q=80&w=1000&auto=format&fit=crop',
      'bullets': [
        'Local fishing regulations',
        'Seasonal restrictions',
        'Catch size and limits',
      ],
      'sections': [
        TopicSection(
          icon: Icons.gavel_outlined,
          title: 'Local fishing regulations',
          content: 'All fishers must carry a valid digital license. Prohibited gear includes explosives, chemicals, and fine-mesh nets. Always check the \'Zones\' map for current no-take areas and restricted marinas.',
        ),
        TopicSection(
          icon: Icons.event_note_outlined,
          title: 'Seasonal restrictions',
          content: 'To protect spawning seasons, specific species are off-limits during certain months. For example, Red Snapper is restricted from May to July. Check the \'Alerts\' tab on the home screen for live seasonal updates.',
        ),
        TopicSection(
          icon: Icons.straighten_outlined,
          title: 'Catch size and limits',
          content: 'Minimum size limits ensure fish have reached reproductive age. Always measure from the tip of the snout to the fork of the tail. Daily bag limits are enforced to prevent overfishing and ensure future supply.',
        ),
      ],
    },
    {
      'title': 'Community Features',
      'imagePath': 'https://images.unsplash.com/photo-1529156069898-49953e39b30f?q=80&w=1000&auto=format&fit=crop',
      'bullets': [
        'How rankings work',
        'Joining fishing cooperatives',
        'Sharing your catches',
      ],
      'sections': [
        TopicSection(
          icon: Icons.leaderboard_outlined,
          title: 'How rankings work',
          content: 'Rankings are updated weekly based on your sustainable logging, participation in community surveys, and reporting boat activity. Higher rankings reward you with exclusive badges and features.',
        ),
        TopicSection(
          icon: Icons.group_add_outlined,
          title: 'Joining fishing cooperatives',
          content: 'Fishing cooperatives allow you to share knowledge and resources with other local fishers. You can join a cooperative through the \'Community\' tab to collaborate on sustainability goals.',
        ),
        TopicSection(
          icon: Icons.share_outlined,
          title: 'Sharing your catches',
          content: 'Share your successful sustainable logs with the community! You can choose to share your catch information while keeping your exact location private, helping others learn best practices.',
        ),
      ],
    },
    {
      'title': 'Maps & Zones',
      'imagePath': 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=1000&auto=format&fit=crop',
      'bullets': [
        'Understanding fishing zones',
        'Finding safe fishing areas',
        'Real-time zone updates',
      ],
      'sections': [
        TopicSection(
          icon: Icons.map_outlined,
          title: 'Understanding fishing zones',
          content: 'Our map uses color-coded zones to indicate different regulations. Green zones are open for sustainable fishing, while red zones are protected no-take areas. Always check the zone legend before dropping anchor.',
        ),
        TopicSection(
          icon: Icons.location_on_outlined,
          title: 'Finding safe fishing areas',
          content: 'Use the \'Zones\' screen to identify areas with favorable conditions and legal fishing grounds. Our real-time data helps you find safe spots away from high-traffic shipping lanes.',
        ),
        TopicSection(
          icon: Icons.refresh_outlined,
          title: 'Real-time zone updates',
          content: 'Fishing zones can change due to seasonal migrations or conservation efforts. Ensure you have \'Automatic Sync\' enabled in Settings to receive the latest zone updates instantly.',
        ),
      ],
    },
    {
      'title': 'Account & Settings',
      'imagePath': 'https://images.unsplash.com/photo-1563986768609-322da13575f3?q=80&w=1000&auto=format&fit=crop',
      'bullets': [
        'Managing your data',
        'Privacy settings',
        'Notification preferences',
      ],
      'sections': [
        TopicSection(
          icon: Icons.security_outlined,
          title: 'Managing your data',
          content: 'Your catch data is yours. You can view, edit, or delete your logs at any time. We use anonymized, aggregated data for research while keeping your personal details secure.',
        ),
        TopicSection(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy settings',
          content: 'Control how much information you share with the ocevara community. You can toggle location sharing, profile visibility, and data contribution in the \'Privacy\' section of your profile settings.',
        ),
        TopicSection(
          icon: Icons.notifications_active_outlined,
          title: 'Notification preferences',
          content: 'Stay updated on the latest regulations and weather alerts. customize your notification settings to receive alerts that matter most to your fishing activities.',
        ),
      ],
    },
  ];

  final List<Map<String, Object>> _contactData = [
    {
      'title': 'Average Response Time',
      'subtitle': 'Under 2 hours during business hours',
      'iconBg': const Color(0xFFE6F7FD),
    },
    {
      'title': 'Email',
      'subtitle': 'support@ocevara.org — 24/7',
      'iconBg': const Color(0xFFEAF3FF),
    },
    {
      'title': 'Phone',
      'subtitle': '+234 800 ocevara — Mon-Fri, 8AM-6PM',
      'iconBg': const Color(0xFFF2F8F9),
    },
  ];

  Widget _buildCategoryCard(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBFD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1CB5AC), size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F3950),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: const Color(0xFF0F3950),
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required Color iconBg,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFD),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3950),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context, {
    required String title,
    required List<String> bullets,
    String? imagePath,
    List<TopicSection>? sections,
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TopicDetailScreen(
            title: title,
            bullets: bullets,
            imagePath: imagePath,
            sections: sections,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFD),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF2FAFB),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_outlined,
                color: const Color(0xFF0F3950),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F3950),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...bullets.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• $b',
                        style: GoogleFonts.lato(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFD),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Builder(
              builder: (context) {
                final bool highlighted = iconBg == const Color(0xFFE6F7FD);
                final Color cardColor = highlighted
                    ? iconBg
                    : const Color(0xFFF7FBFD);
                final Color circleBg = highlighted
                    ? const Color(0xFFF7FBFD)
                    : iconBg;
                IconData leadIcon = Icons.info_outline;
                if (title.toLowerCase().contains('response'))
                  leadIcon = Icons.schedule;
                if (title.toLowerCase().contains('email'))
                  leadIcon = Icons.email_outlined;
                if (title.toLowerCase().contains('phone'))
                  leadIcon = Icons.phone_outlined;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: circleBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      leadIcon,
                      color: const Color(0xFF0F3950),
                      size: 18,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F3950),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

