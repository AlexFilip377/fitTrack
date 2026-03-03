import 'package:flutter/material.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';
import 'package:fit_track/screens/stats_screen.dart';
import 'package:fit_track/screens/root_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и кнопка See all
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Great job !',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Alumni Sans',
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                      fontFamily: 'Alumni Sans',
                    ),
                  ),
                ],
              ),
            ),

            // Карточка с информацией и картой
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF7EB8B8), width: 1),
                ),
                child: Column(
                  children: [
                    // Текстовая информация
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Утренний забег',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Alumni Sans',
                            ),
                          ),
                          Text(
                            'Today, 7:30 AM',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontFamily: 'Alumni Sans',
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              _buildMiniMetric('5 KM', 'Distance'),
                              const SizedBox(width: 30),
                              _buildMiniMetric('33.11/KM', 'Pace'),
                              const SizedBox(width: 30),
                              _buildMiniMetric('30M', 'Time'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Сама карта (изображение)
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

            const SizedBox(height: 25),

            // Список кнопок
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    _buildActionButton(
                      'Вся статистика',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const StatsScreen()),
                        );
                      },
                    ),
                    _buildActionButton('Похожие маршруты', () {}),
                    _buildActionButton('Здоровье', () {}),
                    _buildActionButton(
                      'Повторить',
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

            // Нижнее меню — общее для всего приложения
            const AppBottomNav(activePage: AppPage.workouts),
          ],
        ),
      ),
    );
  }

  // Виджет для маленьких метрик (км, темп, время)
  Widget _buildMiniMetric(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Alumni Sans'),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontFamily: 'Alumni Sans'),
        ),
      ],
    );
  }

  // Виджет широкой кнопки
  Widget _buildActionButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7EB8B8),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Alumni Sans',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

}