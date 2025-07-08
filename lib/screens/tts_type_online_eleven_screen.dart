import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tts_flutter_online_elevenlabs/block/eleven_screen_bloc.dart';
import 'package:tts_flutter_online_elevenlabs/block/eleven_screen_event.dart';
import 'package:tts_flutter_online_elevenlabs/block/eleven_screen_state.dart';
import 'package:tts_flutter_online_elevenlabs/dialogs/dialog_setup/bloc/eleven_speech_dialog_bloc.dart';
import 'package:tts_flutter_online_elevenlabs/dialogs/dialog_setup/bloc/eleven_speech_dialog_event.dart';
import 'package:tts_flutter_online_elevenlabs/dialogs/dialog_setup/eleven_setup_speech_dialog.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';
import 'package:tts_flutter_online_elevenlabs/models/quality_collect.dart';
import 'package:tts_flutter_online_elevenlabs/models/dialog_setup_return.dart';
import 'package:tts_flutter_online_elevenlabs/views/record_voice/voice_record_screen.dart';
import 'package:tts_flutter_online_elevenlabs/voice_loader/eleven_voice_loader.dart';
import 'package:tts_multi_fun/screens/widgets/audio_player_control.dart';


@RoutePage()
class TTSTypeOnlineElevenScreen extends StatefulWidget {



  @override
  _TTSTypeOnlineElevenScreenState createState() => _TTSTypeOnlineElevenScreenState();
}

class _TTSTypeOnlineElevenScreenState extends State<TTSTypeOnlineElevenScreen> {
  final TextEditingController _textController = TextEditingController();
  ElevenVoice? _setupParams;
  QualityContain? _qualityContain;
  String? _modelQuality;
  bool _isLoadingSettings = true;

  @override
  void initState() {
    super.initState();
    _loadSetupParams();
    _loadQuality();
    _loadModelQuality();
  }

