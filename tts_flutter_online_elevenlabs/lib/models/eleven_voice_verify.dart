import 'package:json_annotation/json_annotation.dart';

part 'eleven_voice_verify.g.dart';

@JsonSerializable()
class ElevenVoiceVerification {
  final bool requires_verification;
  final bool is_verified;
  final List<String> verification_failures;
  final int verification_attempts_count;
  final String? language;
  final String? verification_attempts;

  ElevenVoiceVerification({
    required this.requires_verification,
    required this.is_verified,
    required this.verification_failures,
    required this.verification_attempts_count,
    this.language,
    this.verification_attempts,
  });

  factory ElevenVoiceVerification.fromJson(Map<String, dynamic> json) =>
      _$ElevenVoiceVerificationFromJson(json);

  Map<String, dynamic> toJson() => _$ElevenVoiceVerificationToJson(this);
}