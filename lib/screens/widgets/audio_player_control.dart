import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mime/mime.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List audioData;
  final VoidCallback onNewEnterText;

  const AudioPlayerWidget({Key? key,
    required this.audioData,
    required this.onNewEnterText
  }) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final AudioPlayer _audioPlayer;
  double _audioProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudio();

    _audioPlayer.positionStream.listen((position) {
      final totalDuration = _audioPlayer.duration ?? Duration.zero;
      if (totalDuration > Duration.zero) {
        setState(() {
          _audioProgress = position.inMilliseconds / totalDuration.inMilliseconds;
        });
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _audioProgress = 0.0; // Reset progress after playing
        });
        _audioPlayer.seek(Duration.zero);
      }
    });
  }

  Future<void> _loadAudio() async {
    try {
      String mimeType = lookupMimeType('audio.mp3') ?? 'audio/mpeg';
      String base64Audio = base64Encode(widget.audioData);
      String dataUri = 'data:$mimeType;base64,$base64Audio';

      await _audioPlayer.setUrl(dataUri);

    } catch (e) {
      print('Failure about download audio.. :: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        StreamBuilder<Duration?>(
          stream: _audioPlayer.positionStream,
          builder: (context, snapshot) {
            final totalDuration = _audioPlayer.duration ?? Duration.zero;
            final currentPosition = snapshot.data ?? Duration.zero;
            _audioProgress = (currentPosition.inMilliseconds / (totalDuration.inMilliseconds + 1)).clamp(0.0, 1.0);

            return Slider(
              value: _audioProgress,
              onChanged: (value) {
                setState(() {
                  _audioProgress = value;
                });
                _audioPlayer.seek(Duration(milliseconds: (value * totalDuration.inMilliseconds).toInt()));
              },
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_audioPlayer.playing) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.play();
                }
              },
              child: StreamBuilder<bool>(
                stream: _audioPlayer.playingStream,
                builder: (context, snapshot) {
                  bool isPlaying = snapshot.data ?? false;
                  return Icon(isPlaying ? Icons.pause : Icons.play_arrow);
                },
              ),
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: widget.onNewEnterText,
              child: Text("New Enter Text", style: theme.textTheme.bodyLarge,),
            ),
          ],
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     if (_audioPlayer.playing) {
        //       _audioPlayer.pause();
        //     } else {
        //       _audioPlayer.play();
        //     }
        //   },
        //   child: StreamBuilder<bool>(
        //     stream: _audioPlayer.playingStream,
        //     builder: (context, snapshot) {
        //       bool isPlaying = snapshot.data ?? false;
        //       return Icon(isPlaying ? Icons.pause : Icons.play_arrow);
        //     },
        //   ),
        // ),
      ],
    );
  }
}