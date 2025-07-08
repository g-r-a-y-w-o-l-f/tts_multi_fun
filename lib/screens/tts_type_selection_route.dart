import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation_bloc.dart';
import '../router/router.dart';

@RoutePage()
class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  NavigationEvent _selectedScreen = NavigationEvent.tts_offline_screen;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Selected type TTS")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            _buildRadioListTile(
              title: "TTS Offline",
              description: "Offline speech synthesis. Used to work without an Internet connection. May require downloading additional resources and system settings for voice convenience (speed, tone, volume, etc.)",
              value: NavigationEvent.tts_offline_screen,
              theme: theme,
            ),
            _buildRadioListTile(
              title: "TSS Online Azure",
              description: "Online speech synthesis from Microsoft Azure Requires an Internet connection. This method provides better voice synthesis quality. The settings of this method have a very rich selection of voices and settings for the quality of results. The results of the service are listened to using the built-in player.",
              value: NavigationEvent.tts_online_jay_screen,
              theme: theme,
            ),
            _buildRadioListTile(
              title: "TSS Online Elevenlabs",
              description: "Online speech synthesis from Elevenlabs requires an Internet connection. The service has the highest sound quality, but requires fine-tuning and working with speech synthesis. The service also allows you to create speech synthesis based on your own voice (The function requires a PRO subscription). The results of the service are listened to using the built-in player.",
              value: NavigationEvent.tts_online_screen,
              theme: theme,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<NavigationBloc>().navigateTo(_selectedScreen);
                  _navigateToSelectedScreen();
                },
                child: Text("Goto Process", style: theme.textTheme.bodyLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioListTile({
    required String title,
    required String description,
    required NavigationEvent value,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        RadioListTile<NavigationEvent>(
          title: Text(title, style: theme.textTheme.titleMedium),
          subtitle: Text(description, style: theme.textTheme.bodyMedium),
          value: value,
          groupValue: _selectedScreen,
          onChanged: (value) => setState(() {
            _selectedScreen = value!;
          }),
        ),
        Divider(),
      ],
    );
  }


  void _navigateToSelectedScreen() {
    switch (_selectedScreen) {
      case NavigationEvent.tts_offline_screen:
        context.router.push(TTSTypeOfflineRoute());
        break;
      case NavigationEvent.tts_online_screen:
        context.router.push(TTSTypeOnlineRoute());
        break;
      case NavigationEvent.tts_online_jay_screen:
        context.router.push(TTSTypeOnlineJayRoute());
        break;
      default:
        context.router.push(SelectionRoute());
    }
  }
}