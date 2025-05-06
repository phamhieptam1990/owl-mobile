// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productType.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductTypeOfflineModelAdapter
    extends TypeAdapter<ProductTypeOfflineModel> {
  @override
  final int typeId = 8;

  @override
  ProductTypeOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductTypeOfflineModel(
      productName: fields[0] as String,
      productCode: fields[1] as String,
      productValue: fields[2] as String,
      description: fields[3] as String,
      receiveDate: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductTypeOfflineModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.productCode)
      ..writeByte(2)
      ..write(obj.productValue)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.receiveDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
