import 'package:athena/models/dashboard/number-dashboard.dart';
import 'package:athena/screens/home/widgets/customPaint-widget.dart';
import 'package:athena/screens/home/widgets/title_view.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class NumberDashboardView extends StatelessWidget {
  final dynamic dataNumber;
  NumberDashboardView({Key? key, required this.dataNumber}) : super(key: key);
  Widget listItem(Data item) {
    return InkWell(
        onTap: item.action as VoidCallback?,
        child: Row(
          children: <Widget>[
            Container(
              height: 55,
              width: 4,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 2),
                    child: Text(
                      item.name ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: -0.1,
                        color: Color(0xFF3A5160).withOpacity(0.7),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(item.icon, color: item.color)),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 3),
                        child: Text(
                          item.number ?? '0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 32,
                            color: Color(0xFF253840),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 3),
                        child: Text(
                          item.unit ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: -0.2,
                            color: Color(0xFF3A5160).withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            TitleView(
              titleTxt: dataNumber?.title ?? '',
              subTxt: dataNumber?.subTitle ?? '',
              action: dataNumber?.action,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(68.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Color(0xFF3A5160).withOpacity(0.2),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 7, left: 22, right: 22),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Column(
                              children: <Widget>[
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return listItem(dataNumber?.data[index]);
                                  },
                                  separatorBuilder: (context, position) {
                                    return Divider(
                                      height: 3,
                                    );
                                  },
                                  itemCount: dataNumber?.data?.length ?? 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 22,
                        ),
                        // InkWell(
                        //     onTap: dataNumber?.action,
                        //     child: new Container(
                        //       width: 70,
                        //       height: 70,
                        //       decoration: new BoxDecoration(
                        //         // color: Colors.green[600],
                        //         shape: BoxShape.circle,
                        //         border: new Border.all(
                        //           color: Colors.white,
                        //           width: 2.5,
                        //         ),
                        //         gradient: LinearGradient(
                        //           colors: [
                        //             Color.fromARGB(255, 58, 184, 62),
                        //             Color.fromARGB(255, 38, 134, 45),
                        //             Color.fromARGB(255, 6, 51, 9),
                        //           ],
                        //           begin: Alignment.center,
                        //           end: Alignment.topLeft,
                        //         ),
                        //       ),
                        //       child: Icon(
                        //           dataNumber?.icon ?? Icons.calendar_month,
                        //           color: Colors.white,
                        //           size: 25),
                        //     )),
                        InkWell(
                            onTap: dataNumber?.action,
                            child: ArcWidget(data: dataNumber?.data))
                        //  code tiep
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 24, right: 24, top: 8, bottom: 8),
                  //   child: Container(
                  //     height: 2,
                  //     decoration: BoxDecoration(
                  //       color: Color(0xFFF2F3F8),
                  //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ));
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  List<Color> colors;

  CurvePainter({this.colors = const [Colors.white, Colors.white], this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
     // Fix 7: Remove unnecessary null checks
    List<Color> colorsList = List.from(colors);
    
    // Fix 8: Ensure colorsList has at least 2 items
    if (colorsList.isEmpty) {
      colorsList.addAll([Colors.white, Colors.white]);
    } else if (colorsList.length == 1) {
      colorsList.add(colorsList[0]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
