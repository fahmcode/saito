import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/core/data/models/app_preferences.dart';
import 'package:saito/core/data/repositories/app_repository.dart';

// ── State ──────────────────────────────────────────────────

class PreferencesState extends Equatable {
  final AppPreferences preferences;

  const PreferencesState(this.preferences);

  @override
  List<Object?> get props => [
    preferences.audioEnabled,
    preferences.hapticsEnabled,
    preferences.onboardingComplete,
    preferences.themeMode,
  ];
}

// ── Cubit ──────────────────────────────────────────────────

class PreferencesCubit extends Cubit<PreferencesState> {
  final AppRepository _repo;

  PreferencesCubit(this._repo) : super(PreferencesState(AppPreferences()));

  Future<void> load() async {
    final prefs = await _repo.getPreferences();
    emit(PreferencesState(prefs));
  }

  void setAudioEnabled(bool enabled) {
    final updated = state.preferences.copyWith(audioEnabled: enabled);
    _repo.savePreferences(updated);
    emit(PreferencesState(updated));
  }

  void setHapticsEnabled(bool enabled) {
    final updated = state.preferences.copyWith(hapticsEnabled: enabled);
    _repo.savePreferences(updated);
    emit(PreferencesState(updated));
  }

  void setOnboardingComplete(bool complete) {
    final updated = state.preferences.copyWith(onboardingComplete: complete);
    _repo.savePreferences(updated);
    emit(PreferencesState(updated));
  }

  void setThemeMode(String mode) {
    final updated = state.preferences.copyWith(themeMode: mode);
    _repo.savePreferences(updated);
    emit(PreferencesState(updated));
  }
}
