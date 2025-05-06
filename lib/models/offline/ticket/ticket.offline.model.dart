import 'package:hive/hive.dart';
part 'ticket.offline.model.g.dart';

@HiveType(typeId: 7)
class TicketOfflineModel {
  @HiveField(0)
  String? cusMobilePhone;

  @HiveField(1)
  String? issueName;

  @HiveField(2)
  String? fullName;

  @HiveField(3)
  String? customerId;

  @HiveField(4)
  String? issueClassCode;

  @HiveField(5)
  int? id;

  @HiveField(6)
  String? issueCode;

  @HiveField(7)
  String? createDate;

  @HiveField(8)
  String? makerId;

  @HiveField(9)
  String? authStatus;

  @HiveField(10)
  String? reporter;

  @HiveField(11)
  String? recordStatus;

  @HiveField(12)
  String? contractId;

  @HiveField(13)
  String? aggId;

  @HiveField(14)
  String? assignee;

  @HiveField(15)
  String? statusCode;

  @HiveField(16)
  String? status;

  @HiveField(17)
  String? phone;

  @HiveField(18)
  String? actionGroupName;

  @HiveField(19)
  String? actionGroupCode;

  @HiveField(20)
  String? address;

  @HiveField(21)
  String? cusFullAddress;

  @HiveField(22)
  String? feType;

  @HiveField(23)
  String? lastPaymentDate;

  @HiveField(24)
  double? lastPaymentAmount;

  @HiveField(25)
  String? lastEventDate;

  @HiveField(26)
  String? assignedDate;

  @HiveField(27)
  var assigneeData;

  @HiveField(28)
  var customerData;

  @HiveField(29)
  var ticketDetail;

  @HiveField(30)
  var fieldTypeCode;

  @HiveField(31)
  String? createdDate;

  @HiveField(32)
  String? uuid;

  @HiveField(33)
  var contractDetail;

  @HiveField(34)
  var contactDetail;

  @HiveField(35)
  var ticketActionLog;

  @HiveField(36)
  var ticketLastEvent;

  @HiveField(37)
  int? flagDeferment;

  @HiveField(38)
  int? flagLatecall;

  @HiveField(39)
  int? flagSummarize;

  @HiveField(40)
  String? customerAttitude;

  TicketOfflineModel(
      {this.issueName,
      this.assignedDate,
      this.cusMobilePhone,
      this.fullName,
      this.customerId,
      this.issueClassCode,
      this.id,
      this.issueCode,
      this.createDate,
      this.makerId,
      this.authStatus,
      this.reporter,
      this.recordStatus,
      this.contractId,
      this.aggId,
      this.assignee,
      this.statusCode,
      this.status,
      this.phone,
      this.actionGroupName,
      this.actionGroupCode,
      this.feType,
      this.assigneeData,
      this.customerData,
      this.ticketDetail,
      this.fieldTypeCode,
      this.cusFullAddress,
      this.lastPaymentAmount,
      this.lastPaymentDate,
      this.lastEventDate,
      this.address,
      this.createdDate,
      this.uuid,
      this.contractDetail,
      this.contactDetail,
      this.ticketActionLog,
      this.ticketLastEvent,
      this.flagDeferment,
      this.flagLatecall,
      this.flagSummarize,
      this.customerAttitude});

  Map<dynamic, dynamic> toJson() => {
        'issueName': issueName,
        'fullName': issueName,
        'customerId': customerId,
        'issueClassCode': issueClassCode,
        'id': id,
        'issueCode': issueCode,
        'createDate': createDate,
        'makerId': makerId,
        'authStatus': authStatus,
        'reporter': reporter,
        'recordStatus': recordStatus,
        'contractId': contractId,
        'aggId': aggId,
        'assignee': assignee,
        'statusCode': statusCode,
        'status': status,
        'phone': phone,
        'actionGroupName': actionGroupName,
        'actionGroupCode': actionGroupCode,
        'assigneeData': assigneeData,
        'customerData': customerData,
        'ticketDetail': ticketDetail,
        'fieldTypeCode': fieldTypeCode,
        'address': address,
        'cusFullAddress': cusFullAddress,
        'feType': feType,
        'cusMobilePhone': cusMobilePhone,
        'lastPaymentDate': lastPaymentDate,
        'lastPaymentAmount': lastPaymentAmount,
        'lastEventDate': lastEventDate,
        'assignedDate': assignedDate,
        'createdDate': createdDate,
        'uuid': uuid,
        'contractDetail': contractDetail,
        'contactDetail': contactDetail,
        'ticketActionLog': ticketActionLog,
        'ticketLastEvent': ticketLastEvent,
        'flagDeferment': flagDeferment,
        'flagLatecall': flagLatecall,
        'flagSummarize': flagSummarize,
        'customerAttitude': customerAttitude
      };

  factory TicketOfflineModel.fromJson(Map<dynamic, dynamic> ticketModel) {
    return TicketOfflineModel(
        issueName: ticketModel['issueName'].toString(),
        fullName: ticketModel['issueName'].toString(),
        customerId: ticketModel['customerId'],
        issueClassCode: ticketModel['issueClassCode'].toString(),
        id: ticketModel['id'],
        issueCode: ticketModel['issueCode'].toString(),
        createDate: ticketModel['createDate'],
        makerId: ticketModel['makerId'].toString(),
        authStatus: ticketModel['authStatus'].toString(),
        reporter: ticketModel['reporter'].toString(),
        recordStatus: ticketModel['recordStatus'].toString(),
        contractId: ticketModel['contractId'],
        aggId: ticketModel['aggId'].toString(),
        feType: ticketModel['feType'].toString(),
        assignee: ticketModel['assignee'],
        statusCode: ticketModel['statusCode'].toString(),
        status: ticketModel['status'].toString(),
        phone: ticketModel['phone'],
        actionGroupName: ticketModel['actionGroupName'],
        actionGroupCode: ticketModel['actionGroupCode'],
        assigneeData: ticketModel['assigneeData'],
        customerData: ticketModel['customerData'],
        ticketDetail: ticketModel['ticketDetail'],
        fieldTypeCode: ticketModel['fieldTypeCode'],
        address: ticketModel['address'],
        cusMobilePhone: ticketModel['cusMobilePhone'],
        lastPaymentDate: ticketModel['lastPaymentDate'],
        lastPaymentAmount: ticketModel['lastPaymentAmount'],
        lastEventDate: ticketModel['lastEventDate'],
        assignedDate: ticketModel['assignedDate'],
        cusFullAddress: ticketModel['cusFullAddress'].toString(),
        createdDate: ticketModel['createdDate'],
        uuid: ticketModel['uuid'] ,
        contractDetail: ticketModel['contractDetail'],
        contactDetail: ticketModel['contactDetail'],
        ticketActionLog: ticketModel['ticketActionLog'],
        ticketLastEvent: ticketModel['ticketLastEvent'],
        flagDeferment: ticketModel['flagDeferment'],
        flagLatecall: ticketModel['flagLatecall'],
        flagSummarize: ticketModel['flagSummarize'],
        customerAttitude: ticketModel['customerAttitude']);
  }
}
