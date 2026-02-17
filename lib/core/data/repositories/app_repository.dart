import 'package:drift/drift.dart' as drift;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saito/core/data/sources/database.dart';
import 'package:saito/core/data/sources/sync_service.dart';
import 'package:saito/core/data/models/workout_progress.dart';
import 'package:saito/core/data/models/app_preferences.dart';
import 'package:saito/core/data/models/security_config.dart';
import 'package:saito/core/data/models/legacy_user_progress.dart';

/// Central repository that owns the Drift database and provides
/// typed access to the 3 domain models with cloud sync support.
class AppRepository {
  final AppDatabase _db;
  final SyncService? _sync;
  final SharedPreferences _prefs;
  final String _userId;

  static const _key = 'current';
  static const _onboardingKey = 'onboarding_complete';

  AppRepository({
    required AppDatabase db,
    required String userId,
    required SharedPreferences prefs,
    SyncService? sync,
  }) : _db = db,
       _userId = userId,
       _prefs = prefs,
       _sync = sync;

  // ── Workout Progress ──────────────────────────────────────

  Future<WorkoutProgress> getWorkout() async {
    final query = _db.select(_db.workoutProgressTable)
      ..where((t) => t.userId.equals(_userId));
    final row = await query.getSingleOrNull();

    if (row == null) {
      return WorkoutProgress(lastWorkoutDate: DateTime(2000));
    }

    return WorkoutProgress(
      currentDay: row.currentDay,
      streak: row.streak,
      lastWorkoutDate: row.lastWorkoutDate,
      dailyVolume: _castDailyVolume(row.dailyVolume),
      baselineReps: _castBaselineReps(row.baselineReps),
      hasSetBaseline: row.hasSetBaseline,
      startDate: row.startDate,
    );
  }

