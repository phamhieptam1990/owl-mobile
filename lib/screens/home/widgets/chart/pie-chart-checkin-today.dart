import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/screens/home/home.service.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../home.provider.dart';
import 'indicator.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import '../../../../getit.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/utils/services/category/category.provider.dart';
// Contract Details
// Other Checkin
// PTP - Promise To Pay
// Refuse to Pay
// Partial Payment
// Full Payment

class PieChartCheckInToday extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartCheckInTodayState();
}

class PieChartCheckInTodayState extends State {
  final _filterCollection = getIt<FilterCollectionsProvider>();
  final _categorySingeton = new CategorySingeton();
  final _homeService = new HomeService();
  int touchedIndex = -1;
  final homeProvider = getIt<HomeProvider>();
  final userInfoStore = getIt<UserInfoStore>();

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
                    pieTouchData:
                        PieTouchData(touchCallback: (event, pieTouchResponse) {
                      if (event is FlLongPressStart) {
                        touchedIndex =
                            pieTouchResponse?.touchedSection?.touchedSectionIndex ?? -1;
                        // if (touchedIndex == null) {
                        //   return;
                        // }
                        print('touchedIndex: $touchedIndex');
                        int tempTouchIndex = touchedIndex;
                        setState(() {
                          touchedIndex = -1;
                        });
                        handleRequestData(tempTouchIndex);
                      } else if (event is FlLongPressEnd) {
                         print('touchedIndex: $touchedIndex');
                      //   setState(() {
                      //     touchedIndex = -1;
                      //   });
                      // } else {
                      //   setState(() {
                      //     touchedIndex = pieTouchResponse
                      //         .touchedSection.touchedSectionIndex;
                      //   });
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
                    color: Color(0xff4472c4),
                    text: 'Tổng số case',
                    isSquare: true,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                    color: Color(0xffee7e33),
                    text: 'Checkin',
                    isSquare: true,
                  )
                ],
              )
            ],
          ),
        ],
      ),
      // child: Column(
      //   children: <Widget>[
      //     Center(child: Text(S.of(context).customerComplain)),
      //     Center(
      //       child: PieChart(
      //         PieChartData(
      //             pieTouchData:
      //                 PieTouchData(touchCallback: (pieTouchResponse) {
      //               if (pieTouchResponse.touchInput is FlLongPressStart) {
      //                 touchedIndex = pieTouchResponse.touchedSectionIndex;
      //                 if (touchedIndex == null) {
      //                   return;
      //                 }
      //                 int tempTouchIndex = touchedIndex;
      //                 setState(() {
      //                   touchedIndex = -1;
      //                 });
      //                 handleRequestData(tempTouchIndex);
      //               } else if (pieTouchResponse.touchInput
      //                       is FlLongPressEnd ||
      //                   pieTouchResponse.touchInput is FlPanEnd) {
      //                 setState(() {
      //                   touchedIndex = -1;
      //                 });
      //               } else {
      //                 setState(() {
      //                   touchedIndex = pieTouchResponse.touchedSectionIndex;
      //                 });
      //               }
      //             }),
      //             borderData: FlBorderData(
      //               show: false,
      //             ),
      //             sectionsSpace: 0,
      //             centerSpaceRadius: 30,
      //             sections: showingSections()),
      //       ),
      //     ),
      //     SizedBox(
      //       height: 4,
      //     ),
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Indicator(
      //               color: Color(0xffee7e33),
      //               text: 'Contract Details',
      //               isSquare: true,
      //             ),
      //             Indicator(
      //               color: Color(0xfff8b250),
      //               text: S.of(context).otherCheckIn,
      //               isSquare: true,
      //             ),
      //             Indicator(
      //               color: Color(0xFFFF2B45),
      //               text: S.of(context).payment,
      //               isSquare: true,
      //             ),
      //           ],
      //         ),
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Indicator(
      //               color: Color(0xff13d38e),
      //               text: S.of(context).refuseToPay,
      //               isSquare: true,
      //             ),
      //             Indicator(
      //               color: Color(0xff845bef),
      //               text: S.of(context).promiseToPay,
      //               isSquare: true,
      //             ),
      //             Indicator(
      //               color: Colors.transparent,
      //               text: '',
      //               isSquare: true,
      //             ),
      //           ],
      //         )
      //       ],
      //     ),
      //     SizedBox(
      //       height: 4,
      //     ),
      //   ],
      // )
    );
  }

  Future<void> handleRequestData(int index) async {
    try {
      await _categorySingeton.initAllCateogyData();
      if (homeProvider.totalCase > 0) {
        int finalIndex = -1;
        String title = '';
        if (index == 4) {
          this._filterCollection.statusTicketModel = StatusTicketModel();
        } else {
          if(index == 1){
            final empCode = await this.userInfoStore.user?.moreInfo!['empCode'];
            if(empCode == null || empCode == '') {
              WidgetCommon.showSnackbarErrorGet('Không tìm thấy mã nhân viên');
              return;
            }
            final data = await this._homeService.getCaseCheckInToday(empCode);
            if(Utils.checkIsNotNull(data)){
              // print(data);
              final dataHandle = Utils.handleRequestData(data);
              if(Utils.isArray(dataHandle)){
                List<String> aggids = [];
                for(var aggId in dataHandle){
                  aggids.add(aggId['ticketAggid']);
                }
                print(dataHandle);
                this._filterCollection.aggids = aggids;
              }
            }
          }
        }
        Utils.pushName(context, RouteList.COLLECTION_SCREEN, params: title);
      }
    } catch (e) {
      print(e);
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 120 : 100;
      // final double fontSize = 16;
      // final double radius = 100;
      switch (i) {
        case 0:
          return PieChartSectionData(
              // color: const Color(0xff13d38e),
              //  color: Color(0xffee7e33),
              color: Color(0xff4472c4),
              //  value: 35,
              value: homeProvider.totalCase.toDouble(),
              title: homeProvider.totalCase.toString(),
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)));
        case 1:
          return PieChartSectionData(
             color: Color(0xffee7e33),
            value: homeProvider.checkInCase.toDouble(),
            title: homeProvider.checkInCase.toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return PieChartSectionData(
            color: Colors.grey,
            value: 0,
            title: '0',
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
