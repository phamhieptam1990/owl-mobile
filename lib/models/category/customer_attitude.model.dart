import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';

// ignore: must_be_immutable
class CustomerAttitudeModel extends Equatable with BaseModel {
  String title;
  var value;
  CustomerAttitudeModel(this.title, this.value);

  @override
  List<Object> get props => [title, value];

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
