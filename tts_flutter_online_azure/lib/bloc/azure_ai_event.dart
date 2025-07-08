import 'package:equatable/equatable.dart';
import '../models/settings.dart';

abstract class AzureAIEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SynthesizeSpeechEvent extends AzureAIEvent {
  final String text;
  final VoiceSetup settings;

  SynthesizeSpeechEvent({required this.text, required this.settings});

  @override
  List<Object> get props => [text, settings];
}

class NewEnterSpeechTextEvent extends AzureAIEvent {
  NewEnterSpeechTextEvent();
}