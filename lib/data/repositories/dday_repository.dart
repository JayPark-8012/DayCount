import '../database/database_constants.dart';
import '../database/database_helper.dart';
import '../models/dday.dart';

class DdayRepository {
  final DatabaseHelper _dbHelper;

  DdayRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<DDay>> getAll() async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        tableDdays,
        orderBy: '$colSortOrder ASC, $colCreatedAt DESC',
      );
      return maps.map((map) => DDay.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch D-Days: $e');
    }
  }

  Future<DDay?> getById(int id) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        tableDdays,
        where: '$colId = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return DDay.fromMap(maps.first);
    } catch (e) {
      throw Exception('Failed to fetch D-Day: $e');
    }
  }

  Future<int> insert(DDay dday) async {
    try {
      final db = await _dbHelper.database;
      return db.insert(tableDdays, dday.toMap());
    } catch (e) {
      throw Exception('Failed to insert D-Day: $e');
    }
  }

  Future<int> update(DDay dday) async {
    try {
      final db = await _dbHelper.database;
      return db.update(
        tableDdays,
        dday.toMap(),
        where: '$colId = ?',
        whereArgs: [dday.id],
      );
    } catch (e) {
      throw Exception('Failed to update D-Day: $e');
    }
  }

  Future<int> delete(int id) async {
    try {
      final db = await _dbHelper.database;
      // Milestones are CASCADE deleted via foreign key
      return db.delete(
        tableDdays,
        where: '$colId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete D-Day: $e');
    }
  }
}
