import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

class WorkoutProgressTable extends Table {
  @override
  String get tableName => 'workout_progress';

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text()();
  IntColumn get currentDay => integer().withDefault(const Constant(1))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastWorkoutDate =>
      dateTime().withDefault(Constant(DateTime(2000)))();

  // Stored as JSON strings in SQLite, JSONB in Postgres
  TextColumn get dailyVolume => text().map(const JsonConverter())();
  TextColumn get baselineReps => text().map(const JsonConverter())();

  BoolColumn get hasSetBaseline =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class AppPreferencesTable extends Table {
  @override
  String get tableName => 'app_preferences';

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text()();
  BoolColumn get audioEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get hapticsEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SecurityConfigTable extends Table {
  @override
  String get tableName => 'security_config';

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text()();
  BoolColumn get securityEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get securityPin => text().nullable()();
  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get lockDurationMinutes =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class JsonConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return jsonDecode(fromDb) as Map<String, dynamic>;
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return jsonEncode(value);
  }
}

@DriftDatabase(
  tables: [WorkoutProgressTable, AppPreferencesTable, SecurityConfigTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
