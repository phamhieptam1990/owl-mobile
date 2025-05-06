import 'package:flutter/material.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';

class ContactPersonTicketModel extends BaseModel {
  String? personName;
  String? personValue;
  String? personCode;
  String? recordStatus;
  String? makerId;
  String? authStatus;
  int? id;
  String? description;
  ContactPersonTicketModel(
      {this.personName,
      this.personValue,
      this.personCode,
      this.authStatus,
      this.makerId,
      this.id,
      this.description,
      this.recordStatus});

  Map toJson() => {
        'personName': personName,
        'personValue': personValue,
        'personCode': personCode,
        'makerId': makerId,
        'id': id,
        'recordStatus': recordStatus,
        'description': description,
      };
  factory ContactPersonTicketModel.fromJson(
      Map<dynamic, dynamic> contactPersonTicketModel) {
    return ContactPersonTicketModel(
      personName: contactPersonTicketModel['personName'].toString(),
      personValue: contactPersonTicketModel['personValue'].toString(),
      personCode: contactPersonTicketModel['personCode'].toString(),
      makerId: contactPersonTicketModel['makerId'].toString(),
      id: contactPersonTicketModel['id'],
      recordStatus: contactPersonTicketModel['recordStatus'].toString(),
      description: contactPersonTicketModel['description'].toString(),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      personName ?? '',
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
