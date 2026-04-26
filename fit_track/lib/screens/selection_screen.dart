import 'package:flutter/material.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  String _selectedDifficulty = 'Easy';

  final List<_RouteItem> _routes = const [
    _RouteItem(
      title: 'Центральный маршрут',
      subtitle: '6.8 км · Легкий',
      icon: Icons.location_city_outlined,
      difficulty: 'Easy',
    ),
    _RouteItem(
      title: 'Парк и набережная',
      subtitle: '4.1 км · Средний',
      icon: Icons.landscape_outlined,
      difficulty: 'Medium',
    ),
    _RouteItem(
      title: 'Подъем на холмы',
      subtitle: '9.5 км · Сложный',
      icon: Icons.terrain_outlined,
      difficulty: 'Expert',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filteredRoutes = _routes.where((route) => route.difficulty == _selectedDifficulty).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск маршрута...',
                  prefixIcon: Icon(Icons.search, color: cs.primary),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Категории', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryItem(Icons.auto_awesome, 'Easy', cs),
                  _buildCategoryItem(Icons.rocket_launch, 'Medium', cs),
                  _buildCategoryItem(Icons.emoji_events, 'Expert', cs),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: filteredRoutes
                    .map((route) => _routeTile(route.title, route.subtitle, route.icon, cs))
                    .toList(),
              ),
            ),
            const AppBottomNav(activePage: AppPage.workouts),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, ColorScheme cs) {
    final isSelected = _selectedDifficulty == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedDifficulty = label),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? cs.primary : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? cs.primary : const Color(0xFF64748B),
              size: 36,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isSelected ? const Color(0xFF111827) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeTile(String title, String subtitle, IconData icon, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}

class _RouteItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String difficulty;

  const _RouteItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.difficulty,
  });
}