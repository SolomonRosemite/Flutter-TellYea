import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static SharedPreferences prefs;
  static Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  static String getString(String key) => prefs.getString(key);
  static Future<void> setString(String key, String value) async => await prefs.setString(key, value);
}
