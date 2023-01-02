import 'package:shared_preferences/shared_preferences.dart';

class LanguagePerformers {
  static const String _key = 'language';
  static SharedPreferences? preferences;

  static init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static void saveLanguage(String lan) {
    preferences!.setString(_key, lan);
  }

  static String getLanguage() {
    String theme = preferences!.getString(_key) ?? "uz";
    return theme;
  }
}
