import 'package:hive/hive.dart';

part 'security_config.g.dart';

@HiveType(typeId: 3)
class SecurityConfig extends HiveObject {
  @HiveField(0)
  bool securityEnabled;

  @HiveField(1)
  String? securityPin;

  @HiveField(2)
  bool biometricEnabled;

  @HiveField(3)
  int lockDurationMinutes;

  @HiveField(4)
  String? pinHash;

  @HiveField(5)
  String? pinSalt;

  @HiveField(6)
  int? pinIterations;

  @HiveField(7)
  int failedAttempts;

  @HiveField(8)
  DateTime? nextRetryAt;

  SecurityConfig({
    this.securityEnabled = false,
    this.securityPin,
    this.biometricEnabled = false,
    this.lockDurationMinutes = 0,
    this.pinHash,
    this.pinSalt,
    this.pinIterations,
    this.failedAttempts = 0,
    this.nextRetryAt,
  });

  SecurityConfig copyWith({
    bool? securityEnabled,
    String? securityPin,
    bool? biometricEnabled,
    int? lockDurationMinutes,
    String? pinHash,
    String? pinSalt,
    int? pinIterations,
    int? failedAttempts,
    DateTime? nextRetryAt,
  }) {
    return SecurityConfig(
      securityEnabled: securityEnabled ?? this.securityEnabled,
      securityPin: securityPin ?? this.securityPin,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      pinIterations: pinIterations ?? this.pinIterations,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      lockDurationMinutes: lockDurationMinutes ?? this.lockDurationMinutes,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
    );
  }
}
