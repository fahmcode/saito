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

  SecurityConfig({
    this.securityEnabled = false,
    this.securityPin,
    this.biometricEnabled = false,
    this.lockDurationMinutes = 0,
  });

  SecurityConfig copyWith({
    bool? securityEnabled,
    String? securityPin,
    bool? biometricEnabled,
    int? lockDurationMinutes,
  }) {
    return SecurityConfig(
      securityEnabled: securityEnabled ?? this.securityEnabled,
      securityPin: securityPin ?? this.securityPin,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      lockDurationMinutes: lockDurationMinutes ?? this.lockDurationMinutes,
    );
  }
}
