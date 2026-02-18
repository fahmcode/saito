// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecurityConfigAdapter extends TypeAdapter<SecurityConfig> {
  @override
  final int typeId = 3;

  @override
  SecurityConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecurityConfig(
      securityEnabled: fields[0] as bool,
      securityPin: fields[1] as String?,
      biometricEnabled: fields[2] as bool,
      lockDurationMinutes: fields[3] as int,
      pinHash: fields[4] as String?,
      pinSalt: fields[5] as String?,
      pinIterations: fields[6] as int?,
      failedAttempts: fields[7] as int,
      nextRetryAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SecurityConfig obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.securityEnabled)
      ..writeByte(1)
      ..write(obj.securityPin)
      ..writeByte(2)
      ..write(obj.biometricEnabled)
      ..writeByte(3)
      ..write(obj.lockDurationMinutes)
      ..writeByte(4)
      ..write(obj.pinHash)
      ..writeByte(5)
      ..write(obj.pinSalt)
      ..writeByte(6)
      ..write(obj.pinIterations)
      ..writeByte(7)
      ..write(obj.failedAttempts)
      ..writeByte(8)
      ..write(obj.nextRetryAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecurityConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
