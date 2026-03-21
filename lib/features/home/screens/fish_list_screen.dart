import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ocevara/core/models/calendar_day.dart';
import 'package:ocevara/core/models/fish_species.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/features/home/viewmodels/species_view_model.dart';
import 'package:ocevara/features/map/screens/fish_detail_screen.dart';

class FishListScreen extends ConsumerWidget {
  final String date;
  final CalendarDay? dayData;

  const FishListScreen({super.key, required this.date, this.dayData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSpecies = ref.watch(speciesViewModelProvider);
    final navy = AppColors.primaryNavy;
    
    // Filter Species
    final List<FishSpecies> restrictedFish = [];
    final List<FishSpecies> safeFish = [];

    for (var fish in allSpecies) {
      bool isRestricted = fish.isProtected || 
                         dayData?.applicableRules.any((r) => (r.riskLevel == 'high' || r.riskLevel == 'critical') && r.message.toLowerCase().contains(fish.commonName.toLowerCase())) == true;
      if (isRestricted) {
        restrictedFish.add(fish);
      } else {
        safeFish.add(fish);
      }
    }

    final riskLevel = dayData?.riskLevel ?? 'low';
    final statusColor = riskLevel == 'low' ? Colors.green : (riskLevel == 'medium' ? Colors.orange : Colors.red);
    final statusText = riskLevel == 'low' ? 'SAFE TO FISH' : (riskLevel == 'medium' ? 'CAREFUL' : 'DANGER');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E7), // Cream background from design
      appBar: AppBar(
        backgroundColor: navy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          date,
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
            children: [
              // ── Top Summary Card ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFB3D7F3), // Specific light blue
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: navy.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 48),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      statusText,
                      style: GoogleFonts.lato(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Divider(color: navy.withOpacity(0.1), thickness: 1),
                    const SizedBox(height: 16),
                    
                    // 2x2 Weather Metrics Grid
                    Row(
                      children: [
                        Expanded(child: _buildWeatherTile(context, '0.5m', 'Waves', Icons.waves)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildWeatherTile(context, '5 km/h', 'Wind', Icons.air)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildWeatherTile(context, 'Light\nclouds', 'Weather', Icons.cloud_queue_rounded)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildWeatherTile(context, '20°C', 'Heat', Icons.wb_sunny_outlined)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── "You CAN Catch" Section ─────────────────────────────────────
              _buildLargeSection(
                context,
                title: 'You CAN Catch',
                headerColor: navy,
                icon: Icons.set_meal,
                iconColor: Colors.green,
                items: safeFish,
                isDanger: false,
              ),

              const SizedBox(height: 24),

              // ── "Do not Catch" Section ──────────────────────────────────────
              _buildLargeSection(
                context,
                title: 'Do not Catch',
                headerColor: const Color(0xFFE53935), // Red
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.white,
                items: restrictedFish,
                isDanger: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherTile(BuildContext context, String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
          ),
          Text(
            label,
            style: GoogleFonts.lato(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeSection(BuildContext context, {
    required String title,
    required Color headerColor,
    required IconData icon,
    required Color iconColor,
    required List<FishSpecies> items,
    bool isDanger = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB3D7F3).withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: headerColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDanger ? Colors.transparent : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.lato(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items.map((fish) => _buildFishItem(context, fish, isDanger)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFishItem(BuildContext context, FishSpecies fish, bool isDanger) {
    final borderColor = isDanger ? Colors.red.withOpacity(0.5) : Colors.green.withOpacity(0.3);
    final bgColor = isDanger ? const Color(0xFFFFF2F2) : const Color(0xFFF2FFF2);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FishDetailScreen(
              species: fish,
              isRestricted: isDanger,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDanger ? Colors.red : Colors.green,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: fish.imageUrl != null 
                    ? (fish.imageUrl!.startsWith('http')
                        ? Image.network(
                            fish.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.set_meal, color: Colors.white, size: 28),
                          )
                        : Image.asset(
                            fish.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.set_meal, color: Colors.white, size: 28),
                          ))
                    : const Icon(Icons.set_meal, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fish.commonName,
                    style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDanger ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isDanger ? 'DO NOT CATCH' : '✓ SAFE',
                      style: GoogleFonts.lato(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isDanger ? Colors.red : Colors.green, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingBottomNav(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFloatingNavItem(Icons.home_outlined, 'Home', false),
          _buildFloatingNavItem(Icons.calendar_month, 'Calendar', true),
          _buildFloatingNavItem(Icons.set_meal_outlined, 'Log Catch', false),
          _buildFloatingNavItem(Icons.edit_note_outlined, 'Tips', false),
        ],
      ),
    );
  }

  Widget _buildFloatingNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: isActive ? BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 1.5),
          ) : null,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.lato(color: Colors.white, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}

