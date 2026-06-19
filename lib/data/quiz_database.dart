import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/stage_progress.dart';

/// sqflite-backed persistence for stage progress, scoped per user.
/// Mirrors the original Room `QuizDatabase` + `StageProgressDao`, extended with
/// a `userId` column so multiple signed-in accounts don't mix on one device.
class QuizDatabase {
  static const _dbName = 'quiz_db.db';
  static const _table = 'stage_progress';

  Database? _db;

  Future<Database> get _database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, _dbName);
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) => _createTable(db),
      onUpgrade: (db, oldVersion, newVersion) async {
        // v1 had no userId column; drop & recreate (data re-syncs from cloud).
        await db.execute('DROP TABLE IF EXISTS $_table');
        await _createTable(db);
      },
    );
  }

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_table (
        userId TEXT NOT NULL,
        levelId INTEGER NOT NULL,
        stageId INTEGER NOT NULL,
        starsCount INTEGER NOT NULL,
        timeSpentMs INTEGER NOT NULL,
        isCompleted INTEGER NOT NULL,
        isUnlocked INTEGER NOT NULL,
        PRIMARY KEY (userId, levelId, stageId)
      )
    ''');
  }

  Future<List<StageProgress>> getAllProgress(String userId) async {
    final db = await _database;
    final rows = await db.query(
      _table,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'levelId ASC, stageId ASC',
    );
    return rows.map(StageProgress.fromMap).toList();
  }

  Future<void> insertProgress(StageProgress progress) async {
    final db = await _database;
    await db.insert(
      _table,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<StageProgress?> getProgressForStage(String userId, int levelId, int stageId) async {
    final db = await _database;
    final rows = await db.query(
      _table,
      where: 'userId = ? AND levelId = ? AND stageId = ?',
      whereArgs: [userId, levelId, stageId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return StageProgress.fromMap(rows.first);
  }

  Future<void> clearProgress(String userId) async {
    final db = await _database;
    await db.delete(_table, where: 'userId = ?', whereArgs: [userId]);
  }
}
