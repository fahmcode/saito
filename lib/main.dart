import 'app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:saito/core/secrets.dart';
import 'package:saito/core/data/models/workout_progress.dart';
import 'package:saito/core/data/models/app_preferences.dart';
import 'package:saito/core/data/models/security_config.dart';
import 'package:saito/core/data/models/legacy_user_progress.dart';
import 'package:saito/core/data/repositories/app_repository.dart';
import 'package:saito/core/data/sources/database_service.dart';
import 'package:saito/core/data/sources/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── 1. Supabase ──────────────────────────────────────────
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // ── 2. Local Drift/SQLite ────────────────────────────────
  final dbService = DatabaseService();
  await dbService.init();

  // ── 3. Legacy Hive (migration only) ──────────────────────
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutProgressAdapter());
  Hive.registerAdapter(AppPreferencesAdapter());
  Hive.registerAdapter(SecurityConfigAdapter());

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(LegacyUserProgressAdapter(0));
  }
  if (!Hive.isAdapterRegistered(32)) {
    Hive.registerAdapter(LegacyUserProgressAdapter(32));
  }

  // ── 4. Resolve user ID ───────────────────────────────────
  final supabaseUser = Supabase.instance.client.auth.currentUser;
  final userId = supabaseUser?.id ?? 'anon-local-user';

  // ── 5. Repository + migrations ───────────────────────────
  final prefs = await SharedPreferences.getInstance();
  final syncService = SyncService(dbService.database);
  final repository = AppRepository(
    db: dbService.database,
    userId: userId,
    prefs: prefs,
    sync: syncService,
  );

  try {
    await AppRepository.migrateFromLegacy();
    await repository.migrateToSync();
  } catch (_) {
    // Migration failed — safe to skip, defaults will be used.
  }

  // ── 6. Background sync (fire-and-forget) ─────────────────
  syncService.sync().catchError((_) {
    // Sync failed silently — app still works offline.
  });

  runApp(SaitoApp(repository: repository));
}
