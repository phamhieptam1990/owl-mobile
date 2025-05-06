import 'package:after_layout/after_layout.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/home/home.service.dart';
import 'indicator.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import '../../../../getit.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:dio/dio.dart';
import 'package:athena/screens/collections/collection/collections.provider.dart';

class PieChartCollection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartCollectionState();
}

class PieChartCollectionState extends State with AfterLayoutMixin {
  List<StatusTicketModel> lstStatusTicketModel = [];
  final _collectionProvider = getIt<CollectionProvider>();
  final _filterCollection = getIt<FilterCollectionsProvider>();
  final _categorySingeton = new CategorySingeton();
  int touchedIndex = -1;
  int total = 0;
  int totalSub = 0;
  bool isLoading = true;
  dynamic lstData = [];
  Map<String, dynamic> lstDataFinal = {};
  List<dynamic> lstDataChart = [];
  int countItem = 0;
  final homeProvider = getIt<HomeProvider>();
  final _homeService = new HomeService();
  // final _categoryService = new CategoryService();
  conertPhantram(value, total) {
    return value * 100 / total;
  }

  checkActionNam(actionName) {
    if (actionName == FieldTicketConstant.RTP ||
        actionName == FieldTicketConstant.OTHER ||
        actionName == FieldTicketConstant.PTP ||
        actionName == FieldTicketConstant.PAY ||
        actionName == FieldTicketConstant.NO) {
      return true;
    }
    return false;
  }

  Future<void> handleFetchData() async {
    try {
      Response response =
          await this._homeService.getCollectionContractStatusAgg();
      if (Utils.checkRequestIsComplete(response)) {
        lstData = response.data['data'];
        lstDataChart = [];
        if (lstData != null) {
          total = 0;
          totalSub = 0;
          countItem = 0;
          for (var item in lstData) {
            int quantity = item['quantity'] ?? 0;
            if (quantity > 0 && checkActionNam(item['actionName'])) {
              countItem = countItem + 1;
              if (lstDataChart.isEmpty ||
                  lstDataChart.length == 0) {
                lstDataChart = [item];
              } else
                lstDataChart.add(item);
            }
            total += quantity;
            if (item['actionName'] == FieldTicketConstant.RTP) {
              totalSub += quantity;
              lstDataFinal[FieldTicketConstant.RTP] = item;
            } else if (item['actionName'] == FieldTicketConstant.OTHER) {
              totalSub += quantity;
              lstDataFinal[FieldTicketConstant.OTHER] = item;
            } else if (item['actionName'] == FieldTicketConstant.PTP) {
              totalSub += quantity;
              lstDataFinal[FieldTicketConstant.PTP] = item;
            } else if (item['actionName'] == FieldTicketConstant.PAY) {
              totalSub += quantity;
              lstDataFinal[FieldTicketConstant.PAY] = item;
            } else if (item['actionName'] == FieldTicketConstant.NO) {
              totalSub += quantity;
              lstDataFinal[FieldTicketConstant.NO] = item;
            }
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await handleFetchData();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == false && countItem > 0
        ? Container(
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                        pieTouchData: PieTouchData(
                            enabled: true,
                            touchCallback: (event, pieTouchResponse) {
                              if (event is FlLongPressStart) {
                                if (pieTouchResponse?.touchedSection != null) {
                                  touchedIndex = pieTouchResponse
                                          ?.touchedSection
                                          ?.touchedSectionIndex ??
                                      -1;

                                  int tempTouchIndex = touchedIndex;
                                  setState(() {
                                    touchedIndex = -1;
                                  });
                                  handleRequestData(tempTouchIndex);
                                } else if (event is FlLongPressEnd) {
                                  setState(() {
                                    touchedIndex = -1;
                                  });
                                } else {
                                  setState(() {
                                    touchedIndex = pieTouchResponse
                                        ?.touchedSection?.touchedSectionIndex ?? -1;
                                  });
                                }
                              }
                            }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 30,
                        sections: showingSections()),
                  ),
                )),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Indicator(
                          color: Color(0xff0293ee),
                          text: S.of(context).noCheckin,
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
                SizedBox(
                  height: 4,
                ),
              ],
            ))
        : Container();
  }

