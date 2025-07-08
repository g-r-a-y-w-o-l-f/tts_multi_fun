import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';
import 'package:tts_flutter_online_elevenlabs/models/quality_collect.dart';

class DialogSetupReturn {
  final ElevenVoice voice;
  final QualityContain quality;
  final String modelQuality;

  DialogSetupReturn({
    required this.voice,
    required this.quality,
    required this.modelQuality,
  });
}