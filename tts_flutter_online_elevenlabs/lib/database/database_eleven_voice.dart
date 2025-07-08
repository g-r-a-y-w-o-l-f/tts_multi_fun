import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../models/eleven_voice.dart';


class ElevenVoiceSQLiteHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      'eleven_database_voice.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS eleven_voices (
          name TEXT PRIMARY KEY, 
          data TEXT NOT NULL
        )
      ''');
      },
    );
    return _database!;
  }

  Future<void> insertVoice(Map<String, dynamic> voiceData) async {
    final db = await database;
    await db.insert(
      'eleven_voices',
      {'name': voiceData['name'], 'data': jsonEncode(voiceData)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ElevenVoice>> getVoices() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('eleven_voices');
    List<ElevenVoice> parse = result.map((data) {
      return ElevenVoice.fromJson(jsonDecode(data['data'] as String));  // Декодуємо JSON в модель
    }).toList();
    return parse;
  }

  Future<void> updateVoice(String name, Map<String, dynamic> newVoiceData) async {
    final db = await database;
    await db.update(
      'eleven_voices',
      {'data': jsonEncode(newVoiceData)},
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}