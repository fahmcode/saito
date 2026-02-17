import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:saito/core/data/sources/database.dart';

/// Lightweight sync layer that pushes local changes to Supabase
/// and pulls remote changes back. Uses `updated_at` for
/// last-write-wins conflict resolution.
class SyncService {
  final AppDatabase _db;
  SyncService(this._db);

  SupabaseClient get _client => Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  // ── Public API ────────────────────────────────────────────

  /// Full sync: push then pull.
  Future<void> sync() async {
    if (_userId == null) return; // not signed in
    await pushAll();
    await pullAll();
  }

  // ── Push (local → Supabase) ───────────────────────────────

  Future<void> pushAll() async {
    if (_userId == null) return;
    await pushWorkout();
    await pushPreferences();
    await pushSecurity();
  }

  Future<void> pushWorkout() async {
    if (_userId == null) return;
    final rows = await (_db.select(
      _db.workoutProgressTable,
    )..where((t) => t.userId.equals(_userId!))).get();
    for (final row in rows) {
      await _client.from('workout_progress').upsert({
        'id': row.id,
        'user_id': row.userId,
        'current_day': row.currentDay,
        'streak': row.streak,
        'last_workout_date': row.lastWorkoutDate.toIso8601String(),
        'daily_volume': jsonEncode(row.dailyVolume),
        'baseline_reps': jsonEncode(row.baselineReps),
        'has_set_baseline': row.hasSetBaseline,
        'start_date': row.startDate?.toIso8601String(),
        'created_at': row.createdAt.toIso8601String(),
        'updated_at': row.updatedAt.toIso8601String(),
      });
    }
  }

  Future<void> pushPreferences() async {
    if (_userId == null) return;
    final rows = await (_db.select(
      _db.appPreferencesTable,
    )..where((t) => t.userId.equals(_userId!))).get();
    for (final row in rows) {
      await _client.from('app_preferences').upsert({
        'id': row.id,
        'user_id': row.userId,
        'audio_enabled': row.audioEnabled,
        'haptics_enabled': row.hapticsEnabled,
        'theme_mode': row.themeMode,
        'created_at': row.createdAt.toIso8601String(),
        'updated_at': row.updatedAt.toIso8601String(),
      });
    }
  }

  Future<void> pushSecurity() async {
    if (_userId == null) return;
    final rows = await (_db.select(
      _db.securityConfigTable,
    )..where((t) => t.userId.equals(_userId!))).get();
    for (final row in rows) {
      await _client.from('security_config').upsert({
        'id': row.id,
        'user_id': row.userId,
        'security_enabled': row.securityEnabled,
        'security_pin': row.securityPin,
        'biometric_enabled': row.biometricEnabled,
        'lock_duration_minutes': row.lockDurationMinutes,
        'created_at': row.createdAt.toIso8601String(),
        'updated_at': row.updatedAt.toIso8601String(),
      });
    }
  }

  // ── Pull (Supabase → local) ───────────────────────────────

  Future<void> pullAll() async {
    if (_userId == null) return;
    await _pullWorkout();
    await _pullPreferences();
    await _pullSecurity();
  }

  Future<void> _pullWorkout() async {
    final remote = await _client
        .from('workout_progress')
        .select()
        .eq('user_id', _userId!);

    for (final row in remote) {
      await _db
          .into(_db.workoutProgressTable)
          .insertOnConflictUpdate(
            WorkoutProgressTableCompanion.insert(
              id: Value(row['id'] as String),
              userId: row['user_id'] as String,
              currentDay: Value(row['current_day'] as int? ?? 1),
              streak: Value(row['streak'] as int? ?? 0),
              lastWorkoutDate: Value(
                DateTime.tryParse(row['last_workout_date'] ?? '') ??
                    DateTime(2000),
              ),
              dailyVolume: _decodeJson(row['daily_volume']),
              baselineReps: _decodeJson(row['baseline_reps']),
              hasSetBaseline: Value(row['has_set_baseline'] as bool? ?? false),
              startDate: Value(
                row['start_date'] != null
                    ? DateTime.tryParse(row['start_date'])
                    : null,
              ),
              createdAt: Value(
                DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
              ),
              updatedAt: Value(
                DateTime.tryParse(row['updated_at'] ?? '') ?? DateTime.now(),
              ),
            ),
          );
    }
  }

  Future<void> _pullPreferences() async {
    final remote = await _client
        .from('app_preferences')
        .select()
        .eq('user_id', _userId!);

    for (final row in remote) {
      await _db
          .into(_db.appPreferencesTable)
          .insertOnConflictUpdate(
            AppPreferencesTableCompanion.insert(
              id: Value(row['id'] as String),
              userId: row['user_id'] as String,
              audioEnabled: Value(row['audio_enabled'] as bool? ?? true),
              hapticsEnabled: Value(row['haptics_enabled'] as bool? ?? true),
              themeMode: Value(row['theme_mode'] as String? ?? 'system'),
              createdAt: Value(
                DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
              ),
              updatedAt: Value(
                DateTime.tryParse(row['updated_at'] ?? '') ?? DateTime.now(),
              ),
            ),
          );
    }
  }

  Future<void> _pullSecurity() async {
    final remote = await _client
        .from('security_config')
        .select()
        .eq('user_id', _userId!);

    for (final row in remote) {
      await _db
          .into(_db.securityConfigTable)
          .insertOnConflictUpdate(
            SecurityConfigTableCompanion.insert(
              id: Value(row['id'] as String),
              userId: row['user_id'] as String,
              securityEnabled: Value(row['security_enabled'] as bool? ?? false),
              securityPin: Value(row['security_pin'] as String?),
              biometricEnabled: Value(
                row['biometric_enabled'] as bool? ?? false,
              ),
              lockDurationMinutes: Value(
                row['lock_duration_minutes'] as int? ?? 0,
              ),
              createdAt: Value(
                DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
              ),
              updatedAt: Value(
                DateTime.tryParse(row['updated_at'] ?? '') ?? DateTime.now(),
              ),
            ),
          );
    }
  }

  // ── Helpers ───────────────────────────────────────────────

  /// Decode a JSON value that may already be a Map (from Supabase JSONB)
  /// or a JSON string.
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
}
