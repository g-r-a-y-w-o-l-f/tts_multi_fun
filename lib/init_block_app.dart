import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:theme/theme.dart';
import 'package:tts_flutter_online_azure/bloc/azure_ai_bloc.dart';
import 'package:tts_flutter_online_azure/dialogs/bloc/azure_tts_bloc.dart';
import 'package:tts_flutter_online_azure/models/settings.dart';
import 'package:tts_flutter_online_azure/voice_loader/voice_loader.dart';
import 'package:tts_flutter_online_elevenlabs/block/eleven_screen_bloc.dart';
import 'package:tts_flutter_online_elevenlabs/views/record_voice/bloc/record_send_voice_bloc.dart';
import 'package:tts_flutter_online_elevenlabs/voice_loader/eleven_voice_loader.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';
import 'package:tts_multi_fun/router/router.dart';

import 'blocs/navigation_bloc.dart'; // Make sure you import Provider

// ... other imports

class TTSApp extends StatefulWidget {
  const TTSApp({super.key});

  @override
  State<TTSApp> createState() => _TTSAppState();
}

class _TTSAppState extends State<TTSApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(  // Use FutureBuilder for loading settings
      future: _loadAllSettings(), // Your settings loading function
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp( // MaterialApp here for loading state
            home: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return const MaterialApp( // MaterialApp here for error state
            home: Center(child: Text("Error: Could not load settings.")),
          );
        } else {
          final voiceSetup = snapshot.data![0] as VoiceSetup;
          final elevenSetup = snapshot.data![1] as ElevenVoice;

          return MultiBlocProvider( // BlocProvider moved *outside* MaterialApp
            providers: [
              BlocProvider<NavigationBloc>(
                create: (context) => NavigationBloc(),
              ),
              BlocProvider<AzureAIBloc>(
                create: (context) => AzureAIBloc(initialSettings: voiceSetup),
              ),
              BlocProvider<AzureTtsBloc>( // Add the missing BlocProvider!
                create: (context) => AzureTtsBloc(initialSettings: voiceSetup),
              ),
              BlocProvider<ElevenScreenBloc>( // Add the missing BlocProvider!
                create: (context) => ElevenScreenBloc(initSetup: elevenSetup),
              ),
              BlocProvider<RecordSendVoiceBloc>( // Add the missing BlocProvider!
                create: (context) => RecordSendVoiceBloc(),
              ),
            ],
            child: MaterialApp.router( // MaterialApp *inside* BlocProvider
              theme: darkThem,
              title: 'TTS MULTIPACK',
              debugShowCheckedModeBanner: false,
              routerConfig: _appRouter.config(
                navigatorObservers: () => [TalkerRouteObserver(GetIt.I<Talker>())],
              ),
            ),
          );
        }
      },
    );
  }

  Future<VoiceSetup?> _loadSettings() async {
    final voiceLoader = VoiceLoader();
    return await voiceLoader.loadSettings();
  }
  
  Future<ElevenVoice?> _loadElevenSetup() async {
    final elevenLoader = ElevenVoiceLoader();
    return await elevenLoader.loadElevenSetup();
  }

  Future<List<dynamic>> _loadAllSettings() async {
    final voiceSetup = _loadSettings();
    final elevenSetup = _loadElevenSetup();
    return await Future.wait([voiceSetup, elevenSetup]);
  }
}
