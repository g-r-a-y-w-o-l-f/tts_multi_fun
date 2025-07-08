import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../models/settings.dart';

abstract class AzureAIState {
  final VoiceSetup? settings; // Додаємо поле settings

  const AzureAIState({this.settings});
}

class AzureAIInitial extends AzureAIState {
  const AzureAIInitial({VoiceSetup? settings}) : super(settings: settings);
}

class AzureAILoading extends AzureAIState {
  const AzureAILoading({VoiceSetup? settings}) : super(settings: settings);
}

class AzureAIAutoPlay extends AzureAIState {
  final Uint8List dataBytes;

  const AzureAIAutoPlay({required this.dataBytes, VoiceSetup? settings}) : super(settings: settings);
}

class AzureAIError extends AzureAIState {
  final String error;

  const AzureAIError({required this.error, VoiceSetup? settings}) : super(settings: settings);
}
