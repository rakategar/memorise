import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/stage_progress.dart';

/// Persistence for stage progress.
/// On web: in-memory (no SQLite WASM required).
/// On mobile: sqflite.
class QuizDatabase {
  static const _dbName = 'quiz_db.db';
  static const _table = 'stage_progress';

  Database? _db;

  // --- in-memory fallback (web) ---
  final List<StageProgress> _memStore = [];

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
    if (kIsWeb) {
      return _memStore.where((s) => s.userId == userId).toList()
        ..sort((a, b) => a.levelId != b.levelId
            ? a.levelId.compareTo(b.levelId)
            : a.stageId.compareTo(b.stageId));
    }
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
    if (kIsWeb) {
      _memStore.removeWhere((s) =>
          s.userId == progress.userId &&
          s.levelId == progress.levelId &&
          s.stageId == progress.stageId);
      _memStore.add(progress);
      return;
    }
    final db = await _database;
    await db.insert(
      _table,
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<StageProgress?> getProgressForStage(
      String userId, int levelId, int stageId) async {
    if (kIsWeb) {
      try {
        return _memStore.firstWhere((s) =>
            s.userId == userId &&
            s.levelId == levelId &&
            s.stageId == stageId);
      } catch (_) {
        return null;
      }
    }
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
    if (kIsWeb) {
      _memStore.removeWhere((s) => s.userId == userId);
      return;
    }
    final db = await _database;
    await db.delete(_table, where: 'userId = ?', whereArgs: [userId]);
  }
}
