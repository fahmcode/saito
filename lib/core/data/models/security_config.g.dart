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
    );
  }

  @override
  void write(BinaryWriter writer, SecurityConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.securityEnabled)
      ..writeByte(1)
      ..write(obj.securityPin)
      ..writeByte(2)
      ..write(obj.biometricEnabled)
      ..writeByte(3)
      ..write(obj.lockDurationMinutes);
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
