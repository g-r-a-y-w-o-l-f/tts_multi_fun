import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'eleven_fine_tuning.g.dart';

@JsonSerializable()
class ElevenFineTuning {
  final bool is_allowed_to_fine_tune;
  final Map<String, String> state;
  final List<String> verification_failures;
  final int verification_attempts_count;
  final bool manual_verification_requested;
  final String? language;
  final Map<String, double>? progress;
  final Map<String, String>? message;
  final int? dataset_duration_seconds;
  final String? verification_attempts;
  final List<String>? slice_ids;
  final String? manual_verification;
  final int? max_verification_attempts;
  final int? next_max_verification_attempts_reset_unix_ms;

  ElevenFineTuning({
    required this.is_allowed_to_fine_tune,
    required this.state,
    required this.verification_failures,
    required this.verification_attempts_count,
    required this.manual_verification_requested,
    this.language,
    this.progress,
    this.message,
    this.dataset_duration_seconds,
    this.verification_attempts,
    this.slice_ids,
    this.manual_verification,
    this.max_verification_attempts,
    this.next_max_verification_attempts_reset_unix_ms,
  });

  factory ElevenFineTuning.fromJson(Map<String, dynamic> json) =>
      _$ElevenFineTuningFromJson(json);

  Map<String, dynamic> toJson() => _$ElevenFineTuningToJson(this);
}

