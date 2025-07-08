
import 'package:json_annotation/json_annotation.dart';

part 'eleven_labels.g.dart';

@JsonSerializable()
class ElevenLabels {
  final String accent;
  final String description;
  final String age;
  final String gender;
  final String use_case;

  ElevenLabels({
    required this.accent,
    required this.description,
    required this.age,
    required this.gender,
    required this.use_case,
  });

  factory ElevenLabels.fromJson(Map<String, dynamic> json) => _$ElevenLabelsFromJson(json);

  Map<String, dynamic> toJson() => _$ElevenLabelsToJson(this);
}