
import 'package:json_annotation/json_annotation.dart';

part 'quality_collect.g.dart';

@JsonSerializable()
class QualityContain {
  final String name;
  final String description;

  QualityContain({
    required this.name,
    required this.description,
  });

  factory QualityContain.fromJson(Map<String, dynamic> json) => _$QualityContainFromJson(json);

  Map<String, dynamic> toJson() => _$QualityContainToJson(this);
}