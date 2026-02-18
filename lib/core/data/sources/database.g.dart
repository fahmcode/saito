// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WorkoutProgressTableTable extends WorkoutProgressTable
    with TableInfo<$WorkoutProgressTableTable, WorkoutProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentDayMeta =
      const VerificationMeta('currentDay');
  @override
  late final GeneratedColumn<int> currentDay = GeneratedColumn<int>(
      'current_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
      'streak', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastWorkoutDateMeta =
      const VerificationMeta('lastWorkoutDate');
  @override
  late final GeneratedColumn<DateTime> lastWorkoutDate =
      GeneratedColumn<DateTime>('last_workout_date', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: Constant(DateTime(2000)));
  static const VerificationMeta _dailyVolumeMeta =
      const VerificationMeta('dailyVolume');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      dailyVolume = GeneratedColumn<String>('daily_volume', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $WorkoutProgressTableTable.$converterdailyVolume);
  static const VerificationMeta _baselineRepsMeta =
      const VerificationMeta('baselineReps');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      baselineReps = GeneratedColumn<String>(
              'baseline_reps', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $WorkoutProgressTableTable.$converterbaselineReps);
  static const VerificationMeta _hasSetBaselineMeta =
      const VerificationMeta('hasSetBaseline');
  @override
  late final GeneratedColumn<bool> hasSetBaseline = GeneratedColumn<bool>(
      'has_set_baseline', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_set_baseline" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        currentDay,
        streak,
        lastWorkoutDate,
        dailyVolume,
        baselineReps,
        hasSetBaseline,
        startDate,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_progress';
  @override
  VerificationContext validateIntegrity(
      Insertable<WorkoutProgressTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('current_day')) {
      context.handle(
          _currentDayMeta,
          currentDay.isAcceptableOrUnknown(
              data['current_day']!, _currentDayMeta));
    }
    if (data.containsKey('streak')) {
      context.handle(_streakMeta,
          streak.isAcceptableOrUnknown(data['streak']!, _streakMeta));
    }
    if (data.containsKey('last_workout_date')) {
      context.handle(
          _lastWorkoutDateMeta,
          lastWorkoutDate.isAcceptableOrUnknown(
              data['last_workout_date']!, _lastWorkoutDateMeta));
    }
    context.handle(_dailyVolumeMeta, const VerificationResult.success());
    context.handle(_baselineRepsMeta, const VerificationResult.success());
    if (data.containsKey('has_set_baseline')) {
      context.handle(
          _hasSetBaselineMeta,
          hasSetBaseline.isAcceptableOrUnknown(
              data['has_set_baseline']!, _hasSetBaselineMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutProgressTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutProgressTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      currentDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}current_day'])!,
      streak: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}streak'])!,
      lastWorkoutDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_workout_date'])!,
      dailyVolume: $WorkoutProgressTableTable.$converterdailyVolume.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}daily_volume'])!),
      baselineReps: $WorkoutProgressTableTable.$converterbaselineReps.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}baseline_reps'])!),
      hasSetBaseline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_set_baseline'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WorkoutProgressTableTable createAlias(String alias) {
    return $WorkoutProgressTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converterdailyVolume =
      const JsonConverter();
  static TypeConverter<Map<String, dynamic>, String> $converterbaselineReps =
      const JsonConverter();
}

