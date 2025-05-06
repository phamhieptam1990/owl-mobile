import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/collections/checkin/offline/checkin.offline-detail.screen.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/utils/log/crashlystic_services.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/models/offline/action/checkin/checkin.offline.model.dart';
import 'package:athena/common/constants/color.dart';
import '../../collections.service.dart';
import 'package:athena/utils/offline/offline.service.dart';

class CheckinOfflineScreen extends StatefulWidget {
  CheckinOfflineScreen({Key? key}) : super(key: key);
  @override
  _CheckinOfflineScreenState createState() => _CheckinOfflineScreenState();
}

class _CheckinOfflineScreenState extends State<CheckinOfflineScreen>
    with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'CheckInOfflineScreen');
  bool isFirstEnter = true;
  String title = '';
  List<CheckInOfflineModel> lstCheckInOfflineModel = [];
  final _mapService = new VietMapService();
  final _collectionService = new CollectionService();

  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await handleFetchData();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    try {
      lstCheckInOfflineModel.clear();
      this.isFirstEnter = true;
      setState(() {});
      await handleFetchData();
      setState(() {});
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  Future<void> handleFetchData() async {
    try {
      lstCheckInOfflineModel.clear();
      // List<String> lstDataCheckInOffline =
      //     await StorageHelper.getStringList(HiveDBConstant.CHECK_IN_OFFLINE);
      //   List<String> lstDataCheckInOffline =
      //     await StorageHelper.getStringList(HiveDBConstant.CHECK_IN_OFFLINE);
      // if (Utils.isArray(lstDataCheckInOffline)) {
      //   // CheckInOfflineModel offlineModel = boxCheckInOffline.getAt(index);
      //   // var abc = boxCheckInOffline.getAt(index);
      //   // if (Utils.checkIsNotNull(offlineModel)) {
      //   //   lstCheckInOfflineModel.add(offlineModel);
      //   // }
      //   // lstCheckInOfflineModel.f

      //   for (int index = 0; index < lstDataCheckInOffline.length; index++) {
      //     if (Utils.checkIsNotNull(lstDataCheckInOffline[index])) {
      //       CheckInOfflineModel offlineModel = CheckInOfflineModel.fromJson(
      //           jsonDecode(lstDataCheckInOffline[index]));
      //       if (Utils.checkIsNotNull(offlineModel)) {
      //         lstCheckInOfflineModel.add(offlineModel);
      //       }
      //     }
      //   }
      //   // if (lstDataCheckInOffline.isEmpty) {
      //   //   lstDataCheckInOffline.add(jsonEncode(data));
      //   // }
      //   // await StorageHelper.setStringList(
      //   //     HiveDBConstant.CHECK_IN_OFFLINE, lstDataCheckInOffline);
      // }
      final boxCheckInOffline =
          await HiveDBService.openBox(HiveDBConstant.CHECK_IN_OFFLINE);
      if (HiveDBService.checkValuesInBoxesIsNotEmpty(boxCheckInOffline)) {
        final boxCheckInOfflineValues =
            HiveDBService.getValuesData(boxCheckInOffline);
        for (int index = 0; index < boxCheckInOfflineValues.length; index++) {
          CheckInOfflineModel offlineModel = boxCheckInOffline.getAt(index);
          if (Utils.checkIsNotNull(offlineModel)) {
            lstCheckInOfflineModel.add(offlineModel);
          }
        }
        if (boxCheckInOffline.isOpen) {
          await boxCheckInOffline.close();
        }
      }
    } catch (e) {
      printLog(e);
    } finally {
      setState(() {
        if (isFirstEnter == true) {
          isFirstEnter = false;
        }
      });
    }
  }

  void _onLoading() async {
    try {
      if (mounted) {
        await handleFetchData();
      }
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  Widget buildItemListView(int i) {
    try {
      CheckInOfflineModel detail = lstCheckInOfflineModel[i];
      return Column(children: [
        Card(
            child: Column(children: [
          InkWell(
            onTap: () async {
              CheckInOfflineModel temp =
                  CheckInOfflineModel.fromJson(detail.toJson());
              final result = await NavigationService.instance.navigateToRoute(
                MaterialPageRoute(
                    builder: (context) => CheckInOfflineDetailScreen(
                          activityModel: temp,
                        )),
              );
              if (result != null) {
                try {
                  final boxTicketModelOffline = await HiveDBService.openBox(
                      HiveDBConstant.CHECK_IN_OFFLINE);
                  if (HiveDBService.checkValuesInBoxesIsNotEmpty(
                      boxTicketModelOffline)) {
                    boxTicketModelOffline.deleteAt(i);
                    lstCheckInOfflineModel.removeAt(i);
                    if (boxTicketModelOffline.isOpen) {
                      await boxTicketModelOffline.close();
                    }
                  }
                  WidgetCommon.showSnackbar(
                      _scaffoldKey, S.of(context).update_sucess,
                      backgroundColor: Theme.of(context).primaryColor);
                  _onRefresh();
                  // setState(() {});
                } catch (e) {
                  WidgetCommon.showSnackbar(_scaffoldKey, e.toString(),
                      backgroundColor: Theme.of(context).primaryColor);
                  setState(() {});
                }
              }
            },
            child: ListTile(
                contentPadding: EdgeInsets.all(8.0),
                leading: Utils.checkIsNotNull(detail.customerName)
                    ? CircleAvatar(
                        child: Text(detail.customerName![0],
                            style: TextStyle(color: AppColor.white)),
                        backgroundColor: Theme.of(context).primaryColor,
                      )
                    : Container(),
                title: Text(   detail?.actionGroupName ?? '',  // Simplify null check
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: childSubtitle(detail)),
          ),
        ]))
      ]);
    } catch (e) {
      return Container();
    }
  }

  Widget childSubtitle(CheckInOfflineModel detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new SizedBox(height: 4.0),
        Text(
          detail?.customerName ?? '', ),
        new SizedBox(height: 4.0),
        Text(Utils.checkIsNotNull(detail.paymentAmount)
            ? Utils.formatPrice(detail.paymentAmount.toString())
            : ''),
        new SizedBox(height: 4.0),
        Text(Utils.checkIsNotNull(detail.offlineInfo)
            ? Utils.getTimeFromDate(detail.offlineInfo['dataTime']).toString()
            : ''),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarCommon(title: 'CheckIn Offline', lstWidget: [
        InkWell(
          onTap: () async {
            await submitCheckInOffline();
          },
          child: Container(
            width: 40.0,
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.done),
          ),
        )
      ]),
      body: Scrollbar(child: buildBodyView()),
    );
  }

  Future<void> submitCheckInOffline() async {
    final boxTicketModelOffline =
        await HiveDBService.openBox(HiveDBConstant.CHECK_IN_OFFLINE);
    int position = 0;
    try {
      if (lstCheckInOfflineModel.isEmpty) {
        return WidgetCommon.showSnackbar(_scaffoldKey, 'Không có dữ liệu');
      }
      if (!OfflineService.isFeatureValid(FEATURE_APP.SUBMIT_CHECKIN_OFFLINE)) {
        return;
      }
      WidgetCommon.showLoading(status: 'Cập nhật dữ liệu CheckIn');

      List<int> lstRequestComplete = [];
      String message = '';
      if (HiveDBService.checkValuesInBoxesIsNotEmpty(boxTicketModelOffline)) {
        final boxValues = HiveDBService.getValuesData(boxTicketModelOffline);
        for (int index = 0; index < boxValues.length; index++) {
          position = index;
          CheckInOfflineModel dataT = boxTicketModelOffline.getAt(index);
          CheckInOfflineModel data =
              CheckInOfflineModel.fromJson(dataT.toJson());
          data.offlineInfo['submitTime'] =
              DateTime.now().microsecondsSinceEpoch;
          String address = await this._mapService.getAddressFromLongLatVMap(
              data.latitude!, data.longitude!, context);
          if (address.isNotEmpty) {
            data.address = address;
          } else {
            message += ' - Dòng ' +
                (index + 1).toString() +
                ' không lấy được địa chỉ checkin \n';
            continue;
          }

          if (Utils.checkIsNotNull(data)) {
            Response res;
            if (data.actionGroupName == AppStateConfigConstant.REFUSE_TO_PAY) {
              res = await this._collectionService.checkInRefuse(data.toJson());
            } else {
              res = await this._collectionService.checkIn(data.toJson());
            }
            if (Utils.checkRequestIsComplete(res)) {
              if (res.data['data'] == null) {
                lstRequestComplete.add(index);
              }
            } else {
              var dataError = Utils.handleRequestData(res);
              if (Utils.isArray(dataError)) {
                if (Utils.checkIsNotNull(dataError['validateResult']) &&
                    Utils.checkIsNotNull(dataError['messages'])) {
                  String errorMsg = '';
                  if (Utils.isArray(dataError['validateResult'])) {
                    final validateResult = dataError['validateResult'];
                    if (Utils.checkIsNotNull(validateResult['offlineUuid'])) {
                      lstRequestComplete.add(index);
                    } else {
                      if (HiveDBService.checkValuesInBoxesIsNotEmpty(
                          boxTicketModelOffline)) {
                        boxTicketModelOffline.deleteAt(position);
                        lstCheckInOfflineModel.removeAt(position);
                        if (boxTicketModelOffline.isOpen) {
                          await boxTicketModelOffline.close();
                        }
                      }
                      _onRefresh();
                    }
                  }
                  if (errorMsg.isNotEmpty) {
                    message += errorMsg;
                  }
                }
              }
            }
          }
        }
      }

      if (lstRequestComplete.isNotEmpty) {
        for (int _index = lstRequestComplete.length - 1;
            _index >= 0;
            _index--) {
          if (_index >= 0) {
            boxTicketModelOffline.deleteAt(lstRequestComplete[_index]);
          }
        }
        if (boxTicketModelOffline.isOpen) {
          await boxTicketModelOffline.close();
        }
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
            backgroundColor: Theme.of(context).primaryColor);
        await handleFetchData();
      }
      if (message.isNotEmpty) {
        WidgetCommon.generateDialogOKGet(content: message);
      }
      WidgetCommon.dismissLoading();
    } catch (e) {
      WidgetCommon.dismissLoading();
      CrashlysticServices.instance.log(e.toString());
      if (Utils.checkIsNotNull(e)) {
        var dataError;
        if (e is DioError && e.response != null) {
          // Handle Dio errors with response
          dataError = Utils.handleRequestDataLV1(e.response!);
        } else {
          // Handle other errors without response data
          print('Error during check-in: $e');
          WidgetCommon.generateDialogOKGet(
              content: 'Có lỗi xảy ra, vui lòng thử lại sau.');
          return;
        }
        if (Utils.isArray(dataError)) {
          var validation = dataError['validation'];
          if (Utils.checkIsNotNull(validation['validationResults']) &&
              Utils.checkIsNotNull(validation['messages'])) {
            if (Utils.isArray(validation['validationResults'])) {
              final validateResult = validation['validationResults'];
              String errorMsg = '';
              if (Utils.checkIsNotNull(validateResult['offlineUuid'])) {
                if (HiveDBService.checkValuesInBoxesIsNotEmpty(
                    boxTicketModelOffline)) {
                  boxTicketModelOffline.deleteAt(position);
                  lstCheckInOfflineModel.removeAt(position);
                  if (boxTicketModelOffline.isOpen) {
                    await boxTicketModelOffline.close();
                  }
                }
                _onRefresh();
              } else {
                validateResult.forEach((key, value) {
                  errorMsg += value + ' ';
                });
              }
              if (errorMsg.isNotEmpty) {
                WidgetCommon.generateDialogOKGet(content: errorMsg);
              }
            }
          }
        }
      }
      WidgetCommon.dismissLoading();
    }
  }

  Widget buildBodyView() {
    if (isFirstEnter) {
      return ShimmerCheckIn(
        height: 60.0,
        countLoop: 8,
      );
    }
    if (lstCheckInOfflineModel.length == 0) {
      return NoDataWidget();
    }
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      footer: CustomFooter(
        builder: (context, status) {
          Widget body;
          if (status == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (status == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (status == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (status == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemBuilder: (c, i) => buildItemListView(i),
        itemCount: lstCheckInOfflineModel.length,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
