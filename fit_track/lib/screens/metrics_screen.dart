import 'dart:async';

import 'package:flutter/material.dart';
import 'stats_screen.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';
import 'package:fit_track/services/workout_firestore_service.dart';

/// Экран метрик во время тренировки: таймер, моделируемые км и ккал, сохранение одной сессии в Firestore.
class MetricsScreen extends StatefulWidget {
  const MetricsScreen({super.key});

  @override
  State<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen> {
  final Stopwatch _stopwatch = Stopwatch();

  /// Условная скорость забега (км/ч), пока нет GPS — от неё считаются километры за время работы таймера.
  static const double _assumedSpeedKmh = 10.0;

  /// Примерно ккал на 1 км при такой нагрузке (упрощённая модель).
  static const double _kcalPerKm = 65.0;

  Timer? _uiTicker;
  bool _sessionEverStarted = false;

  Duration get _elapsed => _stopwatch.elapsed;

  /// Километры за всё время, пока таймер шёл (пауза не копит дистанцию).
  double get _distanceKm {
    final sec = _elapsed.inMicroseconds / 1e6;
    return _assumedSpeedKmh * (sec / 3600.0);
  }

  int get _kcal => (_distanceKm * _kcalPerKm).round();

  /// Средняя скорость за сессию (для экрана и в БД).
  double get _speedKmh {
    final sec = _elapsed.inMicroseconds / 1e6;
    if (sec < 0.5) return 0;
    return _distanceKm / (sec / 3600.0);
  }

  /// Прогресс полосок: цель 1 ч времени, 10 км, «полная» скорость 12 км/ч.
  double _timeProgress(Duration d) =>
      (d.inSeconds / 3600).clamp(0.0, 1.0);

  double _distanceProgress(double km) => (km / 10.0).clamp(0.0, 1.0);

  double _speedProgress(double kmh) => (kmh / 12.0).clamp(0.0, 1.0);

  /// Формат как в макете: ЧЧ:ММ:СС:сотые (две цифры от сотых секунды).
  String _formatTimer(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    final cs = (d.inMilliseconds.remainder(1000) ~/ 10).clamp(0, 99);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(h)}:${two(m)}:${two(s)}:${two(cs)}';
  }

  void _startUiTicker() {
    _uiTicker?.cancel();
    _uiTicker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  void _stopUiTicker() {
    _uiTicker?.cancel();
    _uiTicker = null;
  }

  @override
  void dispose() {
    _stopUiTicker();
    _stopwatch.stop();
    super.dispose();
  }

  void _onPlay() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _sessionEverStarted = true;
      _startUiTicker();
      setState(() {});
    }
  }

  void _onPause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _stopUiTicker();
      setState(() {});
    }
  }

  Future<void> _onStop(BuildContext context) async {
    _onPause();

    if (!_sessionEverStarted || _elapsed.inSeconds < 1) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала запустите тренировку и подождите хотя бы секунду')),
      );
      return;
    }

    final duration = _elapsed;
    final dist = _distanceKm;
    final kcal = _kcal;
    final speed = _speedKmh;

    try {
      await WorkoutFirestoreService.instance.saveWorkoutSession(
        duration: duration,
        distanceKm: dist,
        kcal: kcal,
        averageSpeedKmh: speed,
      );

      _stopwatch.reset();
      _sessionEverStarted = false;
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Сохранено: ${dist.toStringAsFixed(2)} км, $kcal ккал, ${duration.inMinutes} мин',
          ),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StatsScreen()),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось сохранить: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final elapsed = _elapsed;
    final dist = _distanceKm;
    final kcal = _kcal;
    final speed = _speedKmh;

    final timeStr = _formatTimer(elapsed);
    final distStr = '${dist.toStringAsFixed(2)} km';
    final speedStr = '${speed.toStringAsFixed(1)} km/h';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://i.stack.imgur.com/HILX3.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(Icons.location_on, size: 40, color: Colors.black54),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${dist.toStringAsFixed(2)} км  ·  $kcal ккал  ·  ${_stopwatch.isRunning ? 'идёт' : (_sessionEverStarted ? 'пауза' : 'стоп')}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricRow(timeStr, Icons.access_time, _timeProgress(elapsed), cs),
                    _buildMetricRow(distStr, Icons.directions_run, _distanceProgress(dist), cs),
                    _buildMetricRow(speedStr, Icons.directions_walk, _speedProgress(speed), cs),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: _onPause,
                          child: _buildControlBtn(Icons.pause, cs, isOutlined: true),
                        ),
                        GestureDetector(
                          onTap: _onPlay,
                          child: _buildControlBtn(
                            Icons.play_arrow,
                            cs,
                            size: 85,
                            color: cs.primary.withValues(alpha: 0.8),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onStop(context),
                          child: _buildControlBtn(Icons.stop, cs, isSquare: true, color: cs.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const AppBottomNav(activePage: AppPage.start),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String value, IconData icon, double progress, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w800,
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
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth * progress;
                final knobLeft = (w - 10).clamp(0.0, constraints.maxWidth);
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 4,
                      width: w,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      left: knobLeft,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cs.primary,
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
    ));
  }

  Widget _buildControlBtn(
    IconData icon,
    ColorScheme cs, {
    double size = 65,
    Color? color,
    bool isOutlined = false,
    bool isSquare = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : (color ?? cs.primary),
        shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isSquare ? BorderRadius.circular(12) : null,
        border: isOutlined ? Border.all(color: cs.primary, width: 4) : null,
      ),
      child: Icon(
        icon,
        size: size * 0.55,
        color: isOutlined ? cs.primary : Colors.white,
      ),
    );
  }
}
