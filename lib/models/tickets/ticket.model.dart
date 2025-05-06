import 'package:athena/utils/utils.dart';

class TicketModel {
  String? cusMobilePhone;
  String? issueName;
  String? fullName;
  String? customerId;
  String? issueClassCode;
  int? id;
  String? applId;
  String? issueCode;
  String? createDate;
  String? makerId;
  String? plannedDate;
  String? authStatus;
  String? reporter;
  String? recordStatus;
  String? contractId;
  String? aggId;
  String? assignee;
  String? statusCode;
  String? status;
  String? phone;
  String? actionGroupName;
  String? actionGroupCode;
  String? address;
  String? cusFullAddress;
  String? companyAddress;
  String? permanentAddress;
  String? feType;
  String? managerCode;
  String? managerPosition;
  String? managerName;
  String? managerFullname;
  var caseExpirationDate;
  String? lastPaymentDate;
  double? lastPaymentAmount;
  bool? isChecked = false;
  String? lastEventDate;
  String? assignedDate;
  int? priorityLevel;
  String? idCardNumber;
  String? empFullName;
  String? nvcontractStatus;
  var assigneeData;
  var customerData;
  var ticketDetail;
  var fieldTypeCode;
  var contractDetail;
  var contactDetail;
  var ticketActionLog;
  var ticketLastEvent;
  int? flagDeferment;
  int? flagLatecall;
  int? flagSummarize;
  String? customerAttitude;
  int? flagCash24;
  double? mustPay;
  var addressTypeId;
  var bucket;
  var periodBucket;
  var installmentamount;
  var toCollect;
  var installmentAmt; 
  TicketModel(
      {this.bucket,
      this.installmentAmt,
      this.periodBucket,
      this.installmentamount,
      this.toCollect,
      this.issueName,
      this.nvcontractStatus,
      this.empFullName,
      this.idCardNumber,
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
      this.contractDetail,
      this.contactDetail,
      this.ticketActionLog,
      this.isChecked,
      this.ticketLastEvent,
      this.priorityLevel,
      this.managerCode,
      this.managerName,
      this.managerFullname,
      this.managerPosition,
      this.caseExpirationDate,
      this.flagDeferment,
      this.flagLatecall,
      this.customerAttitude,
      this.flagSummarize,
      this.plannedDate,
      this.flagCash24,
      this.applId,
      this.mustPay,
      this.addressTypeId,
      this.permanentAddress,
      this.companyAddress});

  Map<dynamic, dynamic> toJson() => {
        'issueName': issueName,
        'empFullName': empFullName,
        'permanentAddress': permanentAddress,
        'companyAddress': companyAddress,
        'addressTypeId': addressTypeId,
        'nvcontractStatus': nvcontractStatus,
        'idCardNumber': idCardNumber,
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
        'contractDetail': contractDetail,
        'contactDetail': contactDetail,
        'ticketActionLog': ticketActionLog,
        'ticketLastEvent': ticketLastEvent,
        'priorityLevel': priorityLevel,
        'isChecked': Utils.checkIsNotNull(isChecked) ? isChecked : false,
        'managerCode': managerCode,
        'managerPosition': managerPosition,
        'managerName': Utils.checkIsNotNull(managerName) ? managerName : '',
        'managerFullname':
            Utils.checkIsNotNull(managerFullname) ? managerFullname : '',
        'caseExpirationDate': caseExpirationDate,
        'flagDeferment': flagDeferment,
        'flagLatecall': flagLatecall,
        'flagSummarize': flagSummarize,
        'customerAttitude': customerAttitude,
        'plannedDate': plannedDate,
        'flagCash24': flagCash24,
        'mustPay': mustPay,
        'bucket': bucket,
        'periodBucket': periodBucket,
        'installmentamount': installmentamount,
        "installmentAmt":installmentAmt,
        'toCollect': toCollect,
        'applId': applId
      };
  factory TicketModel.fromJson(Map<dynamic, dynamic> ticketModel) {
    try {
      return TicketModel(
          issueName: Utils.checkIsNotNull(ticketModel['issueName'])
              ? ticketModel['issueName']
              : 'Vô Danh',
          nvcontractStatus: ticketModel['nvcontractStatus'].toString(),
          empFullName: ticketModel['empFullName'].toString(),
          fullName: ticketModel['issueName'].toString(),
          customerId: ticketModel['customerId'],
          bucket: ticketModel['bucket'],
          periodBucket: ticketModel['periodBucket'],
          installmentAmt: ticketModel['installmentAmt'],
          installmentamount: ticketModel['installmentamount'],
          toCollect: ticketModel['toCollect'],
          issueClassCode: ticketModel['issueClassCode'].toString(),
          id: ticketModel['id'],
          issueCode: ticketModel['issueCode'],
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
          addressTypeId: ticketModel['addressTypeId'],
          permanentAddress: ticketModel['permanentAddress'],
          companyAddress: ticketModel['companyAddress'],
          cusMobilePhone:
              Utils.convertFormatPhone(ticketModel['cusMobilePhone'].toString()),
          lastPaymentDate: ticketModel['lastPaymentDate'],
          lastPaymentAmount: ticketModel['lastPaymentAmount'],
          lastEventDate: ticketModel['lastEventDate'],
          assignedDate: ticketModel['assignedDate'],
          cusFullAddress: ticketModel['cusFullAddress'].toString(),
          contractDetail: ticketModel['contractDetail'],
          contactDetail: ticketModel['contactDetail'],
          ticketActionLog: ticketModel['ticketActionLog'],
          ticketLastEvent: ticketModel['ticketLastEvent'],
          priorityLevel: ticketModel['priorityLevel'],
          isChecked: Utils.checkIsNotNull(ticketModel['isChecked'])
              ? ticketModel['isChecked']
              : false,
          managerCode: ticketModel['managerCode'],
          managerPosition: ticketModel['managerPosition'],
          managerName: Utils.checkIsNotNull(ticketModel['managerName'])
              ? ticketModel['managerName']
              : '',
          managerFullname: Utils.checkIsNotNull(ticketModel['managerFullname'])
              ? ticketModel['managerFullname']
              : '',
          caseExpirationDate: ticketModel['caseExpirationDate'],
          flagDeferment: ticketModel['flagDeferment'],
          flagLatecall: ticketModel['flagLatecall'],
          flagSummarize: ticketModel['flagSummarize'],
          customerAttitude: ticketModel['customerAttitude'],
          plannedDate: ticketModel['plannedDate'],
          flagCash24: ticketModel['flagCash24'],
          applId: ticketModel['applId'],
          // mustPay: Utils.checkIsNotNull(ticketModel['mustPay'])
          //     ? Utils.checkValueIsDouble(ticketModel['mustPay'])
          //         ? ticketModel['mustPay']
          //         : double.tryParse(ticketModel['mustPay'].toString())
          //     : null);
          mustPay: Utils.checkIsNotNull(ticketModel['mustPay'])
    ? double.tryParse(ticketModel['mustPay'].toString())
    : null);
    } catch (e) {
      print(e);
      return TicketModel();
    }
  }
}
