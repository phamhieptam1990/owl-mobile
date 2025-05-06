// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityOfflineModelAdapter extends TypeAdapter<ActivityOfflineModel> {
  @override
  final int typeId = 6;

  @override
  ActivityOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityOfflineModel(
      published: fields[0] as String,
      summary: fields[1] as String,
      appCode: fields[2] as String,
      tenantCode: fields[3] as String,
      action: fields[4] as String,
      actor: fields[5] as dynamic,
      target: fields[6] as dynamic,
      object: fields[7] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityOfflineModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.published)
      ..writeByte(1)
      ..write(obj.summary)
      ..writeByte(2)
      ..write(obj.appCode)
      ..writeByte(3)
      ..write(obj.tenantCode)
      ..writeByte(4)
      ..write(obj.action)
      ..writeByte(5)
      ..write(obj.actor)
      ..writeByte(6)
      ..write(obj.target)
      ..writeByte(7)
      ..write(obj.object);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
