import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:tts_flutter_online_azure/models/settings.dart';
import 'package:tts_flutter_online_azure/static/key_property.dart';
import 'azure_ai_event.dart';
import 'azure_ai_state.dart';

import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:hive/hive.dart';

class AzureAIBloc extends Bloc<AzureAIEvent, AzureAIState> {
  final Dio _dio = Dio();
  final String urlSuffix  = 'v1';

  final AudioPlayer audioPlayer = AudioPlayer();
  late Box<String> cacheBox;

  AzureAIBloc({required VoiceSetup initialSettings}) : super(AzureAIInitial(settings: initialSettings)) {
    on<SynthesizeSpeechEvent>((event, emit) async {
      // emit(AzureAILoading(settings: state.settings));

      final String url = 'https://${KeyProperty.azure_region}.${KeyProperty.azure_base_url}$urlSuffix';

      final String ssml = '''
          <speak version='1.0' xml:lang='${event.settings.voice.locale ?? "en-US"  }'>
              <voice name='${event.settings.voice.shortName}'>
                  ${event.text}
              </voice>
          </speak>
      ''';

      try {
        final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'Ocp-Apim-Subscription-Key': KeyProperty.azure_api_key_a,
              'Content-Type': 'application/ssml+xml',
              'X-Microsoft-OutputFormat': event.settings.voice.bitrade ?? 'audio-24khz-48kbitrate-mono-mp3', //'${initialSettings.voice.voiceType}',
              'User-Agent': 'dio',
            },
            responseType: ResponseType.bytes,
          ),
          data: ssml,
        );

        if (response.statusCode == 200) {
          emit(AzureAIAutoPlay(dataBytes: response.data));
        } else {
          emit(AzureAIError(error: 'Failure.. :: ${response.statusCode} - ${response.data}'));
        }
      } catch (e) {
        print('Failure response audio: $e');
        return null;
      }
    });
    on<NewEnterSpeechTextEvent>((event, emit) async {
      emit(AzureAIInitial());
    });

  }

  Future<void> initCache() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    cacheBox = await Hive.openBox<String>('tts_cache');
  }

  Future<String?> _getCachePath(String text) async {
    final Directory cacheDir = await getTemporaryDirectory();
    final String filename = text.hashCode.toString();
    return '${cacheDir.path}/$filename.mp3';
  }

  Future<String?> fetchAndCacheTTS(String text) async {
    // check file in to cash
    if (cacheBox.containsKey(text)) {
      final cachedPath = cacheBox.get(text);
      if (cachedPath != null && File(cachedPath).existsSync()) {
        // used cased audio
        return cachedPath;
      }
    }
  }

  Future<void> playTTS(String text) async {
    final String? filePath = await fetchAndCacheTTS(text);
    if (filePath != null) {
      // await audioPlayer.play(DeviceFileSource(filePath));
      print('Playing audio...');
    } else {
      print('Failure: audio not issue...');
    }
  }

}