import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../providers/health_provider.dart';

class CycleDetailPage extends StatelessWidget {
  const CycleDetailPage({super.key});

  void _showNoteDialog(BuildContext context, HealthProvider provider) {
    final controller = TextEditingController(text: provider.metrics.notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Note',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Mood or symptoms',
            hintText: 'How are you feeling today?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEC4899), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.textLight),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.addNote(controller.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note saved successfully!'),
                  backgroundColor: Color(0xFFEC4899),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC4899),
              foregroundColor: Colors.white,
            ),
            child: Text('Save', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cycle Progress',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          final cycleDay = provider.metrics.cycleDay;
          const cycleLength = 28;
          final progress = (cycleDay / cycleLength).clamp(0.0, 1.0);

          final today = DateTime.now();
          final nextPeriod = today.add(Duration(days: cycleLength - cycleDay));
          final ovulation = today.add(Duration(days: 14 - cycleDay));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFEC4899).withOpacity(0.1),
                        const Color(0xFFEC4899).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Day $cycleDay',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'of $cycleLength-day cycle',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFEC4899).withOpacity(0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFEC4899)),
                          minHeight: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildPhaseTimeline(cycleDay),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Color(0xFFEC4899),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Predicted Dates',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDateRow(
                        'Next Period',
                        DateFormat('MMM dd, yyyy').format(nextPeriod),
                        Colors.red.shade300,
                      ),
                      const SizedBox(height: 12),
                      _buildDateRow(
                        'Ovulation',
                        cycleDay <= 14
                            ? DateFormat('MMM dd, yyyy').format(ovulation)
                            : 'Passed',
                        Colors.purple.shade300,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _showNoteDialog(context, provider),
                    icon: const Icon(Icons.note_add_rounded),
                    label: Text(
                      'Add Note',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEC4899),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                if (provider.metrics.notes != null &&
                    provider.metrics.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFEC4899).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Note',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.metrics.notes!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textLight,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhaseTimeline(int cycleDay) {
    final phases = [
      {'name': 'Menstrual', 'days': '1-5', 'range': [1, 5]},
      {'name': 'Follicular', 'days': '6-13', 'range': [6, 13]},
      {'name': 'Ovulation', 'days': '14-16', 'range': [14, 16]},
      {'name': 'Luteal', 'days': '17-28', 'range': [17, 28]},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Cycle Phases',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        ...phases.map((phase) {
          final start = phase['range'] as List<int>;
          final isActive = cycleDay >= start[0] && cycleDay <= start[1];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFEC4899)
                        : Colors.grey.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isActive ? Icons.check : Icons.circle,
                    color: isActive ? Colors.white : Colors.grey,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phase['name'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          color: isActive ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                      Text(
                        'Days ${phase['days']}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDateRow(String label, String date, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        Text(
          date,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
