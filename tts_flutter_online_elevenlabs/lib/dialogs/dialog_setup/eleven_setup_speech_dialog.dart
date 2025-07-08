import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tts_flutter_online_elevenlabs/database/database_eleven_setup.dart';
import 'package:tts_flutter_online_elevenlabs/models/dialog_setup_return.dart';
import 'package:tts_flutter_online_elevenlabs/models/eleven_voice.dart';
import 'package:tts_flutter_online_elevenlabs/models/quality_collect.dart';
import 'package:tts_flutter_online_elevenlabs/static/key_property.dart';

import '../../database/database_eleven_voice.dart';

class ElevenSetupSpeechDialog extends StatefulWidget {
  final ElevenVoice _setupParams;
  final QualityContain _quality;
  final String _modelQuality;

  const ElevenSetupSpeechDialog({
    Key? key,
    required ElevenVoice setupParams,
    required QualityContain quality,
    required String modelQuality,
  }) :  _setupParams = setupParams,
        _quality = quality,
        _modelQuality = modelQuality,
        super(key: key);

  @override
  _ElevenSetupSpeechDialog createState() => _ElevenSetupSpeechDialog();

}

class _ElevenSetupSpeechDialog extends State<ElevenSetupSpeechDialog> {
  late ElevenVoice _setupParams;
  late QualityContain _quality;
  late String _modelQuality;
  late String _localSelect;
  final List<QualityContain> _bitrade = ElevenProperty.qualityCollect;

  Map<String, List<ElevenVoice>> _localeMap = {};
  Set<String> _availableLanguages = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupParams = widget._setupParams;
    _quality = widget._quality;
    _modelQuality = widget._modelQuality;
    _localSelect = _setupParams.fine_tuning.language ?? 'en';
    _loadVoices();
  }

  Future<void> _loadVoices() async {
    final ElevenVoiceSQLiteHelper voiceSQLiteHelper = ElevenVoiceSQLiteHelper();
    try {
      final voices = await voiceSQLiteHelper.getVoices();
      String local = "";
      List<ElevenVoice> selectVoice = [];
      for (var voice in voices) {
        if (voice.fine_tuning.language != null) { // Check for null locale
          local = voice.fine_tuning.language ?? "";
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
                      final selectedNewVoice = _localeMap[_localSelect]?.firstWhere(
                            (voice) => voice.name == newValue, // Compare shortNames
                        orElse: () => _setupParams, // _updateSetup, // Return current voice if not found (important!)
                      );
                      if (selectedNewVoice != null) { // Check if a voice was found
                        /*_updateSetup*/ _setupParams = selectedNewVoice; // Update _settings.voice
                      }
                    });
                  }
                },
                items: _localeMap[_localSelect]?.map<DropdownMenuItem<String>>((ElevenVoice voice) {
                  return DropdownMenuItem<String>(
                    value: voice.name,
                    child: Text(voice.name ?? "", style: theme.textTheme.bodyLarge),
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
                value: _quality.name,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _quality = ElevenProperty.qualityCollect.firstWhere((quality) => quality.name == newValue);
                    });
                  }
                },
                items: _bitrade.map<DropdownMenuItem<String>>((QualityContain value) {
                  return DropdownMenuItem<String>(
                    value: value.name,
                    child: Text(value.name, style: theme.textTheme.bodyLarge,),
                  );
                }).toList(),
              ),
          ),
          SizedBox(height: 16.0,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Select voice model quality', style: theme.textTheme.bodyLarge,),
          ),
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              value: _modelQuality,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _modelQuality = newValue;
                  });
                }
              },
              items: _setupParams.high_quality_base_model_ids.map<DropdownMenuItem<String>>((String value) {
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
                    final ElevenSetupSQLiteHelper helper = ElevenSetupSQLiteHelper();
                    helper.updateSettings(_setupParams);
                    helper.updateQuality(_quality);
                    helper.updateModelQuality(_modelQuality);
                    Navigator.pop(context, DialogSetupReturn(voice: _setupParams, quality: _quality, modelQuality: _modelQuality));
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
    List<ElevenVoice>? temp = _localeMap[_localSelect];
    String result;
    temp == null ? result = "" : result = temp.firstWhere((voice) =>
                                 voice.name == _setupParams.name,
                                 orElse: () => temp.first).name ?? "";
    result == "" ? result = _localeMap[_localSelect]?.first.name ?? "" : "";
    return result;
  }

}