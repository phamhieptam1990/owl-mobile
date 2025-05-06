import 'package:flutter/material.dart';

class CustomerNameCheckInWidget extends StatelessWidget {
  final String? customerFullName;
  CustomerNameCheckInWidget({Key? key, @required this.customerFullName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(7.0),
      child: Text(
        customerFullName ?? '',
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.black),
      ),
    ));
  }
}
