import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({super.key});

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I log a sustainable catch?',
      'answer':
          'Open the "Log New Catch" form in the Catch Log screen. Choose the species from the dropdown, enter the quantity (number of fish) and weight in kilograms. Always follow local size limits—if a fish is below the minimum size, release it immediately. Protected species must never be kept; report sightings through the Report Issue feature in Help & Support.',
    },
    {
      'question': 'What are fishing regulations in my area?',
      'answer':
          'Fishing regulations vary significantly by location and season. Check the "Regulations & Guidelines" section in Help & Support for your local rules. You can also enable location-based alerts in Settings to receive real-time zone updates when you enter restricted or spawning areas. Always verify regulations before each fishing trip.',
    },
    {
      'question': 'How do I update my profile?',
      'answer':
          'Go to Settings → Edit Profile to update your personal information, contact details, fishing experience level, and preferred fishing locations. Keep your contact info current so you receive critical alerts about restricted zones and emergency closures. Your profile helps us provide location-specific guidance.',
    },
    {
      'question': 'What if I lose internet connection?',
      'answer':
          'ocevara stores essential guidance and offline maps on your device. Catch logs are automatically saved locally and will sync when you reconnect. However, real-time zone updates, weather alerts, and community features require active internet. Your data is never lost—it syncs when connectivity returns.',
    },
    {
      'question': 'How do emergency zone restrictions work?',
      'answer':
          'When a fishing zone is restricted (e.g., during spawning season or due to pollution), the app displays a red warning banner and shows the restricted area on the map. You\'ll receive push notifications and see the alert across all screens. Tap the alert to see the exact coordinates, zone name, and restriction details. Fishing in restricted zones may violate local regulations.',
    },
    {
      'question': 'What does "Stewardship Status" mean?',
      'answer':
          'Your Stewardship Status reflects your commitment to sustainable fishing. It increases when you log catches responsibly, report illegal activities, and avoid restricted zones. Higher status unlocks community features and recognition. Check your Profile to see your current level and progress toward the next tier.',
    },
    {
      'question': 'Can I share my catches with others?',
      'answer':
          'Yes! Your Catch Log tracks all your fishing activity. You can view your catch history, share achievements with the community, and compare your catches with other stewards in your region. Statistics are updated in real-time as you log new catches.',
    },
    {
      'question': 'How do I report illegal fishing activity?',
      'answer':
          'If you witness illegal fishing, use the "Report Issue" feature in Help & Support. Provide details about the activity, location, and time. Reports are sent to local authorities and help protect marine ecosystems. Your report is treated confidentially and helps maintain sustainable fishing practices.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3950),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'FAQs',
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
            Text(
              'Frequently Asked Questions',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F3950),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap any question to expand the answer',
              style: GoogleFonts.lato(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _faqs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final faq = _faqs[index];
                final isExpanded = _expandedIndex == index;
                return _buildExpandableFAQ(
                  question: faq['question']!,
                  answer: faq['answer']!,
                  isExpanded: isExpanded,
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? null : index;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Still need help? Visit Help & Support or contact our team at support@ocevara.org',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableFAQ({
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded ? const Color(0xFF2463EB) : Colors.grey.shade200,
            width: isExpanded ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isExpanded ? 0.06 : 0.02),
              blurRadius: isExpanded ? 12 : 6,
              offset: Offset(0, isExpanded ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F3950),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_more,
                      color: isExpanded
                          ? const Color(0xFF2463EB)
                          : Colors.grey.shade500,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xFF2463EB).withOpacity(0.2),
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Text(
                  answer,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.6,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
