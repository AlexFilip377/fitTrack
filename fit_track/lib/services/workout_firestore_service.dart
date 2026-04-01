import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Запись и чтение тренировок в Firestore (коллекция `workouts`).
class WorkoutFirestoreService {
  WorkoutFirestoreService._();
  static final WorkoutFirestoreService instance = WorkoutFirestoreService._();

  CollectionReference<Map<String, dynamic>> get _workouts =>
      FirebaseFirestore.instance.collection('workouts');

  /// Все документы коллекции (как в задании). Фильтр по [userId] — на клиенте,
  /// чтобы не требовать составной индекс Firestore.
  Stream<QuerySnapshot<Map<String, dynamic>>> workoutsSnapshots() =>
      _workouts.snapshots();

  /// Одноразовое чтение коллекции (неделя 9: `FirebaseFirestore.instance.collection(...).get()`).
  Future<QuerySnapshot<Map<String, dynamic>>> fetchWorkoutsOnce() =>
      _workouts.get();

  /// Документы коллекции [snap], относящиеся к пользователю [uid], по убыванию [createdAt].
  static List<QueryDocumentSnapshot<Map<String, dynamic>>> documentsForUser(
    QuerySnapshot<Map<String, dynamic>>? snap,
    String uid,
  ) {
    if (snap == null) return [];
    final list = snap.docs.where((d) => d.data()['userId'] == uid).toList();
    list.sort((a, b) {
      final ca = a.data()['createdAt'];
      final cb = b.data()['createdAt'];
      if (ca is Timestamp && cb is Timestamp) {
        return cb.compareTo(ca);
      }
      return 0;
    });
    return list;
  }

  /// Одна завершённая тренировка с реальными показателями сессии.
  Future<void> saveWorkoutSession({
    required Duration duration,
    required double distanceKm,
    required int kcal,
    double? averageSpeedKmh,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError('Войдите в аккаунт, чтобы сохранять тренировки.');
    }

    final now = DateTime.now();
    final dateStr = '${now.day} ${_monthRussian(now.month)}';

    await _workouts.add({
      'title': 'Тренировка',
      'distance': double.parse(distanceKm.toStringAsFixed(2)),
      'kcal': kcal,
      'date': dateStr,
      'type': 'session',
      'durationSeconds': duration.inSeconds,
      if (averageSpeedKmh != null && averageSpeedKmh > 0)
        'speedKmh': double.parse(averageSpeedKmh.toStringAsFixed(1)),
      'userId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Три демо-записи — по заданию недели 9. Вызывай после входа (нужен [userId]).
  Future<void> addSampleWorkouts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw StateError('Войдите в аккаунт, чтобы сохранять тренировки.');
    }

    final batch = FirebaseFirestore.instance.batch();
    final col = _workouts;

    void addDoc(Map<String, dynamic> data) {
      final ref = col.doc();
      batch.set(ref, {
        ...data,
        'userId': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    addDoc({
      'title': 'Утренний забег',
      'distance': 5.1,
      'kcal': 367,
      'date': '12 февраля',
      'type': 'Light',
    });

    addDoc({
      'title': 'Вечерняя прогулка',
      'distance': 2.3,
      'kcal': 150,
      'date': '14 февраля',
      'type': 'Medium',
    });

    addDoc({
      'title': 'Интенсивный кросс',
      'distance': 10.0,
      'kcal': 720,
      'date': '16 февраля',
      'type': 'Expert',
    });

    await batch.commit();
  }
}

String _monthRussian(int month) {
  const names = [
    '',
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];
  if (month < 1 || month > 12) return '';
  return names[month];
}
