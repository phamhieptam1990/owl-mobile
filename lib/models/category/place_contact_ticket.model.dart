import 'package:flutter/material.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';

class PlaceContactTicketModel extends BaseModel {
  String? placeValue;
  String? placeName;
  String? placeCode;
  String? recordStatus;
  String? makerId;
  String? authStatus;
  int? id;
  String? description;
  PlaceContactTicketModel(
      {this.placeValue,
      this.placeName,
      this.placeCode,
      this.authStatus,
      this.makerId,
      this.id,
      this.description,
      this.recordStatus});

  Map toJson() => {
        'placeValue': placeValue,
        'placeName': placeName,
        'placeCode': placeCode,
        'makerId': makerId,
        'id': id,
        'recordStatus': recordStatus,
        'description': description,
      };
  factory PlaceContactTicketModel.fromJson(
      Map<dynamic, dynamic> placeContactTicketModel) {
    return PlaceContactTicketModel(
      placeValue: placeContactTicketModel['placeValue'].toString(),
      placeName: placeContactTicketModel['placeName'].toString(),
      placeCode: placeContactTicketModel['placeCode'].toString(),
      makerId: placeContactTicketModel['makerId'].toString(),
      id: placeContactTicketModel['id'],
      recordStatus: placeContactTicketModel['recordStatus'].toString(),
      description: placeContactTicketModel['description'].toString(),
    );
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      placeName ?? '',
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