  Future<void> _loadSetupParams() async {
    final voiceLoader  = ElevenVoiceLoader();
    _setupParams = await voiceLoader.loadElevenSetup();

    if (_setupParams != null) {
      setState(() {
        _isLoadingSettings = false;
      });
    } else {
      setState(() {
        _isLoadingSettings = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load eleven setup voice.')),
      );
    }
  }

  Future<void> _loadQuality() async {
    final voiceLoader  = ElevenVoiceLoader();
    QualityContain? quality = await voiceLoader.loadElevenQuality();
    setState(() {
      _qualityContain = quality;
    });
  }

  Future<void> _loadModelQuality() async {
    final voiceLoader  = ElevenVoiceLoader();
    String? modelQuality = await voiceLoader.loadElevenModelQuality();
    setState(() {
      _modelQuality = modelQuality;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (_isLoadingSettings) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_setupParams == null) {
      return const Center(child: Text("Error: Could not load settings."));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<ElevenScreenBloc>(
          create: (context) => ElevenScreenBloc(initSetup: _setupParams!),
        ),
        BlocProvider<ElevenSpeechDialogBloc>(
          create: (context) => ElevenSpeechDialogBloc(initSetup: _setupParams!),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("Eleven Labs TTS"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
              onPressed: () async {
                final elevenBaseBloc = context.read<ElevenScreenBloc>();
                final elevenSetup = await showModalBottomSheet<DialogSetupReturn>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return BlocProvider.value(
                      value: elevenBaseBloc,
                      child: ElevenSetupSpeechDialog(
                        setupParams: elevenBaseBloc.state.setup!,
                        modelQuality: _modelQuality!,
                        quality: _qualityContain!,),
                    );
                  },
                );
                if (elevenSetup != null) {
                  setState(() {
                    _setupParams = elevenSetup.voice;
                    _qualityContain = elevenSetup.quality;
                    _modelQuality = elevenSetup.modelQuality;
                    // context.read<ElevenScreenBloc>().add(SaveSetupSpeechDialogEvent(elevenSetup));
                  });
                  context.read<ElevenSpeechDialogBloc>().add(SaveSetupSpeechDialogEvent(elevenSetup.voice));
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.mic_rounded),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => VoiceRecordScreen()
              ));
            }
          ),
        ],
        ),
        body: SingleChildScrollView(
          child:  Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Overall padding for the container
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 1.0,           // Border width
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners (optional)
                  ),
                  padding: const EdgeInsets.all(8.0), // Inner padding for the content
                  child:
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Language Of The Synthesized Text:',
                                style: theme.textTheme.bodyMedium),
                            Text(_setupParams?.fine_tuning.language ?? "", // Access language property
                                style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row( // Use Row for better layout
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Voice Of The Synthesized Text:',
                                style: theme.textTheme.bodyMedium),
                            Text(_setupParams?.name ?? "",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row( // Use Row for better layout
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Voice Of The Type:',
                                style: theme.textTheme.bodyMedium),
                            Text(_setupParams?.category ?? "",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row( // Use Row for better layout
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Voice Of The Gender:',
                                style: theme.textTheme.bodyMedium),
                            Text(_setupParams?.labels.gender ?? "",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row( // Use Row for better layout
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Voice Of The Accent:',
                                style: theme.textTheme.bodyMedium),
                            Text(_setupParams?.labels.accent ?? "",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row( // Use Row for better layout
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Voice Of The Age:',
                                style: theme.textTheme.bodyMedium),
                            Text(_setupParams?.labels.age ?? "",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row( // Use Row for better layout
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Voice Of The Use Case:',
                                style: theme.textTheme.bodyMedium),
                            Text(_setupParams?.labels.use_case ?? "",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row( // Use Row for better layout
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Voice Of The Descriptions:',
                                style: theme.textTheme.bodyMedium),
                            Text(_setupParams?.labels.description ?? "",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0), // Spacing between items
                        child: Row( // Use Row for better layout
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('The Voice Of The Model Quality:',
                                style: theme.textTheme.bodyMedium),
                            Text(_modelQuality ?? "Default Value",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        // No bottom padding on the last item
                        padding: const EdgeInsets.only(bottom: 0.0), // Spacing between items
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row( // Use Row for better layout
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('The Quality Of The Synthesized Text:',
                                    style: theme.textTheme.bodyMedium),
                                Text(_qualityContain?.name ?? "default quality",
                                  style: theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            // if(_qualityContain != null && (_qualityContain?.name.isNotEmpty ?? false)) {}
                            Text(
                              _qualityContain?.description ?? "",
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container( // Optional container for styling
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.grey, width: 1.0), // Optional border
                    // borderRadius: BorderRadius.circular(8.0), // Optional rounded corners
                  ),
                  // padding: const EdgeInsets.all(8.0), // Optional padding
                  child: Expanded(
                    child: SizedBox(
                      height: 200.0, // Or whatever height you want
                      child: TextField(
                        controller: _textController,
                        style: theme.textTheme.bodyMedium,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: "Enter text for speech...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.grey, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
              BlocBuilder<ElevenScreenBloc, ElevenScreenState>(
                builder: (context, state) {
                  switch (state) {
                    case ElevenVoiceLoader _:
                      return const CircularProgressIndicator();
                    case ElevenScreenAutoPlay dataEmit:
                      Uint8List audioBytes =
                      Uint8List.fromList(dataEmit.dataBytes as List<int>);
                      return AudioPlayerWidget(
                        audioData: audioBytes,
                        onNewEnterText: () {
                          context.read<ElevenScreenBloc>().add(
                            NewEnterSpeechTextEvent(),
                          );
                        },
                      );
                    case ElevenScreenError error:
                      return Text('Failure.. :: ${error.error}',
                          style: theme.textTheme.titleMedium);
                    default:
                      return ElevatedButton(
                        onPressed: () {
                          context.read<ElevenScreenBloc>().add(
                            SynthesizeSpeechEvent(
                              voice: _setupParams!,
                              voiceQuality: _qualityContain!,
                              modelQuality: _modelQuality!,
                              textForSpeech: _textController.text,
                            ),
                          );
                        },
                        child: Text("GO .. text to speech..",
                            style: theme.textTheme.bodyLarge),
                      );
                  }
                },
              ),
            ]
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _ElevenScreenService.stopPlayback();
  }
}