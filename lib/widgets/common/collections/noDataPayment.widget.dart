import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';

class NoDataPayment extends StatelessWidget {
  final String? title;
  NoDataPayment({this.title});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
            child: Text(
              this.title ?? '',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: AppFont.fontSize18),
            )));
  }
}
