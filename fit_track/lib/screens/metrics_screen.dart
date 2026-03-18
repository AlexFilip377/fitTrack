import 'package:flutter/material.dart';
import 'stats_screen.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';

class MetricsScreen extends StatelessWidget {
  const MetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. КАРТА (ВЕРХНЯЯ ЧАСТЬ)
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    // Здесь будет твоя Google Map или картинка-заглушка карты
                    image: NetworkImage("https://i.stack.imgur.com/HILX3.png"), 
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Тот самый маркер геолокации (пин) поверх карты
                    const Center(
                      child: Icon(Icons.location_on, size: 40, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),

            // 2. БЛОК МЕТРИК
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Список метрик с прогресс-барами
                    _buildMetricRow('00:12:13:03', Icons.access_time, 0.45),
                    _buildMetricRow('0.37 km', Icons.directions_run, 0.65),
                    _buildMetricRow('10 km/h', Icons.directions_walk, 0.55),
                    
                    const SizedBox(height: 20),

                    // КНОПКИ УПРАВЛЕНИЯ ТРЕНИРОВКОЙ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Пауза
                        _buildControlBtn(Icons.pause, isOutlined: true),
                        
                        // Старт/Продолжить
                        _buildControlBtn(Icons.play_arrow, size: 85, color: const Color(0xFF7EB8B8).withValues(alpha: 0.7)),
                        
                        // СТОП (КВАДРАТ) - Ведет на статистику
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StatsScreen()),
                            );
                          },
                          child: _buildControlBtn(Icons.stop, isSquare: true, color: const Color(0xFF7EB8B8)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),

            // 3. НИЖНЕЕ МЕНЮ (NAV BAR) — общее для всего приложения
            const AppBottomNav(activePage: AppPage.start),
          ],
        ),
      ),
    );
  }

  // Виджет для строки метрики
  Widget _buildMetricRow(String value, IconData icon, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            fontFamily: 'Alumni Sans', // Убедись, что шрифт добавлен в pubspec.yaml
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFC1DDDD),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 4,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7EB8B8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      left: (constraints.maxWidth * progress) - 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF7EB8B8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // Универсальный виджет кнопок (круглая или квадратная)
  Widget _buildControlBtn(IconData icon, {double size = 65, Color? color, bool isOutlined = false, bool isSquare = false}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : (color ?? const Color(0xFF7EB8B8)),
        shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isSquare ? BorderRadius.circular(12) : null,
        border: isOutlined ? Border.all(color: const Color(0xFF7EB8B8), width: 4) : null,
      ),
      child: Icon(
        icon, 
        size: size * 0.55, 
        color: isOutlined ? const Color(0xFF7EB8B8) : Colors.white
      ),
    );
  }

}