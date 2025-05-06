import 'package:flutter/material.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';

class StatusTicketModel extends BaseModel {
  String? actionGroupName;
  String? actionGroupCode;
  String? recordStatus;
  String? makerId;
  String? authStatus;
  int? id;
  int? fieldTypeId;
  String? description;
  
  StatusTicketModel({
    this.actionGroupName,
    this.actionGroupCode,
    this.makerId,
    this.id,
    this.fieldTypeId,
    this.description,
    this.recordStatus,
    this.authStatus,
  });

  Map<String, dynamic> toJson() => {
        'fieldTypeId': fieldTypeId,
        'actionGroupName': actionGroupName,
        'actionGroupCode': actionGroupCode,
        'id': id,
        'recordStatus': recordStatus,
        'makerId': makerId,
        'description': description,
        'authStatus': authStatus,
      };
      
  factory StatusTicketModel.fromJson(Map<dynamic, dynamic> statusTicketModel) {
    return StatusTicketModel(
      fieldTypeId: statusTicketModel['fieldTypeId'],
      actionGroupName: statusTicketModel['actionGroupName']?.toString(),
      actionGroupCode: statusTicketModel['actionGroupCode']?.toString(),
      id: statusTicketModel['id'],
      makerId: statusTicketModel['makerId']?.toString(),
      description: statusTicketModel['description']?.toString(),
      recordStatus: statusTicketModel['recordStatus']?.toString(),
      authStatus: statusTicketModel['authStatus']?.toString(),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      convertActionGroupName(
        actionGroupCode ?? '', 
        actionGroupName ?? '', 
        context
      ),
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }

  String convertActionGroupName(
      String actionGroupCode, String actionGroupName, BuildContext context) {
    // return actionGroupName;
    if (actionGroupName.isNotEmpty) {
      return actionGroupName;
    }
    if (actionGroupCode == FieldTicketConstant.PAY) {
      return S.of(context).customerPartialPayment;
    }
    if (actionGroupCode == FieldTicketConstant.C_PAY) {
      return S.of(context).customerPartialPaymentC;
    }
    if (actionGroupCode == FieldTicketConstant.PTP) {
      return S.of(context).customerPromiseToPay;
    }
    if (actionGroupCode == FieldTicketConstant.C_PTP) {
      return S.of(context).customerPromiseToPayC;
    }
    if (actionGroupCode == FieldTicketConstant.RTP) {
      return S.of(context).customerRefuseToPay;
    }
    if (actionGroupCode == FieldTicketConstant.C_RTP) {
      return S.of(context).customerRefuseToPayC;
    }
    if (actionGroupCode == FieldTicketConstant.OTHER) {
      return S.of(context).otherCheckIn;
    }
    if (actionGroupCode == FieldTicketConstant.C_OTHER) {
      return S.of(context).otherCheckInC;
    }

    return actionGroupCode;
  }
}