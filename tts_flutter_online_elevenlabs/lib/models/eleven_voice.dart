import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_fine_tuning.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_labels.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_voice_verify.dart';
import 'package:tts_flutter_online_elevenlabs/voice_loader/eleven_voice_loader.dart';


part 'eleven_voice.g.dart';

@JsonSerializable()
class ElevenVoice {
  final String voice_id;
  final String name;
  final String? samples; // Nullable
  final String category;
  final ElevenFineTuning fine_tuning;
  final ElevenLabels labels;
  final String? description; // Nullable
  final String preview_url;
  final List<String> available_for_tiers;
  final List<String> high_quality_base_model_ids;
  final String? safety_control; // Nullable
  final ElevenVoiceVerification voice_verification;
  final String? permission_on_resource; // Nullable
  final bool? is_owner; // Nullable bool
  final bool is_legacy;
  final bool is_mixed;
  final int? created_at_unix; // Nullable int

  ElevenVoice({
    required this.voice_id,
    required this.name,
    this.samples,
    required this.category,
    required this.fine_tuning,
    required this.labels,
    this.description,
    required this.preview_url,
    required this.available_for_tiers,
    required this.high_quality_base_model_ids,
    this.safety_control,
    required this.voice_verification,
    this.permission_on_resource,
    this.is_owner,
    required this.is_legacy,
    required this.is_mixed,
    this.created_at_unix,
  });

  factory ElevenVoice.fromJson(Map<String, dynamic> json) => _$ElevenVoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ElevenVoiceToJson(this);
}