import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.provider.dart';
import 'package:athena/screens/vietmap/vietmap_tracking.screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as GETX;
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:provider/provider.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/functionsScreen.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/app.model.dart';
import 'package:athena/models/employee/employee.model.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/offline/checkin.offline.screen.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/customer-request/list/customer-request-list.screen.dart';
import 'package:athena/screens/login/login.service.dart';
import 'package:athena/screens/profile/profile.screen.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import '../download_list/screen/download_list_screen.dart';
import './setting.prodiver.dart';
import 'child/browser.screen.dart';
import 'child/guide.screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with AfterLayoutMixin {
  SettingProvider settingProvider = new SettingProvider();
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'SettingsScreen');
  final _appState = new AppState();
  final _loginService = new LoginService();
  List<FileLocal> galleryItemLocalAvartar = [];
  String selectedLanguage = '';
  bool checkMenuTracking = false;
  bool isClickGoMap = false;
  final _userInfoStore = getIt<UserInfoStore>();
  final _collectionService = new CollectionService();
  StreamSubscription? _subscription;
  StreamSubscription? _subscriptionReloadAvatar;
  final _mapProvider = getIt<VietMapProvider>();
  final _categoryProvider = new CategorySingeton();
  // final SaveFileService _saveFileService = new SaveFileService();
  @override
  void initState() {
    super.initState();
    _subscription =
        eventBus.on<LoadUserProfile>().listen((LoadUserProfile event) async {
      setState(() {});
        });
    _subscriptionReloadAvatar =
        eventBus.on<ReloadAvatar>().listen((ReloadAvatar event) async {
      setState(() {});
    });
    if (this._appState.pathFileAvatar.isNotEmpty) {
      galleryItemLocalAvartar.add(
          FileLocal('empCode', 'empCode', File(this._appState.pathFileAvatar)));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (settingProvider.isFirstInit) {
      String? timeFetchOffline = await StorageHelper.getString(
          AppStateConfigConstant.TIME_UPDATE_COLLECTION);
      bool isFingerPrint =
          await StorageHelper.getBool(AppStateConfigConstant.FINGER_LOGIN) ?? false;
      if (!Utils.checkIsNotNull(isFingerPrint)) {
        isFingerPrint = false;
      }
      var isLocationManager =
          await StorageHelper.getBool(AppStateConfigConstant.LOCATION_MANAGER);
      if (Utils.checkIsNotNull(isLocationManager)) {
        isLocationManager = true;
      } else {
        isLocationManager = false;
      }
      settingProvider.setIsLocationManager(isLocationManager);
      settingProvider.setIsFingerPrint(isFingerPrint);
      settingProvider.setTimeFetchOffline(timeFetchOffline ?? '');
      settingProvider.isFirstInit = false;
      if (!MyConnectivity.instance.isOffline) {
        Response response = await this._loginService.getMenuApp();
        if (response.data != null) {
          var list = response.data;
          bool checkMenu = Utils.checkMenuCol(list, 'historyToken', 'tracking');
          _appState.setMenuTracking(checkMenu);
        }
      }
      setState(() {});
    }
    if (galleryItemLocalAvartar.length == 0) {
      if (!this._appState.isCheckShowAvatarComplete) {
        // await _saveFileService.checkAvatar();
      }
      if (this._appState.pathFileAvatar.isEmpty) {
      } else {
        galleryItemLocalAvartar.add(FileLocal(
            'empCode', 'empCode', File(this._appState.pathFileAvatar)));
        setState(() {});
      }
    }
  }

  Future<String> _getInitAvatar() async {
    final userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    return '?username=' + userName;
  }

  // void _changeLanguage(String languageCode) async {
  //   setState(() {
  //     selectedLanguage = languageCode;
  //     StorageHelper.setString(APP_CONFIG.LANGUAGE, selectedLanguage);
  //     Locale locale = (selectedLanguage == null || selectedLanguage.isEmpty)
  //         ? null
  //         : Locale(languageCode);
  //     Locale _temp = Locale(languageCode, '');
  //     AppMain.setLocale(context, _temp);
  //     Provider.of<AppModel>(context, listen: false).setLocale(languageCode);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarCommon(title: S.of(context).settings, lstWidget: []),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Card(
            child: InkWell(
                onTap: () async {
                  await NavigationService.instance
                      .navigateToRoute(MaterialPageRoute(
                          builder: (context) => ProfileScreen()))
                      ?.then((value) => setState(() {}));
                },
                child: ListTile(
                  contentPadding: EdgeInsets.all(6.0),
                  leading: FutureBuilder<String>(
                    future: _getInitAvatar(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                            height: 66,
                            child: Image.asset(
                                AppStateConfigConstant.PLACE_HOLDER_IMAGE)
                            // child: AvatarImgNetwork(
                            //     baseImgUrl: DMS_SERVICE_URL.GET_AVARTAR,
                            //     isShowProgress: false,
                            //     identify: snapshot?.data,
                            //     hasIdentifyer: false,
                            //     errorWidget: (_, __, ___) => Image.asset(
                            //           AppStateConfigConstant.PLACE_HOLDER_IMAGE,
                            //         )),
                            );
                      }
                      return SizedBox();
                    },
                  ),
                  title: Text(getName('fullName'),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.0)),
                  subtitle: Text(getName('userName'),
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14.0)),
                )),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                    leading:
                        Icon(Icons.fingerprint, color: AppColor.dashBoard2),
                    title: Text(S.of(context).login_finterprint),
                    trailing: Switch(
                      value: settingProvider.isFinterPrint,
                      onChanged: (value) async {
                        if (await PermissionAppService.checkDeviceHasBiometric(
                            context)) {
                          if (value == true) {
                            WidgetCommon.generateDialogOKCancelGet(
                                'Bạn muốn kích hoạt chức năng đăng nhập bằng vân tay hoặc khuôn mặt',
                                callbackOK: () async {
                              await StorageHelper.setBool(
                                  AppStateConfigConstant.FINGER_LOGIN, value);
                              setState(() {
                                settingProvider.isFinterPrint = value;
                              });
                            });
                          } else {
                            WidgetCommon.generateDialogOKCancelGet(
                                'Bạn muốn hủy chức năng đăng nhập bằng vân tay hoặc khuôn mặt',
                                callbackOK: () async {
                              await StorageHelper.setBool(
                                  AppStateConfigConstant.FINGER_LOGIN, value);
                              setState(() {
                                settingProvider.isFinterPrint = value;
                              });
                            });
                          }
                        }
                      },
                    ),
                    onTap: () {}),
                Divider(),
                Visibility(
                    child: ListTile(
                        leading:
                            Icon(Icons.location_on, color: AppColor.dashBoard2),
                        title: Text('Sử dụng Location Manager'),
                        trailing: Switch(
                          value: settingProvider.isLocationManager,
                          onChanged: (value) async {
                            await StorageHelper.setBool(
                                AppStateConfigConstant.LOCATION_MANAGER, value);
                            setState(() {
                              settingProvider.isLocationManager = value;
                            });
                          },
                        ),
                        onTap: () {}),
                    visible: Platform.isAndroid),
                Divider(),
                ListTile(
                    leading: Icon(Icons.verified, color: AppColor.dashBoard2),
                    trailing: Icon(Icons.upgrade, color: AppColor.red),
                    title: Text(
                        S.of(context).Version + " : " + Utils.showVersionApp()),
                    onTap: () async {
                      // await WidgetCommon.checkNewVersion(context, _scaffoldKey);
                    }),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ListTile(
                //   leading: Icon(Icons.link_sharp, color: Colors.black87),
                //   title: Text(S.of(context).moneySources),
                //   onTap: () {
                //     // GETX.Get.toNamed(RouteList.WALLET_LIST_SCREEN);
                //     // GETX.Get.toNamed(RouteList.WALLET_LIST_SCREEN,
                //     //     preventDuplicates: false);
                //     GETX.Get.to(() => WalletListScreen());
                //   },
                //   trailing: Icon(Icons.arrow_forward_ios_outlined,
                //       color: Colors.grey),
                // ),
                // Divider(),
                ListTile(
                  leading: Icon(Icons.download_for_offline_outlined,
                      color: Colors.cyan),
                  title: Text(S.of(context).downloadList),
                  onTap: () {
                    GETX.Get.to(() => DownloadListScreen());
                  },
                  trailing: Icon(Icons.arrow_forward_ios_outlined,
                      color: Colors.grey),
                ),
                Divider(),
                // ListTile(
                //     leading: Icon(
                //       Icons.apps,
                //       color: AppColor.dashBoard1,
                //     ),
                //     title: Text('Ứng dụng'),
                //     onTap: () {
                //       GETX.Get.to(() => AppsScreen());
                //     }),
                // Divider(),
                ListTile(
                  leading: Icon(
                    Icons.assignment,
                    color: AppColor.dashBoard5,
                  ),
                  title: Text(S.of(context).collections),
                  onTap: () {
                    Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                        params: '');
                  },
                ),
                Visibility(
                    child: Divider(),
                    visible: _userInfoStore
                        .checkPerimission(ScreenPermission.COMPLAINT_TICKET)),
                Visibility(
                    visible: _userInfoStore
                        .checkPerimission(ScreenPermission.COMPLAINT_TICKET),
                    child: ListTile(
                      leading: Icon(
                        Icons.assignment,
                        color: AppColor.dashBoard6,
                      ),
                      title: Text("Ghi nhận khiếu nại từ KH"),
                      onTap: () {
                        // NavigationService.instance.navigateToRoute(
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           CustomerComplaintListScreen()),
                        // );
                      },
                    )),
                Visibility(
                    child: Divider(),
                    visible: _userInfoStore
                        .checkPerimission(ScreenPermission.SUPPORT_TICKET)),
                Visibility(
                    child: ListTile(
                      leading: Icon(
                        Icons.assignment,
                        color: AppColor.dashBoard5,
                      ),
                      title: Text("Yêu cầu của tôi"),
                      onTap: () {
                        NavigationService.instance.navigateToRoute(
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomerRequestListScreen()),
                        );
                      },
                    ),
                    visible: _userInfoStore
                        .checkPerimission(ScreenPermission.SUPPORT_TICKET)),
                Visibility(
                  visible: _appState.getMenuTracking(),
                  child: Divider(),
                ),
                _appState.getMenuTracking()
                    ? ListTile(
                        leading: Icon(
                          Icons.map,
                          color: AppColor.dashBoard2,
                        ),
                        title: Text("Tracking"),
                        onTap: () async {
                          await openScreenTracking();
                        },
                      )
                    : Container(),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.assignment,
                    color: AppColor.dashBoard1,
                  ),
                  title: Text("Checkin Offline"),
                  onTap: () {
                    NavigationService.instance.navigateToRoute(
                      MaterialPageRoute(
                          builder: (context) => CheckinOfflineScreen()),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.assignment,
                    color: AppColor.dashBoard5,
                  ),
                  title: Text("Đồng bộ dữ liệu collection"),
                  subtitle: Text(settingProvider.timeFetchOffline),
                  onTap: () async {
                    if (!OfflineService.isFeatureValid(
                        FEATURE_APP.SUBMIT_CHECKIN_OFFLINE)) {
                      return;
                    }
                    await fetchDataOffline();
                  },
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Visibility(
                //     visible: _userInfoStore
                //         .checkPerimission(ScreenPermission.RECOVERY_FIELD),
                //     child: ListTile(
                //       leading: Icon(
                //         Icons.description,
                //         color: AppColor.dashBoard6,
                //       ),
                //       title: Text("Recovery"),
                //       onTap: () async {
                //         NavigationService.instance.navigateToRoute(
                //           MaterialPageRoute(
                //               builder: (context) => ListRecoveryScreen()),
                //         );
                //       },
                //     )),
                // Divider(),
                ListTile(
                    leading: Icon(
                      Icons.play_arrow,
                      color: AppColor.dashBoard1,
                    ),
                    title: Text("Hướng dẫn sử dụng"),
                    onTap: () async {
                      GETX.Get.to(() => GuideScreen());
                    }),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.attach_file,
                    color: AppColor.dashBoard3,
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(S.of(context).connection),
                  onTap: () {
                    // NavigationService.instance.navigateToRoute(
                    //   MaterialPageRoute(builder: (context) => SOSScreen()),
                    // );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.inbox_outlined,
                    color: AppColor.dashBoard4,
                  ),
                  title: Text("Chính sách quyền riêng tư"),
                  onTap: () {
                    WidgetCommon.openWebBrowser(
                        'https://athena-public-assets.s3.ap-southeast-1.amazonaws.com/Privacy+Policy.html');
                  },
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: AppColor.dashBoard6,
                  ),
                  title: Text(S.of(context).logout),
                  onTap: () async {
                    WidgetCommon.generateDialogOKCancelGet(
                        S.of(context).logout_alert, callbackOK: () {
                      this._appState.logOut();
                      Utils.pushAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN);
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(20.0), child: Container()),
        ],
      ),
    );
  }

  showActionSheet(listData, String userName, String fcCode) async {
    if (listData.length == 1) {
      var link =
          listData[0]['link'] + '?fc_name=' + userName + '&fc_number=' + fcCode;
      var title = listData[0]['title'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BrowserScreen(url: link, title: title)));
      return;
    }
    List<SheetAction<dynamic>> lstShettActionFinal = [];
    List<SheetAction<dynamic>> lstSheetAction = [];
    for (var i = 0; i < listData.length; i++) {
      var title = listData[i]['title'];
      lstSheetAction.add(SheetAction(
        icon: Icons.surround_sound_rounded,
        label: title,
        key: i,
      ));
    }
    lstSheetAction.add(SheetAction(
        icon: Icons.cancel,
        label: S.of(context).cancel,
        key: ActionPhone.CANCEL,
        isDestructiveAction: true));
    lstShettActionFinal.addAll(lstSheetAction);
    final result = await showModalActionSheet(
      context: context,
      title: 'Vui lòng chọn bài khảo sát',
      materialConfiguration: MaterialModalActionSheetConfiguration(
          initialChildSize: 0.6, minChildSize: 0.25, maxChildSize: 0.9),
      actions: lstShettActionFinal,
    );
    if (result != null) {
      if (result == ActionPhone.CANCEL) {
        return;
      }
      var link = listData[result]['link'] +
          '?fc_name=' +
          userName +
          '&fc_number=' +
          fcCode;
      var title = listData[result]['title'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BrowserScreen(url: link, title: title)));
      return;
    }
  }

  bool checkSelected(String language) {
    String locale = Provider.of<AppModel>(context, listen: false).locale;
    if (locale == language) {
      return true;
    }
    return false;
  }

  String getLanguageUiString(String languageCode) {
    String uiString = S.of(context).System_Default;
    switch (languageCode.toLowerCase()) {
      case 'en':
        uiString = S.of(context).english;
        break;
      case 'vi':
        uiString = S.of(context).vietnamese;
        break;
      default:
        uiString = S.of(context).vietnamese;
        break;
    }
    return uiString;
  }

  Future<void> fetchDataOffline() async {
    try {
      await HiveDBService.clearHiveBox(HiveDBConstant.TICKET);
      await HiveDBService.clearHiveBox(HiveDBConstant.EMMPLOYEE);
      await WidgetCommon.showLoading(status: 'Đang cập nhật dữ liệu');
      final Response? response = await _collectionService
          .fetchDataOffline(APP_CONFIG.MAX_QUERY_OFFLINE);
      if (response != null && Utils.checkRequestIsComplete(response)) {
        var dataFetch = Utils.handleRequestData(response);
        if (dataFetch != null && Utils.checkIsNotNull(dataFetch)) {
          final dataTime = dataFetch['dataTime'];
          if (dataTime != null) {
            String timeFetchOffline = S.of(context).lastUpdate +
                ': ' +
                Utils.convertTime(
                    Utils.convertTimeStampToDateEnhance(dataTime) ?? 0);
            settingProvider.timeFetchOffline = timeFetchOffline;

              await StorageHelper.setString(
              AppStateConfigConstant.TIME_UPDATE_COLLECTION, timeFetchOffline);
              
          }
        
          List<EmployeeModel> lstEmployeeModel = [];
          final employees = dataFetch['employees'];
          for (var emp in employees) {
            lstEmployeeModel.add(EmployeeModel.fromJson(emp));
          }
          if (lstEmployeeModel.length > 0) {
            await HiveDBService.addEmployeesFuture(lstEmployeeModel);
          }
          List<TicketModel> lstTicket = [];
          final tickets = dataFetch['tickets'];
          for (var ticket in tickets) {
            ticket['customerData'] = ticket['contactDetail'];
            for (var emp in employees) {
              if (emp['empCode'] == ticket['assignee']) {
                ticket['assigneeData'] = emp;
              }
            }
            if (Utils.checkIsNotNull(ticket['ticketActionLog'])) {
              if (Utils.isArray(ticket['ticketActionLog']['data'])) {
                ticket['ticketActionLog'] = ticket['ticketActionLog']['data'];
              }
            }
            lstTicket.add(TicketModel.fromJson(ticket));
          }
          if (lstTicket.length > 0) {
            await HiveDBService.addCollectionsFuture(lstTicket);
          }

          await this._categoryProvider.initAllCateogyData(isClearData: true);
          setState(() {});
        }
      }
    } catch (e) {
      print(e);
    } finally {
      WidgetCommon.dismissLoading();
    }
  }

  Future<void> openScreenTracking() async {
    try {
      if (isClickGoMap) {
        return;
      }
      Position? position = this._mapProvider.getCenterPosition();
      if (Utils.checkIsNotNull(position)) {
        NavigationService.instance.navigateToRoute(
          MaterialPageRoute(builder: (context) => VietTrackingMapScreen()),
        );
      } else {
        WidgetCommon.showLoading(status: 'Đang lấy thông tin vị trí');
        isClickGoMap = true;
        position = await PermissionAppService.getCurrentPosition();
        if (position == null) {
          WidgetCommon.dismissLoading();
          isClickGoMap = false;
          return;
        }
        _mapProvider.setCenterPosition(
            new LatLng(position.latitude, position.longitude));
        isClickGoMap = false;
        WidgetCommon.dismissLoading();
        NavigationService.instance.navigateToRoute(
          MaterialPageRoute(builder: (context) => VietTrackingMapScreen()),
        );
            }
    } catch (e) {
      isClickGoMap = false;
      WidgetCommon.dismissLoading();
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  String getName(String type) {
    if (Utils.checkIsNotNull(_userInfoStore)) {
      if (Utils.checkIsNotNull(_userInfoStore.user)) {
        if (type == 'fullName') {
          return _userInfoStore.user?.fullName ?? '';
                } else if (type == 'userName') {
          return _userInfoStore.user?.moreInfo!['globalEmail'] ?? '';
                }
      }
    }

    return '';
  }

  @override
  void dispose() {
    super.dispose();
    this._subscription?.cancel();
    this._subscriptionReloadAvatar?.cancel();
    WidgetCommon.dismissLoading();
  }
}
