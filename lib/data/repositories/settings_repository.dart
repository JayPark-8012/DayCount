import 'package:sqflite/sqflite.dart';

import '../database/database_constants.dart';
import '../database/database_helper.dart';

class SettingsRepository {
  final DatabaseHelper _dbHelper;

  SettingsRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<String?> get(String key) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        tableSettings,
        where: '$colSettingsKey = ?',
        whereArgs: [key],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return maps.first[colSettingsValue] as String?;
    } catch (e) {
      throw Exception('Failed to get setting: $e');
    }
  }

  Future<void> set(String key, String? value) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        tableSettings,
        {colSettingsKey: key, colSettingsValue: value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to set setting: $e');
    }
  }

  Future<String> getString(String key, {String defaultValue = ''}) async {
    final value = await get(key);
    return value ?? defaultValue;
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final value = await get(key);
    if (value == null) return defaultValue;
    return value == '1' || value.toLowerCase() == 'true';
  }
}
