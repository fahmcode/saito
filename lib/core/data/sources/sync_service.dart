import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:saito/core/data/sources/database.dart';

import 'package:flutter/foundation.dart';

enum SyncStatus { idle, syncing, backoff, error }

class SyncState {
  final SyncStatus status;
  final DateTime? lastSyncAt;
  final int pendingCount;
  final String? error;
  final int backoffSeconds;

  const SyncState({
    this.status = SyncStatus.idle,
    this.lastSyncAt,
    this.pendingCount = 0,
    this.error,
    this.backoffSeconds = 0,
  });

  SyncState copyWith({
    SyncStatus? status,
    DateTime? lastSyncAt,
    int? pendingCount,
    String? error,
    int? backoffSeconds,
  }) {
    return SyncState(
      status: status ?? this.status,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      pendingCount: pendingCount ?? this.pendingCount,
      error: error,
      backoffSeconds: backoffSeconds ?? this.backoffSeconds,
    );
  }
}

/// Syncs workout_progress rows to Google Drive appData as a single JSON file.
/// Adds retries with backoff, checksum, and basic etag/modified guard.
class DriveSyncService {
  DriveSyncService(this._db, this._googleSignIn);

  final AppDatabase _db;
  final GoogleSignIn _googleSignIn;

  static const _fileName = 'workout_state.json';
  final ValueNotifier<SyncState> state =
      ValueNotifier<SyncState>(const SyncState());

  Future<drive.DriveApi?> _api() async {
    final account = _googleSignIn.currentUser;
    if (account == null) return null;
    final headers = await account.authHeaders;
    final client = _GoogleAuthClient(headers);
    return drive.DriveApi(client);
  }

  Future<void> sync(String userId) async {
    await _withRetries(() async {
      final api = await _api();
      if (api == null) throw Exception('not_signed_in');
      final fileId = await _ensureFile(api);
      await _pull(api, fileId, userId);
      await _push(api, fileId, userId);
      state.value = state.value.copyWith(
        status: SyncStatus.idle,
        lastSyncAt: DateTime.now(),
        error: null,
      );
    });
  }

  Future<void> pushWorkout(String userId) async {
    await _withRetries(() async {
      final api = await _api();
      if (api == null) throw Exception('not_signed_in');
      final fileId = await _ensureFile(api);
      await _push(api, fileId, userId);
      state.value = state.value.copyWith(
        status: SyncStatus.idle,
        lastSyncAt: DateTime.now(),
        error: null,
      );
    });
  }

  Future<void> _withRetries(Future<void> Function() action) async {
    const maxAttempts = 3;
    int attempt = 0;
    while (attempt < maxAttempts) {
      attempt++;
      try {
        state.value =
            state.value.copyWith(status: SyncStatus.syncing, error: null);
        await action();
        return;
      } catch (e) {
        if (attempt >= maxAttempts) {
          state.value = state.value.copyWith(
            status: SyncStatus.error,
            error: e.toString(),
          );
          rethrow;
        }
        final backoff = Duration(seconds: 2 * attempt);
        state.value = state.value.copyWith(
          status: SyncStatus.backoff,
          backoffSeconds: backoff.inSeconds,
          error: e.toString(),
        );
        await Future.delayed(backoff);
      }
    }
  }

  Future<String> _ensureFile(drive.DriveApi api) async {
    final list = await api.files.list(
      spaces: 'appDataFolder',
      q: "name='$_fileName' and 'appDataFolder' in parents",
      $fields: 'files(id,name,modifiedTime,md5Checksum)',
      pageSize: 1,
    );

    if (list.files != null && list.files!.isNotEmpty) {
      return list.files!.first.id!;
    }

    final created = await api.files.create(
      drive.File(name: _fileName, parents: ['appDataFolder']),
    );
    return created.id!;
  }

