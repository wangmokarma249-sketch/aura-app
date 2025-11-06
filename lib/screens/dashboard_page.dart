import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/health_card.dart';
import '../providers/health_provider.dart';
import 'details/steps_detail_page.dart';
import 'details/water_detail_page.dart';
import 'details/cycle_detail_page.dart';
import 'details/gut_detail_page.dart';
import 'stats_page.dart';
import 'profile_page.dart';
import 'chat_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const StatsPage(),
      const ProfilePage(),
      const ChatPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.lavender,
          unselectedItemColor: AppColors.textLight,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'Chats',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Aura',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          final metrics = provider.metrics;
          final stepsProgress = (metrics.steps / metrics.stepsGoal).clamp(0.0, 1.0);
          final waterProgress = (metrics.waterCups / metrics.waterGoal).clamp(0.0, 1.0);
          final cycleProgress = (metrics.cycleDay / 28).clamp(0.0, 1.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 24),
                Hero(
                  tag: 'steps',
                  child: Material(
                    color: Colors.transparent,
                    child: HealthCard(
                      title: 'Steps',
                      value: metrics.steps.toString(),
                      goal: metrics.stepsGoal.toString(),
                      icon: Icons.directions_walk_rounded,
                      color: AppColors.lavender,
                      progress: stepsProgress,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StepsDetailPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Hero(
                  tag: 'water',
                  child: Material(
                    color: Colors.transparent,
                    child: HealthCard(
                      title: 'Water',
                      value: metrics.waterCups.toString(),
                      goal: '${metrics.waterGoal} glasses',
                      icon: Icons.water_drop_rounded,
                      color: const Color(0xFF3B82F6),
                      progress: waterProgress,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WaterDetailPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Hero(
                  tag: 'cycle',
                  child: Material(
                    color: Colors.transparent,
                    child: HealthCard(
                      title: 'Cycle',
                      value: 'Day ${metrics.cycleDay}',
                      goal: '28-day cycle',
                      icon: Icons.calendar_today_rounded,
                      color: const Color(0xFFEC4899),
                      progress: cycleProgress,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CycleDetailPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Hero(
                  tag: 'gut',
                  child: Material(
                    color: Colors.transparent,
                    child: HealthCard(
                      title: 'Gut Health',
                      value: metrics.gutHealthStatus,
                      goal: 'Track daily',
                      icon: Icons.restaurant_rounded,
                      color: const Color(0xFF10B981),
                      progress: metrics.gutHealthStatus == 'Good'
                          ? 0.8
                          : metrics.gutHealthStatus == 'Okay'
                              ? 0.5
                              : 0.3,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GutDetailPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Insights',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.lavenderLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.lavender.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.lavender.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.lightbulb_rounded,
                          color: AppColors.lavender,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'You sleep better on days you hit your step goals.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.textDark,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
