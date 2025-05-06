import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'indicator.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import '../../../../getit.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/utils/services/category/category.provider.dart';
// Contract Details
// Other Checkin
// PTP - Promise To Pay
// Refuse to Pay
// Partial Payment
// Full Payment

class PieChartReport extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartReportState();
}

class PieChartReportState extends State {
  final _filterCollection = getIt<FilterCollectionsProvider>();
  final _categorySingeton = new CategorySingeton();
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                      // Fix 3: Update callback signature to match fl_chart
                      touchCallback: (FlTouchEvent event, PieTouchResponse? pieTouchResponse) {
                        if (event is FlLongPressStart) {
                          // Fix 4: Add null check for pieTouchResponse
                          if (pieTouchResponse?.touchedSection != null) {
                            int tempTouchIndex = pieTouchResponse
                                  ?.touchedSection?.touchedSectionIndex ??
                              -1;

                            setState(() {
                              touchedIndex = -1;
                            });
                            handleRequestData(tempTouchIndex);
                          }
                        } else if (event is FlLongPressEnd) {
                          setState(() {
                            touchedIndex = -1;
                          });
                        } else if (pieTouchResponse?.touchedSection != null) {
                          setState(() {
                            touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex ??
                              -1;
                          });
                        }
                      }),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    sections: showingSections()),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                    color: Color(0xff0293ee),
                    text: 'Contract Details',
                    isSquare: true,
                  ),
                  Indicator(
                    color: Color(0xfff8b250),
                    text: S.of(context).otherCheckIn,
                    isSquare: true,
                  ),
                  Indicator(
                    color: Color(0xFFFF2B45),
                    text: S.of(context).payment,
                    isSquare: true,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                    color: Color(0xff13d38e),
                    text: S.of(context).refuseToPay,
                    isSquare: true,
                  ),
                  Indicator(
                    color: Color(0xff845bef),
                    text: S.of(context).promiseToPay,
                    isSquare: true,
                  ),
                  Indicator(
                    color: Colors.transparent,
                    text: '',
                    isSquare: true,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> handleRequestData(int index) async {
    try {
      await _categorySingeton.initAllCateogyData();
      if (_categorySingeton.lstStatusTicketModel.length > 0) {
        this._filterCollection.statusTicketModel = new StatusTicketModel();
        int finalIndex = -1;
        String title = '';
        if (index == 4) {
          this._filterCollection.statusTicketModel = StatusTicketModel();
        } else {
          for (StatusTicketModel model
              in this._categorySingeton.lstStatusTicketModel) {
            // if(model == )
            if (index == 0) {
              if (model.actionGroupCode == FieldTicketConstant.RTP) {
                finalIndex = model.id ?? -1;
                title = S.of(context).refuseToPay;
                break;
              }
            }
            if (index == 1) {
              if (model.actionGroupCode == FieldTicketConstant.OTHER) {
                finalIndex = model.id ?? -1;
                title = S.of(context).otherCheckIn;
                break;
              }
            }
            if (index == 2) {
              if (model.actionGroupCode == FieldTicketConstant.PTP) {
                finalIndex = model.id ?? -1;
                title = S.of(context).promiseToPay;
                break;
              }
            }
            if (index == 3) {
              if (model.actionGroupCode == FieldTicketConstant.PAY) {
                finalIndex = model.id ?? -1;
                title = S.of(context).payment;
                break;
              }
            }
          }
          this._filterCollection.statusTicketModel = new StatusTicketModel();
          this._filterCollection.statusTicketModel?.id = finalIndex;
        }
        Utils.pushName(context, RouteList.COLLECTION_SCREEN, params: title);
      }
    } catch (e) {
      print(e);
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 120 : 100;
      // final double fontSize = 16;
      // final double radius = 100;
      switch (i) {
        case 0:
          return PieChartSectionData(
              color: const Color(0xff13d38e),
              value: 10,
              title: '10%',
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)));
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 10,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xFFFF2B45),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        // case 4:
        //   return PieChartSectionData(
        //     color: const Color(0xFFF67264),
        //     value: 20,
        //     title: '20%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //         fontSize: fontSize,
        //         fontWeight: FontWeight.bold,
        //         color: const Color(0xffffffff)),
        //   );
        case 4:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
