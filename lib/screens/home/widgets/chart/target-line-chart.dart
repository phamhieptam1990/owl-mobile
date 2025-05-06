import 'package:flutter/material.dart';
import 'package:athena/utils/utils.dart';

class TargetDashboardWidget extends StatelessWidget {
  const TargetDashboardWidget({
    Key? key,
    required this.info,
  }) : super(key: key);

  final TargetDashboardModel info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
              child: Padding(
            padding: EdgeInsets.only(bottom: 7.0, top: 0.0),
            child: Text(
              info.title,
              // Utils.formatPrice(info.current.toString()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              // style: Padding(padding: EdgeInsets.all(value)),
            ),
          )),
          ProgressLine(
            color: info.color,
            percentage: info.percentage,
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  Utils.formatPrice(info.current.toString()) +
                      ' / ' +
                      Utils.formatPrice(info.target.toString()),
                  style: TextStyle(color: Colors.black, fontSize: 16.0)),
              Text(info.percentage.toString() + '%',
                  style: TextStyle(color: Colors.black, fontSize: 16.0)),
            ],
          ),
          SizedBox(height: 5.0),
          // Text(
          //     "Hiện đã thu được : " +
          //         Utils.formatPrice(info.current.toString()),
          //     style: TextStyle(color: Colors.black, fontSize: 16.0)),
          // Text("Hoàn thành : " + info.percentage.toString() + ' %',
          //     style: TextStyle(color: Colors.black, fontSize: 16.0)),
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    required this.color,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 20,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            // width: (AppState.getWidthDevice(context)) * (percentage / 100),
            width: constraints.maxWidth * (percentage / 100),
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }
}

class TargetDashboardModel {
  final String title;
  final int current, target, percentage;
  final Color color;

  TargetDashboardModel({
    required this.title,
    required this.current,
    required this.target,
    required this.percentage,
    required this.color,
  });
}
