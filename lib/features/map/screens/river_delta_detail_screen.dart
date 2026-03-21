import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiverDeltaDetailScreen extends StatelessWidget {
  const RiverDeltaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealHeader = Color(0xFF1CB5AC);
    const Color safeGreen = Color(0xFF00C853);
    const Color sectionTitleColor = Color(0xFF2D3748);
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
              'Zone A',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Text(
              'River Delta',
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
            // Safe to Fish Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: safeGreen.withOpacity(0.3), width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: safeGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'SAFE TO FISH',
                    style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'River mouth where fresh water meets the sea. Good for many fish types. Safe area for small boats.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF2E7D32),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Today's Conditions
            _buildSection(
              title: "Today's Conditions",
              icon: Icons.cloud_outlined,
              iconColor: Colors.blue,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildConditionTile(
                          'Waves',
                          'Small\n- 0.5m',
                          Icons.waves,
                          Colors.blue.shade100,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildConditionTile(
                          'Wind',
                          'Light -\n8 km/h',
                          Icons.air,
                          Colors.blue.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildConditionTile(
                          'Visibility',
                          'Good -\nCan see\n2m',
                          Icons.visibility_outlined,
                          Colors.blue.shade100,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildConditionTile(
                          'Depth',
                          'Shallow -\n2-5m',
                          Icons.landscape_outlined,
                          Colors.blue.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Distance: 2 km from shore\nBottom: Mud and sand\nTide: High flow 8:30 AM, Low tide 12:45 PM',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Fish You Can Catch
            _buildSection(
              title: 'Fish You Can Catch',
              icon: Icons.set_meal_outlined,
              iconColor: tealHeader,
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildFishTag('Tilapia'),
                  _buildFishTag('Catfish'),
                  _buildFishTag('Mullet'),
                  _buildFishTag('Small Carp'),
                ],
              ),
            ),

            // Best Times to Fish
            _buildSection(
              title: 'Best Times to Fish',
              icon: Icons.calendar_today_outlined,
              iconColor: Colors.purple,
              child: Column(
                children: [
                  _buildTimeTile('Early morning (5-9 AM) - best catch time'),
                  const SizedBox(height: 8),
                  _buildTimeTile('Late afternoon (4-6 PM) - good fishing'),
                  const SizedBox(height: 8),
                  _buildTimeTile('High tide brings more fish'),
                ],
              ),
            ),

            // Safety Tips
            _buildSection(
              title: 'Safety Tips',
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.orange,
              borderColor: Colors.orange.shade200,
              child: Column(
                children: [
                  _buildTipTile('Watch for changing currents in tide times'),
                  _buildTipTile('Stay in marked channels'),
                  _buildTipTile('Avoid fishing during heavy rain (river flow fast)'),
                  _buildTipTile('Tell someone your fishing plan'),
                ],
              ),
            ),

            // Local Fishing Wisdom
            _buildSection(
              title: 'Local Fishing Wisdom',
              icon: Icons.info_outline,
              iconColor: tealHeader,
              borderColor: tealHeader.withOpacity(0.3),
              child: Column(
                children: [
                  _buildWisdomTile('Fish gather near mangrove roots'),
                  _buildWisdomTile('Best mullet fishing during outgoing tide'),
                  _buildWisdomTile('Catfish active at dawn and dusk'),
                  _buildWisdomTile('Avoid muddy areas after storms'),
                ],
              ),
            ),

            // Rules & Regulations
            _buildSection(
              title: 'Rules & Regulations',
              icon: Icons.menu_book_outlined,
              iconColor: Colors.blue.shade700,
              borderColor: Colors.blue.shade200,
              child: Column(
                children: [
                  _buildRegTile('No fishing with nets larger than 1m'),
                  _buildRegTile('Respect local fishing times (6 AM - 6 PM)'),
                  _buildRegTile('Release all small fish under size limit'),
                  _buildRegTile('No motorboats in shallow areas'),
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

  Widget _buildConditionTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.blue.shade700),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ],
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
          const Icon(Icons.set_meal_outlined, size: 14, color: Colors.green),
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
        color: Colors.purple.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18, color: Colors.purple),
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
          border: Border.all(color: Colors.orange.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange),
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
            const Icon(Icons.lightbulb_outline, size: 18, color: Colors.amber),
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
            Icon(Icons.radio_button_off, size: 18, color: Colors.blue.shade400),
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
