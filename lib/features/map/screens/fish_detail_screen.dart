import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/core/models/fish_species.dart';
import 'package:ocevara/core/theme/app_colors.dart';

class FishDetailScreen extends StatelessWidget {
  final FishSpecies species;
  final bool isRestricted;

  const FishDetailScreen({super.key, required this.species, this.isRestricted = false});

  @override
  Widget build(BuildContext context) {
    final bool isSafe = !isRestricted;
    final Color themeColor = isSafe ? Colors.green : const Color(0xFFFF5221); // Brighter orange-red from design
    final Color cardBg = isSafe ? const Color(0xFFEDF9F4) : const Color(0xFFFFF1F1); // Mint vs Pale Red
    final Color borderColor = isSafe ? Colors.green.withOpacity(0.3) : const Color(0xFFFF5221).withOpacity(0.4);
    
    // Using teal for AppBar exactly as in design
    const Color tealHeader = Color(0xFF1CB5AC); 

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F0), // Off-white/cream background
      appBar: AppBar(
        backgroundColor: tealHeader,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          species.commonName,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                'assets/images/sign-up.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
          children: [
            // ── Main Fish Card ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image with Badge
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: species.imageUrl != null 
                      ? Image.network(
                          species.imageUrl!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 220,
                          color: AppColors.primaryNavy.withOpacity(0.2),
                          child: const Icon(Icons.set_meal, size: 64, color: Colors.white),
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Icon(
                          isSafe ? Icons.check_circle : Icons.warning_amber_rounded,
                          color: themeColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              species.commonName,
                              style: GoogleFonts.lato(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isSafe ? 'SAFE' : 'RESTRICTED',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    species.scientificName,
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    species.description,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Identification Tips ─────────────────────────────────────
            _buildDetailSection(
              context,
              title: 'Identification Tips',
              icon: Icons.fingerprint,
              themeColor: isSafe ? tealHeader : themeColor,
              borderColor: borderColor,
              child: Column(
                children: species.identificationTips.map((tip) => _buildBulletPoint(tip, isSafe ? tealHeader : themeColor)).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // ── Quick Facts ─────────────────────────────────────────────
            _buildDetailSection(
              context,
              title: 'Quick Facts',
              icon: Icons.info_outline,
              themeColor: isSafe ? tealHeader : themeColor,
              borderColor: borderColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildFactTile(Icons.straighten, 'Size Limits', species.sizeLimits ?? 'N/A')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildFactTile(Icons.location_on_outlined, 'Habitat', species.habitats.join(', '))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildFactTile(Icons.calendar_today_outlined, 'Best Seasons', species.bestSeasons.join(', '))),
                      const SizedBox(width: 12),
                      Expanded(child: _buildFactTile(Icons.trending_up, 'Nutritional Value', species.nutritionalValue ?? 'N/A')),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Catch Techniques OR Important Notice ───────────────────
            if (isSafe)
              _buildDetailSection(
                context,
                title: 'Catch Techniques',
                icon: Icons.waves,
                themeColor: tealHeader,
                borderColor: borderColor,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: species.catchTechniques.map((tech) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: tealHeader.withOpacity(0.5)),
                    ),
                    child: Text(
                      tech,
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F3950),
                      ),
                    ),
                  )).toList(),
                ),
              )
            else
              _buildDetailSection(
                context,
                title: 'Important Notice',
                icon: Icons.shield_outlined,
                themeColor: themeColor,
                borderColor: borderColor,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'This species is restricted and requires special care. Violating regulations can result in heavy fines and criminal charges. When in doubt, release the fish and contact local fisheries authorities.',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: const Color(0xFFB71C1C),
                      height: 1.5,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, {
    required String title, 
    required IconData icon, 
    required Widget child,
    required Color themeColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              Icon(icon, color: themeColor, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F3950),
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

  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: CircleAvatar(radius: 4, backgroundColor: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.lato(fontSize: 15, color: Colors.black.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF4E7).withOpacity(0.5), // Subtle beige
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0F3950), size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
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
}
