// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryAll.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAllOfflineModelAdapter
    extends TypeAdapter<CategoryAllOfflineModel> {
  @override
  final int typeId = 1;

  @override
  CategoryAllOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryAllOfflineModel(
      fetmContactPeoples: fields[0] as dynamic,
      fetmContactPlaces: fields[1] as dynamic,
      fetmContactMode: fields[2] as dynamic,
      fetbFieldActions: fields[3] as dynamic,
      fetmActionGroups: fields[4] as dynamic,
      fetmFieldTypes: fields[5] as dynamic,
      fetmActionAttribute: fields[7] as dynamic,
      fetmFieldReason: fields[6] as dynamic,
      fetmActionSubAttribute: fields[9] as dynamic,
      locality: fields[8] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryAllOfflineModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.fetmContactPeoples)
      ..writeByte(1)
      ..write(obj.fetmContactPlaces)
      ..writeByte(2)
      ..write(obj.fetmContactMode)
      ..writeByte(3)
      ..write(obj.fetbFieldActions)
      ..writeByte(4)
      ..write(obj.fetmActionGroups)
      ..writeByte(5)
      ..write(obj.fetmFieldTypes)
      ..writeByte(6)
      ..write(obj.fetmFieldReason)
      ..writeByte(7)
      ..write(obj.fetmActionAttribute)
      ..writeByte(8)
      ..write(obj.locality)
      ..writeByte(9)
      ..write(obj.fetmActionSubAttribute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAllOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
