// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mockLocationApp.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MockLocationAppOfflineModelAdapter
    extends TypeAdapter<MockLocationAppOfflineModel> {
  @override
  final int typeId = 9;

  @override
  MockLocationAppOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MockLocationAppOfflineModel(
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MockLocationAppOfflineModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockLocationAppOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
