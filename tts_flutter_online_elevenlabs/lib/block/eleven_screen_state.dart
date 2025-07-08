import 'package:equatable/equatable.dart';
import 'dart:typed_data';

import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';

abstract class ElevenScreenState {
  final ElevenVoice? setup;
  const ElevenScreenState({this.setup});
}

class ElevenScreenInitial extends ElevenScreenState {
  const ElevenScreenInitial({ElevenVoice? setup}) : super(setup: setup);
}

class ElevenScreenLoading extends ElevenScreenState {
  const ElevenScreenLoading({ElevenVoice? setup}) : super(setup: setup);
}

class ElevenScreenSuccess extends ElevenScreenState {
  final Uint8List audioBytes;

  ElevenScreenSuccess({required this.audioBytes});

  @override
  List<Object> get props => [audioBytes];
}

class ElevenScreenAutoPlay extends ElevenScreenState {
  final Uint8List dataBytes;

  const ElevenScreenAutoPlay({required this.dataBytes, ElevenVoice? setupParams}) : super(setup: setupParams);
}

class ElevenScreenError extends ElevenScreenState {
  final String error;
  const ElevenScreenError ({required this.error, ElevenVoice? setup}): super(setup: setup);
}

// abstract class AzureAIState {
//   final VoiceSetup? settings; // Додаємо поле settings
//
//   const AzureAIState({this.settings});
// }
//
// class AzureAIInitial extends AzureAIState {
//   const AzureAIInitial({VoiceSetup? settings}) : super(settings: settings);
// }
//
// class AzureAILoading extends AzureAIState {
//   const AzureAILoading({VoiceSetup? settings}) : super(settings: settings);
// }
//
// class AzureAIAutoPlay extends AzureAIState {
//   final Uint8List dataBytes;
//
//   const AzureAIAutoPlay({required this.dataBytes, VoiceSetup? settings}) : super(settings: settings);
// }
//
// class AzureAIError extends AzureAIState {
//   final String error;
//
//   const AzureAIError({required this.error, VoiceSetup? settings}) : super(settings: settings);
// }