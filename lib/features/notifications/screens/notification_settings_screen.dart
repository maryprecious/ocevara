import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ocevara/features/sync/screens/sync_error_screen.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _masterToggle = true;
  bool _sound = true;
  bool _vibration = true;
  bool _emailNotifications = true;
  bool _catchReminders = true;
  bool _oceanAlerts = true;
  bool _achievements = true;
  bool _sustainabilityTips = false;
  bool _impactReports = true;
  bool _weatherAlerts = true;
  bool _tideUpdates = true;
  bool _appUpdates = false;

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0F3950);
    const Color masterToggleColor = Color(0xFF0F3950);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.lato(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Sync Failure Alert
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SyncErrorScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFED7D7)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53E3E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.sync_problem, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Synchronization Failed',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFC53030),
                              ),
                            ),
                            Text(
                              '3 categories could not be backed up.',
                              style: GoogleFonts.lato(
                                fontSize: 12,
                                color: const Color(0xFFC53030).withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFFC53030), size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Master Toggle Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: masterToggleColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: masterToggleColor.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _masterToggle ? 'Notifications Enabled' : 'Notifications Disabled',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _masterToggle ? '6 notification types active' : 'All notifications paused',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _masterToggle,
                      onChanged: (val) => setState(() => _masterToggle = val),
                      activeColor: Colors.white,
                      activeTrackColor: Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('Delivery Settings'),
            const SizedBox(height: 12),
            _buildToggleSection([
              _buildToggleTile(Icons.volume_up_outlined, 'Sound', '', _sound, (val) => setState(() => _sound = val)),
              _buildToggleTile(Icons.vibration_outlined, 'Vibration', '', _vibration, (val) => setState(() => _vibration = val)),
              _buildToggleTile(Icons.mail_outline, 'Email Notifications', 'Weekly digest', _emailNotifications, (val) => setState(() => _emailNotifications = val), isLast: true),
            ]),

            const SizedBox(height: 32),
            _buildSectionLabel('Activity'),
            const SizedBox(height: 12),
            _buildToggleSection([
              _buildToggleTile(Icons.set_meal_outlined, 'Catch Reminders', 'Log your daily catches', _catchReminders, (val) => setState(() => _catchReminders = val), isLast: true),
            ]),

            const SizedBox(height: 32),
            _buildSectionLabel('Conservation & Impact'),
            const SizedBox(height: 12),
            _buildToggleSection([
              _buildToggleTile(Icons.waves, 'Ocean Alerts', 'Conservation updates & warnings', _oceanAlerts, (val) => setState(() => _oceanAlerts = val)),
              _buildToggleTile(Icons.workspace_premium_outlined, 'Achievements', 'New badges & milestones', _achievements, (val) => setState(() => _achievements = val)),
              _buildToggleTile(Icons.lightbulb_outline, 'Sustainability Tips', 'Daily eco-friendly fishing tips', _sustainabilityTips, (val) => setState(() => _sustainabilityTips = val)),
              _buildToggleTile(Icons.trending_up, 'Impact Reports', 'Monthly conservation impact', _impactReports, (val) => setState(() => _impactReports = val), isLast: true),
            ]),

            const SizedBox(height: 32),
            _buildSectionLabel('Environment'),
            const SizedBox(height: 12),
            _buildToggleSection([
              _buildToggleTile(Icons.wb_cloudy_outlined, 'Weather Alerts', 'Severe weather warnings', _weatherAlerts, (val) => setState(() => _weatherAlerts = val)),
              _buildToggleTile(Icons.waves, 'Tide Updates', 'Best fishing times', _tideUpdates, (val) => setState(() => _tideUpdates = val), isLast: true),
            ]),

            const SizedBox(height: 32),
            _buildSectionLabel('System'),
            const SizedBox(height: 12),
            _buildToggleSection([
              _buildToggleTile(Icons.file_download_outlined, 'App Updates', 'New features & improvements', _appUpdates, (val) => setState(() => _appUpdates = val), isLast: true),
            ]),

            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF2C5282), size: 22),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Some notifications may still appear based on your device settings. Check your iOS settings for system-level notification controls.',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: primaryBlue.withOpacity(0.7),
                          height: 1.5,
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

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildToggleSection(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged, {bool isLast = false}) {
    const Color primaryBlue = Color(0xFF0F3950);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F6F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryBlue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: GoogleFonts.lato(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: _masterToggle ? onChanged : null,
                activeColor: Colors.white,
                activeTrackColor: primaryBlue,
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 64),
            child: Divider(height: 1, color: Colors.grey.shade100),
          ),
      ],
    );
  }
}

