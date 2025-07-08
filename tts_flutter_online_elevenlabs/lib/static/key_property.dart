
import 'package:tts_flutter_online_elevenlabs/models/quality_collect.dart';

class ElevenProperty {
  //'Testing Keys For Flutter Multilanguge Voice Speech'
  static const String eleven_api_key = 'sk_a5cd60455d05442493d38ac0d47731c9f57e68af7189861a';

  static const String eleven_base_uri = 'https://api.elevenlabs.io/';
  static const String eleven_version = 'v1/';
  static const String eleven_suffix_voices = 'voices';
  static const String eleven_suffix_speech = 'text-to-speech';
  static const String eleven_suffix_add_voice = 'add';


  static final List<QualityContain> qualityCollect = [
    QualityContain(name: 'mp3_22050_32', description: 'Output format mp3 with 22.05kHz sample rate at 32kbps'),
    QualityContain(name: 'mp3_44100_32', description: 'Output format mp3 with 44.1kHz sample rate at 32kbps'),
    QualityContain(name: 'mp3_44100_64', description: 'Output format mp3 with 44.1kHz sample rate at 64kbps'),
    QualityContain(name: 'mp3_44100_96', description: 'Output format mp3 with 44.1kHz sample rate at 96kbps'),
    QualityContain(name: 'mp3_44100_128', description: 'Output format mp3 with 44.1kHz sample rate at 128kbps'),
    // QualityContain(name: 'mp3_44100_192', description: 'Output format mp3 with 44.1kHz sample rate at 192kbps'), // not all voices supported this format quality
  ];
  // used only mp3
  //['mp3_22050_32', 'mp3_44100_32', 'mp3_44100_64', 'mp3_44100_96', 'mp3_44100_128', 'mp3_44100_192', 'pcm_16000' 'pcm_22050' 'pcm_24000' 'pcm_44100' 'ulaw_8000']

}