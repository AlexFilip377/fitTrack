import 'package:flutter/material.dart';
import 'package:fit_track/screens/root_screen.dart';
import 'package:fit_track/widgets/app_bottom_nav.dart';
import 'package:fit_track/services/auth_service.dart';

class FitnessHomeScreen extends StatelessWidget {
  const FitnessHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu, color: Color(0xFF7EB8B8), size: 30),
                      );
                    },
                  ),
                  Row(
                    children: const [
                      Text('Help', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 15),
                      Text('Community', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 15),
                      Text('Website', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '12 февраля ⌵',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFA1EBEB), width: 15),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '6000',
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        '/10000',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'шагов',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RootScreen()),
                );
              },
              child: Container(
                width: 250,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF7EB8B8),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: const Center(
                  child: Text(
                    'Начать тренировку',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSmallStat('KCAL', '140', const Color(0xFF7EB8B8)),
                  _buildSmallStat('KM', '3.2', const Color(0xFF7EB8B8)),
                ],
              ),
            ),
            const AppBottomNav(activePage: AppPage.home),
          ],
        ),
      ),
    );
  }

  static Widget _buildSmallStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.3), width: 8),
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

