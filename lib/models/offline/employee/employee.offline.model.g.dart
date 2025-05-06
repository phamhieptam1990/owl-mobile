// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeOfflineModelAdapter extends TypeAdapter<EmployeeOfflineModel> {
  @override
  final int typeId = 4;

  @override
  EmployeeOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployeeOfflineModel(
      lastName: fields[0] as String?,
      agentId: fields[1] as int?,
      gender: fields[2] as int?,
      workEmail: fields[3] as String?,
      personalMail: fields[4] as String?,
      empLevel: fields[5] as int?,
      tenantCode: fields[6] as String?,
      id: fields[10] as int?,
      makerId: fields[11] as String?,
      makerDate: fields[12] as int?,
      fullName: fields[14] as String?,
      userName: fields[15] as String?,
      birthDate: fields[16] as int?,
      firstName: fields[17] as String?,
      recordStatus: fields[18] as String?,
      mobilePhone: fields[19] as String?,
      empCode: fields[20] as String?,
      workPhone: fields[21] as String?,
      aggId: fields[22] as String?,
    )
      ..modNo = fields[7] as int?
      ..checkerDate = fields[8] as int?
      ..hrtmPosition = fields[9] as int?
      ..authStatus = fields[13] as String?;
  }

  @override
  void write(BinaryWriter writer, EmployeeOfflineModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.lastName)
      ..writeByte(1)
      ..write(obj.agentId)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.workEmail)
      ..writeByte(4)
      ..write(obj.personalMail)
      ..writeByte(5)
      ..write(obj.empLevel)
      ..writeByte(6)
      ..write(obj.tenantCode)
      ..writeByte(7)
      ..write(obj.modNo)
      ..writeByte(8)
      ..write(obj.checkerDate)
      ..writeByte(9)
      ..write(obj.hrtmPosition)
      ..writeByte(10)
      ..write(obj.id)
      ..writeByte(11)
      ..write(obj.makerId)
      ..writeByte(12)
      ..write(obj.makerDate)
      ..writeByte(13)
      ..write(obj.authStatus)
      ..writeByte(14)
      ..write(obj.fullName)
      ..writeByte(15)
      ..write(obj.userName)
      ..writeByte(16)
      ..write(obj.birthDate)
      ..writeByte(17)
      ..write(obj.firstName)
      ..writeByte(18)
      ..write(obj.recordStatus)
      ..writeByte(19)
      ..write(obj.mobilePhone)
      ..writeByte(20)
      ..write(obj.empCode)
      ..writeByte(21)
      ..write(obj.workPhone)
      ..writeByte(22)
      ..write(obj.aggId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
