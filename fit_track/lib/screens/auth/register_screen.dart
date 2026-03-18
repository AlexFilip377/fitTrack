import 'package:flutter/material.dart';
import 'package:fit_track/services/auth_service.dart';
import 'package:fit_track/screens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _password2Ctrl = TextEditingController();
  final _auth = AuthService.instance;

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _password2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    try {
      await _auth.registerWithEmail(
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text('Регистрация'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Создайте аккаунт',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
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
                          obscureText: _obscure1,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure1 = !_obscure1),
                              icon: Icon(_obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (v) {
                            final value = v ?? '';
                            if (value.isEmpty) return 'Введите пароль';
                            if (value.length < 6) return 'Минимум 6 символов';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password2Ctrl,
                          obscureText: _obscure2,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _loading ? null : _submit(),
                          decoration: InputDecoration(
                            labelText: 'Повторите пароль',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure2 = !_obscure2),
                              icon: Icon(_obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (v) {
                            final value = v ?? '';
                            if (value.isEmpty) return 'Повторите пароль';
                            if (value != _passwordCtrl.text) return 'Пароли не совпадают';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 52,
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
                                : const Text(
                                    'Зарегистрироваться',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Это временная заглушка: логин/пароль сохраняются локально.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

