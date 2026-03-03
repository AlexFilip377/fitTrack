import 'package:flutter/material.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Поиск
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF7EB8B8), width: 2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'поиск маршрута...',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 18,
                      fontFamily: 'Alumni Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Категории сложности
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryItem(Icons.auto_awesome, 'Light'),
                _buildCategoryItem(Icons.rocket_launch, 'Medium'),
                _buildCategoryItem(Icons.emoji_events, 'Expert'),
              ],
            ),
            const Spacer(),
            // Общая навигационная панель
            const AppBottomNav(activePage: AppPage.workouts),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF7EB8B8), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF7EB8B8), size: 35),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Alumni Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}