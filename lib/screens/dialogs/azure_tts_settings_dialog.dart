// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// //
// // class AzureTTSSettingsDialog extends StatefulWidget {
// //   final Map<String, List<String>> languagesWithVoices;
// //   final String selectedLanguage;
// //   final String selectedVoice;
// //   final Function(String, String) onSettingsSelected;
// //
// //   const AzureTTSSettingsDialog({
// //     required this.languagesWithVoices,
// //     required this.selectedLanguage,
// //     required this.selectedVoice,
// //     required this.onSettingsSelected,
// //     Key? key,
// //   }) : super(key: key);
// //
// //   @override
// //   _AzureTTSSettingsDialogState createState() => _AzureTTSSettingsDialogState();
// // }
// //
// // class _AzureTTSSettingsDialogState extends State<AzureTTSSettingsDialog> {
// //   late String _selectedLanguage;
// //   late String _selectedVoice;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _selectedLanguage = widget.selectedLanguage;
// //     _selectedVoice = widget.selectedVoice;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     List<String> voices = widget.languagesWithVoices[_selectedLanguage] ?? [];
// //     final ThemeData theme = Theme.of(context);
// //     return Container(
// //       padding: EdgeInsets.all(16.0),
// //       height: MediaQuery.of(context).size.height * 0.6, // Авто висота
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text('Налаштування Azure TTS', style: theme.textTheme.titleMedium),
// //           SizedBox(height: 10),
// //
// //           // Вибір мови
// //           DropdownButtonFormField<String>(
// //             value: _selectedLanguage,
// //             items: widget.languagesWithVoices.keys.map((lang) {
// //               return DropdownMenuItem(value: lang, child: Text(lang));
// //             }).toList(),
// //             onChanged: (value) {
// //               setState(() {
// //                 _selectedLanguage = value!;
// //                 _selectedVoice = widget.languagesWithVoices[_selectedLanguage]!.first; // Оновлюємо голос
// //               });
// //             },
// //             decoration: InputDecoration(labelText: 'Виберіть мову'),
// //           ),
// //
// //           SizedBox(height: 16),
// //
// //           // Вибір голосу
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: voices.length,
// //               itemBuilder: (context, index) {
// //                 final voice = voices[index];
// //                 return RadioListTile<String>(
// //                   title: Text(voice),
// //                   value: voice,
// //                   groupValue: _selectedVoice,
// //                   onChanged: (value) {
// //                     setState(() {
// //                       _selectedVoice = value!;
// //                     });
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //
// //           // Кнопка "Зберегти"
// //           ElevatedButton(
// //             onPressed: () {
// //               widget.onSettingsSelected(_selectedLanguage, _selectedVoice);
// //               Navigator.pop(context);
// //             },
// //             child: Text('Зберегти'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// // ... інші імпорти
//
// class _TTSTypeOnlineJayScreen extends State<TTSTypeOnlineJayScreen> {
//
//
//   void _showSettingsDialog() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Container(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   // Вибір мови вводу
//                   DropdownButton<String>(
//                     value: _settings.language, // Припустімо, що _settings.language зберігає обрану мову
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _settings.language = newValue!;
//                         // Завантаження голосів для обраної мови
//                         _loadVoicesForLanguage(_settings.language);
//                       });
//                     },
//                     items: <String>['uk-UA', 'en-US', ' інші мови'].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   // Вибір голосу
//                   DropdownButton<String>(
//                     value: _settings.voice, // Припустімо, що _settings.voice зберігає обраний голос
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _settings.voice = newValue!;
//                       });
//                     },
//                     items: _availableVoices.map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   // Вибір якості (бітрейт)
//                   DropdownButton<String>(
//                     value: _settings.bitrate, // Припустімо, що _settings.bitrate зберігає обраний бітрейт
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _settings.bitrate = newValue!;
//                       });
//                     },
//                     items: <String>['audio-16khz-128kbitrate-mono-mp3', 'інші бітрейти'].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                   // Вибір тону
//                   Slider(
//                     value: _settings.pitch, // Припустімо, що _settings.pitch зберігає обраний тон
//                     min: -10,
//                     max: 10,
//                     onChanged: (double value) {
//                       setState(() {
//                         _settings.pitch = value;
//                       });
//                     },
//                     label: 'Тон: ${_settings.pitch}',
//                   ),
//                   // Вибір швидкості
//                   Slider(
//                     value: _settings.rate, // Припустімо, що _settings.rate зберігає обрану швидкість
//                     min: 0.5,
//                     max: 2.0,
//                     onChanged: (double value) {
//                       setState(() {
//                         _settings.rate = value;
//                       });
//                     },
//                     label: 'Швидкість: ${_settings.rate}',
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('Зберегти'),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _loadVoicesForLanguage(String language) async {
//     // Тут потрібно реалізувати логіку для завантаження списку голосів для обраної мови
//     // Використовуйте API Azure TTS для отримання доступних голосів
//     // Оновіть список _availableVoices та встановіть перший голос за замовчуванням
//   }
//
// // ... інші методи та змінні
// }
