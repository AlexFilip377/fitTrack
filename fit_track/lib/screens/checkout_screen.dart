import 'package:flutter/material.dart';
import 'package:fit_track/screens/home_screen.dart';
import 'package:fit_track/screens/selection_screen.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';
import 'package:fit_track/screens/stats_screen.dart';
import 'package:fit_track/screens/root_screen.dart';
import 'package:fit_track/screens/workouts_list_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Great job!',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                    'See all',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Утренний забег',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Today, 7:30 AM',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMiniMetric('5 KM', 'Distance'),
                              _buildMiniMetric('33.11/KM', 'Pace'),
                              _buildMiniMetric('30M', 'Time'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                        image: DecorationImage(
                          image: NetworkImage("https://i.stack.imgur.com/HILX3.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    _buildActionButton(
                      'Вся статистика',
                      cs,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StatsScreen()),
                        );
                      },
                    ),
                    _buildActionButton(
                      'Мои тренировки',
                      cs,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WorkoutsListScreen()),
                        );
                      },
                    ),
                    _buildActionButton(
                      'Маршруты',
                      cs,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SelectionPage()),
                        );
                      },
                    ),
                    _buildActionButton(
                      'На главную',
                      cs,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FitnessHomeScreen()),
                        );
                      },
                    ),
                    _buildActionButton(
                      'Повторить',
                      cs,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RootScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const AppBottomNav(activePage: AppPage.workouts),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMetric(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, ColorScheme cs, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}