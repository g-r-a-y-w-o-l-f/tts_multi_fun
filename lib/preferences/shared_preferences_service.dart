
import 'package:tts_multi_fun/preferences/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService implements PreferencesService {
  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }
}