import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';
import 'package:ocevara/features/catch_log/services/catch_log_service.dart';
import 'package:ocevara/features/catch_log/widgets/add_catch_form.dart';
import 'package:ocevara/features/sync/screens/sync_error_screen.dart';
import 'package:ocevara/features/ai_camera/screens/ai_camera_screen.dart';
import 'package:ocevara/core/services/auth_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/catch_log.dart';
import 'package:ocevara/features/catch_log/services/catch_log_service.dart';

class CatchLogScreen extends ConsumerStatefulWidget {
  const CatchLogScreen({super.key});

  @override
  ConsumerState<CatchLogScreen> createState() => _CatchLogScreenState();
}

class _CatchLogScreenState extends ConsumerState<CatchLogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProvider);
      if (user != null) {
        final notifier = ref.read(catchLogServiceProvider.notifier);
        notifier.loadUserLogs(user.id).then((_) {
          if (ref.read(catchLogServiceProvider).isEmpty) {
            notifier.refreshLogsFromServer(user.id);
          }
        });
      }
    });
  }

  String _fishEmojiFor(String species) {
    // Current model uses speciesId, but we might only have IDs for now
    // We'll fallback to a generic one or use the metadata if available
    final s = species.toLowerCase();
    if (s.contains('tuna')) return '🐟';
    if (s.contains('snapper') || s.contains('red')) return '🐠';
    if (s.contains('grouper')) return '🐡';
    if (s.contains('salmon')) return '🐟';
    if (s.contains('mackerel')) return '🐟';
    return '🐟';
  }

  String _formatDate(CatchLog log) {
    final now = DateTime.now();
    final d = log.date;
    
    // Normalize dates to midnight for accurate day difference
    final today = DateTime(now.year, now.month, now.day);
    final catchDate = DateTime(d.year, d.month, d.day);
    final diffDays = today.difference(catchDate).inDays;

    if (diffDays == 0) return 'Today';
    if (diffDays == 1) return 'Yesterday';
    if (diffDays > 1 && diffDays <= 7) return '$diffDays days ago';
    
    return '${d.day}/${d.month}/${d.year}';
  }

  void _openAddForm() {
    showAddCatchDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(catchLogServiceProvider);
    final service = ref.read(catchLogServiceProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? Colors.white : AppColors.primaryNavy;
    final accentBlue = AppColors.accentBlue;
    final cardBg = AppColors.getCardBackground(context);

    return Scaffold(
      backgroundColor: AppColors.getScaffoldBackground(context),
      appBar: OcevaraAppBar(
        title: 'Catch Log',
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: _openAddForm,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      // remove floating button to keep primary action inside the page
      body: RefreshIndicator(
        onRefresh: () async {
          final user = ref.read(userProvider);
          if (user != null) {
            await ref.read(catchLogServiceProvider.notifier).refreshLogsFromServer(user.id);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
          children: [
            // 1. Stats Row
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  _buildStatCard(
                    service.totalLogs.toString(),
                    'Total Logs',
                    accentBlue,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    service.totalFish.toString(),
                    'Total Fish',
                    Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    service.speciesCount.toString(),
                    'Species',
                    Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            // Add Catch button (prominent, inside page)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _openAddForm,
                      icon: Icon(Icons.add, color: isDark ? AppColors.primaryNavy : Colors.white),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text('Add Catch', style: TextStyle(
                          fontSize: 16,
                          color: isDark ? AppColors.primaryNavy : Colors.white)
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AICameraScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Icon(Icons.psychology, color: Colors.white, size: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Weekly Activity Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
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
                      Icon(Icons.show_chart, color: accentBlue),
                      const SizedBox(width: 12),
                      Text(
                        "This Week's Activity",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildActivityRow('Fishing Days:', '0'),
                  const SizedBox(height: 12),
                  _buildActivityRow(
                    'Total Catch:',
                    '${service.totalFish} fish',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3. Recent Logs Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Logs',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${service.totalLogs} entries',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: accentBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // List recent logs
            if (logs.isEmpty)
              Column(
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No catches logged yet',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the Add button to log your first catch',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.darkBorder.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: log.imagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: kIsWeb
                                      ? Image.network(
                                          log.imagePath!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          io.File(log.imagePath!),
                                          fit: BoxFit.cover,
                                        ),
                                )
                              : Center(
                                  child: Text(
                                    _fishEmojiFor(log.speciesId),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.speciesName ?? (log.speciesId == '00000000-0000-0000-0000-000000000000' 
                                    ? 'Unknown Species' 
                                    : log.speciesId),
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${log.quantity.toInt()} ${log.unit} • ${log.avgWeight ?? 0.0} kg',
                                style: GoogleFonts.lato(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatDate(log),
                              style: GoogleFonts.lato(
                                color: Colors.grey.shade500,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              log.displayTime ?? '${log.date.hour.toString().padLeft(2, '0')}:${log.date.minute.toString().padLeft(2, '0')}',
                              style: GoogleFonts.lato(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (!log.synced)
                              const Tooltip(
                                message: 'Wait for sync',
                                child: Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                              )
                            else
                              const Icon(
                                Icons.cloud_done_rounded,
                                size: 16,
                                  color: AppColors.primaryTeal,
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 60),

            // 4. Offline Note
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentBlue.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: accentBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your catch logs are saved on your phone and work offline. They will sync when you have internet connection.',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: navy.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    final cardBg = AppColors.getCardBackground(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: cardBg,
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
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ],
    );
  }
}


