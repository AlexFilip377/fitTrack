import 'package:flutter/material.dart';
import 'package:fit_track/screens/checkout_screen.dart';
import 'package:fit_track/screens/root_screen.dart';
import 'package:fit_track/screens/stats_screen.dart';

enum AppPage { home, workouts, start, overview }

class AppBottomNav extends StatelessWidget {
  final AppPage activePage;

  const AppBottomNav({super.key, required this.activePage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            isActive: activePage == AppPage.home,
            onTap: () => _handleTap(context, AppPage.home),
          ),
          _NavItem(
            icon: Icons.check_box_outlined,
            label: 'Workouts',
            isActive: activePage == AppPage.workouts,
            onTap: () => _handleTap(context, AppPage.workouts),
          ),
          _NavItem(
            icon: Icons.radio_button_checked,
            label: 'Start',
            isActive: activePage == AppPage.start,
            onTap: () => _handleTap(context, AppPage.start),
          ),
          _NavItem(
            icon: Icons.stacked_line_chart,
            label: 'Overview',
            isActive: activePage == AppPage.overview,
            onTap: () => _handleTap(context, AppPage.overview),
          ),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, AppPage tappedPage) {
    if (tappedPage == activePage) return;

    if (tappedPage == AppPage.home) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (tappedPage == AppPage.workouts) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CheckoutScreen()),
      );
    } else if (tappedPage == AppPage.start) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RootScreen()),
      );
    } else if (tappedPage == AppPage.overview) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatsScreen()),
      );
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF7EB8B8) : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