class WorkoutProgressTableData extends DataClass
    implements Insertable<WorkoutProgressTableData> {
  final String id;
  final String userId;
  final int currentDay;
  final int streak;
  final DateTime lastWorkoutDate;
  final Map<String, dynamic> dailyVolume;
  final Map<String, dynamic> baselineReps;
  final bool hasSetBaseline;
  final DateTime? startDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkoutProgressTableData(
      {required this.id,
      required this.userId,
      required this.currentDay,
      required this.streak,
      required this.lastWorkoutDate,
      required this.dailyVolume,
      required this.baselineReps,
      required this.hasSetBaseline,
      this.startDate,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['current_day'] = Variable<int>(currentDay);
    map['streak'] = Variable<int>(streak);
    map['last_workout_date'] = Variable<DateTime>(lastWorkoutDate);
    {
      map['daily_volume'] = Variable<String>(
          $WorkoutProgressTableTable.$converterdailyVolume.toSql(dailyVolume));
    }
    {
      map['baseline_reps'] = Variable<String>($WorkoutProgressTableTable
          .$converterbaselineReps
          .toSql(baselineReps));
    }
    map['has_set_baseline'] = Variable<bool>(hasSetBaseline);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutProgressTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutProgressTableCompanion(
      id: Value(id),
      userId: Value(userId),
      currentDay: Value(currentDay),
      streak: Value(streak),
      lastWorkoutDate: Value(lastWorkoutDate),
      dailyVolume: Value(dailyVolume),
      baselineReps: Value(baselineReps),
      hasSetBaseline: Value(hasSetBaseline),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutProgressTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutProgressTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      currentDay: serializer.fromJson<int>(json['currentDay']),
      streak: serializer.fromJson<int>(json['streak']),
      lastWorkoutDate: serializer.fromJson<DateTime>(json['lastWorkoutDate']),
      dailyVolume:
          serializer.fromJson<Map<String, dynamic>>(json['dailyVolume']),
      baselineReps:
          serializer.fromJson<Map<String, dynamic>>(json['baselineReps']),
      hasSetBaseline: serializer.fromJson<bool>(json['hasSetBaseline']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'currentDay': serializer.toJson<int>(currentDay),
      'streak': serializer.toJson<int>(streak),
      'lastWorkoutDate': serializer.toJson<DateTime>(lastWorkoutDate),
      'dailyVolume': serializer.toJson<Map<String, dynamic>>(dailyVolume),
      'baselineReps': serializer.toJson<Map<String, dynamic>>(baselineReps),
      'hasSetBaseline': serializer.toJson<bool>(hasSetBaseline),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkoutProgressTableData copyWith(
          {String? id,
          String? userId,
          int? currentDay,
          int? streak,
          DateTime? lastWorkoutDate,
          Map<String, dynamic>? dailyVolume,
          Map<String, dynamic>? baselineReps,
          bool? hasSetBaseline,
          Value<DateTime?> startDate = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WorkoutProgressTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        currentDay: currentDay ?? this.currentDay,
        streak: streak ?? this.streak,
        lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
        dailyVolume: dailyVolume ?? this.dailyVolume,
        baselineReps: baselineReps ?? this.baselineReps,
        hasSetBaseline: hasSetBaseline ?? this.hasSetBaseline,
        startDate: startDate.present ? startDate.value : this.startDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WorkoutProgressTableData copyWithCompanion(
      WorkoutProgressTableCompanion data) {
    return WorkoutProgressTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      currentDay:
          data.currentDay.present ? data.currentDay.value : this.currentDay,
      streak: data.streak.present ? data.streak.value : this.streak,
      lastWorkoutDate: data.lastWorkoutDate.present
          ? data.lastWorkoutDate.value
          : this.lastWorkoutDate,
      dailyVolume:
          data.dailyVolume.present ? data.dailyVolume.value : this.dailyVolume,
      baselineReps: data.baselineReps.present
          ? data.baselineReps.value
          : this.baselineReps,
      hasSetBaseline: data.hasSetBaseline.present
          ? data.hasSetBaseline.value
          : this.hasSetBaseline,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutProgressTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('currentDay: $currentDay, ')
          ..write('streak: $streak, ')
          ..write('lastWorkoutDate: $lastWorkoutDate, ')
          ..write('dailyVolume: $dailyVolume, ')
          ..write('baselineReps: $baselineReps, ')
          ..write('hasSetBaseline: $hasSetBaseline, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      currentDay,
      streak,
      lastWorkoutDate,
      dailyVolume,
      baselineReps,
      hasSetBaseline,
      startDate,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutProgressTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.currentDay == this.currentDay &&
          other.streak == this.streak &&
          other.lastWorkoutDate == this.lastWorkoutDate &&
          other.dailyVolume == this.dailyVolume &&
          other.baselineReps == this.baselineReps &&
          other.hasSetBaseline == this.hasSetBaseline &&
          other.startDate == this.startDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutProgressTableCompanion
    extends UpdateCompanion<WorkoutProgressTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> currentDay;
  final Value<int> streak;
  final Value<DateTime> lastWorkoutDate;
  final Value<Map<String, dynamic>> dailyVolume;
  final Value<Map<String, dynamic>> baselineReps;
  final Value<bool> hasSetBaseline;
  final Value<DateTime?> startDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkoutProgressTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.currentDay = const Value.absent(),
    this.streak = const Value.absent(),
    this.lastWorkoutDate = const Value.absent(),
    this.dailyVolume = const Value.absent(),
    this.baselineReps = const Value.absent(),
    this.hasSetBaseline = const Value.absent(),
    this.startDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutProgressTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.currentDay = const Value.absent(),
    this.streak = const Value.absent(),
    this.lastWorkoutDate = const Value.absent(),
    required Map<String, dynamic> dailyVolume,
    required Map<String, dynamic> baselineReps,
    this.hasSetBaseline = const Value.absent(),
    this.startDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        dailyVolume = Value(dailyVolume),
        baselineReps = Value(baselineReps);
  static Insertable<WorkoutProgressTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? currentDay,
    Expression<int>? streak,
    Expression<DateTime>? lastWorkoutDate,
    Expression<String>? dailyVolume,
    Expression<String>? baselineReps,
    Expression<bool>? hasSetBaseline,
    Expression<DateTime>? startDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (currentDay != null) 'current_day': currentDay,
      if (streak != null) 'streak': streak,
      if (lastWorkoutDate != null) 'last_workout_date': lastWorkoutDate,
      if (dailyVolume != null) 'daily_volume': dailyVolume,
      if (baselineReps != null) 'baseline_reps': baselineReps,
      if (hasSetBaseline != null) 'has_set_baseline': hasSetBaseline,
      if (startDate != null) 'start_date': startDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutProgressTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? currentDay,
      Value<int>? streak,
      Value<DateTime>? lastWorkoutDate,
      Value<Map<String, dynamic>>? dailyVolume,
      Value<Map<String, dynamic>>? baselineReps,
      Value<bool>? hasSetBaseline,
      Value<DateTime?>? startDate,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return WorkoutProgressTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentDay: currentDay ?? this.currentDay,
      streak: streak ?? this.streak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      dailyVolume: dailyVolume ?? this.dailyVolume,
      baselineReps: baselineReps ?? this.baselineReps,
      hasSetBaseline: hasSetBaseline ?? this.hasSetBaseline,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (currentDay.present) {
      map['current_day'] = Variable<int>(currentDay.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (lastWorkoutDate.present) {
      map['last_workout_date'] = Variable<DateTime>(lastWorkoutDate.value);
    }
    if (dailyVolume.present) {
      map['daily_volume'] = Variable<String>($WorkoutProgressTableTable
          .$converterdailyVolume
          .toSql(dailyVolume.value));
    }
    if (baselineReps.present) {
      map['baseline_reps'] = Variable<String>($WorkoutProgressTableTable
          .$converterbaselineReps
          .toSql(baselineReps.value));
    }
    if (hasSetBaseline.present) {
      map['has_set_baseline'] = Variable<bool>(hasSetBaseline.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutProgressTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('currentDay: $currentDay, ')
          ..write('streak: $streak, ')
          ..write('lastWorkoutDate: $lastWorkoutDate, ')
          ..write('dailyVolume: $dailyVolume, ')
          ..write('baselineReps: $baselineReps, ')
          ..write('hasSetBaseline: $hasSetBaseline, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppPreferencesTableTable extends AppPreferencesTable
    with TableInfo<$AppPreferencesTableTable, AppPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioEnabledMeta =
      const VerificationMeta('audioEnabled');
  @override
  late final GeneratedColumn<bool> audioEnabled = GeneratedColumn<bool>(
      'audio_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("audio_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _hapticsEnabledMeta =
      const VerificationMeta('hapticsEnabled');
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
      'haptics_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("haptics_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('system'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        audioEnabled,
        hapticsEnabled,
        themeMode,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_preferences';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppPreferencesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('audio_enabled')) {
      context.handle(
          _audioEnabledMeta,
          audioEnabled.isAcceptableOrUnknown(
              data['audio_enabled']!, _audioEnabledMeta));
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
          _hapticsEnabledMeta,
          hapticsEnabled.isAcceptableOrUnknown(
              data['haptics_enabled']!, _hapticsEnabledMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppPreferencesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPreferencesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      audioEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}audio_enabled'])!,
      hapticsEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}haptics_enabled'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppPreferencesTableTable createAlias(String alias) {
    return $AppPreferencesTableTable(attachedDatabase, alias);
  }
}

class AppPreferencesTableData extends DataClass
    implements Insertable<AppPreferencesTableData> {
  final String id;
  final String userId;
  final bool audioEnabled;
  final bool hapticsEnabled;
  final String themeMode;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppPreferencesTableData(
      {required this.id,
      required this.userId,
      required this.audioEnabled,
      required this.hapticsEnabled,
      required this.themeMode,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['audio_enabled'] = Variable<bool>(audioEnabled);
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    map['theme_mode'] = Variable<String>(themeMode);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return AppPreferencesTableCompanion(
      id: Value(id),
      userId: Value(userId),
      audioEnabled: Value(audioEnabled),
      hapticsEnabled: Value(hapticsEnabled),
      themeMode: Value(themeMode),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppPreferencesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPreferencesTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      audioEnabled: serializer.fromJson<bool>(json['audioEnabled']),
      hapticsEnabled: serializer.fromJson<bool>(json['hapticsEnabled']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'audioEnabled': serializer.toJson<bool>(audioEnabled),
      'hapticsEnabled': serializer.toJson<bool>(hapticsEnabled),
      'themeMode': serializer.toJson<String>(themeMode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppPreferencesTableData copyWith(
          {String? id,
          String? userId,
          bool? audioEnabled,
          bool? hapticsEnabled,
          String? themeMode,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AppPreferencesTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        audioEnabled: audioEnabled ?? this.audioEnabled,
        hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
        themeMode: themeMode ?? this.themeMode,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppPreferencesTableData copyWithCompanion(AppPreferencesTableCompanion data) {
    return AppPreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      audioEnabled: data.audioEnabled.present
          ? data.audioEnabled.value
          : this.audioEnabled,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('audioEnabled: $audioEnabled, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('themeMode: $themeMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, audioEnabled, hapticsEnabled,
      themeMode, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPreferencesTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.audioEnabled == this.audioEnabled &&
          other.hapticsEnabled == this.hapticsEnabled &&
          other.themeMode == this.themeMode &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppPreferencesTableCompanion
    extends UpdateCompanion<AppPreferencesTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<bool> audioEnabled;
  final Value<bool> hapticsEnabled;
  final Value<String> themeMode;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppPreferencesTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.audioEnabled = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppPreferencesTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.audioEnabled = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<AppPreferencesTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<bool>? audioEnabled,
    Expression<bool>? hapticsEnabled,
    Expression<String>? themeMode,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (audioEnabled != null) 'audio_enabled': audioEnabled,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (themeMode != null) 'theme_mode': themeMode,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppPreferencesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<bool>? audioEnabled,
      Value<bool>? hapticsEnabled,
      Value<String>? themeMode,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AppPreferencesTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      themeMode: themeMode ?? this.themeMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (audioEnabled.present) {
      map['audio_enabled'] = Variable<bool>(audioEnabled.value);
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('audioEnabled: $audioEnabled, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('themeMode: $themeMode, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SecurityConfigTableTable extends SecurityConfigTable
    with TableInfo<$SecurityConfigTableTable, SecurityConfigTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SecurityConfigTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _securityEnabledMeta =
      const VerificationMeta('securityEnabled');
  @override
  late final GeneratedColumn<bool> securityEnabled = GeneratedColumn<bool>(
      'security_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("security_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _securityPinMeta =
      const VerificationMeta('securityPin');
  @override
  late final GeneratedColumn<String> securityPin = GeneratedColumn<String>(
      'security_pin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinSaltMeta =
      const VerificationMeta('pinSalt');
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
      'pin_salt', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pinIterationsMeta =
      const VerificationMeta('pinIterations');
  @override
  late final GeneratedColumn<int> pinIterations = GeneratedColumn<int>(
      'pin_iterations', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _biometricEnabledMeta =
      const VerificationMeta('biometricEnabled');
  @override
  late final GeneratedColumn<bool> biometricEnabled = GeneratedColumn<bool>(
      'biometric_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("biometric_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lockDurationMinutesMeta =
      const VerificationMeta('lockDurationMinutes');
  @override
  late final GeneratedColumn<int> lockDurationMinutes = GeneratedColumn<int>(
      'lock_duration_minutes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _failedAttemptsMeta =
      const VerificationMeta('failedAttempts');
  @override
  late final GeneratedColumn<int> failedAttempts = GeneratedColumn<int>(
      'failed_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nextRetryAtMeta =
      const VerificationMeta('nextRetryAt');
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
      'next_retry_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        securityEnabled,
        securityPin,
        pinHash,
        pinSalt,
        pinIterations,
        biometricEnabled,
        lockDurationMinutes,
        failedAttempts,
        nextRetryAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'security_config';
  @override
  VerificationContext validateIntegrity(
      Insertable<SecurityConfigTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('security_enabled')) {
      context.handle(
          _securityEnabledMeta,
          securityEnabled.isAcceptableOrUnknown(
              data['security_enabled']!, _securityEnabledMeta));
    }
    if (data.containsKey('security_pin')) {
      context.handle(
          _securityPinMeta,
          securityPin.isAcceptableOrUnknown(
              data['security_pin']!, _securityPinMeta));
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    }
    if (data.containsKey('pin_salt')) {
      context.handle(_pinSaltMeta,
          pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta));
    }
    if (data.containsKey('pin_iterations')) {
      context.handle(
          _pinIterationsMeta,
          pinIterations.isAcceptableOrUnknown(
              data['pin_iterations']!, _pinIterationsMeta));
    }
    if (data.containsKey('biometric_enabled')) {
      context.handle(
          _biometricEnabledMeta,
          biometricEnabled.isAcceptableOrUnknown(
              data['biometric_enabled']!, _biometricEnabledMeta));
    }
    if (data.containsKey('lock_duration_minutes')) {
      context.handle(
          _lockDurationMinutesMeta,
          lockDurationMinutes.isAcceptableOrUnknown(
              data['lock_duration_minutes']!, _lockDurationMinutesMeta));
    }
    if (data.containsKey('failed_attempts')) {
      context.handle(
          _failedAttemptsMeta,
          failedAttempts.isAcceptableOrUnknown(
              data['failed_attempts']!, _failedAttemptsMeta));
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
          _nextRetryAtMeta,
          nextRetryAt.isAcceptableOrUnknown(
              data['next_retry_at']!, _nextRetryAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SecurityConfigTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SecurityConfigTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      securityEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}security_enabled'])!,
      securityPin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}security_pin']),
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash']),
      pinSalt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_salt']),
      pinIterations: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pin_iterations']),
      biometricEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}biometric_enabled'])!,
      lockDurationMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}lock_duration_minutes'])!,
      failedAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failed_attempts'])!,
      nextRetryAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_retry_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SecurityConfigTableTable createAlias(String alias) {
    return $SecurityConfigTableTable(attachedDatabase, alias);
  }
}

class SecurityConfigTableData extends DataClass
    implements Insertable<SecurityConfigTableData> {
  final String id;
  final String userId;
  final bool securityEnabled;
  final String? securityPin;
  final String? pinHash;
  final String? pinSalt;
  final int? pinIterations;
  final bool biometricEnabled;
  final int lockDurationMinutes;
  final int failedAttempts;
  final DateTime? nextRetryAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SecurityConfigTableData(
      {required this.id,
      required this.userId,
      required this.securityEnabled,
      this.securityPin,
      this.pinHash,
      this.pinSalt,
      this.pinIterations,
      required this.biometricEnabled,
      required this.lockDurationMinutes,
      required this.failedAttempts,
      this.nextRetryAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['security_enabled'] = Variable<bool>(securityEnabled);
    if (!nullToAbsent || securityPin != null) {
      map['security_pin'] = Variable<String>(securityPin);
    }
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    if (!nullToAbsent || pinSalt != null) {
      map['pin_salt'] = Variable<String>(pinSalt);
    }
    if (!nullToAbsent || pinIterations != null) {
      map['pin_iterations'] = Variable<int>(pinIterations);
    }
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['lock_duration_minutes'] = Variable<int>(lockDurationMinutes);
    map['failed_attempts'] = Variable<int>(failedAttempts);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SecurityConfigTableCompanion toCompanion(bool nullToAbsent) {
    return SecurityConfigTableCompanion(
      id: Value(id),
      userId: Value(userId),
      securityEnabled: Value(securityEnabled),
      securityPin: securityPin == null && nullToAbsent
          ? const Value.absent()
          : Value(securityPin),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
      pinSalt: pinSalt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinSalt),
      pinIterations: pinIterations == null && nullToAbsent
          ? const Value.absent()
          : Value(pinIterations),
      biometricEnabled: Value(biometricEnabled),
      lockDurationMinutes: Value(lockDurationMinutes),
      failedAttempts: Value(failedAttempts),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SecurityConfigTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SecurityConfigTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      securityEnabled: serializer.fromJson<bool>(json['securityEnabled']),
      securityPin: serializer.fromJson<String?>(json['securityPin']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      pinSalt: serializer.fromJson<String?>(json['pinSalt']),
      pinIterations: serializer.fromJson<int?>(json['pinIterations']),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      lockDurationMinutes:
          serializer.fromJson<int>(json['lockDurationMinutes']),
      failedAttempts: serializer.fromJson<int>(json['failedAttempts']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'securityEnabled': serializer.toJson<bool>(securityEnabled),
      'securityPin': serializer.toJson<String?>(securityPin),
      'pinHash': serializer.toJson<String?>(pinHash),
      'pinSalt': serializer.toJson<String?>(pinSalt),
      'pinIterations': serializer.toJson<int?>(pinIterations),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'lockDurationMinutes': serializer.toJson<int>(lockDurationMinutes),
      'failedAttempts': serializer.toJson<int>(failedAttempts),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SecurityConfigTableData copyWith(
          {String? id,
          String? userId,
          bool? securityEnabled,
          Value<String?> securityPin = const Value.absent(),
          Value<String?> pinHash = const Value.absent(),
          Value<String?> pinSalt = const Value.absent(),
          Value<int?> pinIterations = const Value.absent(),
          bool? biometricEnabled,
          int? lockDurationMinutes,
          int? failedAttempts,
          Value<DateTime?> nextRetryAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SecurityConfigTableData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        securityEnabled: securityEnabled ?? this.securityEnabled,
        securityPin: securityPin.present ? securityPin.value : this.securityPin,
        pinHash: pinHash.present ? pinHash.value : this.pinHash,
        pinSalt: pinSalt.present ? pinSalt.value : this.pinSalt,
        pinIterations:
            pinIterations.present ? pinIterations.value : this.pinIterations,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        lockDurationMinutes: lockDurationMinutes ?? this.lockDurationMinutes,
        failedAttempts: failedAttempts ?? this.failedAttempts,
        nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SecurityConfigTableData copyWithCompanion(SecurityConfigTableCompanion data) {
    return SecurityConfigTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      securityEnabled: data.securityEnabled.present
          ? data.securityEnabled.value
          : this.securityEnabled,
      securityPin:
          data.securityPin.present ? data.securityPin.value : this.securityPin,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      pinIterations: data.pinIterations.present
          ? data.pinIterations.value
          : this.pinIterations,
      biometricEnabled: data.biometricEnabled.present
          ? data.biometricEnabled.value
          : this.biometricEnabled,
      lockDurationMinutes: data.lockDurationMinutes.present
          ? data.lockDurationMinutes.value
          : this.lockDurationMinutes,
      failedAttempts: data.failedAttempts.present
          ? data.failedAttempts.value
          : this.failedAttempts,
      nextRetryAt:
          data.nextRetryAt.present ? data.nextRetryAt.value : this.nextRetryAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SecurityConfigTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('securityEnabled: $securityEnabled, ')
          ..write('securityPin: $securityPin, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinIterations: $pinIterations, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('lockDurationMinutes: $lockDurationMinutes, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      securityEnabled,
      securityPin,
      pinHash,
      pinSalt,
      pinIterations,
      biometricEnabled,
      lockDurationMinutes,
      failedAttempts,
      nextRetryAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SecurityConfigTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.securityEnabled == this.securityEnabled &&
          other.securityPin == this.securityPin &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt &&
          other.pinIterations == this.pinIterations &&
          other.biometricEnabled == this.biometricEnabled &&
          other.lockDurationMinutes == this.lockDurationMinutes &&
          other.failedAttempts == this.failedAttempts &&
          other.nextRetryAt == this.nextRetryAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SecurityConfigTableCompanion
    extends UpdateCompanion<SecurityConfigTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<bool> securityEnabled;
  final Value<String?> securityPin;
  final Value<String?> pinHash;
  final Value<String?> pinSalt;
  final Value<int?> pinIterations;
  final Value<bool> biometricEnabled;
  final Value<int> lockDurationMinutes;
  final Value<int> failedAttempts;
  final Value<DateTime?> nextRetryAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SecurityConfigTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.securityEnabled = const Value.absent(),
    this.securityPin = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinIterations = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.lockDurationMinutes = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SecurityConfigTableCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.securityEnabled = const Value.absent(),
    this.securityPin = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinIterations = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.lockDurationMinutes = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<SecurityConfigTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<bool>? securityEnabled,
    Expression<String>? securityPin,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
    Expression<int>? pinIterations,
    Expression<bool>? biometricEnabled,
    Expression<int>? lockDurationMinutes,
    Expression<int>? failedAttempts,
    Expression<DateTime>? nextRetryAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (securityEnabled != null) 'security_enabled': securityEnabled,
      if (securityPin != null) 'security_pin': securityPin,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (pinIterations != null) 'pin_iterations': pinIterations,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (lockDurationMinutes != null)
        'lock_duration_minutes': lockDurationMinutes,
      if (failedAttempts != null) 'failed_attempts': failedAttempts,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SecurityConfigTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<bool>? securityEnabled,
      Value<String?>? securityPin,
      Value<String?>? pinHash,
      Value<String?>? pinSalt,
      Value<int?>? pinIterations,
      Value<bool>? biometricEnabled,
      Value<int>? lockDurationMinutes,
      Value<int>? failedAttempts,
      Value<DateTime?>? nextRetryAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SecurityConfigTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      securityEnabled: securityEnabled ?? this.securityEnabled,
      securityPin: securityPin ?? this.securityPin,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      pinIterations: pinIterations ?? this.pinIterations,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      lockDurationMinutes: lockDurationMinutes ?? this.lockDurationMinutes,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (securityEnabled.present) {
      map['security_enabled'] = Variable<bool>(securityEnabled.value);
    }
    if (securityPin.present) {
      map['security_pin'] = Variable<String>(securityPin.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (pinIterations.present) {
      map['pin_iterations'] = Variable<int>(pinIterations.value);
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (lockDurationMinutes.present) {
      map['lock_duration_minutes'] = Variable<int>(lockDurationMinutes.value);
    }
    if (failedAttempts.present) {
      map['failed_attempts'] = Variable<int>(failedAttempts.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SecurityConfigTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('securityEnabled: $securityEnabled, ')
          ..write('securityPin: $securityPin, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinIterations: $pinIterations, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('lockDurationMinutes: $lockDurationMinutes, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutProgressTableTable workoutProgressTable =
      $WorkoutProgressTableTable(this);
  late final $AppPreferencesTableTable appPreferencesTable =
      $AppPreferencesTableTable(this);
  late final $SecurityConfigTableTable securityConfigTable =
      $SecurityConfigTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [workoutProgressTable, appPreferencesTable, securityConfigTable];
}

typedef $$WorkoutProgressTableTableCreateCompanionBuilder
    = WorkoutProgressTableCompanion Function({
  Value<String> id,
  required String userId,
  Value<int> currentDay,
  Value<int> streak,
  Value<DateTime> lastWorkoutDate,
  required Map<String, dynamic> dailyVolume,
  required Map<String, dynamic> baselineReps,
  Value<bool> hasSetBaseline,
  Value<DateTime?> startDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$WorkoutProgressTableTableUpdateCompanionBuilder
    = WorkoutProgressTableCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<int> currentDay,
  Value<int> streak,
  Value<DateTime> lastWorkoutDate,
  Value<Map<String, dynamic>> dailyVolume,
  Value<Map<String, dynamic>> baselineReps,
  Value<bool> hasSetBaseline,
  Value<DateTime?> startDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$WorkoutProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutProgressTableTable> {
  $$WorkoutProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get currentDay => $composableBuilder(
      column: $table.currentDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastWorkoutDate => $composableBuilder(
      column: $table.lastWorkoutDate,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get dailyVolume => $composableBuilder(
          column: $table.dailyVolume,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get baselineReps => $composableBuilder(
          column: $table.baselineReps,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get hasSetBaseline => $composableBuilder(
      column: $table.hasSetBaseline,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$WorkoutProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutProgressTableTable> {
  $$WorkoutProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get currentDay => $composableBuilder(
      column: $table.currentDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get streak => $composableBuilder(
      column: $table.streak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastWorkoutDate => $composableBuilder(
      column: $table.lastWorkoutDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dailyVolume => $composableBuilder(
      column: $table.dailyVolume, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baselineReps => $composableBuilder(
      column: $table.baselineReps,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasSetBaseline => $composableBuilder(
      column: $table.hasSetBaseline,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutProgressTableTable> {
  $$WorkoutProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get currentDay => $composableBuilder(
      column: $table.currentDay, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<DateTime> get lastWorkoutDate => $composableBuilder(
      column: $table.lastWorkoutDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      get dailyVolume => $composableBuilder(
          column: $table.dailyVolume, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      get baselineReps => $composableBuilder(
          column: $table.baselineReps, builder: (column) => column);

  GeneratedColumn<bool> get hasSetBaseline => $composableBuilder(
      column: $table.hasSetBaseline, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WorkoutProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutProgressTableTable,
    WorkoutProgressTableData,
    $$WorkoutProgressTableTableFilterComposer,
    $$WorkoutProgressTableTableOrderingComposer,
    $$WorkoutProgressTableTableAnnotationComposer,
    $$WorkoutProgressTableTableCreateCompanionBuilder,
    $$WorkoutProgressTableTableUpdateCompanionBuilder,
    (
      WorkoutProgressTableData,
      BaseReferences<_$AppDatabase, $WorkoutProgressTableTable,
          WorkoutProgressTableData>
    ),
    WorkoutProgressTableData,
    PrefetchHooks Function()> {
  $$WorkoutProgressTableTableTableManager(
      _$AppDatabase db, $WorkoutProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutProgressTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutProgressTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> currentDay = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<DateTime> lastWorkoutDate = const Value.absent(),
            Value<Map<String, dynamic>> dailyVolume = const Value.absent(),
            Value<Map<String, dynamic>> baselineReps = const Value.absent(),
            Value<bool> hasSetBaseline = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutProgressTableCompanion(
            id: id,
            userId: userId,
            currentDay: currentDay,
            streak: streak,
            lastWorkoutDate: lastWorkoutDate,
            dailyVolume: dailyVolume,
            baselineReps: baselineReps,
            hasSetBaseline: hasSetBaseline,
            startDate: startDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String userId,
            Value<int> currentDay = const Value.absent(),
            Value<int> streak = const Value.absent(),
            Value<DateTime> lastWorkoutDate = const Value.absent(),
            required Map<String, dynamic> dailyVolume,
            required Map<String, dynamic> baselineReps,
            Value<bool> hasSetBaseline = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutProgressTableCompanion.insert(
            id: id,
            userId: userId,
            currentDay: currentDay,
            streak: streak,
            lastWorkoutDate: lastWorkoutDate,
            dailyVolume: dailyVolume,
            baselineReps: baselineReps,
            hasSetBaseline: hasSetBaseline,
            startDate: startDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkoutProgressTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $WorkoutProgressTableTable,
        WorkoutProgressTableData,
        $$WorkoutProgressTableTableFilterComposer,
        $$WorkoutProgressTableTableOrderingComposer,
        $$WorkoutProgressTableTableAnnotationComposer,
        $$WorkoutProgressTableTableCreateCompanionBuilder,
        $$WorkoutProgressTableTableUpdateCompanionBuilder,
        (
          WorkoutProgressTableData,
          BaseReferences<_$AppDatabase, $WorkoutProgressTableTable,
              WorkoutProgressTableData>
        ),
        WorkoutProgressTableData,
        PrefetchHooks Function()>;
typedef $$AppPreferencesTableTableCreateCompanionBuilder
    = AppPreferencesTableCompanion Function({
  Value<String> id,
  required String userId,
  Value<bool> audioEnabled,
  Value<bool> hapticsEnabled,
  Value<String> themeMode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$AppPreferencesTableTableUpdateCompanionBuilder
    = AppPreferencesTableCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<bool> audioEnabled,
  Value<bool> hapticsEnabled,
  Value<String> themeMode,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AppPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get audioEnabled => $composableBuilder(
      column: $table.audioEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get audioEnabled => $composableBuilder(
      column: $table.audioEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get audioEnabled => $composableBuilder(
      column: $table.audioEnabled, builder: (column) => column);

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
      column: $table.hapticsEnabled, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppPreferencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppPreferencesTableTable,
    AppPreferencesTableData,
    $$AppPreferencesTableTableFilterComposer,
    $$AppPreferencesTableTableOrderingComposer,
    $$AppPreferencesTableTableAnnotationComposer,
    $$AppPreferencesTableTableCreateCompanionBuilder,
    $$AppPreferencesTableTableUpdateCompanionBuilder,
    (
      AppPreferencesTableData,
      BaseReferences<_$AppDatabase, $AppPreferencesTableTable,
          AppPreferencesTableData>
    ),
    AppPreferencesTableData,
    PrefetchHooks Function()> {
  $$AppPreferencesTableTableTableManager(
      _$AppDatabase db, $AppPreferencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPreferencesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppPreferencesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<bool> audioEnabled = const Value.absent(),
            Value<bool> hapticsEnabled = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppPreferencesTableCompanion(
            id: id,
            userId: userId,
            audioEnabled: audioEnabled,
            hapticsEnabled: hapticsEnabled,
            themeMode: themeMode,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String userId,
            Value<bool> audioEnabled = const Value.absent(),
            Value<bool> hapticsEnabled = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppPreferencesTableCompanion.insert(
            id: id,
            userId: userId,
            audioEnabled: audioEnabled,
            hapticsEnabled: hapticsEnabled,
            themeMode: themeMode,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppPreferencesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppPreferencesTableTable,
    AppPreferencesTableData,
    $$AppPreferencesTableTableFilterComposer,
    $$AppPreferencesTableTableOrderingComposer,
    $$AppPreferencesTableTableAnnotationComposer,
    $$AppPreferencesTableTableCreateCompanionBuilder,
    $$AppPreferencesTableTableUpdateCompanionBuilder,
    (
      AppPreferencesTableData,
      BaseReferences<_$AppDatabase, $AppPreferencesTableTable,
          AppPreferencesTableData>
    ),
    AppPreferencesTableData,
    PrefetchHooks Function()>;
typedef $$SecurityConfigTableTableCreateCompanionBuilder
    = SecurityConfigTableCompanion Function({
  Value<String> id,
  required String userId,
  Value<bool> securityEnabled,
  Value<String?> securityPin,
  Value<String?> pinHash,
  Value<String?> pinSalt,
  Value<int?> pinIterations,
  Value<bool> biometricEnabled,
  Value<int> lockDurationMinutes,
  Value<int> failedAttempts,
  Value<DateTime?> nextRetryAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SecurityConfigTableTableUpdateCompanionBuilder
    = SecurityConfigTableCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<bool> securityEnabled,
  Value<String?> securityPin,
  Value<String?> pinHash,
  Value<String?> pinSalt,
  Value<int?> pinIterations,
  Value<bool> biometricEnabled,
  Value<int> lockDurationMinutes,
  Value<int> failedAttempts,
  Value<DateTime?> nextRetryAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SecurityConfigTableTableFilterComposer
    extends Composer<_$AppDatabase, $SecurityConfigTableTable> {
  $$SecurityConfigTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get securityEnabled => $composableBuilder(
      column: $table.securityEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get securityPin => $composableBuilder(
      column: $table.securityPin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinSalt => $composableBuilder(
      column: $table.pinSalt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pinIterations => $composableBuilder(
      column: $table.pinIterations, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lockDurationMinutes => $composableBuilder(
      column: $table.lockDurationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SecurityConfigTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SecurityConfigTableTable> {
  $$SecurityConfigTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get securityEnabled => $composableBuilder(
      column: $table.securityEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get securityPin => $composableBuilder(
      column: $table.securityPin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinSalt => $composableBuilder(
      column: $table.pinSalt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pinIterations => $composableBuilder(
      column: $table.pinIterations,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lockDurationMinutes => $composableBuilder(
      column: $table.lockDurationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SecurityConfigTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SecurityConfigTableTable> {
  $$SecurityConfigTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get securityEnabled => $composableBuilder(
      column: $table.securityEnabled, builder: (column) => column);

  GeneratedColumn<String> get securityPin => $composableBuilder(
      column: $table.securityPin, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<int> get pinIterations => $composableBuilder(
      column: $table.pinIterations, builder: (column) => column);

  GeneratedColumn<bool> get biometricEnabled => $composableBuilder(
      column: $table.biometricEnabled, builder: (column) => column);

  GeneratedColumn<int> get lockDurationMinutes => $composableBuilder(
      column: $table.lockDurationMinutes, builder: (column) => column);

  GeneratedColumn<int> get failedAttempts => $composableBuilder(
      column: $table.failedAttempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SecurityConfigTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SecurityConfigTableTable,
    SecurityConfigTableData,
    $$SecurityConfigTableTableFilterComposer,
    $$SecurityConfigTableTableOrderingComposer,
    $$SecurityConfigTableTableAnnotationComposer,
    $$SecurityConfigTableTableCreateCompanionBuilder,
    $$SecurityConfigTableTableUpdateCompanionBuilder,
    (
      SecurityConfigTableData,
      BaseReferences<_$AppDatabase, $SecurityConfigTableTable,
          SecurityConfigTableData>
    ),
    SecurityConfigTableData,
    PrefetchHooks Function()> {
  $$SecurityConfigTableTableTableManager(
      _$AppDatabase db, $SecurityConfigTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SecurityConfigTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SecurityConfigTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SecurityConfigTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<bool> securityEnabled = const Value.absent(),
            Value<String?> securityPin = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            Value<String?> pinSalt = const Value.absent(),
            Value<int?> pinIterations = const Value.absent(),
            Value<bool> biometricEnabled = const Value.absent(),
            Value<int> lockDurationMinutes = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<DateTime?> nextRetryAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SecurityConfigTableCompanion(
            id: id,
            userId: userId,
            securityEnabled: securityEnabled,
            securityPin: securityPin,
            pinHash: pinHash,
            pinSalt: pinSalt,
            pinIterations: pinIterations,
            biometricEnabled: biometricEnabled,
            lockDurationMinutes: lockDurationMinutes,
            failedAttempts: failedAttempts,
            nextRetryAt: nextRetryAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String userId,
            Value<bool> securityEnabled = const Value.absent(),
            Value<String?> securityPin = const Value.absent(),
            Value<String?> pinHash = const Value.absent(),
            Value<String?> pinSalt = const Value.absent(),
            Value<int?> pinIterations = const Value.absent(),
            Value<bool> biometricEnabled = const Value.absent(),
            Value<int> lockDurationMinutes = const Value.absent(),
            Value<int> failedAttempts = const Value.absent(),
            Value<DateTime?> nextRetryAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SecurityConfigTableCompanion.insert(
            id: id,
            userId: userId,
            securityEnabled: securityEnabled,
            securityPin: securityPin,
            pinHash: pinHash,
            pinSalt: pinSalt,
            pinIterations: pinIterations,
            biometricEnabled: biometricEnabled,
            lockDurationMinutes: lockDurationMinutes,
            failedAttempts: failedAttempts,
            nextRetryAt: nextRetryAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SecurityConfigTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SecurityConfigTableTable,
    SecurityConfigTableData,
    $$SecurityConfigTableTableFilterComposer,
    $$SecurityConfigTableTableOrderingComposer,
    $$SecurityConfigTableTableAnnotationComposer,
    $$SecurityConfigTableTableCreateCompanionBuilder,
    $$SecurityConfigTableTableUpdateCompanionBuilder,
    (
      SecurityConfigTableData,
      BaseReferences<_$AppDatabase, $SecurityConfigTableTable,
          SecurityConfigTableData>
    ),
    SecurityConfigTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutProgressTableTableTableManager get workoutProgressTable =>
      $$WorkoutProgressTableTableTableManager(_db, _db.workoutProgressTable);
  $$AppPreferencesTableTableTableManager get appPreferencesTable =>
      $$AppPreferencesTableTableTableManager(_db, _db.appPreferencesTable);
  $$SecurityConfigTableTableTableManager get securityConfigTable =>
      $$SecurityConfigTableTableTableManager(_db, _db.securityConfigTable);
}