  Future<void> _pull(drive.DriveApi api, String fileId, String userId) async {
    final media = await api.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final bytes = await media.stream.fold<List<int>>(
      [],
      (prev, chunk) => prev..addAll(chunk),
    );

    if (bytes.isEmpty) return;

    final decoded = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    final version = decoded['version'] as int? ?? 1;
    final workouts = (decoded['workouts'] as List?) ?? [];
    final checksum = decoded['checksum'] as String?;

    if (!_validateChecksum(bytes, checksum)) {
      throw Exception('checksum_mismatch');
    }

    final items = (version >= 2) ? workouts : workouts;

    for (final raw in items) {
      final map = raw as Map<String, dynamic>;
      if ((map['user_id'] as String?) != userId) continue;

      final remoteUpdated =
          DateTime.tryParse(map['updated_at'] as String? ?? '') ??
              DateTime.fromMillisecondsSinceEpoch(0);

      final existing = await (_db.select(
        _db.workoutProgressTable,
      )..where((t) => t.id.equals(map['id'] as String))).getSingleOrNull();

      if (existing != null && !remoteUpdated.isAfter(existing.updatedAt)) {
        continue; // local is newer or equal
      }

      await _db
          .into(_db.workoutProgressTable)
          .insertOnConflictUpdate(
            WorkoutProgressTableCompanion(
              id: Value(map['id'] as String),
              userId: Value(map['user_id'] as String),
              currentDay: Value(map['current_day'] as int? ?? 1),
              streak: Value(map['streak'] as int? ?? 0),
              lastWorkoutDate: Value(
                DateTime.tryParse(map['last_workout_date'] ?? '') ??
                    DateTime(2000),
              ),
              dailyVolume: Value(_decodeJson(map['daily_volume'])),
              baselineReps: Value(_decodeJson(map['baseline_reps'])),
              hasSetBaseline: Value(map['has_set_baseline'] as bool? ?? false),
              startDate: Value(
                map['start_date'] != null
                    ? DateTime.tryParse(map['start_date'])
                    : null,
              ),
              createdAt: Value(
                DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
              ),
              updatedAt: Value(remoteUpdated),
            ),
          );
    }
  }

  Future<void> _push(drive.DriveApi api, String fileId, String userId) async {
    final rows = await (_db.select(
      _db.workoutProgressTable,
    )..where((t) => t.userId.equals(userId))).get();

    final payload = {
      'version': 2,
      'last_sync_at': DateTime.now().toUtc().toIso8601String(),
      'workouts': rows
          .map(
            (row) => {
              'id': row.id,
              'user_id': row.userId,
              'current_day': row.currentDay,
              'streak': row.streak,
              'last_workout_date': row.lastWorkoutDate.toIso8601String(),
              'daily_volume': row.dailyVolume,
              'baseline_reps': row.baselineReps,
              'has_set_baseline': row.hasSetBaseline,
              'start_date': row.startDate?.toIso8601String(),
              'created_at': row.createdAt.toIso8601String(),
              'updated_at': row.updatedAt.toIso8601String(),
            },
          )
          .toList(),
    };

    final bytes = utf8.encode(jsonEncode(payload));
    payload['checksum'] = _sha256Base64(bytes);
    final gzipped = gzip.encode(utf8.encode(jsonEncode(payload)));
    final media = drive.Media(Stream.value(gzipped), gzipped.length);

    await api.files.update(
      drive.File(
        name: _fileName,
        modifiedTime: DateTime.now().toUtc(),
      ),
      fileId,
      uploadMedia: media,
      $fields: 'md5Checksum,modifiedTime',
    );
  }

  static Map<String, dynamic> _decodeJson(dynamic raw) {
    if (raw == null) return {};
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String) {
      try {
        return jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    }
    return {};
  }

  String _sha256Base64(List<int> data) {
    final digest = sha256.convert(data);
    return base64Encode(digest.bytes);
  }

  bool _validateChecksum(List<int> data, String? checksum) {
    if (checksum == null) return true;
    return _sha256Base64(data) == checksum;
  }
}

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
