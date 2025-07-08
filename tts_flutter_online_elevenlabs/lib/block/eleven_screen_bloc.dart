import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';
import '../static/key_property.dart';
import 'eleven_screen_event.dart';
import 'eleven_screen_state.dart';

class ElevenScreenBloc extends Bloc<ElevenScreenEvent, ElevenScreenState> {
  final Dio _dio = Dio();

  ElevenScreenBloc({required ElevenVoice initSetup}) : super(ElevenScreenInitial(setup: initSetup)) {
    on<SynthesizeSpeechEvent>((event, emit) async {

      final String url = '${ElevenProperty.eleven_base_uri}${ElevenProperty.eleven_version}${ElevenProperty.eleven_suffix_speech}/${event.voice.voice_id}?output_format=${event.voiceQuality.name}'; // mp3_44100_128';

      try {
        final response = await _dio.post(
          url,
          options: Options(
            headers: {
              'xi-api-key': ElevenProperty.eleven_api_key,
              'Content-Type': 'application/json',
              'User-Agent': 'dio',
            },
            responseType: ResponseType.bytes,
          ),
          data: '''{
              "text": "${event.textForSpeech}"
            }''',
          // "model_id": "${event.modelQuality}"`
        );
        // "eleven_multilingual_v2"
        if (response.statusCode == 200) {
          emit(ElevenScreenAutoPlay(dataBytes: response.data));
        } else {
          emit(ElevenScreenError(error: 'Failure.. :: ${response.statusCode} - ${response.data}'));
        }
      } catch (e) {
        print('Failure response audio: $e');
        emit(ElevenScreenError(error: 'Failure.. :: ${e.toString()}'));
        return null;
      }
    });
    on<NewEnterSpeechTextEvent>((event, emit) async {
      emit(ElevenScreenInitial());
    });

  }
}