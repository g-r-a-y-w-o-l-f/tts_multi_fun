import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tts_flutter_online_azure/bloc/azure_ai_bloc.dart';
import 'package:tts_flutter_online_azure/bloc/azure_ai_event.dart';
import 'package:tts_flutter_online_azure/bloc/azure_ai_state.dart';

import 'package:tts_flutter_online_azure/dialogs/azure_tts_settings_dialog.dart';
import 'package:tts_flutter_online_azure/dialogs/bloc/azure_tts_bloc.dart';
import 'package:tts_flutter_online_azure/dialogs/bloc/azure_tts_event.dart';

import 'package:tts_flutter_online_azure/models/settings.dart';

import 'package:tts_multi_fun/screens/widgets/audio_player_control.dart';

import 'package:tts_flutter_online_azure/voice_loader/voice_loader.dart';

@RoutePage()
class TTSTypeOnlineAzureScreen extends StatefulWidget {
  @override
  _TTSTypeOnlineJayScreen createState() => _TTSTypeOnlineJayScreen();
}

class _TTSTypeOnlineJayScreen extends State<TTSTypeOnlineAzureScreen> {
  final TextEditingController _textController = TextEditingController();
  VoiceSetup? _settings;
  bool _isLoadingSettings = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final voiceLoader = VoiceLoader();
    _settings = await voiceLoader.loadSettings();

    if (_settings != null) {
      setState(() {
        _isLoadingSettings = false;
      });
    } else {
      // Handle the case where settings could not be loaded
      setState(() {
        _isLoadingSettings = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load settings.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (_isLoadingSettings) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_settings == null) {
      return const Center(child: Text("Error: Could not load settings."));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<AzureTtsBloc>(
          create: (context) => AzureTtsBloc(initialSettings: _settings!),
        ),
        BlocProvider<AzureAIBloc>(
          create: (context) => AzureAIBloc(initialSettings: _settings!),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Azure AI Service'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                final azureTtsBloc = context.read<AzureTtsBloc>();
                final settings = await showModalBottomSheet<VoiceSetup>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return BlocProvider.value(
                      value: azureTtsBloc,
                      child: AzureTtsSettingsDialog(settings: azureTtsBloc.state.settings),
                    );
                  },
                );
                if (settings != null) {
                  setState(() {
                    _settings = settings;
                  });
                  context.read<AzureTtsBloc>().add(SaveSettingsEvent(settings));
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 0.0, right: 0.0, bottom: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('The Language Of The Synthesized Text:',
                            style: theme.textTheme.bodyMedium),
                        // SizedBox(width: 20),
                        Text(_settings?.voice.locale ?? "",
                            style: theme.textTheme.bodyMedium),
                      ])
              ),
              Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 0.0, right: 0.0, bottom: 8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child:
                            Text('The Voice Of The Synthesized Text:',
                                style: theme.textTheme.bodyMedium),
                            // SizedBox(width: 20),
                          ),
                        SizedBox(
                            width: double.infinity,
                            child:
                              Text(_settings?.voice.name ?? "",
                                  style: theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.right,),
                        ),
                      ])
              ),
              Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 0.0, right: 0.0, bottom: 8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child:
                            Text('The Quality Of The Synthesized Text:',
                                style: theme.textTheme.bodyMedium),
                          ),
                        // SizedBox(width: 20),
                        SizedBox(
                          width: double.infinity,
                          child:
                            Text(_settings?.voice.bitrade ?? "base settings",
                                style: theme.textTheme.bodyMedium,
                                textAlign: TextAlign.right,),
                        ),
                      ])
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: theme.textTheme.bodyMedium,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: "Enter text for speech...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<AzureAIBloc, AzureAIState>(
                builder: (context, state) {
                  switch (state) {
                    case AzureAILoading _:
                      return const CircularProgressIndicator();
                    case AzureAIAutoPlay dataEmit:
                      Uint8List audioBytes =
                      Uint8List.fromList(dataEmit.dataBytes as List<int>);
                      return AudioPlayerWidget(
                        audioData: audioBytes,
                        onNewEnterText: () {
                          context.read<AzureAIBloc>().add(
                            NewEnterSpeechTextEvent(),
                          );
                        },
                      );
                    case AzureAIError error:
                      return Text('Failure.. :: ${error.error}',
                          style: theme.textTheme.titleMedium);
                    default:
                      return ElevatedButton(
                        onPressed: () {
                          context.read<AzureAIBloc>().add(
                            SynthesizeSpeechEvent(
                              text: _textController.text,
                              settings: _settings!,
                            ),
                          );
                        },
                        child: Text("GO .. text to speech..",
                            style: theme.textTheme.bodyLarge),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}