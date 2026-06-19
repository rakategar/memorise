import 'package:gsheets/gsheets.dart';

import '../config/app_config.dart';
import '../models/stage_progress.dart';

/// Syncs progress to a Google Spreadsheet so the client can monitor users.
///
/// Given an empty spreadsheet, it auto-creates two worksheets and their header
/// columns if missing:
///   - `ProgressLog`: one row per completed stage attempt (history).
///   - `Users`: one upserted summary row per user.
///
/// All methods are no-ops (and never throw to the UI) when Sheets isn't
/// configured in `.env`.
class RemoteProgressService {
  static const _logTitle = 'ProgressLog';
  static const _usersTitle = 'Users';

  static const _logHeaders = [
    'timestamp',
    'userId',
    'email',
    'name',
    'levelId',
    'stageId',
    'stars',
    'timeSpentMs',
    'score',
    'isSuccess',
  ];
  static const _usersHeaders = [
    'userId',
    'email',
    'name',
    'totalStars',
    'solvedStages',
    'lastActive',
  ];

  GSheets? _gsheets;
  Spreadsheet? _spreadsheet;
  Worksheet? _logWs;
  Worksheet? _usersWs;
  bool _ready = false;

  bool get isEnabled => AppConfig.isSheetsConfigured;

  /// Connects, and creates/repairs the worksheets + header columns as needed.
  /// Safe to call repeatedly; only does the work once.
  Future<void> ensureStructure() async {
    if (!isEnabled || _ready) return;
    _gsheets ??= GSheets(AppConfig.sheetsCredentials);
    _spreadsheet ??= await _gsheets!.spreadsheet(AppConfig.spreadsheetId);
    _logWs = await _ensureSheet(_logTitle, _logHeaders);
    _usersWs = await _ensureSheet(_usersTitle, _usersHeaders);
    _ready = true;
  }

  Future<Worksheet> _ensureSheet(String title, List<String> headers) async {
    var ws = _spreadsheet!.worksheetByTitle(title);
    ws ??= await _spreadsheet!.addWorksheet(title);
    final existing = await ws.values.row(1);
    if (existing.isEmpty) {
      await ws.values.insertRow(1, headers);
    } else {
      // Detect required columns that are missing and append them.
      final missing = headers.where((h) => !existing.contains(h)).toList();
      if (missing.isNotEmpty) {
        await ws.values.insertRow(1, [...existing, ...missing]);
      }
    }
    return ws;
  }

  /// Appends one completion event to `ProgressLog`.
  Future<void> appendProgressLog({
    required String userId,
    required String email,
    required String name,
    required int levelId,
    required int stageId,
    required int stars,
    required int timeSpentMs,
    required int score,
    required bool isSuccess,
  }) async {
    await ensureStructure();
    if (!_ready) return;
    await _logWs!.values.map.appendRow(
      {
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'userId': userId,
        'email': email,
        'name': name,
        'levelId': '$levelId',
        'stageId': '$stageId',
        'stars': '$stars',
        'timeSpentMs': '$timeSpentMs',
        'score': '$score',
        'isSuccess': '$isSuccess',
      },
      appendMissing: true,
    );
  }

  /// Inserts or updates the summary row for [userId] in `Users`.
  Future<void> upsertUserSummary({
    required String userId,
    required String email,
    required String name,
    required int totalStars,
    required int solvedStages,
  }) async {
    await ensureStructure();
    if (!_ready) return;
    final row = {
      'userId': userId,
      'email': email,
      'name': name,
      'totalStars': '$totalStars',
      'solvedStages': '$solvedStages',
      'lastActive': DateTime.now().toUtc().toIso8601String(),
    };
    // Column 1 holds userId; row 1 is the header so data starts at row 2.
    final index = await _usersWs!.values.rowIndexOf(userId, inColumn: 1);
    if (index < 2) {
      await _usersWs!.values.map.appendRow(row, appendMissing: true);
    } else {
      await _usersWs!.values.map.insertRow(index, row, appendMissing: true);
    }
  }

  /// Reads `ProgressLog`, filters by [userId], and aggregates the best result
  /// per stage (max stars, min time among successes) for cloud restore.
  Future<List<StageProgress>> pullUserProgress(String userId) async {
    await ensureStructure();
    if (!_ready) return const [];
    final rows = await _logWs!.values.map.allRows() ?? const [];

    final agg = <String, _StageAgg>{};
    for (final r in rows) {
      if (r['userId'] != userId) continue;
      final lvl = int.tryParse(r['levelId'] ?? '');
      final stg = int.tryParse(r['stageId'] ?? '');
      if (lvl == null || stg == null) continue;
      final success = (r['isSuccess'] ?? '').toLowerCase() == 'true';
      if (!success) continue;
      final stars = int.tryParse(r['stars'] ?? '') ?? 0;
      final timeMs = int.tryParse(r['timeSpentMs'] ?? '') ?? 0;
      final a = agg.putIfAbsent('${lvl}_$stg', () => _StageAgg(lvl, stg));
      a.completed = true;
      if (stars > a.stars) a.stars = stars;
      if (timeMs > 0 && (a.timeMs == 0 || timeMs < a.timeMs)) a.timeMs = timeMs;
    }

    return agg.values
        .map((a) => StageProgress(
              userId: userId,
              levelId: a.levelId,
              stageId: a.stageId,
              starsCount: a.stars,
              timeSpentMs: a.timeMs,
              isCompleted: a.completed,
              isUnlocked: true,
            ))
        .toList();
  }
}

class _StageAgg {
  _StageAgg(this.levelId, this.stageId);
  final int levelId;
  final int stageId;
  int stars = 0;
  int timeMs = 0;
  bool completed = false;
}
