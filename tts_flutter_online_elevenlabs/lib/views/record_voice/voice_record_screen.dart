import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tts_flutter_online_elevenlabs/views/record_voice/bloc/record_send_voice_bloc.dart';
import 'bloc/record_send_voice_event.dart';
import 'bloc/record_send_voice_state.dart';

class VoiceRecordScreen extends StatefulWidget {
  const VoiceRecordScreen({super.key});

  @override
  State<VoiceRecordScreen> createState() => _VoiceRecordScreenState();
}

class _VoiceRecordScreenState extends State<VoiceRecordScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late AnimationController _controllerPlay;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isRequestingPermissions = false;
  late ThemeData _themeData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _requestNeededPermission(BuildContext context) async {
    // Запитуємо обидва дозволи одночасно
    if (_isRequestingPermissions) {
      return;
    }
    setState(() {
      _isRequestingPermissions = true;
    });
    try {
      final microphoneStatus = await Permission.microphone.request(); // statuses[0];
      final storageStatus = await Permission.manageExternalStorage.request();

      if (microphoneStatus.isGranted && storageStatus.isGranted) {
        _startRecordingAndAnimation(context);
      } else {
        String message = '';
        late PermissionStatus microStatus;
        if (!microphoneStatus.isGranted) {
          message += 'Permission for microphone is denied.\n';
        }
        late PermissionStatus storeStatus;
        if (!storageStatus.isGranted) {
          message += 'Permission for storage is denied.\n';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        if (microphoneStatus.isPermanentlyDenied ||
            storageStatus.isPermanentlyDenied) {
          if (microphoneStatus.isPermanentlyDenied) {
            openAppSettings();
          } else if (storageStatus.isPermanentlyDenied) {
            openAppSettings();
          }
        }
      }
    } finally {
      setState(() {
        _isRequestingPermissions = false;
      });
    }
  }

  void _startRecordingAndAnimation(BuildContext context) {
    context.read<RecordSendVoiceBloc>().add(StartRecording());
    setState(() {
      _isRecording = true;
      _controller.repeat();
    });
  }

  void _stopRecordingAndAnimation(BuildContext context) {
    context.read<RecordSendVoiceBloc>().add(StopRecording());
    setState(() {
      _isRecording = false;
      _controller.stop();
    });
  }

  void _startPlayingAndAnimation(BuildContext context) {
    context.read<RecordSendVoiceBloc>().add(PlayRecording());
    setState(() {
      _isPlaying = true;
      _controller.repeat();
    });
  }

  void _stopPlayingAndAnimation(BuildContext context) {
    context.read<RecordSendVoiceBloc>().add(StopPlayback());
    setState(() {
      _isPlaying = false;
      _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Record Example Voice')),
      body: BlocBuilder<RecordSendVoiceBloc, RecordSendVoiceState>(
        builder: (context, state) {
          switch(state){
            case VoiceInitial _: return _buildInitialState(context);
            case RecordingInProgress _:
            case ConvertingInProgress _: return _buildRecordingState(context);
            case RecordingCompleted _: return _buildCompletedState(context, state.filePath);

            case ConvertingSuccess _:
            case PlayingRecording _:
            case PlaybackStopped _:  return _buildCompletedState(context, state.filePath);

            case SendingInProgress _: return const Center(child: CircularProgressIndicator());
            case SendingSuccess _: return _buildSendingSuccessState(context);
            case SendingFailure _:
            case RecordingFailure _:
            case ConvertingFailure _:
              return _buildSendingFailureState(context, state.failureMessage);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0, bottom: 32.0),
      child: Column(
        children: [
          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                            '''Here you can click a voice sample to upload the latter to the speech synthesis generation service. The voice sample must be clear and without extraneous noise. For best results, a recording of 1 to 5 minutes with gentle intonations is recommended.''',
                style: _themeData.textTheme.bodyMedium,
              ),
             ),
            ),
          // ),
          const SizedBox(height: 16.0),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _requestNeededPermission(context),
              icon: const Icon(Icons.circle, color: Colors.redAccent),
              label: const Text('START RECORD VOICE'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingState(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Expanded(child: Lottie.asset("assets/record_imitation_scene.json",
              repeat: true,
              animate: true,
              controller: _controller,
              onLoaded: (composition) {
                _controller.duration = composition.duration;
              },
              width: 200,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(child: Container()),
          Center(
              child: ElevatedButton.icon(
              onPressed: () => _stopRecordingAndAnimation(context),
              icon: const Icon(Icons.stop, color: Colors.blueAccent),
              label: const Text('STOP RECORD VOICE')
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedState(BuildContext context, String filePath) {
    final bool isPlaying = context.watch<RecordSendVoiceBloc>().state is PlayingRecording;
    return Padding(padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Expanded(child: Lottie.asset("assets/playing_imitation_scene.json",
              controller: _controller,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(child: Container()),
          Align(
            alignment: Alignment.center,
            child: Text('Recoded dir: $filePath')
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPlayButtonState(context, filePath, isPlaying),
                SizedBox(width: 8.0,),
                _buildPlayingState(context)
              ]
            ),
          ),
          _buildSendButtonState(context, isPlaying),
          _buildRepeatButtonState(context, isPlaying)
        ],
      ),
    );
  }

  Widget _buildPlayingState(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _stopPlayingAndAnimation(context),
        icon: const Icon(Icons.stop, color: Colors.greenAccent),
        label: const Text('STOP VOICE'),
      ),
    );
  }

  Widget _buildPlayButtonState(BuildContext context, String filePath, isPlaying) {
    return Center(
      child:  ElevatedButton.icon(
          onPressed: () => {
            _startPlayingAndAnimation(context)
          },
          icon: const Icon(Icons.play_arrow, color: Colors.greenAccent),
          label: const Text('PLAY VOICE')
      ),
    );
  }

  Widget _buildSendButtonState(BuildContext context, bool isPlaying) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: isPlaying ? null : () => context.read<RecordSendVoiceBloc>().add(SendRecording(voiceName: '', voiceDescription: '')),
        icon: const Icon(Icons.send_sharp, color: Colors.orangeAccent),
        label: const Text('SEND TO A VOICE SAMPLE'),
      ),
    );
  }

  Widget _buildRepeatButtonState(BuildContext context, bool isPlaying) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => context.read<RecordSendVoiceBloc>().add(ResetRecording()),
        icon: const Icon(Icons.repeat, color: Colors.pinkAccent),
        label: const Text('REPEAT RECORD EXAMPLE VOICE'),
      ),
    );
  }

  Widget _buildSendingSuccessState(BuildContext context) {
    return Padding(padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Text('Sending file SUCCESS!', style: _themeData.textTheme.displayLarge,),
          Expanded(child: Container()),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {Navigator.pop(context);},
            child: const Text('BACK'),
          ),
        ],
      ),
    );
  }

  Widget _buildSendingFailureState(BuildContext context, String failureMessage) {
    return Padding(padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Text('Oops, an error occurred!', style: _themeData.textTheme.displayMedium),
          SizedBox(height: 32.0),
          Text(failureMessage),
          Expanded(child: Container()),
          SizedBox(height: 16.0),
          _buildRepeatButtonState(context, false),
        ],
      ),
    );
  }

}
