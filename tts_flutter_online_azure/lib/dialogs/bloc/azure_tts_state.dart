import '../../models/settings.dart';

class AzureTtsState {
  final VoiceSetup settings;

  AzureTtsState({required this.settings});

  AzureTtsState copyWith({VoiceSetup? settings}) {
    return AzureTtsState(settings: settings ?? this.settings);
  }
}