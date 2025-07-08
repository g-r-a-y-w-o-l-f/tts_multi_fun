// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleven_voice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElevenVoice _$ElevenVoiceFromJson(Map<String, dynamic> json) => ElevenVoice(
      voice_id: json['voice_id'] as String,
      name: json['name'] as String,
      samples: json['samples'] as String?,
      category: json['category'] as String,
      fine_tuning: ElevenFineTuning.fromJson(
          json['fine_tuning'] as Map<String, dynamic>),
      labels: ElevenLabels.fromJson(json['labels'] as Map<String, dynamic>),
      description: json['description'] as String?,
      preview_url: json['preview_url'] as String,
      available_for_tiers: (json['available_for_tiers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      high_quality_base_model_ids:
          (json['high_quality_base_model_ids'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      safety_control: json['safety_control'] as String?,
      voice_verification: ElevenVoiceVerification.fromJson(
          json['voice_verification'] as Map<String, dynamic>),
      permission_on_resource: json['permission_on_resource'] as String?,
      is_owner: json['is_owner'] as bool?,
      is_legacy: json['is_legacy'] as bool,
      is_mixed: json['is_mixed'] as bool,
      created_at_unix: (json['created_at_unix'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ElevenVoiceToJson(ElevenVoice instance) =>
    <String, dynamic>{
      'voice_id': instance.voice_id,
      'name': instance.name,
      'samples': instance.samples,
      'category': instance.category,
      'fine_tuning': instance.fine_tuning,
      'labels': instance.labels,
      'description': instance.description,
      'preview_url': instance.preview_url,
      'available_for_tiers': instance.available_for_tiers,
      'high_quality_base_model_ids': instance.high_quality_base_model_ids,
      'safety_control': instance.safety_control,
      'voice_verification': instance.voice_verification,
      'permission_on_resource': instance.permission_on_resource,
      'is_owner': instance.is_owner,
      'is_legacy': instance.is_legacy,
      'is_mixed': instance.is_mixed,
      'created_at_unix': instance.created_at_unix,
    };
