import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeepSeaZoneDetailScreen extends StatelessWidget {
  const DeepSeaZoneDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealHeader = Color(0xFF1CB5AC);
    const Color dangerRed = Color(0xFFFF3D00);
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
              'Zone E',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Text(
              'Deep Sea Zone',
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
            // Danger Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: dangerRed.withOpacity(0.3), width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: dangerRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cancel, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'DANGER',
                    style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFB71C1C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Far from shore. Only for experienced fishermen with good boats. STRONG WINDS TODAY.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFFC62828),
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
                          'Rough\n- 3.5m',
                          Icons.waves,
                          Colors.blue.shade100,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildConditionTile(
                          'Wind',
                          'Gale -\n45 km/h',
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
                          'Poor -\nCan see\n1m',
                          Icons.visibility_outlined,
                          Colors.blue.shade100,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildConditionTile(
                          'Depth',
                          'Very Deep -\n200-500m',
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
                      'Distance: 15+ km from shore\nBottom: Deep trenches and oceanic shelf\nTide: Dangerous swells expected at 2:30 PM',
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
                  _buildFishTag('Tuna'),
                  _buildFishTag('Barracuda'),
                  _buildFishTag('Marlin'),
                  _buildFishTag('Sailfish'),
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
                  _buildTimeTile('NOT RECOMMENDED TODAY due to weather'),
                  const SizedBox(height: 8),
                  _buildTimeTile('Usually best at first light on calm days'),
                  const SizedBox(height: 8),
                  _buildTimeTile('Overnight trips require professional crew'),
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
                  _buildTipTile('DO NOT DEPART - Gale warnings active'),
                  _buildTipTile('Ensure all safety equipment is rated for open ocean'),
                  _buildTipTile('Radio check mandatory every hour'),
                  _buildTipTile('High risk of capsizing for vessels under 10m'),
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
                  _buildWisdomTile('Deep sea marlin follow the warm current edge'),
                  _buildWisdomTile('Use heavy-duty trolling gear only'),
                  _buildWisdomTile('Large swells can hide floating debris'),
                  _buildWisdomTile('Always keep the engine running in high waves'),
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
                  _buildRegTile('Special offshore permit required'),
                  _buildRegTile('Minimum vessel length: 8 meters'),
                  _buildRegTile('Mandatory GPS and beacon logs'),
                  _buildRegTile('No solitary fishing allow beyond 12nm'),
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
