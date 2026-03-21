import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BreedingGroundsDetailScreen extends StatelessWidget {
  const BreedingGroundsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealHeader = Color(0xFF1CB5AC);
    const Color closedBlue = Color(0xFF2D3748);
    const Color bgBeige = Color(0xFFF7F4EB);

    return Scaffold(
      backgroundColor: bgBeige,
      appBar: AppBar(
        backgroundColor: tealHeader,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zone F',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Text(
              'Breeding Grounds',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Closed Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF2F7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: closedBlue.withOpacity(0.3), width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: closedBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.security, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CLOSED',
                    style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1A202C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'NO FISHING ALLOWED. This area is currently protected for the fish breeding season. Help us maintain our ocean heritage.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF4A5568),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Protecting Our Future Section
            _buildSection(
              title: "Protecting Our Future",
              icon: Icons.shield_outlined,
              iconColor: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why is this area closed?',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: closedBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Between February and April, many local species migrate here to spawn. Minimizing human activity ensures a healthy fish population for next season.',
                    style: GoogleFonts.lato(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoSmallTile('Closure Start', 'Feb 1st'),
                      const SizedBox(width: 8),
                      _buildInfoSmallTile('Est. Reopen', 'May 15th'),
                    ],
                  ),
                ],
              ),
            ),

            // Active Breeding Species
            _buildSection(
              title: 'Active Breeding Species',
              icon: Icons.set_meal_outlined,
              iconColor: tealHeader,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildFishTag('All Local Species'),
                  _buildFishTag('Protected Corals'),
                  _buildFishTag('Sea Turtles'),
                  _buildFishTag('Spawning Snapper'),
                ],
              ),
            ),

            // Zone Monitoring
            _buildSection(
              title: 'Zone Monitoring',
              icon: Icons.videocam_outlined,
              iconColor: Colors.redAccent,
              child: Column(
                children: [
                  _buildTimeTile('24/7 Satellite Surveillance'),
                  const SizedBox(height: 8),
                  _buildTimeTile('ocevara Coast Guard Patrols'),
                  const SizedBox(height: 8),
                  _buildTimeTile('Underwater Acoustic Monitoring'),
                ],
              ),
            ),

            // Penalty for Violation
            _buildSection(
              title: 'Penalty for Violation',
              icon: Icons.gavel_outlined,
              iconColor: Colors.red,
              borderColor: Colors.red.shade200,
              child: Column(
                children: [
                  _buildTipTile('Confiscation of all fishing gear'),
                  _buildTipTile('High fines starting from \$1,500'),
                  _buildTipTile('Permanent ban from ocean resources'),
                  _buildTipTile('Legal prosecution for eco-terrorism'),
                ],
              ),
            ),

            // Local Fishing Wisdom (Future)
            _buildSection(
              title: 'Historical Wisdom',
              icon: Icons.history_edu_outlined,
              iconColor: tealHeader,
              borderColor: tealHeader.withOpacity(0.3),
              child: Column(
                children: [
                  _buildWisdomTile('Ancient fishers always left this area untouched'),
                  _buildWisdomTile('The "Heart of the Sea" provides life to all zones'),
                  _buildWisdomTile('Respecting the cycle brings abundance in May'),
                ],
              ),
            ),

            // Rules & Regulations
            _buildSection(
              title: 'Conservation Rules',
              icon: Icons.menu_book_outlined,
              iconColor: Colors.blue.shade700,
              borderColor: Colors.blue.shade200,
              child: Column(
                children: [
                  _buildRegTile('No entry for motorized vessels'),
                  _buildRegTile('Non-extractive tourism permitted (No touching)'),
                  _buildRegTile('No disposal of any organic/inorganic waste'),
                  _buildRegTile('Report violations via the app'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor ?? Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoSmallTile(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.lato(fontSize: 10, color: Colors.blue.shade800),
            ),
            Text(
              value,
              style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFishTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_outlined, size: 14, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTile(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.gavel, size: 18, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWisdomTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1CB5AC).withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, size: 18, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.lato(fontSize: 12, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegTile(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, size: 18, color: Colors.blue.shade400),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.lato(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
