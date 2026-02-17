import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saito/core/data/models/security_config.dart';
import 'package:saito/core/data/repositories/app_repository.dart';

// ── State ──────────────────────────────────────────────────

class SecurityState extends Equatable {
  final SecurityConfig config;

  const SecurityState(this.config);

  @override
  List<Object?> get props => [
    config.securityEnabled,
    config.securityPin,
    config.biometricEnabled,
    config.lockDurationMinutes,
  ];
}

// ── Cubit ──────────────────────────────────────────────────

class SecurityCubit extends Cubit<SecurityState> {
  final AppRepository _repo;

  SecurityCubit(this._repo) : super(SecurityState(SecurityConfig()));

  Future<void> load() async {
    final config = await _repo.getSecurity();
    emit(SecurityState(config));
  }

  void enableSecurity({required String pin}) {
    final updated = state.config.copyWith(
      securityEnabled: true,
      securityPin: pin,
    );
    _repo.saveSecurity(updated);
    emit(SecurityState(updated));
  }

  void disableSecurity() {
    final updated = state.config.copyWith(securityEnabled: false);
    _repo.saveSecurity(updated);
    emit(SecurityState(updated));
  }

  void setBiometricEnabled(bool enabled) {
    final updated = state.config.copyWith(biometricEnabled: enabled);
    _repo.saveSecurity(updated);
    emit(SecurityState(updated));
  }

  void setLockDuration(int minutes) {
    final updated = state.config.copyWith(lockDurationMinutes: minutes);
    _repo.saveSecurity(updated);
    emit(SecurityState(updated));
  }
}
