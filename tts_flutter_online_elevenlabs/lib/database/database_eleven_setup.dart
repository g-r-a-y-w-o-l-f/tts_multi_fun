import 'package:sqflite/sqflite.dart';
import 'package:tts_flutter_online_elevenlabs/models/quality_collect.dart';
import 'dart:convert';
import '../models/eleven_voice.dart';

class ElevenSetupSQLiteHelper {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await openDatabase(
      'eleven_database_setup.db', // Database name
      version: 1,
      onCreate: (Database db, int version) async {
        // await db.execute(
        //   'CREATE TABLE eleven_setup (id INTEGER PRIMARY KEY, eleven_voice TEXT)',
        // );
          await db.execute('''CREATE TABLE IF NOT EXISTS eleven_setup (
                              id INTEGER PRIMARY KEY AUTOINCREMENT, 
                              eleven_voice TEXT NOT NULL)''');
          
          await db.execute('''CREATE TABLE IF NOT EXISTS eleven_quality (
                              id INTEGER PRIMARY KEY AUTOINCREMENT, 
                              quality_voice TEXT NOT NULL)''');

          await db.execute('''CREATE TABLE IF NOT EXISTS eleven_model_quality (
                              id INTEGER PRIMARY KEY AUTOINCREMENT, 
                              quality_model_voice TEXT NOT NULL)''');
      },
    );
    return _db!;
  }

  Future<void> insertSetup(ElevenVoice setup) async {
    final db = await database;
    final voiceJson = jsonEncode(setup.toJson());
    await db.insert('eleven_setup', {'id': 1, 'eleven_voice': voiceJson},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ElevenVoice?> getSetup() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('eleven_setup', where: 'id = 1');
    if (maps.isNotEmpty) {
      final voiceJson = maps[0]['eleven_voice'] as String;
      final voice = ElevenVoice.fromJson(jsonDecode(voiceJson));
      return voice;
    }
    return null;
  }

  Future<void> updateSettings(ElevenVoice settings) async {
    final db = await database;
    final voiceJson = jsonEncode(settings.toJson());
    await db.update('eleven_setup', {'eleven_voice': voiceJson}, where: 'id = 1');
  }
  
  // ============ Quality methods ============================

  Future<void> insertQuality(QualityContain quality) async {
    final db = await database;
    final qualityJson = jsonEncode(quality.toJson());
    await db.insert('eleven_quality', {'id': 1, 'quality_voice': qualityJson},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<QualityContain?> getQuality() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('eleven_quality', where: 'id = 1');
    if (maps.isNotEmpty) {
      final qualityJson = maps[0]['quality_voice'] as String;
      final quality = QualityContain.fromJson(jsonDecode(qualityJson));
      return quality;
    }
    return null;
  }

  Future<void> updateQuality(QualityContain quality) async {
    final db = await database;
    final qualityJson = jsonEncode(quality.toJson());
    await db.update('eleven_quality', {'quality_voice': qualityJson}, where: 'id = 1');
  }

  // ============ Quality model ============================

  Future<void> insertModelQuality(String modelQuality) async {
    final db = await database;
    await db.insert('eleven_model_quality', {'id': 1, 'quality_model_voice': modelQuality},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getModelQuality() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('eleven_model_quality', where: 'id = 1');
    if (maps.isNotEmpty) {
      final modelQuality = maps[0]['quality_model_voice'] as String;
      return modelQuality;
    }
    return null;
  }

  Future<void> updateModelQuality(String modelQuality) async {
    final db = await database;
    await db.update('eleven_model_quality', {'quality_model_voice': modelQuality}, where: 'id = 1');
  }

}