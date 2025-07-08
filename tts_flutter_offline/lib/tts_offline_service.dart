import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> initialize() async {
    // await flutterTts.setLanguage("uk-UA");
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}
