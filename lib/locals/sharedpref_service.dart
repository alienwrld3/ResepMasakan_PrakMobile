import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  // Simpan akun saat register
  static Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  // Validasi login
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    if (username == savedUsername && password == savedPassword) {
      await prefs.setBool('isLogin', true);
      return true;
    }

    return false;
  }

  // Cek apakah user masih login
  static Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogin') ?? false;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
  }
}