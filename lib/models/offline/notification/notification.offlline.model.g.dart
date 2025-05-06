// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.offlline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationOfflineModelAdapter
    extends TypeAdapter<NotificationOfflineModel> {
  @override
  final int typeId = 5;

  @override
  NotificationOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationOfflineModel(
      updatedTime: fields[0] as String,
      makerDate: fields[1] as String,
      unread: fields[2] as int,
      title: fields[3] as String,
      createdTime: fields[4] as String,
      to: fields[5] as String,
      from: fields[6] as String,
      aggId: fields[7] as String,
      object: fields[8] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationOfflineModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.updatedTime)
      ..writeByte(1)
      ..write(obj.makerDate)
      ..writeByte(2)
      ..write(obj.unread)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.createdTime)
      ..writeByte(5)
      ..write(obj.to)
      ..writeByte(6)
      ..write(obj.from)
      ..writeByte(7)
      ..write(obj.aggId)
      ..writeByte(8)
      ..write(obj.object);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
