// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchOfflineModelAdapter extends TypeAdapter<SearchOfflineModel> {
  @override
  final int typeId = 11;

  @override
  SearchOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchOfflineModel(
      keyword: fields[0] as String?,
      description: fields[1] as String?,
      makerDate: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SearchOfflineModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.keyword)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.makerDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}