import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_constants.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableDdays (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colTargetDate TEXT NOT NULL,
        $colCategory TEXT NOT NULL DEFAULT 'general',
        $colEmoji TEXT NOT NULL DEFAULT '📅',
        $colThemeId TEXT NOT NULL DEFAULT 'cloud',
        $colIsCountUp INTEGER NOT NULL DEFAULT 0,
        $colIsFavorite INTEGER NOT NULL DEFAULT 0,
        $colMemo TEXT,
        $colNotifyEnabled INTEGER NOT NULL DEFAULT 1,
        $colSortOrder INTEGER NOT NULL DEFAULT 0,
        $colCreatedAt TEXT NOT NULL,
        $colUpdatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMilestones (
        $colMilestoneId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colMilestoneDdayId INTEGER NOT NULL,
        $colMilestoneDays INTEGER NOT NULL,
        $colMilestoneLabel TEXT NOT NULL,
        $colMilestoneIsCustom INTEGER NOT NULL DEFAULT 0,
        $colMilestoneNotifyBefore TEXT NOT NULL DEFAULT '["7d","3d","0d"]',
        FOREIGN KEY ($colMilestoneDdayId) REFERENCES $tableDdays ($colId) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableSettings (
        $colSettingsKey TEXT PRIMARY KEY,
        $colSettingsValue TEXT
      )
    ''');

    await db.execute(
      'CREATE INDEX $idxDdaysCategory ON $tableDdays ($colCategory)',
    );
    await db.execute(
      'CREATE INDEX $idxDdaysTargetDate ON $tableDdays ($colTargetDate)',
    );
    await db.execute(
      'CREATE INDEX $idxMilestonesDdayId ON $tableMilestones ($colMilestoneDdayId)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migrations will be added here as the schema evolves.
    // Use switch-case for sequential migration:
    //
    // switch (oldVersion) {
    //   case 1:
    //     await db.execute('ALTER TABLE ...');
    //     continue v2;
    //   v2:
    //   case 2:
    //     await db.execute('ALTER TABLE ...');
    // }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
