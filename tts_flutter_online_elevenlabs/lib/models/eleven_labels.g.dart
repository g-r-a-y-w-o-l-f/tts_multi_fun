// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eleven_labels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElevenLabels _$ElevenLabelsFromJson(Map<String, dynamic> json) => ElevenLabels(
      accent: json['accent'] as String,
      description: json['description'] as String,
      age: json['age'] as String,
      gender: json['gender'] as String,
      use_case: json['use_case'] as String,
    );

Map<String, dynamic> _$ElevenLabelsToJson(ElevenLabels instance) =>
    <String, dynamic>{
      'accent': instance.accent,
      'description': instance.description,
      'age': instance.age,
      'gender': instance.gender,
      'use_case': instance.use_case,
    };
