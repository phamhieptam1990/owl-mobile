import 'package:flutter/material.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';

class ActionAttributeTicketModel extends BaseModel {
  int? orderNo;
  String? attributeValue;
  String? authStatus;
  String? attributeCode;
  int? modNo;
  String? recordStatus;
  int? actionGroupId;
  int? actionId;
  String? attributeName;
  int? id;
  String? makerId;
  String? description;
  
  ActionAttributeTicketModel({
    this.orderNo,
    this.attributeValue,
    this.authStatus,
    this.attributeCode,
    this.modNo,
    this.recordStatus,
    this.actionGroupId,
    this.actionId,
    this.attributeName,
    this.id,
    this.description,
    this.makerId,
  });

  ActionAttributeTicketModel.fromJson(Map<dynamic, dynamic> json) {
    orderNo = json['orderNo'];
    attributeValue = json['attributeValue'];
    authStatus = json['authStatus'];
    attributeCode = json['attributeCode'];
    modNo = json['modNo'];
    recordStatus = json['recordStatus'];
    actionGroupId = json['actionGroupId'];
    actionId = json['actionId'];
    attributeName = json['attributeName'];
    id = json['id'];
    makerId = json['makerId'];
    description = json['description'] ?? '';
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = Map<dynamic, dynamic>();
    data['orderNo'] = orderNo;
    data['attributeValue'] = attributeValue;
    data['authStatus'] = authStatus;
    data['attributeCode'] = attributeCode;
    data['modNo'] = modNo;
    data['recordStatus'] = recordStatus;
    data['actionGroupId'] = actionGroupId;
    data['actionId'] = actionId;
    data['attributeName'] = attributeName;
    data['id'] = id;
    data['makerId'] = makerId;
    data['description'] = description ?? '';
    return data;
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      description ?? '',
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}