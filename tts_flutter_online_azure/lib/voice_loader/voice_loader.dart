import 'dart:convert';

import 'package:dio/dio.dart';

import '../database/settings_database_helper.dart';
import '../database/voice_database_helper.dart';
import '../models/settings.dart';
import '../models/voice.dart';
import '../static/key_property.dart';

class VoiceLoader {
  final VoiceSQLiteHelper _voiceSQLiteHelper = VoiceSQLiteHelper();
  final SettingsSQLiteHelper _settingsSQLiteHelper = SettingsSQLiteHelper();

  Future<List<Voice>> loadVoices() async {
    final savedVoices = await _voiceSQLiteHelper.getVoices();

    if (savedVoices.isNotEmpty) {
      return savedVoices;
    }

    final String urlSuffixList = 'voices/list';
    final String url = 'https://${KeyProperty.azure_region}.${KeyProperty.azure_base_url}$urlSuffixList';

    final response = await Dio().get(
      url,
      options: Options(headers: {'Ocp-Apim-Subscription-Key': KeyProperty.azure_api_key_a}),
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonDynamic = response.data;
      for (var voice in jsonDynamic) {
        await _voiceSQLiteHelper.insertVoice(voice);
      }

      return _voiceSQLiteHelper.getVoices();
    } else {
      print('Error loading voices: ${response.statusCode}');
      return [];
    }
  }

  Future<VoiceSetup?> loadSettings() async {
    final savedSettings = await _settingsSQLiteHelper.getSettings();
    if (savedSettings != null) {
      return savedSettings;
    }

    final voices = await loadVoices();

    if (voices.isNotEmpty) {
      final newSettings = VoiceSetup(voice: voices.first);
      await _settingsSQLiteHelper.insertSettings(newSettings);
      return newSettings;
    } else {
      return null;
    }
  }
}