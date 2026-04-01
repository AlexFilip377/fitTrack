import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fit_track/services/workout_firestore_service.dart';

/// Неделя 10: список тренировок из Firestore в реальном времени (StreamBuilder).
class WorkoutsListScreen extends StatelessWidget {
  const WorkoutsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7EB8B8),
        foregroundColor: Colors.white,
        title: const Text('Мои тренировки'),
      ),
      body: uid == null
          ? const Center(child: Text('Войдите в аккаунт'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: WorkoutFirestoreService.instance.workoutsSnapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Ошибка Firestore: ${snapshot.error}\n'
                        'Проверьте правила безопасности в консоли Firebase.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final docs = WorkoutFirestoreService.documentsForUser(snapshot.data, uid);

                if (docs.isEmpty) {
                  return const Center(child: Text('Тренировок пока нет'));
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: docs.map((document) {
                    final data = document.data();
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.directions_run, color: Color(0xFF7EB8B8)),
                        title: Text(data['title']?.toString() ?? 'Без названия'),
                        subtitle: Text(
                          '${data['distance']} км • ${data['kcal']} ккал • ${data['type'] ?? ''}',
                        ),
                        trailing: Text(data['date']?.toString() ?? ''),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
