import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/stage_progress.dart';

/// sqflite-backed persistence for stage progress. Mirrors the original Room
/// `QuizDatabase` + `StageProgressDao`.
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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            levelId INTEGER NOT NULL,
            stageId INTEGER NOT NULL,
            starsCount INTEGER NOT NULL,
            timeSpentMs INTEGER NOT NULL,
            isCompleted INTEGER NOT NULL,
            isUnlocked INTEGER NOT NULL,
            PRIMARY KEY (levelId, stageId)
          )
        ''');
      },
    );
  }

  Future<List<StageProgress>> getAllProgress() async {
    final db = await _database;
    final rows = await db.query(_table, orderBy: 'levelId ASC, stageId ASC');
    return rows.map(StageProgress.fromMap).toList();
  }

  /// Insert or replace (mirrors Room OnConflictStrategy.REPLACE).
  Future<void> insertProgress(StageProgress progress) async {
    final db = await _database;
    await db.insert(
      _table,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<StageProgress?> getProgressForStage(int levelId, int stageId) async {
    final db = await _database;
    final rows = await db.query(
      _table,
      where: 'levelId = ? AND stageId = ?',
      whereArgs: [levelId, stageId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return StageProgress.fromMap(rows.first);
  }

  Future<void> clearProgress() async {
    final db = await _database;
    await db.delete(_table);
  }
}
