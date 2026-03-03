import 'package:flutter/material.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String activeTab = 'Неделя'; // Текущая выбранная вкладка

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFCDE2E2),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bar_chart, color: Color(0xFF8D8985)),
            const SizedBox(width: 8),
            const Text('Статистика', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Вкладки: Неделя, Месяц, Год
            Container(
              color: const Color(0xFFCDE2E2),
              child: Row(
                children: [
                  _buildTab('Неделя'),
                  _buildTab('Месяц'),
                  _buildTab('Год'),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Область с графиком (заглушка под дизайн)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 150,
                          child: CustomPaint(painter: ChartPainter()), // Рисуем линию графика
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildQualityCard(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Индикаторы (KCAL, KM, AVG SPEED)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCircle('367', 'KCAL'),
                      _buildStatCircle('5.1', 'KM'),
                      _buildStatCircle('9', 'AVG SPEED'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Список тренировок
                  _buildHistoryItem('12 февраля 7:30 AM', const Color(0xFFCDE2E2)),
                  _buildHistoryItem('14 февраля 11:15 AM', const Color(0xFFE5F0F0)),
                  _buildHistoryItem('16 февраля 8:23 PM', const Color(0xFF7EB8B8), textColor: Colors.white),
                ],
              ),
            ),
            // Нижняя панель навигации — общая для всего приложения
            const AppBottomNav(activePage: AppPage.overview),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title) {
    bool isActive = activeTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeTab = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF7EB8B8) : Colors.transparent,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF8D8985),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCircle(String value, String label) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 5),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF7EB8B8), width: 4),
          ),
          child: Center(
            child: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String date, Color bgColor, {Color textColor = Colors.black}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
          Text('Show more', style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildQualityCard() {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFF7EB8B8), borderRadius: BorderRadius.circular(15)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Качество сна:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          SizedBox(height: 20),
          Align(alignment: Alignment.bottomRight, child: Icon(Icons.arrow_forward, color: Colors.white, size: 16)),
        ],
      ),
    );
  }

}

// Простой рисовальщик линии графика
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.black..style = PaintingStyle.stroke..strokeWidth = 2;
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.2, size.height * 0.7);
    path.lineTo(size.width * 0.4, size.height * 0.9);
    path.lineTo(size.width * 0.7, size.height * 0.4);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}