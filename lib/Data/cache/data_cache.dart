import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataCache {
  static Database? _db;

  static Future<Database> get _database async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'app_cache.db'),
      onCreate: (db, _) => db.execute(
        'CREATE TABLE cache(key TEXT PRIMARY KEY, data TEXT NOT NULL)',
      ),
      version: 1,
    );
    return _db!;
  }

  static Future<void> save(String key, List<Map<String, dynamic>> data) async {
    final db = await _database;
    await db.insert(
      'cache',
      {'key': key, 'data': jsonEncode(data)},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>?> load(String key) async {
    final db = await _database;
    final rows = await db.query('cache', where: 'key = ?', whereArgs: [key]);
    if (rows.isEmpty) return null;
    final list = jsonDecode(rows.first['data'] as String) as List;
    return list.cast<Map<String, dynamic>>();
  }
}
