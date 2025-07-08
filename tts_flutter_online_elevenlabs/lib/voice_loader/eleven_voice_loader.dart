import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';
import 'package:tts_flutter_online_elevenlabs/models/quality_collect.dart';
import '../database/database_eleven_setup.dart';
import '../database/database_eleven_voice.dart';
import '../static/key_property.dart';

class ElevenVoiceLoader {
  final ElevenVoiceSQLiteHelper _voiceSQLiteHelper = ElevenVoiceSQLiteHelper();
  final ElevenSetupSQLiteHelper _setupSQLiteHelper = ElevenSetupSQLiteHelper();

  Future<List<ElevenVoice>> loadVoices() async {
    final savedVoices = await _voiceSQLiteHelper.getVoices();
    if (savedVoices.isNotEmpty) {
      return savedVoices;
    }

    final String url = '${ElevenProperty.eleven_base_uri}${ElevenProperty.eleven_version}${ElevenProperty.eleven_suffix_voices}';
    //curl https://api.elevenlabs.io/v1/voices \
    //      -H "xi-api-key: sk_a5cd60455d05442493d38ac0d47731c9f57e68af7189861a"
    try {
      final response = await Dio().get(
        url,
        options: Options(
            headers: {
              'xi-api-key': ElevenProperty.eleven_api_key,
              'Content-Type': 'application/json',
              'User-Agent': 'dio',
            }),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonDynamic = response.data;
        for (var voice in jsonDynamic['voices']) {
          await _voiceSQLiteHelper.insertVoice(voice);
        }

        return _voiceSQLiteHelper.getVoices();
      } else {
        // 4. Обробка помилки завантаження голосів з мережі
        print('Error loading voices: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Failure response audio: $e');
      // emit(ElevenScreenError(error: 'Failure.. :: ${e.toString()}'));
      return [];
    }
  }

  Future<ElevenVoice?> loadElevenSetup() async {
    final savedSettings = await _setupSQLiteHelper.getSetup();
    if (savedSettings != null) {
      return savedSettings;
    }

    final voices = await loadVoices();

    if (voices.isNotEmpty) {
      final newSetup = voices[0];
      await _setupSQLiteHelper.insertSetup(newSetup);
      return newSetup;
    } else {
      return null;
    }
  }

  Future<QualityContain?> loadElevenQuality() async {
    final quality  = await _setupSQLiteHelper.getQuality();
    if (quality != null) {
      return quality;
    }

    final qualities = ElevenProperty.qualityCollect;

    if (qualities.isNotEmpty) {
      final newQuality = qualities[0];
      await _setupSQLiteHelper.insertQuality(newQuality);
      return newQuality;
    } else {
      return null;
    }
  }

  Future<String?> loadElevenModelQuality() async {
    final modelQuality  = await _setupSQLiteHelper.getModelQuality();
    if (modelQuality != null) {
      return modelQuality;
    }
    final voices = await _voiceSQLiteHelper.getVoices();
    if (voices.isNotEmpty) {
      final newModelQuality = voices[0].high_quality_base_model_ids[0];
      await _setupSQLiteHelper.insertModelQuality(newModelQuality);
      return newModelQuality;
    } else {
      return null;
    }
  }

}