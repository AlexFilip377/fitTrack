import 'package:flutter/material.dart';
import 'package:fit_track/services/auth_service.dart';
import 'package:fit_track/screens/auth/register_screen.dart';
import 'package:fit_track/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _auth = AuthService.instance;

  bool _obscure = true;
  bool _loading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorText = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    try {
      await _auth.signInWithEmail(
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
      );
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const FitnessHomeScreen()),
        (route) => false,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Вход',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 4),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    color: const Color(0xFFF6FAFA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: cs.primary.withValues(alpha: 0.25)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Почта',
                                prefixIcon: Icon(Icons.email_outlined),
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return 'Введите почту';
                                if (!value.contains('@')) return 'Некорректная почта';
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordCtrl,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _loading ? null : _submit(),
                              decoration: InputDecoration(
                                labelText: 'Пароль',
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                ),
                              ),
                              validator: (v) {
                                final value = v ?? '';
                                if (value.isEmpty) return 'Введите пароль';
                                if (value.length < 6) return 'Минимум 6 символов';
                                return null;
                              },
                            ),
                            if (_errorText != null) ...[
                              const SizedBox(height: 12),
                              Text(_errorText!, style: const TextStyle(color: Colors.red)),
                            ],
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _loading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF7EB8B8),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Text('Войти', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _loading
                          ? null
                          : () async {
                              setState(() {
                                _errorText = null;
                                _loading = true;
                              });
                              try {
                                final user = await _auth.signInWithGoogle();
                                if (!mounted) return;
                                if (user == null) {
                                  setState(() => _errorText = 'Вход через Google отменён');
                                  return;
                                }
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const FitnessHomeScreen()),
                                  (route) => false,
                                );
                              } catch (e) {
                                if (!mounted) return;
                                setState(() => _errorText = 'Ошибка входа через Google: $e');
                              } finally {
                                if (mounted) {
                                  setState(() => _loading = false);
                                }
                              }
                            },
                      icon: Image.asset(
                        'assets/google_logo.png',
                        height: 20,
                        width: 20,
                      ),
                      label: const Text('Войти через Google'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Нет аккаунта?', style: TextStyle(color: Colors.grey.shade800)),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: const Text('Регистрация'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

