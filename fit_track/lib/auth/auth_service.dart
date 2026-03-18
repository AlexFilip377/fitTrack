import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _kIsLoggedIn = 'auth.isLoggedIn';
  static const _kEmail = 'auth.email';
  static const _kPassword = 'auth.password';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsLoggedIn) ?? false;
  }

  Future<bool> hasRegisteredUser() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_kEmail) ?? '').isNotEmpty &&
        (prefs.getString(_kPassword) ?? '').isNotEmpty;
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmail, email.trim());
    await prefs.setString(_kPassword, password);
    await prefs.setBool(_kIsLoggedIn, true);
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_kEmail) ?? '';
    final storedPassword = prefs.getString(_kPassword) ?? '';
    final ok = storedEmail == email.trim() && storedPassword == password;
    if (ok) {
      await prefs.setBool(_kIsLoggedIn, true);
    }
    return ok;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsLoggedIn, false);
  }
}

