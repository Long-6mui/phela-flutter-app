import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const String _loggedInKey = 'is_logged_in';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> saveLoginStatus({required bool isLoggedIn}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, isLoggedIn);
  }
}
