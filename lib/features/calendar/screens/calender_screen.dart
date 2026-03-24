import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ocevara/core/theme/app_colors.dart';
import 'package:ocevara/core/widgets/ocevara_app_bar.dart';
import 'package:ocevara/features/calendar/viewmodels/calendar_view_model.dart';
import 'package:ocevara/features/home/screens/fish_list_screen.dart';

class FishingCalendarScreen extends ConsumerStatefulWidget {
  const FishingCalendarScreen({super.key});

  @override
  ConsumerState<FishingCalendarScreen> createState() => _FishingCalendarScreenState();
}

class _FishingCalendarScreenState extends ConsumerState<FishingCalendarScreen> {
  int? _selectedDay;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
      _selectedDay = null;
    });
    ref.read(calendarViewModelProvider.notifier).changeMonth(_focusedMonth);
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
      _selectedDay = null;
    });
    ref.read(calendarViewModelProvider.notifier).changeMonth(_focusedMonth);
  }

  void _goToToday() {
    setState(() {
      _focusedMonth = DateTime.now();
      _selectedDay = null;
    });
    ref.read(calendarViewModelProvider.notifier).changeMonth(_focusedMonth);
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  int _firstDayOfWeek(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday % 7;
  }

  @override
  Widget build(BuildContext context) {
    final calendarState = ref.watch(calendarViewModelProvider);
    final viewModel = ref.read(calendarViewModelProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navy = isDark ? Colors.white : AppColors.primaryNavy;
    final teal = AppColors.primaryTeal;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: OcevaraAppBar(
        title: 'Fishing Calendar',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _goToToday,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: teal.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Today',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: calendarState.isLoading && calendarState.days.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Region Selection
                  if (calendarState.regions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.getCardBackground(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: teal.withOpacity(0.3)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: calendarState.selectedRegion?.id,
                            isExpanded: true,
                            hint: const Text('Select Region'),
                            items: calendarState.regions.map((region) {
                              return DropdownMenuItem(
                                value: region.id,
                                child: Text(region.name, style: GoogleFonts.lato(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) viewModel.changeRegion(val);
                            },
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Summary Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: _buildSummaryCard('${calendarState.summary['low'] ?? 0}', 'Safe Days', Colors.green)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSummaryCard('${calendarState.summary['medium'] ?? 0}', 'Warning Days', Colors.orange)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSummaryCard('${(calendarState.summary['high'] ?? 0) + (calendarState.summary['critical'] ?? 0)}', 'Danger Days', Colors.red)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Legend
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.getCardBackground(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: teal.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLegendEntry(Colors.green, 'Safe'),
                          _buildLegendEntry(Colors.orange, 'Warning'),
                          _buildLegendEntry(Colors.red, 'Danger'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Calendar Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.darkCard 
                            : const Color(0xFF7DDED8),
                        borderRadius: BorderRadius.circular(24),
                        border: Theme.of(context).brightness == Brightness.dark 
                            ? Border.all(color: Colors.white.withOpacity(0.1)) 
                            : null,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.chevron_left, color: navy),
                                onPressed: _previousMonth,
                              ),
                              Text(
                                DateFormat('MMMM yyyy').format(_focusedMonth),
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: navy,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.chevron_right, color: navy),
                                onPressed: _nextMonth,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                                .map((day) => Text(
                                      day,
                                      style: GoogleFonts.lato(
                                        color: navy,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: _daysInMonth(_focusedMonth) + _firstDayOfWeek(_focusedMonth),
                            itemBuilder: (context, index) {
                              int firstDay = _firstDayOfWeek(_focusedMonth);
                              if (index < firstDay) {
                                return const SizedBox.shrink();
                              }

                              int dayNum = index - firstDay + 1;
                              bool isSelected = _selectedDay == dayNum;
                              
                              final now = DateTime.now();
                              bool isToday = now.day == dayNum && 
                                             now.month == _focusedMonth.month && 
                                             now.year == _focusedMonth.year;
                              
                              // Get status from real data
                              String riskLevel = 'low';
                              if (dayNum <= calendarState.days.length) {
                                riskLevel = calendarState.days[dayNum - 1].riskLevel;
                              }
                              Color dotColor = _getStatusColor(riskLevel);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedDay = (_selectedDay == dayNum) ? null : dayNum;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? AppColors.getCardBackground(context) 
                                        : (isToday ? teal.withOpacity(0.3) : AppColors.getCardBackground(context).withOpacity(0.4)),
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSelected 
                                        ? Border.all(color: navy, width: 2) 
                                        : (isToday ? Border.all(color: teal, width: 2) : null),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (isToday && !isSelected)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 1),
                                          child: Text(
                                            'TODAY',
                                            style: GoogleFonts.lato(
                                              fontSize: 6,
                                              fontWeight: FontWeight.bold,
                                              color: navy,
                                            ),
                                          ),
                                        ),
                                      if (isSelected)
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 2, top: 2),
                                            child: CircleAvatar(radius: 3, backgroundColor: navy),
                                          ),
                                        ),
                                      Text(
                                        '$dayNum',
                                        style: GoogleFonts.lato(
                                          color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      CircleAvatar(radius: 2, backgroundColor: dotColor),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Dynamic Detail View
                  if (_selectedDay != null)
                    _buildDetailView(
                      dayNum: _selectedDay!,
                      dayData: _selectedDay! <= calendarState.days.length 
                          ? calendarState.days[_selectedDay! - 1] 
                          : null,
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 5, backgroundColor: color),
              const SizedBox(width: 8),
              Text(
                count,
                style: GoogleFonts.lato(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendEntry(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String level) {
    switch (level) {
      case 'critical':
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      default: return Colors.green;
    }
  }

  Widget _buildDetailView({required int dayNum, dynamic dayData}) {
    final date = dayData != null 
        ? DateTime.parse(dayData.date) 
        : DateTime(_focusedMonth.year, _focusedMonth.month, dayNum);
    final weekday = DateFormat('EEEE').format(date);
    final riskLevel = dayData?.riskLevel ?? 'low';
    final statusColor = _getStatusColor(riskLevel);
    
    String statusText = 'SAFE';
    String statusSub = 'Perfect Day';
    IconData statusIcon = Icons.check_circle_outline;

    if (riskLevel == 'medium') {
      statusText = 'CAREFUL';
      statusSub = 'Be careful';
      statusIcon = Icons.warning_amber_rounded;
    } else if (riskLevel == 'high' || riskLevel == 'critical') {
      statusText = 'DANGER';
      statusSub = 'High Risk';
      statusIcon = Icons.error_outline;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: Month & Date inside a bordered container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  weekday,
                  style: GoogleFonts.lato(
                    fontSize: 24, 
                    color: Colors.black, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMMM d').format(date),
                  style: GoogleFonts.lato(
                    fontSize: 36, 
                    color: Colors.black, 
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Large Status Icon (Circle)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              size: 80,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            statusSub,
            style: GoogleFonts.lato(
              fontSize: 28, 
              fontWeight: FontWeight.w900, 
              color: AppColors.primaryNavy,
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Metrics Header
          Text(
            statusText == 'SAFE' ? 'Perfect Day' : 'Warning',
            style: GoogleFonts.lato(
              fontSize: 24, 
              fontWeight: FontWeight.w900, 
              color: statusColor,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Metrics Row (Waves, Wind, Sky)
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  '2.3m', 
                  'Waves', 
                  Icons.waves, 
                  statusColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  '23km/h', 
                  'Wind', 
                  Icons.air, 
                  statusColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  'Rain', 
                  'Sky', 
                  Icons.cloud_outlined, 
                  statusColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // See Fish List Button
          ElevatedButton(
            onPressed: () {
              debugPrint('Navigating to FishListScreen');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FishListScreen(
                    date: DateFormat('MMMM d, yyyy').format(date),
                    dayData: dayData,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 70),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.set_meal_outlined, size: 28),
                const SizedBox(width: 16),
                Text(
                  'See Fish List',
                  style: GoogleFonts.lato(
                    fontSize: 22, 
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryNavy.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: AppColors.primaryNavy,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 14, 
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}

