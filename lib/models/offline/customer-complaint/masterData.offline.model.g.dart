// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'masterData.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MasterDataComplainOfflineModelAdapter
    extends TypeAdapter<MasterDataComplainOfflineModel> {
  @override
  final int typeId = 3;

  @override
  MasterDataComplainOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MasterDataComplainOfflineModel(
      attributeValue: fields[0] as String,
      categoryCode: fields[1] as String,
      categoryName: fields[2] as String,
      productName: fields[3] as String,
      casetypeName: fields[4] as String,
      attributeCode: fields[5] as String,
      subcategoryName: fields[6] as String,
      productCode: fields[7] as String,
      productValue: fields[8] as String,
      subcategoryValue: fields[9] as String,
      casetypeCode: fields[10] as String,
      categoryValue: fields[11] as String,
      casetypeValue: fields[12] as String,
      attributeName: fields[13] as String,
      subcategoryCode: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MasterDataComplainOfflineModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.attributeValue)
      ..writeByte(1)
      ..write(obj.categoryCode)
      ..writeByte(2)
      ..write(obj.categoryName)
      ..writeByte(3)
      ..write(obj.productName)
      ..writeByte(4)
      ..write(obj.casetypeName)
      ..writeByte(5)
      ..write(obj.attributeCode)
      ..writeByte(6)
      ..write(obj.subcategoryName)
      ..writeByte(7)
      ..write(obj.productCode)
      ..writeByte(8)
      ..write(obj.productValue)
      ..writeByte(9)
      ..write(obj.subcategoryValue)
      ..writeByte(10)
      ..write(obj.casetypeCode)
      ..writeByte(11)
      ..write(obj.categoryValue)
      ..writeByte(12)
      ..write(obj.casetypeValue)
      ..writeByte(13)
      ..write(obj.attributeName)
      ..writeByte(14)
      ..write(obj.subcategoryCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MasterDataComplainOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
