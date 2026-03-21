import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoastalWatersDetailScreen extends StatelessWidget {
  const CoastalWatersDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color tealHeader = Color(0xFF1CB5AC);
    const Color carefulOrange = Color(0xFFFF6D00);
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
              'Zone C',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Text(
              'Coastal Waters',
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
            // Careful Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: carefulOrange.withOpacity(0.3), width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: carefulOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CAREFUL',
                    style: GoogleFonts.lato(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Coastal sea area. Good fishing but watch weather conditions carefully. Wind speed is increasing.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFFEF6C00),
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
                          'Moderate\n- 1.2m',
                          Icons.waves,
                          Colors.blue.shade100,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildConditionTile(
                          'Wind',
                          'Fresh -\n18 km/h',
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
                          'Fair -\nCan see\n5m',
                          Icons.visibility_outlined,
                          Colors.blue.shade100,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildConditionTile(
                          'Depth',
                          'Varies -\n10-30m',
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
                      'Distance: 5 km from shore\nBottom: Rocky and coral\nTide: Low flow 10:15 AM, High tide 4:20 PM',
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
                  _buildFishTag('Mackerel'),
                  _buildFishTag('Mullet'),
                  _buildFishTag('Snapper'),
                  _buildFishTag('Barracuda'),
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
                  _buildTimeTile('Early morning (6-10 AM) - rising tide'),
                  const SizedBox(height: 8),
                  _buildTimeTile('Mid-afternoon (2-5 PM) - before wind peaks'),
                  const SizedBox(height: 8),
                  _buildTimeTile('Night fishing yields larger species'),
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
                  _buildTipTile('Watch for increasing wind in late afternoon'),
                  _buildTipTile('Maintain safe distance from reef edges'),
                  _buildTipTile('Ensure life jackets are worn at all times'),
                  _buildTipTile('Check fuel levels before departing'),
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
                  _buildWisdomTile('Birds circling indicate schools of fish'),
                  _buildWisdomTile('Use heavier weights for deeper waters'),
                  _buildWisdomTile('Cast near rock formations for snapper'),
                  _buildWisdomTile('Fresh bait works best in these waters'),
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
                  _buildRegTile('Maximum catch limit: 5 large fish per person'),
                  _buildRegTile('Minimum size for Snapper: 35cm'),
                  _buildRegTile('No disposal of trash in the ocean'),
                  _buildRegTile('Anchoring restricted in coral zones'),
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
