import 'package:json_annotation/json_annotation.dart';

part 'voice.g.dart';

@JsonSerializable()
class Voice {
  @JsonKey(name: 'Name')
  final String? name;
  @JsonKey(name: 'DisplayName')
  final String? displayName;
  @JsonKey(name: 'ShortName')
  final String? shortName;
  @JsonKey(name: 'Gender')
  final String? gender;
  @JsonKey(name: 'Locale')
  final String? locale;
  @JsonKey(name: 'LocaleName')
  final String? localeName;
  @JsonKey(name: 'SampleRateHertz')
  final String? sampleRateHertz; // Змінено на int?
  @JsonKey(name: 'VoiceType')
  final String? voiceType;
  @JsonKey(name: 'Status')
  final String? status;
  @JsonKey(name: 'WordsPerMinute')
  final String? wordsPerMinute; // Змінено на int?
  @JsonKey(name: 'StyleList')
  List<String>? styleList;
  @JsonKey(name: 'RolePlayList')
  List<String>? rolePlayList;

  @JsonKey(name: 'Bitraide')
  String? bitrade;

  Voice({
    required this.name,
    required this.displayName,
    required this.shortName,
    required this.gender,
    required this.locale,
    required this.localeName,
    required this.sampleRateHertz,
    required this.voiceType,
    required this.status,
    required this.wordsPerMinute,
    required this.styleList,
    required this.rolePlayList,
    required this.bitrade,
  });

  factory Voice.fromJson(Map<String, dynamic> json) => _$VoiceFromJson(json);
  Map<String, dynamic> toJson() => _$VoiceToJson(this);
}
