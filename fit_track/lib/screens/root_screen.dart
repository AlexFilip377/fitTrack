import 'package:flutter/material.dart';
import 'package:fit_track/screens/selection_screen.dart';
import 'package:fit_track/screens/metrics_screen.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool isBaseTabActive = true;
  int selectedRouteIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. ЗАГОЛОВОК
            Container(
              width: double.infinity,
              color: const Color(0xFFC1DDDD),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'Выберите маршрут',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            // 2. ВКЛАДКИ
            Row(
              children: [
                // Вкладка "Базовые" остается как есть — она просто переключает контент внутри страницы
                _buildTab(
                  'Базовые', 
                  isActive: isBaseTabActive, 
                  onTap: () {
                    setState(() => isBaseTabActive = true);
                  },
                ),
                // Вкладка "Мои маршруты" теперь открывает новую страницу SelectionPage
                _buildTab(
                  'Мои маршруты', 
                  isActive: !isBaseTabActive, 
                  onTap: () {
                    // 1. Сначала меняем визуальное состояние (по желанию)
                    setState(() => isBaseTabActive = false);
                    
                    // 2. Переходим на страницу выбора (selection)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SelectionPage()),
                    );
                  },
                ),
              ],
            ),

            // 3. МАРШРУТЫ
            _buildRouteItem('Маршрут 1', index: 0),
            _buildRouteItem('Маршрут 2', index: 1),
            _buildRouteItem('Маршрут 3', index: 2),

            // 4. КАРТА И КНОПКА GO!
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey[200], // Заглушка вместо карты
                    child: const Center(child: Text("Карта")),
                  ),
                  
                  Positioned(
                    bottom: 25,
                    child: GestureDetector(
                      onTap: () {
                        // ПЕРЕХОД НА ЭКРАН МЕТРИК
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MetricsScreen()),
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7EB8B8),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('GO!', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 5. НИЖНЕЕ МЕНЮ — общее для всего приложения
            const AppBottomNav(activePage: AppPage.start),
          ],
        ),
      ),
    );
  }

  // Вспомогательные методы (Tabs и RouteItems) без изменений...
  Widget _buildTab(String label, {required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          color: isActive ? const Color(0xFF7EB8B8) : const Color(0xFFC1DDDD).withOpacity(0.5),
          child: Center(child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  Widget _buildRouteItem(String title, {required int index}) {
    bool isSelected = selectedRouteIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedRouteIndex = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        color: isSelected ? const Color(0xFF7EB8B8) : const Color(0xFFC1DDDD),
        child: Text(title, style: TextStyle(fontSize: 20, color: isSelected ? Colors.black : Colors.black45)),
      ),
    );
  }
}