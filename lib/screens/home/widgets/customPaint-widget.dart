import 'package:athena/models/dashboard/number-dashboard.dart';
import 'package:athena/screens/collections/collection/history_payment_card_response.dart';
import 'package:athena/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ArcWidget extends StatefulWidget {
  final data;
  const ArcWidget({Key? key, required this.data}) : super(key: key);

  @override
  _ArcWidgetState createState() => _ArcWidgetState();
}

convertData(data) {
  double percent = 0.0;
  double total = 0.0;
  if (Utils.isArray(data)) {
    for (var i = 0; i < 2; i++) {
      Data item = data[i];
      total += tryToParseInt(item.number) ?? 0;
    }
    if (total > 0) percent = tryToParseInt(data[1].number ?? 0) / total;
  }

  return [percent, total];
}

class _ArcWidgetState extends State<ArcWidget> {
  final double width = 100;
  final double height = 100;

  double total = 0.0;
  double baseAngle = 0;
  Offset? lastPosition;
  double lastBaseAngle = 0;

  @override
  Widget build(BuildContext context) {
    double percent = convertData(widget.data).first;
    double total = convertData(widget.data).last;
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Center(
            child: Stack(clipBehavior: Clip.none, children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(
                Radius.circular(100.0),
              ),
              border: new Border.all(
                  width: 4, color: Color(0xFF2633C5).withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  tryToParseInt(total).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                    letterSpacing: 0.0,
                    color: Color(0xFF2633C5),
                  ),
                ),
                Text(
                  'Tổng',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    color: Color(0xFF3A5160).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              painter: ArcPainter(50, baseAngle, percent),
              child: GestureDetector(
                onVerticalDragStart: (value) {
                  setInitialState(value);
                },
                onHorizontalDragUpdate: (value) {
                  updateAngle(value);
                },
                onVerticalDragUpdate: (value) {
                  updateAngle(value);
                },
                onHorizontalDragStart: (value) {
                  setInitialState(value);
                },
              ),
            ),
          )
        ])));
  }

  void updateAngle(DragUpdateDetails value) {
    double result = 0.0;

    if (lastPosition != null) {
      result = math.atan2(value.localPosition.dy - height / 2,
              value.localPosition.dx - width / 2) -
          math.atan2(
              lastPosition!.dy - height / 2, lastPosition!.dx - width / 2);
    }
    // double result = math.atan2(value.localPosition.dy - height / 2,
    //         value.localPosition.dx - width / 2) -
    //     math.atan2(lastPosition?.dy - height / 2, lastPosition?.dx - width / 2);
    setState(() {
      baseAngle = lastBaseAngle + result;
    });
  }

  void setInitialState(DragStartDetails value) {
    lastPosition = value.localPosition;
    lastBaseAngle = baseAngle;
  }
}

class ArcPainter extends CustomPainter {
  final double radius;
  double baseAngle;
  // final Paint red = createPaintForColor(Colors.red);
  // final Paint blue = createPaintForColor(Colors.blue);
  Paint? green;
  double percent;

  ArcPainter(this.radius, this.baseAngle, this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
    green = createPaintForColor(Colors.green, size, 50 / 100);
    // canvas.drawArc(rect, baseAngle, sweepAngle(), false, blue);
    // canvas.drawArc(rect, baseAngle + 2 / 3 * math.pi, sweepAngle(), false, red);
    canvas.drawArc(rect, 3 * math.pi / 2, sweepAngle(percent), false, green!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double sweepAngle(percent) => (2 * math.pi) * percent;
}

Paint createPaintForColor(Color color, size, percent) {
  return Paint()
    ..color = color
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15;
}
