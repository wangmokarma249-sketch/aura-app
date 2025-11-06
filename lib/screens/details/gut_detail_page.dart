import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/health_provider.dart';

class GutDetailPage extends StatelessWidget {
  const GutDetailPage({super.key});

  void _showLogDialog(BuildContext context, HealthProvider provider) {
    final controller = TextEditingController(text: provider.metrics.notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Daily Log',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'Meal or digestion notes',
            hintText: 'What did you eat? How do you feel?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
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
                  content: Text('Log saved successfully!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: Text('Save', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return const Color(0xFF10B981);
      case 'okay':
        return const Color(0xFFF59E0B);
      case 'poor':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF10B981);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'good':
        return Icons.sentiment_very_satisfied_rounded;
      case 'okay':
        return Icons.sentiment_neutral_rounded;
      case 'poor':
        return Icons.sentiment_dissatisfied_rounded;
      default:
        return Icons.sentiment_satisfied_rounded;
    }
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
          'Gut Health',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          final status = provider.metrics.gutHealthStatus;
          final statusColor = _getStatusColor(status);
          final statusIcon = _getStatusIcon(status);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        statusColor.withOpacity(0.1),
                        statusColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          statusIcon,
                          size: 64,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        status,
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Current Status',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      Text(
                        'Update Status',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatusButton(
                              context,
                              'Good',
                              Icons.sentiment_very_satisfied_rounded,
                              const Color(0xFF10B981),
                              provider,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatusButton(
                              context,
                              'Okay',
                              Icons.sentiment_neutral_rounded,
                              const Color(0xFFF59E0B),
                              provider,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildStatusButton(
                              context,
                              'Poor',
                              Icons.sentiment_dissatisfied_rounded,
                              const Color(0xFFEF4444),
                              provider,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogDialog(context, provider),
                    icon: const Icon(Icons.restaurant_rounded),
                    label: Text(
                      'Daily Log',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
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
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF10B981).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.note_rounded,
                              color: Color(0xFF10B981),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Today\'s Log',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.lightbulb_rounded,
                              color: Color(0xFF10B981),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Insights',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInsightItem(
                        'High fiber meals improved your gut score this week.',
                      ),
                      const SizedBox(height: 12),
                      _buildInsightItem(
                        'Try adding more probiotics to your diet for better digestion.',
                      ),
                      const SizedBox(height: 12),
                      _buildInsightItem(
                        'Staying hydrated helps maintain healthy gut bacteria.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    HealthProvider provider,
  ) {
    final isSelected = provider.metrics.gutHealthStatus == label;

    return GestureDetector(
      onTap: () {
        provider.updateGutHealthStatus(label);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $label'),
            backgroundColor: color,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF10B981),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textDark,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
