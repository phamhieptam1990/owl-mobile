import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/models/dashboard/number-dashboard.dart';
import 'package:athena/screens/home/widgets/number-widget.dart';
import 'package:athena/screens/home/widgets/title_view.dart';
import 'package:athena/screens/vietmap/vietmap.provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/screens/home.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/collections/collection/collections.provider.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/customer-request/list/customer-request-list.screen.dart';
// import 'package:athena/screens/filter/collections/filter-collections-team.screen.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/screens/filter/collections/filter-collections.screen.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/home/home.service.dart';
// import 'package:athena/screens/home/widgets/chart/target-line-chart.dart';
// import 'package:athena/screens/home/widgets/target.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/permission._app.service.dart';
// import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/geolocation.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';

import '../../utils/global-store/user_info_store.dart';
import '../../utils/storage/storage_helper.dart';
import '../../widgets/common/floatContainer/floatContainerHomeScreen.dart';
import 'widgets/chart/pie-chart-checkin-today.dart';
import 'widgets/chart/pie-chart-collection.sample.dart';
import 'widgets/record_location_popup.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigator;
  HomeScreen({Key? key, this.navigator}) : super(key: key);

  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with
        TickerProviderStateMixin,
        AfterLayoutMixin,
        AutomaticKeepAliveClientMixin<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'HomeScreen');
  final homeProvider = getIt<HomeProvider>();
  final _collectionProvider = getIt<CollectionProvider>();
  final _filterCollectionProvider = getIt<FilterCollectionsProvider>();
  final _homeService = new HomeService();
  final _collectionService = new CollectionService();
  final userInfoStore = getIt<UserInfoStore>();
  bool isExpanded = false;
  bool isLoading = true;
  bool isLoadingRecordTLLocation = false;
  final _mapProvider = getIt<VietMapProvider>();
  final _appState = new AppState();
  StreamSubscription? _subscription;
  AnimationController? _animationController;
  GeoPositionBackgroundService _geoPositionBackgroundService =
      new GeoPositionBackgroundService();
  final _categorySingeton = new CategorySingeton();
  bool isClickGotoMap = false;
  bool ennableMap = false;
  @override
  void afterFirstLayout(BuildContext context) async {
    // _categorySingeton.initAllCateogyData();
    String username =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    if (username.contains('product@athenafs.io')) {
      setState(() {
        ennableMap = false;
      });
    } else {
      setState(() {
        ennableMap = true;
      });
    }
    // if (_appState.isFirstEnter) {
      _appState.isFirstEnter = false;
      Future.delayed(Duration(milliseconds: 300), () {
        handleFetchData(true);
      });
    // } else {}
  }

  @override
  initState() {
    super.initState();
    
    _subscription =
        eventBus.on<ReloadHomeScreen>().listen((ReloadHomeScreen event) async {
      await handleFetchData(false);
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _subscription = eventBus
        .on<ReloadPlannedHomeScreen>()
        .listen((ReloadPlannedHomeScreen event) async {
      Response responsePlan = await this._collectionService.countPlannedDate();
      if (Utils.checkRequestIsComplete(responsePlan)) {
        var countPlanned = Utils.handleRequestData(responsePlan);
        if (Utils.checkIsNotNull(countPlanned)) {
          homeProvider.setCountPlanned(countPlanned);
          setState(() {});
          return;
        }
      }
    });

    if (_appState.isFirstEnter) {
      if (homeProvider.unpaidCases > 0 || homeProvider.paidCases > 0) {
        isLoading = false;
        return;
      }
    } else {
      isLoading = false;
    }
  }

  initCollectionNumber(_paid, _unpaid) {
    List<Data> dataTemp = [];

    dataTemp.add(Data(
        name: S.of(context).unpaidCases,
        color: Color(0xFF2633C5).withOpacity(0.2),
        linkImage: null,
        icon: Icons.money_off,
        action: () => unpaidCasesCollection(),
        number: _unpaid.toString()));
    dataTemp.add(Data(
        name: S.of(context).paidCases,
        color: Colors.green,
        linkImage: null,
        action: () => paidCasesCollection(),
        icon: Icons.attach_money,
        number: _paid.toString()));
    homeProvider.setcollectionModel = NumberDashboardModel(
        title: S.of(context).collections,
        subTitle: S.of(context).seeAll,
        action: () => seeAllCollection(),
        icon: Icons.collections,
        data: dataTemp);
  }

  initCalendarNumber(plan, done) {
    List<Data> dataTemp = [];
    dataTemp.add(Data(
        name: S.of(context).propose,
        color: AppColor.grey,
        icon: Icons.airplane_ticket,
        linkImage: null,
        action: () {
          Utils.pushName(context, RouteList.CALENDAR_SCREEN);
        },
        number: plan.toString()));
    dataTemp.add(Data(
        name: S.of(context).actionDone,
        color: Colors.green,
        linkImage: null,
        icon: Icons.done,
        action: () {
          Utils.pushName(context, RouteList.CALENDAR_SCREEN);
        },
        number: done.toString()));
    homeProvider.setcalendarModel = NumberDashboardModel(
        title: S.of(context).calendarToday,
        subTitle: S.of(context).seeMap,
        action: () async {
          if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
            await gotoMapPage();
          }
        },
        icon: Icons.map,
        data: dataTemp);
  }

  Future<void> handleFetchData(bool isSetState) async {
    int _unpaid = 0;
    int _paid = 0;
    try {
      if (isSetState) {
        final homeModelBox =
            await HiveDBService.openBox(HiveDBConstant.HOME_SCREEN);
        if (HiveDBService.checkValuesInBoxesIsNotEmpty(homeModelBox)) {
          HomeModel _homeModel = homeModelBox.getAt(0);
          _unpaid = _homeModel.unPaid ?? 0;
          _paid = _homeModel.paid ?? 0;
          homeProvider.setUnpaidCases(_unpaid);
          homeProvider.setPaiCases(_paid);
          isLoading = false;
          initCollectionNumber(_paid, _unpaid);

          setState(() {});
        }
      }

      if (_geoPositionBackgroundService.initTracking == false) {
        Future.delayed(Duration(seconds: 2)).then((value) {
          handleCheckinLocation();
        });
      }

      Response response = await this._homeService.getTodayAggCollectionReport();
      if (Utils.checkRequestIsComplete(response)) {
        var lstData = response.data['data'];
        if (lstData != null) {
          _unpaid = lstData['report']['UNPAID'];
          _paid = lstData['report']['PAID'];
          homeProvider.setUnpaidCases(_unpaid);
          homeProvider.setPaiCases(_paid);
          await HiveDBService.addDataHomeScreen(_paid, _unpaid, 0, 0);
        }
      }

      initCollectionNumber(_paid, _unpaid);
      countPlannedDate();
      countBackLog();
      todayAggCalendarReport();
      dashBoardPlan();
      String empCode = this.userInfoStore.user?.moreInfo?['empCode'];
      if (Utils.checkIsNotNull(empCode)) {
        Response responses =
            await this._homeService.getCheckInTodayReport(empCode);
        if (Utils.checkRequestIsComplete(responses)) {
          var lstData = responses.data['data'];
          if (lstData != null) {
            if (Utils.isArray(lstData)) {
              for (final d in lstData) {
                if (d['status'] == 'CHECKIN') {
                  int totalCase = d['totalCase'];
                  int checkinCase = d['checkinCase'];
                  homeProvider.totalCase = totalCase;
                  homeProvider.checkInCase = checkinCase;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      setState(() {});
      _categorySingeton.initAllCateogyData();
    }
  }

  Future<void> handleCheckinLocation() async {
    if (_geoPositionBackgroundService.initTracking == false) {
      // PermissionAppService.getCurrentPosition();
      await _geoPositionBackgroundService.getUsername();
      String username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      if (username.contains('product@athenafs.io')) {
      } else {
        await Geolocator.requestPermission();
        await Permission.phone.request();
        await _geoPositionBackgroundService.handlePermission();
        await _geoPositionBackgroundService.startLocationService();
      }
    }
  }

  Widget buildTitle(BuildContext context) {
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(S.of(context).hello +
                    ", " +
                    _homeService.getLastFullName()),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     super.build(context);
     
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomPadding: true,
      appBar: new AppBar(
        title: buildTitle(context),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (OfflineService.isFeatureValid(
                  FEATURE_APP.SEARCH_COLLECTIONS)) {
                Utils.pushName(context, RouteList.SEARCH_SCREEN);
              }
            },
          ),
        ],
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
      ),
      // floatingActionButton: FloatContainerHomeScreen(
      //   onRecordTLLocation: onRecordTLLocation,
      // ),
      body: Container(
        height: AppState.getHeightDevice(context),
        width: AppState.getWidthDevice(context),
        child: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          displacement: 30,
          child: Stack(
            children: [buildHomeScreen(), buildLoadingRecordLocation()],
          ),
          onRefresh: _onRefresh,
        ),
      ),
    );
  }

  Widget buildLoadingRecordLocation() {
    return isLoadingRecordTLLocation
        ? Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        S.of(context).loading,
                        style: new TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  void onRecordTLLocation() async {
    showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      barrierDismissible: true,
      context: context,
      pageBuilder: (_, __, ___) {
        return RecordLocationPopup(
          title: 'Lưu địa điểm',
          onsubmit: (position, title) async {
            try {
              setState(() {
                isLoadingRecordTLLocation = true;
              });

              final response =
                  await this._homeService.createGPSLog(position, title);

              if (response.data['status'] == 0) {
                WidgetCommon.showSnackbar(_scaffoldKey, 'Ghi nhận thành công',
                    backgroundColor: AppColor.blue);
              } else {
                WidgetCommon.showSnackbar(_scaffoldKey, 'Ghi nhận thất bại!');
              }
              setState(() {
                isLoadingRecordTLLocation = false;
              });
            } catch (_) {
              WidgetCommon.showSnackbar(
                  _scaffoldKey, S.of(context).update_failed);
              setState(() {
                isLoadingRecordTLLocation = false;
              });
            }
          },
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Widget buildHomeScreen() {
    return (isLoading == true)
        ? ShimmerCheckIn(
            height: 180,
            countLoop: 4,
          )
        : SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(children: <Widget>[
              countPlannedView(),
              // Visibility(
              //     visible: homeProvider.countPlanned > 0,
              //     child: countPlannedView()),
              // Visibility(
              //     visible: homeProvider.countBacklog > 0, child: backLog()),
              // calendarToday(),
              // collection(),
              ennableMap
                  ? NumberDashboardView(
                      dataNumber: homeProvider.getcalendarModel,
                    )
                  : Container(),
              NumberDashboardView(
                dataNumber: homeProvider.getCollectionModel,
              ),
              widgetDashboardPlan(),
              dashboardCheckInToday(),
              kra(),
              Container(
                height: 20,
              ),
              Container(
                  child: Text('Chúc bạn một ngày làm việc tốt lành',
                      style: TextStyle(fontSize: 18))),
              Container(
                height: 80,
              )
            ]),
          );
  }

  void postRecordTLLocation() async {}

  Future<void> _onRefresh() async {
    if (OfflineService.isFeatureValid(FEATURE_APP.SEARCH_COLLECTIONS)) {
      isLoading = true;
      setState(() {});
      handleFetchData(false);
    }
  } //

  Future<void> gotoMapPage() async {
    try {
      if (isClickGotoMap) {
        return;
      }
      String username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      if (username.contains('product@athenafs.io')) {
        return;
      }
      await Geolocator.requestPermission();
      WidgetCommon.showLoading(status: 'Đang lấy thông tin vị trí');
      bool permission =
          await PermissionAppService.checkServiceEnabledLocation();
      if (permission) {
        isClickGotoMap = true;
        Position? position = await PermissionAppService.getCurrentPosition();
        if (position == null) {
          return;
        }
        _mapProvider.setCenterPosition(
            new LatLng(position.latitude, position.longitude));
        isClickGotoMap = false;
        WidgetCommon.dismissLoading();
        if (APP_CONFIG.enableVietMap) {
          Utils.pushName(context, RouteList.VIETMAP_SCREEN);
        } else {}
        // Utils.pushName(null, RouteList.MAP_SCREEN);

        return;
      }
      WidgetCommon.dismissLoading();
    } catch (e) {
      isClickGotoMap = false;
      WidgetCommon.dismissLoading();
    }
  }

  Widget backLog() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(28.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xFF3A5160).withOpacity(0.2),
                offset: Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${homeProvider.countBacklog} mục tồn đọng',
                      style: TextStyle(
                          fontSize: AppFont.fontSize18,
                          fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {
                        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                          String dateFrom =
                              Utils.convertTimeToSearch(DateTime.now());
                          String dateTo = Utils.convertTimeToSearch(
                              DateTime.now().add(Duration(days: 30)));
                          this._collectionProvider.filter = {
                            "lastEventDate": {
                              "type": FilterType.IN_RANGE,
                              "dateFrom": dateFrom,
                              "dateTo": dateTo,
                              "filterType": FilterType.DATE
                            },
                            "hasCheckinInMonth": {
                              "type": FilterType.EQUALS,
                              "filter": FilterType.TRUE,
                              "filterType": "text"
                            }
                          };
                          // this._collectionProvider.filter +=
                          //     '"hasCheckinInMonth": {"type": "${FilterType.EQUALS}", "filter": "${FilterType.TRUE}","filterType": "text"}';
                          Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                              params: 'Tồn đọng');
                        }
                      },
                      child: Text(
                        'Xem chi tiết',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: AppFont.fontSize18),
                      ))
                ],
              ),
            ),
            // Divider(
            //   color: AppColor.blackOpacity,
            // ),
          ],
        ),
      ),
    );
  }

  Widget countPlannedView() {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(28.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xFF3A5160).withOpacity(0.2),
                offset: Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${homeProvider.countPlanned} Kế hoạch',
                      style: TextStyle(
                          fontSize: AppFont.fontSize18,
                          fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {
                        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                          Utils.pushName(context, RouteList.PLANNED_SCREEN);
                        }
                      },
                      child: Text(
                        'Xem chi tiết',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: AppFont.fontSize18),
                      ))
                ],
              ),
            ),
            // Divider(
            //   color: AppColor.blackOpacity,
            // ),
          ],
        ),
      ),
    );
  }

  Widget calendarToday() {
    return Container(
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).calendarToday,
                      style: TextStyle(
                          fontSize: AppFont.fontSize18,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                      onTap: () async {
                        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                          await gotoMapPage();
                        }
                      },
                      child: Text(
                        S.of(context).seeMap,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: AppFont.fontSize18),
                      ))
                ],
              ),
            ),
            Divider(
              color: AppColor.blackOpacity,
            ),
            VerticalDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Utils.pushName(context, RouteList.CALENDAR_SCREEN);
                  },
                  child: Column(children: [
                    Text(homeProvider.getProposeCalendar().toString(),
                        style: TextStyle(
                            fontSize: AppFont.fontSize50,
                            color: AppColor.blackOpacity)),
                    Text(S.of(context).propose,
                        style: TextStyle(fontSize: AppFont.fontSize18)),
                  ]),
                ),
                Container(
                    height: 70,
                    child: VerticalDivider(color: AppColor.blackOpacity)),
                InkWell(
                    onTap: () {
                      Utils.pushName(context, RouteList.CALENDAR_SCREEN);
                    },
                    child: Column(children: [
                      Text(homeProvider.getDoneActionCalendar().toString(),
                          style: TextStyle(
                              fontSize: AppFont.fontSize50,
                              color: AppColor.blackOpacity)),
                      Text(S.of(context).actionDone,
                          style: TextStyle(fontSize: AppFont.fontSize18)),
                    ])),
              ],
            ),
            Divider(
              color: AppColor.blackOpacity,
            ),
          ],
        ),
      ),
    );
  }

  void pushPage(context, statusFilter) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CustomerRequestListScreen(fillterStatus: statusFilter),
      ),
    );
  }

  seeAllCollection() {
    this._filterCollectionProvider.paidCaseModel = null;
    if (mounted) {
      Utils.pushName(context, RouteList.COLLECTION_SCREEN, params: '');
    } else {
      // handleFetchData(true);
    }
  }

  paidCasesCollection() {
    this._filterCollectionProvider.paidCaseModel =
        new PaidCaseModel(S.of(context).paidCases, 1);
    this._collectionProvider.filter = {
      "nvcontract_status": {
        "type": FilterType.EQUALS,
        "filter": "PAID",
        "filterType": FilterType.TEXT
      }
    };
    Utils.pushName(context, RouteList.COLLECTION_SCREEN,
        params: S.of(context).paidCases);
  }

  unpaidCasesCollection() {
    this._filterCollectionProvider.paidCaseModel =
        new PaidCaseModel(S.of(context).unpaidCases, 0);
    this._collectionProvider.filter = {
      "nvcontract_status": {
        "type": FilterType.EQUALS,
        "filter": "UNPAID",
        "filterType": FilterType.TEXT
      }
    };
    Utils.pushName(context, RouteList.COLLECTION_SCREEN,
        params: S.of(context).unpaidCases);
  }

  Widget collection() {
    return Container(
      // height: 200,
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).collections,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                      onTap: () => seeAllCollection(),
                      child: Text(
                        S.of(context).seeAll,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: AppFont.fontSize18),
                      )),
                ],
              ),
            ),
            Divider(
              color: AppColor.blackOpacity,
            ),
            VerticalDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => paidCasesCollection(),
                  child: Column(children: [
                    Text(homeProvider.getPaiCases().toString(),
                        style: TextStyle(
                            fontSize: AppFont.fontSize50,
                            color: AppColor.blackOpacity)),
                    Text(S.of(context).paidCases,
                        style: TextStyle(fontSize: AppFont.fontSize16)),
                  ]),
                ),
                Container(
                    height: 70,
                    child: VerticalDivider(color: AppColor.blackOpacity)),
                InkWell(
                  onTap: () => unpaidCasesCollection(),
                  child: Column(children: [
                    Text(homeProvider.getUnpaidCases().toString(),
                        style: TextStyle(
                            fontSize: AppFont.fontSize50,
                            color: AppColor.blackOpacity)),
                    Text(S.of(context).unpaidCases,
                        style: TextStyle(fontSize: AppFont.fontSize16)),
                  ]),
                )
              ],
            ),
            SizedBox(height: 1.0),
            Divider(
              color: AppColor.blackOpacity,
            ),
          ],
        ),
      ),
    );
  }

  Widget customerComplain() {
    return Container(
      height: 160,
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).customerComplain,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                      onTap: () {},
                      child: Text(
                        S.of(context).seeAll,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: AppFont.fontSize16),
                      )),
                ],
              ),
            ),
            Divider(color: AppColor.blackOpacity),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text(homeProvider.getPaiCases().toString(),
                      style: TextStyle(
                          fontSize: AppFont.fontSize50,
                          color: AppColor.blackOpacity)),
                  Text(S.of(context).today,
                      style: TextStyle(fontSize: AppFont.fontSize16)),
                ]),
                Container(
                    height: 70,
                    child: VerticalDivider(color: AppColor.blackOpacity)),
                Column(children: [
                  Text(homeProvider.getUnpaidCases().toString(),
                      style: TextStyle(
                          fontSize: AppFont.fontSize50,
                          color: AppColor.blackOpacity)),
                  Text("< 1 " + S.of(context).week,
                      style: TextStyle(fontSize: AppFont.fontSize16)),
                ]),
                Container(
                    height: 70,
                    child: VerticalDivider(color: AppColor.blackOpacity)),
                Column(children: [
                  Text(homeProvider.getUnpaidCases().toString(),
                      style: TextStyle(
                          fontSize: AppFont.fontSize50,
                          color: AppColor.blackOpacity)),
                  Text("> 1 " + S.of(context).week,
                      style: TextStyle(fontSize: AppFont.fontSize16)),
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget actionInMonth() {
    return Container(
      height: 110,
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).actionInMonth,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                      onTap: () {},
                      child: Text(
                        S.of(context).seeAll,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: AppFont.fontSize16),
                      )),
                ],
              ),
            ),
            Divider(color: AppColor.blackOpacity),
            ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).examine, textAlign: TextAlign.left),
                    Text(homeProvider.getExamineCustomer.toString(),
                        textAlign: TextAlign.right),
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Theme.of(context).primaryColor),
                onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget widgetDashboardPlan() {
    return Container(
      child: Card(
        color:Colors.white,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).plannedDashboard,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                      onTap: () {
                        // this._collectionProvider.filterNew =
                        //     new FilterNew(true, CollectionTicket.ALL);
                        // Utils.pushName(null, RouteList.COLLECTION_SCREEN,
                        //     params: S.of(context).plannedDashboard);
                        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                          Utils.pushName(
                              context, RouteList.PLANNED_FOR_DATE_SCREEN);
                        }
                      },
                      child: Text(
                        'Xem kế hoạch',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: AppFont.fontSize18),
                      )),
                ],
              ),
            ),
            Divider(
              color: AppColor.blackOpacity,
            ),
            VerticalDivider(),
            Container(
                color: Colors.white, // 👈 màu nền bạn muốn// nếu cần padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        this._collectionProvider.filterNew =
                            new FilterNew(true, CollectionTicket.DONE);
                        // this._collectionProvider.filter =
                        //     '"hasLastPaymentInMonth": {"type": "${FilterType.EQUALS}", "filter": "PAID","filterType": "${FilterType.TEXT}"}';
                        Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                            params: S.of(context).plannedDashboard +
                                ' ' +
                                S.of(context).done);
                      },
                      child: Column(children: [
                        Text(homeProvider.getPlanDone.toString(),
                            style: TextStyle(
                                fontSize: AppFont.fontSize50,
                                color: AppColor.blackOpacity)),
                        Text(S.of(context).done,
                            style: TextStyle(fontSize: AppFont.fontSize16)),
                      ]),
                    ),
                    Container(
                        height: 70,
                        child: VerticalDivider(color: AppColor.blackOpacity)),
                    InkWell(
                      onTap: () {
                        this._collectionProvider.filterNew =
                            new FilterNew(true, CollectionTicket.UNDONE);
                        // this._collectionProvider.filter =
                        //     '"hasLastPaymentInMonth": {"type": "${FilterType.EQUALS}", "filter": "UNPAID","filterType": "${FilterType.TEXT}"}';
                        Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                            params: S.of(context).plannedDashboard +
                                ' ' +
                                S.of(context).undone);
                      },
                      child: Column(children: [
                        Text(homeProvider.getPlanUnDone.toString(),
                            style: TextStyle(
                                fontSize: AppFont.fontSize50,
                                color: AppColor.blackOpacity)),
                        Text(S.of(context).undone,
                            style: TextStyle(fontSize: AppFont.fontSize16)),
                      ]),
                    ),
                    Container(
                        height: 70,
                        child: VerticalDivider(color: AppColor.blackOpacity)),
                    InkWell(
                      onTap: () {
                        this._collectionProvider.filterNew =
                            new FilterNew(true, CollectionTicket.CANCEL);
                        Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                            params: S.of(context).plannedDashboard +
                                ' ' +
                                S.of(context).btCancel);
                      },
                      child: Column(children: [
                        Text(homeProvider.getPlanCancel.toString(),
                            style: TextStyle(
                                fontSize: AppFont.fontSize50,
                                color: AppColor.blackOpacity)),
                        Text(S.of(context).btCancel,
                            style: TextStyle(fontSize: AppFont.fontSize16)),
                      ]),
                    )
                  ],
                )),
            SizedBox(height: 1.0),
            Divider(
              color: AppColor.blackOpacity,
            ),
          ],
        ),
      ),
    );
  }

  Widget kra() {
    return Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(children: [
          TitleView(
            titleTxt: S.of(context).kraMonthCurrent,
            subTxt: '',
            action: () {},
          ),
          Container(
            height: 400,
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
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.zero,
                child: buildSlider(),
              )
            ]),
          )
        ]));
  }

  Widget dashboardCheckInToday() {
    return Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(children: [
          TitleView(
            titleTxt: 'Số lượng Check in trong ngày',
            subTxt: '',
            action: () {},
          ),
          Container(
            height: 400,
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
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.zero,
                child: PieChartCheckInToday(),
              )
            ]),
          )
        ]));
  }

  var imgList = [1];
  Widget buildSlider() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        width: MediaQuery.of(context).size.width,
        child: PieChartCollection());
  }

  @override
  void dispose() {
    if (_subscription != null) {
      Utils.cancelSubscription(_subscription);
    }
    super.dispose();
  }

  void countPlannedDate() {
    try {
      this._collectionService.countPlannedDate().then((responsePlan) => {
            if (Utils.checkRequestIsComplete(responsePlan))
              {
                if (Utils.checkIsNotNull(responsePlan.data['data']))
                  {
                    setState(() {
                      homeProvider.setCountPlanned(responsePlan.data['data']);
                    })
                  }
              }
          });
    } catch (e) {}
  }

  void todayAggCalendarReport() {
    try {
      this._homeService.getTodayAggCalendarReport().then((response) {
        if (Utils.checkRequestIsComplete(response)) {
          final lstData = response.data['data'];
          if (lstData != null) {
            homeProvider.setProposeCalendar(lstData['report']['PLAN']);
            homeProvider.setDoneActionCalendar(lstData['report']['DONE']);
            initCalendarNumber(
                lstData['report']['PLAN'], lstData['report']['DONE']);
            setState(() {});
          }
        } else {
          initCalendarNumber(0, 0);
        }
      });
    } catch (e) {}
  }

  void dashBoardPlan() {
    try {
      this._collectionService.countDashboadPlan().then((responsePlan) {
        if (Utils.checkRequestIsComplete(responsePlan)) {
          final lstData = responsePlan.data['data'];
          if (Utils.checkIsNotNull(lstData)) {
            homeProvider.setPlanDone(lstData['DONE']);
            homeProvider.setPlanUnDone(lstData['UNDONE']);
            homeProvider.setPlanCancel(lstData['CANCEL']);
            setState(() {});
          }
        }
      });
    } catch (e) {}
  }

  void countBackLog() {
    try {
      this._collectionService.countBacklog().then((response) => {
            if (Utils.checkRequestIsComplete(response))
              {
                if (Utils.checkIsNotNull(response.data))
                  {
                    setState(() {
                      this.homeProvider.countBacklog = response.data['data'];
                    })
                  }
              }
          });
    } catch (e) {}
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
