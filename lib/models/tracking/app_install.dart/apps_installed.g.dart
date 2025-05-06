// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apps_installed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppsInstalledAdapter extends TypeAdapter<AppsInstalled> {
  @override
  final int typeId = 12;

  @override
  AppsInstalled read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppsInstalled(
      excuteTinme: fields[0] as String,
      recordType: fields[1] as String,
      appsInstalled: (fields[2] as List)?.cast<AppsInstalledElement>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppsInstalled obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.excuteTinme)
      ..writeByte(1)
      ..write(obj.recordType)
      ..writeByte(2)
      ..write(obj.appsInstalled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppsInstalledAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppsInstalledElementAdapter extends TypeAdapter<AppsInstalledElement> {
  @override
  final int typeId = 13;

  @override
  AppsInstalledElement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppsInstalledElement(
      appName: fields[0] as String,
      packageName: fields[1] as String,
      versionName: fields[2] as String,
      installTimeMillis: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppsInstalledElement obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.appName)
      ..writeByte(1)
      ..write(obj.packageName)
      ..writeByte(2)
      ..write(obj.versionName)
      ..writeByte(3)
      ..write(obj.installTimeMillis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppsInstalledElementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