  Future<void> saveWorkout(WorkoutProgress progress) async {
    await _db
        .into(_db.workoutProgressTable)
        .insertOnConflictUpdate(
          WorkoutProgressTableCompanion.insert(
            userId: _userId,
            currentDay: drift.Value(progress.currentDay),
            streak: drift.Value(progress.streak),
            lastWorkoutDate: drift.Value(progress.lastWorkoutDate),
            dailyVolume: <String, dynamic>{
              for (var e in progress.dailyVolume.entries)
                e.key.toString(): e.value,
            },
            baselineReps: <String, dynamic>{...progress.baselineReps},
            hasSetBaseline: drift.Value(progress.hasSetBaseline),
            startDate: drift.Value(progress.startDate),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
    _sync?.pushWorkout().catchError((_) {});
  }

  // ── App Preferences ───────────────────────────────────────

  Future<AppPreferences> getPreferences() async {
    final query = _db.select(_db.appPreferencesTable)
      ..where((t) => t.userId.equals(_userId));
    final row = await query.getSingleOrNull();

    if (row == null) return AppPreferences();

    return AppPreferences(
      audioEnabled: row.audioEnabled,
      hapticsEnabled: row.hapticsEnabled,
      themeMode: row.themeMode,
      onboardingComplete: _prefs.getBool(_onboardingKey) ?? false,
    );
  }

  Future<void> savePreferences(AppPreferences prefs) async {
    await _prefs.setBool(_onboardingKey, prefs.onboardingComplete);
    await _db
        .into(_db.appPreferencesTable)
        .insertOnConflictUpdate(
          AppPreferencesTableCompanion.insert(
            userId: _userId,
            audioEnabled: drift.Value(prefs.audioEnabled),
            hapticsEnabled: drift.Value(prefs.hapticsEnabled),
            themeMode: drift.Value(prefs.themeMode),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
    _sync?.pushPreferences().catchError((_) {});
  }

  // ── Security Config ───────────────────────────────────────

  Future<SecurityConfig> getSecurity() async {
    final query = _db.select(_db.securityConfigTable)
      ..where((t) => t.userId.equals(_userId));
    final row = await query.getSingleOrNull();

    if (row == null) return SecurityConfig();

    return SecurityConfig(
      securityEnabled: row.securityEnabled,
      securityPin: row.securityPin,
      biometricEnabled: row.biometricEnabled,
      lockDurationMinutes: row.lockDurationMinutes,
    );
  }

  Future<void> saveSecurity(SecurityConfig config) async {
    await _db
        .into(_db.securityConfigTable)
        .insertOnConflictUpdate(
          SecurityConfigTableCompanion.insert(
            userId: _userId,
            securityEnabled: drift.Value(config.securityEnabled),
            securityPin: drift.Value(config.securityPin),
            biometricEnabled: drift.Value(config.biometricEnabled),
            lockDurationMinutes: drift.Value(config.lockDurationMinutes),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
    _sync?.pushSecurity().catchError((_) {});
  }

  // ── Migration ─────────────────────────────────────────────

  /// Moves data from Hive boxes to Drift/SQL.
  Future<void> migrateToSync() async {
    final workoutBox = await Hive.openBox<WorkoutProgress>('workout_box');
    final prefsBox = await Hive.openBox<AppPreferences>('prefs_box');
    final securityBox = await Hive.openBox<SecurityConfig>('security_box');

    final workout = workoutBox.get(_key);
    if (workout != null) {
      await saveWorkout(workout);
      await workoutBox.delete(_key);
    }

    final prefs = prefsBox.get(_key);
    if (prefs != null) {
      await savePreferences(prefs);
      await prefsBox.delete(_key);
    }

    final security = securityBox.get(_key);
    if (security != null) {
      await saveSecurity(security);
      await securityBox.delete(_key);
    }

    await workoutBox.close();
    await prefsBox.close();
    await securityBox.close();
  }

  /// One-time migration from old single-box UserProgress to new split models.
  /// Call this on app startup. Safe to call multiple times (idempotent).
  static Future<void> migrateFromLegacy() async {
    Box? legacyBox;
    try {
      legacyBox = await Hive.openBox('user_progress_box');
    } catch (e) {
      // If we can't open the box (e.g. unknown typeId), we can't migrate.
      // Better to return and let the app start with defaults than crash.
      return;
    }

    final legacy = legacyBox.get(_key);
    if (legacy == null) {
      await legacyBox.close();
      return;
    }

    // Already migrated check: if new boxes have data, skip
    final workoutBox = await Hive.openBox<WorkoutProgress>('workout_box');
    if (workoutBox.get(_key) != null) {
      await legacyBox.close();
      return;
    }

    // The legacy object might be a UserProgress instance, LegacyUserProgress, or a Map
    try {
      Map<dynamic, dynamic> raw;

      if (legacy is LegacyUserProgress) {
        raw = {
          'currentDay': legacy.currentDay,
          'streak': legacy.streak,
          'lastWorkoutDate': legacy.lastWorkoutDate,
          'dailyVolume': legacy.dailyVolume,
          'baselineReps': legacy.baselineReps,
          'hasSetBaseline': legacy.hasSetBaseline,
          'audioEnabled': legacy.audioEnabled,
          'hapticsEnabled': legacy.hapticsEnabled,
          'securityEnabled': legacy.securityEnabled,
          'securityPin': legacy.securityPin,
          'biometricEnabled': legacy.biometricEnabled,
          'lockDurationMinutes': legacy.lockDurationMinutes,
          'themeMode': legacy.themeMode,
          'startDate': legacy.startDate,
        };
      } else if (legacy is Map) {
        raw = legacy;
      } else {
        raw = legacyBox.toMap()[_key] as Map? ?? {};
      }

      final workoutProgress = WorkoutProgress(
        currentDay: (raw['currentDay'] ?? 1) as int,
        streak: (raw['streak'] ?? 0) as int,
        lastWorkoutDate: (raw['lastWorkoutDate'] ?? DateTime(2000)) as DateTime,
        dailyVolume: _castDailyVolume(raw['dailyVolume']),
        baselineReps: _castBaselineReps(raw['baselineReps']),
        hasSetBaseline: (raw['hasSetBaseline'] ?? false) as bool,
        startDate: raw['startDate'] as DateTime?,
      );
      await workoutBox.put(_key, workoutProgress);

      final prefsBox = await Hive.openBox<AppPreferences>('prefs_box');
      final prefs = AppPreferences(
        audioEnabled: (raw['audioEnabled'] ?? true) as bool,
        hapticsEnabled: (raw['hapticsEnabled'] ?? true) as bool,
        themeMode: (raw['themeMode'] ?? 'system') as String,
      );
      await prefsBox.put(_key, prefs);

      final securityBox = await Hive.openBox<SecurityConfig>('security_box');
      final security = SecurityConfig(
        securityEnabled: (raw['securityEnabled'] ?? false) as bool,
        securityPin: raw['securityPin'] as String?,
        biometricEnabled: (raw['biometricEnabled'] ?? false) as bool,
        lockDurationMinutes: (raw['lockDurationMinutes'] ?? 0) as int,
      );
      await securityBox.put(_key, security);

      // Optional: Delete/Clear legacy data to avoid re-migration
      // await legacyBox.clear();
    } catch (_) {
      // Migration failed — safe to skip, new defaults will be used.
    } finally {
      await legacyBox.close();
    }
  }

  static Map<int, List<int>> _castDailyVolume(dynamic raw) {
    if (raw == null) return {};
    if (raw is Map<int, List<int>>) return raw;
    final map = <int, List<int>>{};
    (raw as Map).forEach((key, value) {
      final day = key is int ? key : int.tryParse(key.toString()) ?? 1;
      map[day] = (value as List).cast<int>();
    });
    return map;
  }

  static Map<String, int> _castBaselineReps(dynamic raw) {
    if (raw == null) return {'armor': 20, 'foundation': 20, 'shred': 10};
    if (raw is Map<String, int>) return raw;
    final map = <String, int>{};
    (raw as Map).forEach((key, value) {
      map[key as String] = value as int;
    });
    return map;
  }
}
