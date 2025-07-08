import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tts_flutter_offline/tts_offline_service.dart';

@RoutePage()
class TTSTypeOfflineScreen extends StatefulWidget {
  @override
  _TTSTypeOfflineScreenState createState() => _TTSTypeOfflineScreenState();
}

class _TTSTypeOfflineScreenState extends State<TTSTypeOfflineScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isPlaying = false;
  final _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    // initialization TTS offline service before start screen
    _ttsService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("TTS Offline TTS", style: theme.textTheme.titleLarge)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                style: theme.textTheme.bodyMedium,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: "Enter for text to speech...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isPlaying
                  ? null
                  : () {
                if (_textController.text.isNotEmpty) {
                  setState(() {
                    _isPlaying = true;
                  });
                  _ttsService.speak(_textController.text).then((_) {
                    setState(() {
                      _isPlaying = false;
                    });
                  });
                }
              },
              icon: Icon(Icons.speaker),
              label: Text(_isPlaying ? "Playing..." : "To Play", style: theme.textTheme.titleMedium),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _ttsService.stop();
    _textController.dispose();
    super.dispose();
  }
}