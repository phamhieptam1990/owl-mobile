import 'package:athena/models/map/location.model.dart';

class MapTicketModel {
  String? cusMobilePhone;
  String? issueName;
  String? fullName;
  String? customerId;
  String? issueClassCode;
  int? id;
  String? issueCode;
  String? makerId;
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
  String? cusFullAddress;
  Location? location;
  String? feType;
  String? assignedDate;
  var assigneeData;
  var customerData;
  var ticketDetail;
  var fieldTypeCode;
  String? permanentAddress;
  String? companyAddress;
  var addressTypeId;
  MapTicketModel(
      {this.issueName,
      this.cusMobilePhone,
      this.fullName,
      this.customerId,
      this.issueClassCode,
      this.id,
      this.issueCode,
      this.makerId,
      this.authStatus,
      this.reporter,
      this.recordStatus,
      this.contractId,
      this.aggId,
      this.feType,
      this.assignee,
      this.statusCode,
      this.status,
      this.phone,
      this.actionGroupName,
      this.actionGroupCode,
      this.assigneeData,
      this.customerData,
      this.ticketDetail,
      this.fieldTypeCode,
      this.location,
      this.assignedDate,
      this.permanentAddress,
      this.companyAddress,
      this.addressTypeId,
      this.cusFullAddress});

  Map<String, dynamic> convertToJson(MapTicketModel map) {
    return map.toJson();
  }

  Map<String, dynamic> toJson() => {
        'issueName': issueName,
        'fullName': fullName,
        'customerId': customerId,
        'issueClassCode': issueClassCode,
        'id': id,
        'issueCode': issueCode,
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
        'cusFullAddress': cusFullAddress,
        'permanentAddress': permanentAddress,
        'companyAddress': companyAddress,
        "addressTypeId": addressTypeId,
        'location': location,
        'cusMobilePhone': cusMobilePhone,
        'assignedDate': assignedDate,
        'feType': feType
      };

  factory MapTicketModel.fromJson(Map<String, dynamic> ticketModel) {
    return MapTicketModel(
        issueName: ticketModel['issueName'].toString(),
        fullName: ticketModel['issueName'].toString(),
        customerId: ticketModel['customerId'],
        issueClassCode: ticketModel['issueClassCode'].toString(),
        id: ticketModel['id'],
        issueCode: ticketModel['issueCode'].toString(),
        makerId: ticketModel['makerId'].toString(),
        authStatus: ticketModel['authStatus'].toString(),
        reporter: ticketModel['reporter'].toString(),
        recordStatus: ticketModel['recordStatus'].toString(),
        contractId: ticketModel['contractId'],
        aggId: ticketModel['aggId'].toString(),
        assignee: ticketModel['assignee'],
        statusCode: ticketModel['statusCode'].toString(),
        status: ticketModel['status'].toString(),
        phone: ticketModel['phone'],
        actionGroupName: ticketModel['actionGroupName'].toString(),
        actionGroupCode: ticketModel['actionGroupCode'].toString(),
        assigneeData: ticketModel['assigneeData'],
        customerData: ticketModel['customerData'],
        ticketDetail: ticketModel['ticketDetail'],
        fieldTypeCode: ticketModel['fieldTypeCode'],
        cusFullAddress: ticketModel['cusFullAddress'].toString(),
        permanentAddress: ticketModel['permanentAddress'].toString(),
        companyAddress: ticketModel['companyAddress'].toString(),
        addressTypeId: ticketModel['addressTypeId'],
        location: ticketModel['location'],
        assignedDate: ticketModel['assignedDate'],
        feType: ticketModel['feType'],
        cusMobilePhone: ticketModel['cusMobilePhone'].toString());
  }
}
