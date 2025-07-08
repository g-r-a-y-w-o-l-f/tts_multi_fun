// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleven_fine_tuning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElevenFineTuning _$ElevenFineTuningFromJson(Map<String, dynamic> json) =>
    ElevenFineTuning(
      is_allowed_to_fine_tune: json['is_allowed_to_fine_tune'] as bool,
      state: Map<String, String>.from(json['state'] as Map),
      verification_failures: (json['verification_failures'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      verification_attempts_count:
          (json['verification_attempts_count'] as num).toInt(),
      manual_verification_requested:
          json['manual_verification_requested'] as bool,
      language: json['language'] as String?,
      progress: (json['progress'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      message: (json['message'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      dataset_duration_seconds:
          (json['dataset_duration_seconds'] as num?)?.toInt(),
      verification_attempts: json['verification_attempts'] as String?,
      slice_ids: (json['slice_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      manual_verification: json['manual_verification'] as String?,
      max_verification_attempts:
          (json['max_verification_attempts'] as num?)?.toInt(),
      next_max_verification_attempts_reset_unix_ms:
          (json['next_max_verification_attempts_reset_unix_ms'] as num?)
              ?.toInt(),
    );

Map<String, dynamic> _$ElevenFineTuningToJson(ElevenFineTuning instance) =>
    <String, dynamic>{
      'is_allowed_to_fine_tune': instance.is_allowed_to_fine_tune,
      'state': instance.state,
      'verification_failures': instance.verification_failures,
      'verification_attempts_count': instance.verification_attempts_count,
      'manual_verification_requested': instance.manual_verification_requested,
      'language': instance.language,
      'progress': instance.progress,
      'message': instance.message,
      'dataset_duration_seconds': instance.dataset_duration_seconds,
      'verification_attempts': instance.verification_attempts,
      'slice_ids': instance.slice_ids,
      'manual_verification': instance.manual_verification,
      'max_verification_attempts': instance.max_verification_attempts,
      'next_max_verification_attempts_reset_unix_ms':
          instance.next_max_verification_attempts_reset_unix_ms,
    };
