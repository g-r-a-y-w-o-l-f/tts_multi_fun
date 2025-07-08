// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voice _$VoiceFromJson(Map<String, dynamic> json) => Voice(
      name: json['Name'] as String?,
      displayName: json['DisplayName'] as String?,
      shortName: json['ShortName'] as String?,
      gender: json['Gender'] as String?,
      locale: json['Locale'] as String?,
      localeName: json['LocaleName'] as String?,
      sampleRateHertz: json['SampleRateHertz'] as String?,
      voiceType: json['VoiceType'] as String?,
      status: json['Status'] as String?,
      wordsPerMinute: json['WordsPerMinute'] as String?,
      styleList: (json['StyleList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      rolePlayList: (json['RolePlayList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      bitrade: json['Bitraide'] as String?,
    );

Map<String, dynamic> _$VoiceToJson(Voice instance) => <String, dynamic>{
      'Name': instance.name,
      'DisplayName': instance.displayName,
      'ShortName': instance.shortName,
      'Gender': instance.gender,
      'Locale': instance.locale,
      'LocaleName': instance.localeName,
      'SampleRateHertz': instance.sampleRateHertz,
      'VoiceType': instance.voiceType,
      'Status': instance.status,
      'WordsPerMinute': instance.wordsPerMinute,
      'StyleList': instance.styleList,
      'RolePlayList': instance.rolePlayList,
      'Bitraide': instance.bitrade,
    };
