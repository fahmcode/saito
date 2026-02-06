import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saito/core/data/models/user_progress.dart';

// --- Events ---
abstract class UserProgressEvent extends Equatable {
  const UserProgressEvent();

  @override
  List<Object?> get props => [];
}

class CompleteDayEvent extends UserProgressEvent {
  final int day;
  final List<int> volume;

  const CompleteDayEvent({required this.day, required this.volume});

  @override
  List<Object?> get props => [day, volume];
}

class SaveBaselineRepsEvent extends UserProgressEvent {
  final Map<String, int> baselineReps;

  const SaveBaselineRepsEvent(this.baselineReps);

  @override
  List<Object?> get props => [baselineReps];
}

class ResetProgressEvent extends UserProgressEvent {}

class UpdateSettingsEvent extends UserProgressEvent {
  final bool? audioEnabled;
  final bool? hapticsEnabled;
  final bool? securityEnabled;
  final bool? biometricEnabled;
  final String? securityPin;
  final int? lockDurationMinutes;
  final String? themeMode;

  const UpdateSettingsEvent({
    this.audioEnabled,
    this.hapticsEnabled,
    this.securityEnabled,
    this.biometricEnabled,
    this.securityPin,
    this.lockDurationMinutes,
    this.themeMode,
  });

  @override
  List<Object?> get props => [
    audioEnabled,
    hapticsEnabled,
    securityEnabled,
    biometricEnabled,
    securityPin,
    lockDurationMinutes,
    themeMode,
  ];
}

// --- State ---
class UserProgressState extends Equatable {
  final UserProgress progress;

  const UserProgressState(this.progress);

  @override
  List<Object?> get props => [progress];
}

// --- Bloc ---
class UserProgressBloc extends Bloc<UserProgressEvent, UserProgressState> {
  final Box<UserProgress> _box;

  UserProgressBloc(this._box)
    : super(
        UserProgressState(
          _box.get('current') ?? UserProgress(lastWorkoutDate: DateTime(2000)),
        ),
      ) {
    on<CompleteDayEvent>(_onCompleteDay);
    on<SaveBaselineRepsEvent>(_onSaveBaselineReps);
    on<ResetProgressEvent>(_onResetProgress);
    on<UpdateSettingsEvent>(_onUpdateSettings);
  }

  void _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<UserProgressState> emit,
  ) {
    final newState = UserProgress(
      currentDay: state.progress.currentDay,
      streak: state.progress.streak,
      lastWorkoutDate: state.progress.lastWorkoutDate,
      dailyVolume: state.progress.dailyVolume,
      baselineReps: state.progress.baselineReps,
      hasSetBaseline: state.progress.hasSetBaseline,
      audioEnabled: event.audioEnabled ?? state.progress.audioEnabled,
      hapticsEnabled: event.hapticsEnabled ?? state.progress.hapticsEnabled,
      securityEnabled: event.securityEnabled ?? state.progress.securityEnabled,
      securityPin: event.securityPin ?? state.progress.securityPin,
      biometricEnabled:
          event.biometricEnabled ?? state.progress.biometricEnabled,
      lockDurationMinutes:
          event.lockDurationMinutes ?? state.progress.lockDurationMinutes,
      themeMode: event.themeMode ?? state.progress.themeMode,
    );
    _box.put('current', newState);
    emit(UserProgressState(newState));
  }

  void _onResetProgress(
    ResetProgressEvent event,
    Emitter<UserProgressState> emit,
  ) {
    final newState = UserProgress(lastWorkoutDate: DateTime(2000));
    _box.put('current', newState);
    emit(UserProgressState(newState));
  }

  void _onSaveBaselineReps(
    SaveBaselineRepsEvent event,
    Emitter<UserProgressState> emit,
  ) {
    final newState = UserProgress(
      currentDay: state.progress.currentDay,
      streak: state.progress.streak,
      lastWorkoutDate: state.progress.lastWorkoutDate,
      dailyVolume: state.progress.dailyVolume,
      baselineReps: event.baselineReps,
      hasSetBaseline: true,
      audioEnabled: state.progress.audioEnabled,
      hapticsEnabled: state.progress.hapticsEnabled,
      securityEnabled: state.progress.securityEnabled,
      securityPin: state.progress.securityPin,
      biometricEnabled: state.progress.biometricEnabled,
      lockDurationMinutes: state.progress.lockDurationMinutes,
      themeMode: state.progress.themeMode,
    );

    _box.put('current', newState);
    emit(UserProgressState(newState));
  }

  void _onCompleteDay(CompleteDayEvent event, Emitter<UserProgressState> emit) {
    final updatedVolume = Map<int, List<int>>.from(state.progress.dailyVolume);
    updatedVolume[event.day] = event.volume;

    final newState = UserProgress(
      currentDay: state.progress.currentDay + 1,
      streak: state.progress.streak + 1,
      lastWorkoutDate: DateTime.now(),
      dailyVolume: updatedVolume,
      baselineReps: state.progress.baselineReps,
      hasSetBaseline: state.progress.hasSetBaseline,
      audioEnabled: state.progress.audioEnabled,
      hapticsEnabled: state.progress.hapticsEnabled,
      securityEnabled: state.progress.securityEnabled,
      securityPin: state.progress.securityPin,
      biometricEnabled: state.progress.biometricEnabled,
      lockDurationMinutes: state.progress.lockDurationMinutes,
      themeMode: state.progress.themeMode,
    );

    _box.put('current', newState);
    HapticFeedback.heavyImpact();
    emit(UserProgressState(newState));
  }
}
