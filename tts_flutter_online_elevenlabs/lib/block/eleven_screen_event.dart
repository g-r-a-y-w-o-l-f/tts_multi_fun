import 'package:equatable/equatable.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';
import 'package:tts_flutter_online_elevenlabs/models/quality_collect.dart';

abstract class ElevenScreenEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SynthesizeSpeechEvent extends ElevenScreenEvent {
  final ElevenVoice voice;
  final QualityContain voiceQuality;
  final String modelQuality;
  final String textForSpeech;

  SynthesizeSpeechEvent({
    required this.voice,
    required this.voiceQuality,
    required this.modelQuality,
    required this.textForSpeech,
  });

  @override
  List<Object> get props => [voice, voiceQuality, modelQuality, textForSpeech];
}

class NewEnterSpeechTextEvent extends ElevenScreenEvent {
  NewEnterSpeechTextEvent();
}
