import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';
import 'package:fit_track/services/workout_firestore_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String activeTab = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Statistics'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 4, 16, 6),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  _buildTab('Weekly', cs),
                  _buildTab('Monthly', cs),
                  _buildTab('All-time', cs),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildRunningVolumeCard(cs),
                  const SizedBox(height: 16),
                  const Text(
                    'Weekly Goals',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  _buildGoalCard(
                    icon: Icons.gps_fixed,
                    iconBg: const Color(0xFFE0ECFF),
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Distance',
                    subtitle: '45.6 / 50 km',
                    percentLabel: '91%',
                    progress: 0.91,
                    progressColor: const Color(0xFF2563EB),
                  ),
                  _buildGoalCard(
                    icon: Icons.access_time,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    title: 'Time',
                    subtitle: '4h 15m / 5h',
                    percentLabel: '85%',
                    progress: 0.85,
                    progressColor: const Color(0xFF16A34A),
                  ),
                  _buildGoalCard(
                    icon: Icons.local_fire_department_outlined,
                    iconBg: const Color(0xFFFFEDD5),
                    iconColor: const Color(0xFFEA580C),
                    title: 'Calories',
                    subtitle: '3,240 / 4,000',
                    percentLabel: '81%',
                    progress: 0.81,
                    progressColor: const Color(0xFFEA580C),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Recent Sessions',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _FirestoreWorkoutsHistory(),
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

  Widget _buildTab(String title, ColorScheme cs) {
    bool isActive = activeTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeTab = title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFF1F5F9) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? const Color(0xFF111827) : const Color(0xFF64748B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRunningVolumeCard(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Running Volume',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Icon(Icons.trending_up_rounded, color: const Color(0xFF22C55E), size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFCFDFE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: CustomPaint(painter: ChartPainter(cs.primary)),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mon', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                Text('Tue', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                Text('Wed', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                Text('Thu', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                Text('Fri', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                Text('Sat', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                Text('Sun', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          const Divider(height: 20, color: Color(0xFFE2E8F0)),
          const Text('Total Distance', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          const SizedBox(height: 2),
          const Text('45.6 km', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String percentLabel,
    required double progress,
    required Color progressColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Text(
                percentLabel,
                style: TextStyle(color: progressColor, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: progress,
              color: progressColor,
              backgroundColor: progressColor.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

}

/// Неделя 10: история тренировок из Firestore (обновляется в реальном времени).
class _FirestoreWorkoutsHistory extends StatelessWidget {
  const _FirestoreWorkoutsHistory();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Войдите в аккаунт, чтобы видеть историю из облака'),
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: WorkoutFirestoreService.instance.workoutsSnapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Ошибка Firestore: ${snapshot.error}'),
          );
        }

        final docs = WorkoutFirestoreService.documentsForUser(snapshot.data, uid);

        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Тренировок пока нет'),
          );
        }

        const colors = [
          Color(0xFFCDE2E2),
          Color(0xFFE5F0F0),
          Color(0xFF7EB8B8),
        ];

        return Column(
          children: List.generate(docs.length, (i) {
            final data = docs[i].data();
            final dateStr = data['date']?.toString() ?? '';
            final title = data['title']?.toString() ?? '';
            final subtitle = '${data['distance']} км • ${data['kcal']} ккал';
            final bg = colors[i % colors.length];
            final isDark = bg == const Color(0xFF7EB8B8);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$dateStr — $title',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Show more',
                    style: TextStyle(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

// Простой рисовальщик линии графика
class ChartPainter extends CustomPainter {
  final Color color;

  ChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i < 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    var path = Path();
    path.moveTo(0, size.height * 0.85);
    path.lineTo(size.width * 0.16, size.height * 0.75);
    path.lineTo(size.width * 0.34, size.height * 0.78);
    path.lineTo(size.width * 0.50, size.height * 0.62);
    path.lineTo(size.width * 0.68, size.height * 0.55);
    path.lineTo(size.width * 0.82, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.34);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}