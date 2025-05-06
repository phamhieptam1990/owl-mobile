// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.offline.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketOfflineModelAdapter extends TypeAdapter<TicketOfflineModel> {
  @override
  final int typeId = 7;

  @override
  TicketOfflineModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketOfflineModel(
      issueName: fields[1] as String?,
      assignedDate: fields[26] as String?,
      cusMobilePhone: fields[0] as String?,
      fullName: fields[2] as String?,
      customerId: fields[3] as String?,
      issueClassCode: fields[4] as String?,
      id: fields[5] as int?,
      issueCode: fields[6] as String?,
      createDate: fields[7] as String?,
      makerId: fields[8] as String?,
      authStatus: fields[9] as String?,
      reporter: fields[10] as String?,
      recordStatus: fields[11] as String?,
      contractId: fields[12] as String?,
      aggId: fields[13] as String?,
      assignee: fields[14] as String?,
      statusCode: fields[15] as String?,
      status: fields[16] as String?,
      phone: fields[17] as String?,
      actionGroupName: fields[18] as String?,
      actionGroupCode: fields[19] as String?,
      feType: fields[22] as String?,
      assigneeData: fields[27] as dynamic,
      customerData: fields[28] as dynamic,
      ticketDetail: fields[29] as dynamic,
      fieldTypeCode: fields[30] as dynamic,
      cusFullAddress: fields[21] as String?,
      lastPaymentAmount: fields[24] as double,
      lastPaymentDate: fields[23] as String?,
      lastEventDate: fields[25] as String?,
      address: fields[20] as String?,
      createdDate: fields[31] as String?,
      uuid: fields[32] as String?,
      contractDetail: fields[33] as dynamic,
      contactDetail: fields[34] as dynamic,
      ticketActionLog: fields[35] as dynamic,
      ticketLastEvent: fields[36] as dynamic,
      flagDeferment: fields[37] as int?,
      flagLatecall: fields[38] as int?,
      flagSummarize: fields[39] as int?,
      customerAttitude: fields[40] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TicketOfflineModel obj) {
    writer
      ..writeByte(41)
      ..writeByte(0)
      ..write(obj.cusMobilePhone)
      ..writeByte(1)
      ..write(obj.issueName)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.customerId)
      ..writeByte(4)
      ..write(obj.issueClassCode)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.issueCode)
      ..writeByte(7)
      ..write(obj.createDate)
      ..writeByte(8)
      ..write(obj.makerId)
      ..writeByte(9)
      ..write(obj.authStatus)
      ..writeByte(10)
      ..write(obj.reporter)
      ..writeByte(11)
      ..write(obj.recordStatus)
      ..writeByte(12)
      ..write(obj.contractId)
      ..writeByte(13)
      ..write(obj.aggId)
      ..writeByte(14)
      ..write(obj.assignee)
      ..writeByte(15)
      ..write(obj.statusCode)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.phone)
      ..writeByte(18)
      ..write(obj.actionGroupName)
      ..writeByte(19)
      ..write(obj.actionGroupCode)
      ..writeByte(20)
      ..write(obj.address)
      ..writeByte(21)
      ..write(obj.cusFullAddress)
      ..writeByte(22)
      ..write(obj.feType)
      ..writeByte(23)
      ..write(obj.lastPaymentDate)
      ..writeByte(24)
      ..write(obj.lastPaymentAmount)
      ..writeByte(25)
      ..write(obj.lastEventDate)
      ..writeByte(26)
      ..write(obj.assignedDate)
      ..writeByte(27)
      ..write(obj.assigneeData)
      ..writeByte(28)
      ..write(obj.customerData)
      ..writeByte(29)
      ..write(obj.ticketDetail)
      ..writeByte(30)
      ..write(obj.fieldTypeCode)
      ..writeByte(31)
      ..write(obj.createdDate)
      ..writeByte(32)
      ..write(obj.uuid)
      ..writeByte(33)
      ..write(obj.contractDetail)
      ..writeByte(34)
      ..write(obj.contactDetail)
      ..writeByte(35)
      ..write(obj.ticketActionLog)
      ..writeByte(36)
      ..write(obj.ticketLastEvent)
      ..writeByte(37)
      ..write(obj.flagDeferment)
      ..writeByte(38)
      ..write(obj.flagLatecall)
      ..writeByte(39)
      ..write(obj.flagSummarize)
      ..writeByte(40)
      ..write(obj.customerAttitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketOfflineModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
