import 'package:json_annotation/json_annotation.dart';

import 'voice.dart';
part 'settings.g.dart';

@JsonSerializable()
class VoiceSetup {
  Voice voice;

  VoiceSetup({required this.voice});

  factory VoiceSetup.fromJson(Map<String, dynamic> json) => _$VoiceSetupFromJson(json);
  Map<String, dynamic> toJson() => _$VoiceSetupToJson(this);
}