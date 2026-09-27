import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setUsername(String username) async {
    await _prefs.setString('username', username);
  }

  static String getUsername() {
    return _prefs.getString('username') ?? '';
  }

  static Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool('isDarkMode', isDark);
  }

  static bool isDarkMode() {
    return _prefs.getBool('isDarkMode') ?? false;
  }
}