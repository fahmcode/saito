import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptography/cryptography.dart';
import 'dart:convert';
import 'dart:math';
import 'package:saito/core/data/models/security_config.dart';
import 'package:saito/core/data/repositories/app_repository.dart';

// ── State ──────────────────────────────────────────────────

class SecurityState extends Equatable {
  final SecurityConfig config;
  final bool loaded;

  const SecurityState(this.config, {this.loaded = false});

  @override
  List<Object?> get props => [
    loaded,
    config.securityEnabled,
    config.pinHash,
    config.pinSalt,
    config.pinIterations,
    config.biometricEnabled,
    config.lockDurationMinutes,
    config.failedAttempts,
    config.nextRetryAt,
  ];
}

// ── Cubit ──────────────────────────────────────────────────

class SecurityCubit extends Cubit<SecurityState> {
  final AppRepository _repo;
  final Random _random = Random.secure();
  static const _iterations = 150000;

  SecurityCubit(this._repo) : super(SecurityState(SecurityConfig()));

  Future<void> load() async {
    final config = await _repo.getSecurity();
    emit(SecurityState(config, loaded: true));
  }

  Future<void> enableSecurity({required String pin}) async {
    final hashed = await _hashPin(pin);
    final updated = state.config.copyWith(
      securityEnabled: true,
      securityPin: null,
      pinHash: hashed['hash'],
      pinSalt: hashed['salt'],
      pinIterations: hashed['iterations'],
      failedAttempts: 0,
      nextRetryAt: null,
    );
    await _repo.saveSecurity(updated);
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

  Future<bool> verifyPin(String pin) async {
    final cfg = state.config;
    // Legacy support
    if (cfg.pinHash == null || cfg.pinSalt == null) {
      if (cfg.securityPin != null && cfg.securityPin == pin) {
        // migrate to hash
        await enableSecurity(pin: pin);
        return true;
      }
      return false;
    }
    final saltBytes = base64Decode(cfg.pinSalt!);
    final key = await _pbkdf2(pin, saltBytes, cfg.pinIterations ?? _iterations);
    final hash = base64Encode(key);
    return constantTimeBytesEquality(
      base64Decode(cfg.pinHash!),
      base64Decode(hash),
    );
  }

  Future<Map<String, dynamic>> _hashPin(String pin) async {
    final salt = List<int>.generate(16, (_) => _random.nextInt(256));
    final key = await _pbkdf2(pin, salt, _iterations);
    return {
      'hash': base64Encode(key),
      'salt': base64Encode(salt),
      'iterations': _iterations,
    };
  }

  Future<List<int>> _pbkdf2(String pin, List<int> salt, int iterations) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations,
      bits: 256,
    );
    final secretKey = SecretKey(utf8.encode(pin));
    final newKey = await algorithm.deriveKey(secretKey: secretKey, nonce: salt);
    return await newKey.extractBytes();
  }

  bool constantTimeBytesEquality(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}
