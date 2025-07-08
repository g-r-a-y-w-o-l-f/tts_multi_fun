import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../models/settings.dart'; // Import your Settings model
import '../models/voice.dart'; // Import your Voice model

class SettingsSQLiteHelper {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      'settings.db', // Database name
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE settings (id INTEGER PRIMARY KEY, voice TEXT)', // Single row table
        );
      },
    );
    return _db!;
  }

  Future<void> insertSettings(VoiceSetup settings) async {
    final db = await database;
    final voiceJson = jsonEncode(settings.voice.toJson());
    await db.insert('settings', {'id': 1, 'voice': voiceJson},
        conflictAlgorithm: ConflictAlgorithm.replace); // Use replace for single row
  }

  Future<VoiceSetup?> getSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('settings', where: 'id = 1');
    if (maps.isNotEmpty) {
      final voiceJson = maps[0]['voice'] as String;
      final voice = Voice.fromJson(jsonDecode(voiceJson));
      return VoiceSetup(voice: voice);
    }
    return null;
  }

  Future<void> updateSettings(VoiceSetup settings) async {
    final db = await database;
    final voiceJson = jsonEncode(settings.voice.toJson());
    await db.update('settings', {'voice': voiceJson}, where: 'id = 1');
  }
}