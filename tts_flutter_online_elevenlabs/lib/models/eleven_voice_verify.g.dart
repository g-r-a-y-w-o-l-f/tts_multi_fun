// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleven_voice_verify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElevenVoiceVerification _$ElevenVoiceVerificationFromJson(
        Map<String, dynamic> json) =>
    ElevenVoiceVerification(
      requires_verification: json['requires_verification'] as bool,
      is_verified: json['is_verified'] as bool,
      verification_failures: (json['verification_failures'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      verification_attempts_count:
          (json['verification_attempts_count'] as num).toInt(),
      language: json['language'] as String?,
      verification_attempts: json['verification_attempts'] as String?,
    );

Map<String, dynamic> _$ElevenVoiceVerificationToJson(
        ElevenVoiceVerification instance) =>
    <String, dynamic>{
      'requires_verification': instance.requires_verification,
      'is_verified': instance.is_verified,
      'verification_failures': instance.verification_failures,
      'verification_attempts_count': instance.verification_attempts_count,
      'language': instance.language,
      'verification_attempts': instance.verification_attempts,
    };
