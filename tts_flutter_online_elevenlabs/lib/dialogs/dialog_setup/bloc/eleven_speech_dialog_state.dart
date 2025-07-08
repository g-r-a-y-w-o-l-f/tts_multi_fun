import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';

class ElevenSpeechDialogState {
  final ElevenVoice setupParams;

  ElevenSpeechDialogState({required this.setupParams});

  ElevenSpeechDialogState copyWith({ElevenVoice? setupParams}) {
    return ElevenSpeechDialogState(setupParams: setupParams ?? this.setupParams);
  }
}