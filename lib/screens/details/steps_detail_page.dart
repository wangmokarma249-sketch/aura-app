import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../theme/app_colors.dart';
import '../../providers/health_provider.dart';

class StepsDetailPage extends StatefulWidget {
  const StepsDetailPage({super.key});

  @override
  State<StepsDetailPage> createState() => _StepsDetailPageState();
}

class _StepsDetailPageState extends State<StepsDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showGoalDialog(BuildContext context, HealthProvider provider) {
    final controller = TextEditingController(
      text: provider.metrics.stepsGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Set Step Goal',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Daily Step Goal',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.lavender, width: 2),
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
              final goal = int.tryParse(controller.text);
              if (goal != null && goal > 0) {
                provider.updateStepsGoal(goal);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Goal updated to $goal steps!'),
                    backgroundColor: AppColors.lavender,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lavender,
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
          'Daily Steps',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          final steps = provider.metrics.steps;
          final goal = provider.metrics.stepsGoal;
          final progress = (steps / goal).clamp(0.0, 1.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(250, 250),
                      painter: CircularProgressPainter(
                        progress: progress * _animation.value,
                        color: AppColors.lavender,
                      ),
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TweenAnimationBuilder<int>(
                                tween: IntTween(
                                  begin: 0,
                                  end: steps,
                                ),
                                duration: const Duration(milliseconds: 1500),
                                builder: (context, value, child) {
                                  return Text(
                                    value.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  );
                                },
                              ),
                              Text(
                                'steps',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Goal: $goal',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(progress * 100).toInt()}% Complete',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.lavender,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _showGoalDialog(context, provider),
                    icon: const Icon(Icons.flag_rounded),
                    label: Text(
                      'Set Step Goal',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lavender,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildInfoCard(
                  'Benefits',
                  'Walking 10,000 steps daily can help improve cardiovascular health, strengthen bones, and boost mental well-being.',
                  Icons.favorite_rounded,
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  'Tip',
                  'Try taking short walking breaks every hour to reach your daily goal more easily.',
                  Icons.lightbulb_rounded,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lavenderLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lavender.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lavender.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.lavender,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
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
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
