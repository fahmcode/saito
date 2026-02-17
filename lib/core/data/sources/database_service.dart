import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:saito/core/data/sources/database.dart';

/// Singleton service that owns the native Drift/SQLite database.
/// Replaces the old PowerSyncService.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  late final AppDatabase _db;

  /// Open the local SQLite database.
  Future<void> init() async {
    _db = AppDatabase(SqfliteQueryExecutor.inDatabaseFolder(path: 'saito.db'));
  }

  AppDatabase get database => _db;
}
