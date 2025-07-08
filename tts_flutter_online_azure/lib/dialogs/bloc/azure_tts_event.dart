import '../../models/settings.dart';

abstract class AzureTtsEvent {}

class OpenSettingsDialogEvent extends AzureTtsEvent {}

class SaveSettingsEvent extends AzureTtsEvent {
  final VoiceSetup settings;

  SaveSettingsEvent(this.settings);
}