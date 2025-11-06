import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../providers/health_provider.dart';

class WaterDetailPage extends StatefulWidget {
  const WaterDetailPage({super.key});

  @override
  State<WaterDetailPage> createState() => _WaterDetailPageState();
}

class _WaterDetailPageState extends State<WaterDetailPage> {
  final List<String> _hydrationTips = [
    'Drinking water improves metabolism and helps burn more calories.',
    'Stay hydrated to maintain healthy skin and prevent premature aging.',
    'Proper hydration aids digestion and prevents constipation.',
    'Water helps regulate body temperature and maintain energy levels.',
    'Drinking enough water can improve concentration and cognitive function.',
  ];

  void _addCup(HealthProvider provider) {
    provider.addWaterCup();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Great job! Keep staying hydrated!'),
        backgroundColor: Color(0xFF3B82F6),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
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
          'Hydration Tracker',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          final waterCups = provider.metrics.waterCups;
          final waterGoal = provider.metrics.waterGoal;
          final progress = (waterCups / waterGoal).clamp(0.0, 1.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF3B82F6).withOpacity(0.1),
                        const Color(0xFF3B82F6).withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$waterCups / $waterGoal',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'cups today',
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
                          backgroundColor: const Color(0xFF3B82F6).withOpacity(0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                          minHeight: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${(progress * 100).toInt()}% of daily goal',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: List.generate(waterGoal, (index) {
                    final isFilled = index < waterCups;
                    return AnimatedScale(
                      scale: isFilled ? 1.0 : 0.9,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isFilled
                              ? const Color(0xFF3B82F6).withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          Icons.water_drop,
                          color: isFilled
                              ? const Color(0xFF3B82F6)
                              : Colors.grey.withOpacity(0.3),
                          size: 32,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: waterCups < waterGoal
                              ? () => _addCup(provider)
                              : null,
                          icon: const Icon(Icons.add),
                          label: Text(
                            'Add Cup',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: waterCups > 0 ? () => provider.removeWaterCup() : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          foregroundColor: AppColors.textDark,
                          disabledBackgroundColor: Colors.grey.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Icon(Icons.remove),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.2),
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
                              color: const Color(0xFF3B82F6).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.tips_and_updates_rounded,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Hydration Tips',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._hydrationTips.map((tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3B82F6),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
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
}
