import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tts_flutter_online_azure/database/settings_database_helper.dart';
import 'package:tts_flutter_online_azure/database/voice_database_helper.dart';
import 'package:tts_flutter_online_azure/voice_loader/voice_loader.dart';

import '../models/settings.dart';
import '../models/voice.dart';
import '../static/key_property.dart';

class AzureTtsSettingsDialog extends StatefulWidget {
  final VoiceSetup settings;

  const AzureTtsSettingsDialog({Key? key, required this.settings}) : super(key: key);

  @override
  _AzureTtsSettingsDialogState createState() => _AzureTtsSettingsDialogState();
}

class _AzureTtsSettingsDialogState extends State<AzureTtsSettingsDialog> {
  late VoiceSetup _settings;
  late String _localSelect;
  late VoiceSetup _updateSettings;
  // array for setup quality voice generation...
  late List<String> _bitrade = ['audio-16khz-32kbitrate-mono-mp3', 'audio-16khz-64kbitrate-mono-mp3', 'audio-16khz-128kbitrate-mono-mp3', 'audio-24khz-48kbitrate-mono-mp3', 'audio-24khz-96kbitrate-mono-mp3', 'audio-24khz-160kbitrate-mono-mp3', 'audio-48khz-96kbitrate-mono-mp3', 'audio-48khz-192kbitrate-mono-mp3'];

  Map<String, List<Voice>> _localeMap = {};
  Set<String> _availableLanguages = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
    _updateSettings = _settings;
    _updateSettings.voice.bitrade ??= _bitrade[0];
    _localSelect = _settings.voice.locale ?? 'en_US';
    _loadVoices();
  }

  Future<void> _loadVoices() async {
    final VoiceSQLiteHelper voiceSQLiteHelper = VoiceSQLiteHelper();
    try {
      final voices = await voiceSQLiteHelper.getVoices();
      String local = "";
      List<Voice> selectVoice = [];
      for (var voice in voices) {
        if (voice.locale != null) { // Check for null locale
          local = voice.locale ?? "";
          _availableLanguages.add(local);
          if (_localeMap.containsKey(local)) {
            _localeMap[local]?.add(voice);
          } else {
            _localeMap[local] = [];
            _localeMap[local]?.add(voice);
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading voices: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Settings Text To Speech', style: theme.textTheme.titleLarge,),
          SizedBox(height: 16.0,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Select language', style: theme.textTheme.bodyLarge,),
          ),
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
                value: _localSelect,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _localSelect = newValue;
                    });
                  }
                },
                items: _availableLanguages.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: theme.textTheme.bodyLarge),
                  );
                }).toList(),
              ),
          ),
          SizedBox(height: 16.0,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Select voices for Text To Speech', style: theme.textTheme.bodyLarge,),
          ),
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
                value: _getItem(), //_settings.voice.shortName,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      final selectedVoice = _localeMap[_localSelect]?.firstWhere(
                            (voice) => voice.shortName == newValue, // Compare shortNames
                        orElse: () => _updateSettings.voice, // Return current voice if not found (important!)
                      );
                      if (selectedVoice != null) { // Check if a voice was found
                        _updateSettings.voice = selectedVoice; // Update _settings.voice
                      }
                    });
                  }
                },
                items: _localeMap[_localSelect]?.map<DropdownMenuItem<String>>((Voice voice) {
                  return DropdownMenuItem<String>(
                    value: voice.shortName,
                    child: Text(voice.displayName ?? "", style: theme.textTheme.bodyLarge),
                  );
                }).toList() ?? [], // Empty list, when voices not loaded...
              ),
          ),
          SizedBox(height: 16.0,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Select quality voice generation', style: theme.textTheme.bodyLarge,),
          ),
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
                value: _updateSettings.voice.bitrade ?? _bitrade[0] ,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _updateSettings.voice.bitrade = newValue;
                    });
                  }
                },
                items: _bitrade.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: theme.textTheme.bodyLarge,),
                  );
                }).toList(),
              ),
          ),
          // ... Buttons for saving new voice setup
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 0.0, right: 0.0, bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red),
                  onPressed: () {
                      Navigator.pop(context);
                    },
                      child: Text('Cancel', style: theme.textTheme.bodyLarge),
                    ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green),
                  onPressed: () {
                    final SettingsSQLiteHelper helper = SettingsSQLiteHelper();
                    helper.updateSettings(_updateSettings);
                    Navigator.pop(context, _updateSettings);
                    },
                  child: Text('Save', style: theme.textTheme.bodyLarge),
                ),
              ])
          )
        ],
      ),
    );
  }

  String _getItem() {
    List<Voice>? temp = _localeMap[_localSelect];
    String result;
    temp == null ? result = "" : result = temp.firstWhere((voice) =>
                                 voice.shortName == _settings.voice.shortName,
                                 orElse: () => temp.first).shortName ?? "";
    result == "" ? result = _localeMap[_localSelect]?.first.shortName ?? "" : "";
    return result;
  }

}