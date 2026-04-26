import 'package:flutter/material.dart';
import 'package:fit_track/screens/root_screen.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';
import 'package:fit_track/services/auth_service.dart';

class FitnessHomeScreen extends StatelessWidget {
  const FitnessHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Меню',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Выйти'),
                onTap: () async {
                  Navigator.of(context).pop(); // закрыть drawer
                  await AuthService.instance.signOut();
                  if (!context.mounted) return;
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: Icon(Icons.sort_rounded, color: cs.primary, size: 32),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7EDF8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _topPill('Help'),
                        const SizedBox(width: 8),
                        _topPill('Community'),
                        const SizedBox(width: 8),
                        _topPill('Website'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EEF7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('12 февраля', style: TextStyle(fontWeight: FontWeight.w700)),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE3EF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildMainStepRing(cs),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: _buildMiniArcMetric(cs, 'KCAL', '140')),
                                  Expanded(child: _buildMiniArcMetric(cs, 'KM', '3.2')),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RootScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Начать тренировку', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: cs.primary, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        'Morning Park Loop',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 108,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE3EF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: CustomPaint(
                      painter: _SimpleWavePainter(cs.primary),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildBottomMetricTile('Distance', '5.2 km')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildBottomMetricTile('Pace', '5:15 /km')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildBottomMetricTile('Time', '27:18')),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const AppBottomNav(activePage: AppPage.home),
          ],
        ),
      ),
    );
  }

  static Widget _topPill(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    );
  }

  static Widget _buildMainStepRing(ColorScheme cs) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(shape: BoxShape.circle, color: cs.primary.withValues(alpha: 0.2)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('6000', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, height: 1)),
                Text('/10000', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, height: 1)),
                Text('шагов', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, height: 1.2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMiniArcMetric(ColorScheme cs, String label, String value) {
    return SizedBox(
      height: 102,
      child: Column(
        children: [
          SizedBox(
            height: 16,
            child: Center(
              child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
            ),
          ),
          SizedBox(
            width: 84,
            height: 78,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  width: 58,
                  height: 36,
                  child: CustomPaint(
                    painter: _ArcPainter(cs.primary),
                  ),
                ),
                Positioned(
                  top: 20,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      height: 0.6,
                      fontFamily: 'monospace',
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBottomMetricTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;
  _ArcPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.width),
      2.6,
      2.1,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SimpleWavePainter extends CustomPainter {
  final Color color;
  _SimpleWavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(size.width * 0.1, size.height * 0.84);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.22,
      size.width * 0.48,
      size.height * 0.85,
      size.width * 0.9,
      size.height * 0.28,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

