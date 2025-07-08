import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:convert'; // Import for JSON encoding/decoding
import '../models/voice.dart';

class VoiceSQLiteHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      'voices.db', // Database name
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE voices (name TEXT PRIMARY KEY, data TEXT)',
        );
      },
    );
    return _database!;
  }

  Future<void> insertVoice(Map<String, dynamic> voice) async {
    final db = await database;
    await db.insert(
      'voices',
      {'name': voice['Name'], 'data': jsonEncode(voice)}, // Store Voice as JSON
      conflictAlgorithm: ConflictAlgorithm.replace, // Handle duplicates
    );
  }

  Future<List<Voice>> getVoices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('voices');
    return List.generate(maps.length, (i) {
      final decodedData = jsonDecode(maps[i]['data']) as Map<String, dynamic>;
      return Voice.fromJson(decodedData);
    });
  }

  Future<void> deleteVoice(String name) async {
    final db = await database;
    await db.delete('voices', where: 'name = ?', whereArgs: [name]);
  }

  Future<void> updateVoice(Voice voice) async {
    final db = await database;
    await db.update(
      'voices',
      {'data': jsonEncode(voice.toJson())}, // Update with JSON
      where: 'name = ?',
      whereArgs: [voice.name],
    );
  }

  Future<Voice?> getVoiceByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'voices',
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      final decodedData = jsonDecode(maps[0]['data']) as Map<String, dynamic>;
      return Voice.fromJson(decodedData);
    }
    return null;
  }
}