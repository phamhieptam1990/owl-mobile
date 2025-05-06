import 'package:flutter/material.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';

class ContactByTicketModel extends BaseModel {
  String? modeName;
  String? modeCode;
  String? recordStatus;
  String? makerId;
  String? authStatus;
  int? id;
  String? description;
  ContactByTicketModel(
      {this.modeName,
      this.modeCode,
      this.authStatus,
      this.makerId,
      this.id,
      this.description,
      this.recordStatus});

  Map toJson() => {
        'modeName': modeName,
        'modeCode': modeCode,
        'makerId': makerId,
        'id': id,
        'recordStatus': recordStatus,
        'description': description,
      };
  factory ContactByTicketModel.fromJson(
      Map<dynamic, dynamic> contactByTicketModel) {
    return ContactByTicketModel(
      modeName: contactByTicketModel['modeName'].toString(),
      modeCode: contactByTicketModel['modeCode'].toString(),
      makerId: contactByTicketModel['makerId'].toString(),
      id: contactByTicketModel['id'],
      recordStatus: contactByTicketModel['recordStatus'].toString(),
      description: contactByTicketModel['description'].toString(),
    );
  }

  @override
  Widget buildTitle(BuildContext text) {
    return Text(
      modeName ?? '',
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
