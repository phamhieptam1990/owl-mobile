import 'package:flutter/material.dart';

class ToturialWidget extends StatelessWidget {
  final String title;
  final String description;

  const ToturialWidget({this.title = 'Hướng dẫn', this.description = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              description,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
