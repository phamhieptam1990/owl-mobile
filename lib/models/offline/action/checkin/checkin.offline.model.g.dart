// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckInOfflineModelAdapter extends TypeAdapter<CheckInOfflineModel> {
  @override
  final int typeId = 0;

  @override
  CheckInOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckInOfflineModel(
      aggId: fields[0] as String,
      contactModeId: fields[1] as int,
      contactPlaceId: fields[2] as int,
      contactPersonId: fields[3] as int,
      paymentAmount: fields[4] as dynamic,
      paymentBy: fields[5] as String,
      paymentUnit: fields[6] as int,
      clientPhone: fields[7] as String,
      description: fields[8] as String,
      fieldActionId: fields[9] as int,
      address: fields[10] as String,
      longitude: fields[11] as double,
      latitude: fields[12] as double,
      accuracy: fields[13] as double,
      date: fields[14] as String,
      durationInMins: fields[15] as String,
      actionGroupName: fields[16] as String,
      attachments: (fields[17] as List)?.cast<dynamic>(),
      time: fields[19] as String,
      customerName: fields[20] as String,
      actionName: fields[21] as String,
      offlineInfo: fields[18] as dynamic,
      contractId: fields[22] as String,
      employeeInfomation: fields[23] as String,
      actionAttributeId: fields[24] as int,
      contactName: fields[25] as String,
      contactMobile: fields[26] as String,
      contactProvinceId: fields[27] as int,
      contactDistrictId: fields[28] as int,
      contactWardId: fields[29] as int,
      contactAddress: fields[30] as String,
      actionGroupCode: fields[32] as String,
      customerAttitude: fields[33] as String,
      contactFullAddress: fields[31] as String,
      extraInfo: (fields[39] as Map)?.cast<dynamic, dynamic>(),
      subAttributeId: fields[34] as int,
      currentIncomeAmount: fields[35] as dynamic,
      loanAmount: fields[36] as dynamic,
      lastIncomeAmount: fields[37] as dynamic,
      isRefusePayment: fields[38] as bool,
      subAttributeGroupId: fields[40] as int,
      selfie: (fields[41] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CheckInOfflineModel obj) {
    writer
      ..writeByte(42)
      ..writeByte(0)
      ..write(obj.aggId)
      ..writeByte(1)
      ..write(obj.contactModeId)
      ..writeByte(2)
      ..write(obj.contactPlaceId)
      ..writeByte(3)
      ..write(obj.contactPersonId)
      ..writeByte(4)
      ..write(obj.paymentAmount)
      ..writeByte(5)
      ..write(obj.paymentBy)
      ..writeByte(6)
      ..write(obj.paymentUnit)
      ..writeByte(7)
      ..write(obj.clientPhone)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.fieldActionId)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.longitude)
      ..writeByte(12)
      ..write(obj.latitude)
      ..writeByte(13)
      ..write(obj.accuracy)
      ..writeByte(14)
      ..write(obj.date)
      ..writeByte(15)
      ..write(obj.durationInMins)
      ..writeByte(16)
      ..write(obj.actionGroupName)
      ..writeByte(17)
      ..write(obj.attachments)
      ..writeByte(18)
      ..write(obj.offlineInfo)
      ..writeByte(19)
      ..write(obj.time)
      ..writeByte(20)
      ..write(obj.customerName)
      ..writeByte(21)
      ..write(obj.actionName)
      ..writeByte(22)
      ..write(obj.contractId)
      ..writeByte(23)
      ..write(obj.employeeInfomation)
      ..writeByte(24)
      ..write(obj.actionAttributeId)
      ..writeByte(25)
      ..write(obj.contactName)
      ..writeByte(26)
      ..write(obj.contactMobile)
      ..writeByte(27)
      ..write(obj.contactProvinceId)
      ..writeByte(28)
      ..write(obj.contactDistrictId)
      ..writeByte(29)
      ..write(obj.contactWardId)
      ..writeByte(30)
      ..write(obj.contactAddress)
      ..writeByte(31)
      ..write(obj.contactFullAddress)
      ..writeByte(32)
      ..write(obj.actionGroupCode)
      ..writeByte(33)
      ..write(obj.customerAttitude)
      ..writeByte(34)
      ..write(obj.subAttributeId)
      ..writeByte(35)
      ..write(obj.currentIncomeAmount)
      ..writeByte(36)
      ..write(obj.loanAmount)
      ..writeByte(37)
      ..write(obj.lastIncomeAmount)
      ..writeByte(38)
      ..write(obj.isRefusePayment)
      ..writeByte(39)
      ..write(obj.extraInfo)
      ..writeByte(40)
      ..write(obj.subAttributeGroupId)
      ..writeByte(41)
      ..write(obj.selfie);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckInOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
