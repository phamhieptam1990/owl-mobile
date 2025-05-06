import 'package:flutter/material.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';

class ActionSubAttributeModel extends BaseModel {
  ActionSubAttributeModel({
    this.orderNo,
    this.attributeValue,
    this.authStatus,
    this.description,
    this.attributeCode,
    this.modNo,
    this.recordStatus,
    this.attributeName,
    this.id,
    this.actionAttributeId,
    this.makerId,
    this.groupId,
  });

  final String? orderNo;
  final String? attributeValue;
  final String? authStatus;
  final String? description;
  final String? attributeCode;
  final int? modNo;
  final String? recordStatus;
  final String? attributeName;
  final int? id;
  final int? actionAttributeId;
  final String? makerId;
  final int? groupId;

  factory ActionSubAttributeModel.fromJson(Map<dynamic, dynamic> json) =>
      ActionSubAttributeModel(
        orderNo: json["orderNo"],
        attributeValue: json["attributeValue"],
        authStatus: json["authStatus"],
        description: json["description"],
        attributeCode: json["attributeCode"],
        modNo: json["modNo"],
        recordStatus: json["recordStatus"],
        attributeName: json["attributeName"],
        id: json["id"],
        actionAttributeId: json["actionAttributeId"],
        makerId: json["makerId"],
        groupId: json["groupId"],
      );

  Map<String, dynamic> toJson() => {
        "orderNo": orderNo,
        "attributeValue": attributeValue,
        "authStatus": authStatus,
        "description": description,
        "attributeCode": attributeCode,
        "modNo": modNo,
        "recordStatus": recordStatus,
        "attributeName": attributeName,
        "id": id,
        "actionAttributeId": actionAttributeId,
        "makerId": makerId,
        "groupId": groupId,
      };

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      description ?? '',
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}