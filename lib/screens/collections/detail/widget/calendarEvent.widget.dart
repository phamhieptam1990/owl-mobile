import 'package:flutter/widgets.dart';
import 'package:athena/common/constants/color.dart';

class CalendarEventWidget extends StatelessWidget {
  final DateTime date;
  final color;
  final checkColor;
  CalendarEventWidget(
      {required this.date, this.color, this.checkColor = false});
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 60.0,
            height: 20.0,
            // alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: checkColor ? color : AppColor.orange,
            ),
            child: Text("TH " + date.month.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColor.white)),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 7.0),
            width: 60.0,
            height: 40.0,
            decoration:
                BoxDecoration(border: Border.all(color: AppColor.blackOpacity)),
            child: Text(
              date.day.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ]);
  }
}
