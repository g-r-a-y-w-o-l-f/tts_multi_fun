import '../../../models/eleven_voice.dart';

abstract class ElevenSpeechDialogEvent {}

class OpenSetupSpeechDialogEvent extends ElevenSpeechDialogEvent {}

class SaveSetupSpeechDialogEvent extends ElevenSpeechDialogEvent {
  final ElevenVoice setupParams;

  SaveSetupSpeechDialogEvent(this.setupParams);
}