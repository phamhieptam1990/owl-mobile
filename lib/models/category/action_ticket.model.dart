import 'package:flutter/material.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';

class ActionTicketModel extends BaseModel {
  String? actionCode;
  String? actionName;
  String? actionValue;
  String? recordStatus;
  String? makerId;
  String? authStatus;
  int? id;
  String? description;
  dynamic fetmAction;
  
  ActionTicketModel({
    this.actionCode,
    this.actionName,
    this.actionValue,
    this.id,
    this.fetmAction,
    this.description,
    this.recordStatus,
    this.makerId,
    this.authStatus,
  });

  Map<String, dynamic> toJson() => {
        'actionCode': actionCode,
        'actionName': actionName,
        'actionValue': actionValue,
        'id': id,
        'recordStatus': recordStatus,
        'description': description,
        'fetmAction': fetmAction,
        'makerId': makerId,
        'authStatus': authStatus,
      };
      
  factory ActionTicketModel.fromJson(Map<dynamic, dynamic> actionTicketModel) {
    return ActionTicketModel(
      actionCode: actionTicketModel['actionCode']?.toString(),
      actionName: actionTicketModel['actionName']?.toString(),
      actionValue: actionTicketModel['actionValue']?.toString(),
      id: actionTicketModel['id'],
      fetmAction: actionTicketModel['fetmAction'],
      recordStatus: actionTicketModel['recordStatus']?.toString(),
      description: actionTicketModel['description']?.toString(),
      makerId: actionTicketModel['makerId']?.toString(),
      authStatus: actionTicketModel['authStatus']?.toString(),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      fetmAction != null && fetmAction['actionValue'] != null 
          ? fetmAction['actionValue'] 
          : '',
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}