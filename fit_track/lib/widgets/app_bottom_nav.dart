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
    final cs = Theme.of(context).colorScheme;

    return Container(
      height: 84,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            activeColor: cs.primary,
            isActive: activePage == AppPage.home,
            onTap: () => _handleTap(context, AppPage.home),
          ),
          _NavItem(
            icon: Icons.check_box_outlined,
            label: 'Workouts',
            activeColor: cs.primary,
            isActive: activePage == AppPage.workouts,
            onTap: () => _handleTap(context, AppPage.workouts),
          ),
          _NavItem(
            icon: Icons.radio_button_checked,
            label: 'Start',
            activeColor: cs.primary,
            isActive: activePage == AppPage.start,
            onTap: () => _handleTap(context, AppPage.start),
          ),
          _NavItem(
            icon: Icons.stacked_line_chart,
            label: 'Overview',
            activeColor: cs.primary,
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
  final Color activeColor;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 46,
              height: 34,
              decoration: BoxDecoration(
                color: isActive ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

