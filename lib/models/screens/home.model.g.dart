// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeModelAdapter extends TypeAdapter<HomeModel> {
  @override
  final int typeId = 10;

  @override
  HomeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeModel(
      paid: fields[0] as int,
      unPaid: fields[1] as int,
      proposeCalendar: fields[2] as int,
      doneActionCalendar: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HomeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.paid)
      ..writeByte(1)
      ..write(obj.unPaid)
      ..writeByte(2)
      ..write(obj.proposeCalendar)
      ..writeByte(3)
      ..write(obj.doneActionCalendar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
