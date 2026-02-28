import '../database/database_constants.dart';
import '../database/database_helper.dart';
import '../models/milestone.dart';

class MilestoneRepository {
  final DatabaseHelper _dbHelper;

  MilestoneRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<List<Milestone>> getByDdayId(int ddayId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        tableMilestones,
        where: '$colMilestoneDdayId = ?',
        whereArgs: [ddayId],
        orderBy: '$colMilestoneDays ASC',
      );
      return maps.map((map) => Milestone.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to fetch milestones: $e');
    }
  }

  Future<int> insert(Milestone milestone) async {
    try {
      final db = await _dbHelper.database;
      return db.insert(tableMilestones, milestone.toMap());
    } catch (e) {
      throw Exception('Failed to insert milestone: $e');
    }
  }

  Future<void> insertAll(List<Milestone> milestones) async {
    try {
      final db = await _dbHelper.database;
      final batch = db.batch();
      for (final milestone in milestones) {
        batch.insert(tableMilestones, milestone.toMap());
      }
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Failed to insert milestones: $e');
    }
  }

  Future<int> delete(int id) async {
    try {
      final db = await _dbHelper.database;
      return db.delete(
        tableMilestones,
        where: '$colMilestoneId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete milestone: $e');
    }
  }

  Future<int> deleteByDdayId(int ddayId) async {
    try {
      final db = await _dbHelper.database;
      return db.delete(
        tableMilestones,
        where: '$colMilestoneDdayId = ?',
        whereArgs: [ddayId],
      );
    } catch (e) {
      throw Exception('Failed to delete milestones: $e');
    }
  }
}
