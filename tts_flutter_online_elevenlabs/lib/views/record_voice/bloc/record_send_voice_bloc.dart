import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:tts_flutter_online_elevenlabs/static/key_property.dart';
import 'package:tts_flutter_online_elevenlabs/views/record_voice/bloc/record_send_voice_event.dart';
import 'package:tts_flutter_online_elevenlabs/views/record_voice/bloc/record_send_voice_state.dart';

class RecordSendVoiceBloc extends Bloc<RecordSendVoiceEvent, RecordSendVoiceState> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  String? _filePath;
  String? _mp3FilePath;
  bool isPlaying = false;
  bool _isConverting = false;

  RecordSendVoiceBloc() : super(VoiceInitial()) {

    Future<String> _getPublicDirectory() async {
      Directory? externalDir = Directory('/storage/emulated/0/Music/multipack/voices/');
      if (!await externalDir.exists()) {
        await externalDir.create(recursive: true);
      }
      return externalDir.path;
    }

    Future<void> _convertToMp3(Emitter<RecordSendVoiceState> emit) async {
      if (_filePath == null || _isConverting) return;

      _isConverting = true;
      emit(ConvertingInProgress());

      try {
        final publicDir = await                      _getPublicDirectory();
        _mp3FilePath = '${publicDir}voice_sample.mp3';

        final session = await FFmpegKit.execute('-y -i $_filePath -codec:a libmp3lame $_mp3FilePath');
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          emit(RecordingCompleted(_mp3FilePath!));
        } else {
          final output = await session.getOutput();
          final logs = await session.getLogsAsString();
          print('Failure by FFmpeg: $returnCode');
          print('Input data: $output');
          print('Logs: $logs');
          emit(ConvertingFailure(failureMessage: 'Conversion error: $logs'));
        }
      } catch (e) {
        print('Conversion error: $e');
        emit(ConvertingFailure(failureMessage: 'Conversion error: $e'));
      }
    }

    on<ViewVoiceInitial>((event, emit) async {
      emit(VoiceInitial());
    });

    on<StartRecording>((event, emit) async {
      if (_recorder.isRecording) {
        await _recorder.stopRecorder();
        await _recorder.closeRecorder();
      }

      final publicDir = await _getPublicDirectory();
      _filePath = '${publicDir}voice_sample.aac';
      _mp3FilePath = '${publicDir}voice_sample.mp3';

      try {
        await _recorder.openRecorder();
        await _recorder.startRecorder(toFile: _filePath);
        emit(RecordingInProgress());
      } catch (e) {
        print('Recording error: $e');
        emit(RecordingFailure(failureMessage: 'Recording error: $e'));
      }
    });

    on<StopRecording>((event, emit) async {
      await _recorder.stopRecorder();
      await _recorder.closeRecorder();

      if (_filePath != null) {
        await _convertToMp3(emit); // Pass the emit function to _convertToMp3
      } else {
        emit(VoiceInitial());
      }
    });

    on<PlayRecording>((event, emit) async {
      if (_mp3FilePath == null) return;
      await _player.openPlayer();
      await _player.startPlayer(fromURI: _mp3FilePath, whenFinished: () {
        isPlaying = false;
        emit(PlaybackStopped(_mp3FilePath!));
      });
      isPlaying = true;
      emit(PlayingRecording(_mp3FilePath!));
    });

    on<StopPlayback>((event, emit) async {
      await _player.stopPlayer();
      await _player.closePlayer();
      isPlaying = false;
      emit(PlaybackStopped(_mp3FilePath!));
    });

    on<SendRecording>((event, emit) async {
      if (_mp3FilePath == null) return;
      emit(SendingInProgress());

      final dio = Dio();

      try {
        final formData = FormData.fromMap({
          "name": "Customer Voice",
          "remove_background_noise": "false",
          "description": "Description for Customer Voice",
          "labels": '''{"accent":"American", "description":"friendly", "age":"middle", "gender":"male", "use_case":"social media"}''',
          "files": await MultipartFile.fromFile(_mp3FilePath!, filename: "voice.mp3"),
        });

        final response = await dio.post(
          "https://api.elevenlabs.io/v1/voices/add",
          data: formData,
          options: Options(
            headers: {
              "xi-api-key": ElevenProperty.eleven_api_key,
              "Content-Type": "multipart/form-data",
            },
          ),
        );

        if (response.statusCode == 200) {
          print("Response: Success -> ${response.data}");
          emit(SendingSuccess());
        } else {
          try {
            final Map<String, dynamic> responseData = jsonDecode(response.data);
            if (responseData.containsKey('status') && responseData['status'] == 'can_not_use_instant_voice_cloning') {
              emit(SendingFailure(failureMessage: responseData['message']));
            } else {
              emit(SendingFailure(failureMessage: '$responseData'));
            }
          } catch (e) {
            emit(SendingFailure(failureMessage: 'Error validate response data!'));
          }
        }
      } catch (e) {
        DioException err = e as DioException;
        var data = err.response!.data;
        final Map<String, dynamic> responseData = jsonDecode(jsonEncode(data));
        if(responseData.containsKey('detail')){
          var detail = responseData['detail'];
          if (detail.containsKey('message')) {
            emit(SendingFailure(failureMessage: detail['message']));
          } else {
            emit(SendingFailure(failureMessage: '$responseData'));
          }
        } else {
          emit(SendingFailure(
              failureMessage:
                  'Failure sending to server for analyses voice customer: ${err.message}'));
        }
      }
    });

    on<ResetRecording>((event, emit) async {
      if (_filePath != null) {
        final fileAAC = File(_filePath!);
        if (await fileAAC.exists()) {
          await fileAAC.delete();
        }
      }
      if (_mp3FilePath != null) {
        final fileMP3 = File(_mp3FilePath!);
        if (await fileMP3.exists()) {
          await fileMP3.delete();
        }
      }
      _isConverting = false;
      _filePath = null;
      _mp3FilePath = null;
      emit(VoiceInitial());
    });
  }
}