  Future<void> handleRequestData(int index) async {
    try {
      int finalIndex = -1;
      await _categorySingeton.initAllCateogyData();
      if (_categorySingeton.lstStatusTicketModel.length > 0) {
        this._filterCollection.statusTicketModel = new StatusTicketModel();
        String title = '';
        switch (lstDataChart[index]['actionName']) {
          case FieldTicketConstant.NO:
            finalIndex = 4;
            break;
          case FieldTicketConstant.RTP:
            finalIndex = 0;
            break;
          case FieldTicketConstant.OTHER:
            finalIndex = 1;
            break;
          case FieldTicketConstant.PTP:
            finalIndex = 2;
            break;
          case FieldTicketConstant.PAY:
            finalIndex = 3;
            break;
          default:
            break;
        }

        if (finalIndex == 4) {
          this._filterCollection.statusTicketModel = StatusTicketModel();
          if (!Utils.checkIsNotNull(this._collectionProvider.filter)) {
            this._collectionProvider.filter = {};
          }
          this._collectionProvider.filter["hasCheckinInMonth"] = {
            "type": FilterType.EQUALS,
            "filter": FilterType.FALSE,
            "filterType": "text"
          };
          title = S.of(context).noCheckin;
        } else {
          for (StatusTicketModel model
              in this._categorySingeton.lstStatusTicketModel) {
            if (finalIndex == 0) {
              if (model.actionGroupCode == FieldTicketConstant.RTP) {
                finalIndex = model.id ?? -1;
                title = S.of(context).refuseToPay;
                break;
              }
            }
            if (finalIndex == 1) {
              if (model.actionGroupCode == FieldTicketConstant.OTHER) {
                finalIndex = model.id ?? -1;
                title = S.of(context).otherCheckIn;
                break;
              }
            }
            if (finalIndex == 2) {
              if (model.actionGroupCode == FieldTicketConstant.PTP) {
                finalIndex = model.id ?? -1;
                title = S.of(context).promiseToPay;
                break;
              }
            }
            if (finalIndex == 3) {
              if (model.actionGroupCode == FieldTicketConstant.PAY) {
                finalIndex = model.id ?? -1;
                title = S.of(context).payment;
                break;
              }
            }
          }
          this._filterCollection.statusTicketModel = new StatusTicketModel();
          if(this._filterCollection.statusTicketModel != null) {
            this._filterCollection.statusTicketModel?.id = finalIndex;
          }
        }
        Utils.pushName(context, RouteList.COLLECTION_SCREEN, params: title);
      }
    } catch (e) {
      print(e);
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(lstDataChart.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 120 : 100;
      switch (lstDataChart[i]['actionName']) {
        case FieldTicketConstant.RTP:
          return PieChartSectionData(
              color: const Color(0xff13d38e),
              value: double.tryParse(
                  lstDataFinal[FieldTicketConstant.RTP]['quantity'].toString()),
              title:
                  lstDataFinal[FieldTicketConstant.RTP]['quantity'].toString(),
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xffffffff)));

        case FieldTicketConstant.OTHER:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: double.tryParse(
                lstDataFinal[FieldTicketConstant.OTHER]['quantity'].toString()),
            title:
                lstDataFinal[FieldTicketConstant.OTHER]['quantity'].toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                // fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case FieldTicketConstant.PTP:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: double.tryParse(
                lstDataFinal[FieldTicketConstant.PTP]['quantity'].toString()),
            title: lstDataFinal[FieldTicketConstant.PTP]['quantity'].toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case FieldTicketConstant.PAY:
          return PieChartSectionData(
            color: const Color(0xFFFF2B45),
            value: double.tryParse(
                lstDataFinal[FieldTicketConstant.PAY]['quantity'].toString()),
            title: lstDataFinal[FieldTicketConstant.PAY]['quantity'].toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case FieldTicketConstant.NO:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: double.tryParse(
                lstDataFinal[FieldTicketConstant.NO]['quantity'].toString()),
            title: lstDataFinal[FieldTicketConstant.NO]['quantity'].toString(),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
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
            color: const Color(0xffffffff)
          ),
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
