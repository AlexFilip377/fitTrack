import 'package:flutter/material.dart';
import 'package:fit_track/screens/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fit_track/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FitTrackApp());
}

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7EB8B8)),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      home: const FirebaseInitGate(),
    );
  }
}

class FirebaseInitGate extends StatefulWidget {
  const FirebaseInitGate({super.key});

  @override
  State<FirebaseInitGate> createState() => _FirebaseInitGateState();
}

class _FirebaseInitGateState extends State<FirebaseInitGate> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initFirebase();
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture.timeout(const Duration(seconds: 15)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Важно: НЕ показываем LoginScreen до инициализации Firebase,
          // потому что там создаётся FirebaseAuth.instance.
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Ошибка инициализации Firebase.\n${snapshot.error}\n\nПопробуйте перезапустить приложение.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          );
        }

        return const AuthGate();
      },
    );
  }
}