import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class RecordingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/record_imitation_scene.json');
  }
}

class PlayingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/play_imitation_scene.json');
  }
}