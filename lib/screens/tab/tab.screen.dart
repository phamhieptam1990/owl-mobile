import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/offline/action/checkin/checkin.offline.model.dart';
import 'package:athena/screens/calendar/calendar/calendar.screen.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/home/home.screen.dart';
import 'package:athena/screens/login/login.service.dart';
import 'package:athena/screens/notification/notication.app.service.dart';
import 'package:athena/screens/notification/notification.provider.dart';
import 'package:athena/screens/notification/notification.screen.dart';
import 'package:athena/screens/settings/setting.screen.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import '../../getit.dart';
import '../../utils/common/master_data_manager.dart';
import '../../utils/idie/idieActivity.service.dart';
import '../../utils/log/crashlystic_services.dart';

class TabScreen extends StatefulWidget {
  final int currentPage;

  const TabScreen({Key? key, this.currentPage = 0}) : super(key: key);
  @override
  TabScreenState createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'tabScreen');
  int currentPage = 0;
  NotificationApp _notificationApp = new NotificationApp();
  final _notificationProvider = getIt<NotificationProvider>();
  final _loginService = new LoginService();
  final _homeProvider = getIt<HomeProvider>();
  // ChatProvider chatProvider = new ChatProvider();
  bool isAndroid = true;
  String typeOS = APP_CONFIG.ANDROID;
  var deviceInfoTemp;
  //  ChatProvider chatProvider = new ChatProvider();
  List<Widget> screens = [];
  Widget currentScreen = HomeScreen();

  final PageStorageBucket _bucket = PageStorageBucket();
  final _userInfoStore = getIt<UserInfoStore>();
  StreamSubscription? subscription;
  final _appState = new AppState();
  final _mapService = new VietMapService();
  final _collectionService = new CollectionService();

  final filterCollectionProvider = getIt<FilterCollectionsProvider>();

  @override
  initState() {
    super.initState();
    currentPage = widget.currentPage;
    // Future.delayed(Duration(seconds: 8), () async {
    //   AppSessionManager.startListening();

    //   // checkAvatar();
    // });

    if (Platform.isIOS) {
      isAndroid = false;
      typeOS = APP_CONFIG.IOS;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    MasterDataManager.listenCacheCurrentVersion();
    if (!IdieActivity.instance.checkTimer()) {
      IdieActivity.instance.initIdieActivity();
    }
    if (_homeProvider.getIsLogined == false) {
      await checkLogin();
    }
    if (IS_PRODUCTION_APP) {
      this.checkVersion();
    } else {
      this.checkVersionAndroid();
    }

    // _categorySingeton.getPaymentMethods();

    if (APP_OFFLINE == false) {
      this._notificationProvider.getCountNotification();
      Future.delayed(Duration(seconds: 4), () async {
        this._notificationApp.initFirebase(context);
      });
    }
    setState(() {});
    subscription =
        eventBus.on<ReloadNotification>().listen((ReloadNotification event) {
      setState(() {});
    });

    // Future.delayed(Duration(seconds: 6), () async {
    //   submitOfflineApp();
    // });
  }

  checkVersion() {
    if (Platform.isAndroid) {
      checkVersionAndroid();
    } else if (Platform.isIOS) {
      Utils.checkUpdateIOS(context);
    }
  }

  checkVersionAndroid() async {
    bool isVersionValid = false;
    try {
      Map<String, dynamic> versionApp = {
        "android": "",
        "ios": "",
        "releaseNoteIOS": "",
        "releaseNoteAndroid": "",
        "isCheckVersionPlayStore": true
      };
      String version = "";
      String releaseNote = '';
      Response response = await this._loginService.getVersionAppp();
      if (Utils.checkIsNotNull(response.data) &&
          Utils.checkIsNotNull(response.data['data'])) {
        final data = json.decode(response.data['data']);
        AppState.versionApp = data;
        this._homeProvider.appDataConfig = data;
        // this._homeProvider.timeVisitForm =
        //     TimeGetVisitForm.fromJson(data)?.visitForm;
        if (IS_INSTALLED_BY_STORE) {
          versionApp = {
            "android": data['androidStore'],
            "ios": data['iosStore'],
            "releaseNoteIOS": data['releaseNoteIOS'],
            "releaseNoteAndroid": data['releaseNoteAndroid'],
            "isCheckVersionPlayStore": data['isCheckVersionPlayStore']
          };
        } else {
          versionApp = {
            "android": data['androidUat'],
            "ios": data['iosUat'],
            "releaseNoteIOS": data['releaseNoteIOS'],
            "releaseNoteAndroid": data['releaseNoteAndroid'],
            "isCheckVersionPlayStore": data['isCheckVersionPlayStore']
          };
        }
      } else {
        return;
      }
      if (isAndroid) {
        version = versionApp["android"];
        if (Utils.checkIsNotNull(version)) {
          AppState.setVerionAndroid(version);
          if (IS_PRODUCTION_APP) {
            if (APP_CONFIG.VERSION_ANDROID_PROD != version) {
              releaseNote = versionApp["releaseNoteAndroid"];
              isVersionValid = true;
            }
          } else {
            if (APP_CONFIG.VERSION_ANDROID != version) {
              releaseNote = versionApp["releaseNoteAndroid"];
              isVersionValid = true;
            }
          }
        }
      } else {
        version = versionApp["ios"];
        if (Utils.checkIsNotNull(version)) {
          AppState.setVerionIOS(version);
          if (IS_PRODUCTION_APP) {
            if (APP_CONFIG.VERSION_IOS_PROD != version) {
              releaseNote = versionApp["releaseNoteIOS"];
              isVersionValid = true;
            }
          } else {
            if (APP_CONFIG.VERSION_IOS != version) {
              releaseNote = versionApp["releaseNoteIOS"];
              isVersionValid = true;
            }
          }
        }
      }
      if (isVersionValid) {
        if (Utils.checkIsNotNull(releaseNote)) {
          if (releaseNote.toString().indexOf('\\n') > -1) {
            final releaseTemp = releaseNote.split('\\n');
            releaseNote = '';
            for (var re in releaseTemp) {
              releaseNote += re + '\n';
            }
          }
        }
        this._appState.isShowTitleUpdate = true;
        this._appState.titleUpdateApp = releaseNote.toString();
        Utils.pushAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN);
      }
      return isVersionValid;
    } catch (err) {
      print(err);
      return isVersionValid;
    }
  }

   Future<void> checkLogin() async {
    try {
      _homeProvider.setIsLogined = true;
      if (_userInfoStore != null) {
        if (_userInfoStore.user != null) {
          eventBus.fire(LoadUserProfile(_userInfoStore));
          return;
        }
      } else {
        final userInfo =
            await StorageHelper.getString(AppStateConfigConstant.USER_INFO);
        if (userInfo != null && userInfo.isNotEmpty) {
          final newJson = jsonDecode(userInfo);
          if(newJson != null){
            final userModel = Utils.setUserInfo(newJson);
            if (userModel != null) {
              _userInfoStore.updateUser(userModel);
              return;
            }
          }
        } else {
          Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
          return;
        }
        return;
      }
      Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
    } catch (e) {
      Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
    }
  }

 String getName(String type) {
    if (_userInfoStore != null) {
      if (_userInfoStore.user != null) {
        if (type == 'fullName') {
          return _userInfoStore.user?.fullName ?? '';
        } else if (type == 'userName') {
          if (_userInfoStore.user?.moreInfo != null) {
            final userName = _userInfoStore.user?.moreInfo!['userName'];
            if (userName != null) {
              return userName as String;
            }
          }
        } else if (type == 'userCode') {
          if (_userInfoStore.user?.moreInfo != null) {
            final empCode = _userInfoStore.user?.moreInfo!['empCode'];
            if (empCode != null) {
              return empCode as String;
            }
          }
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: PageStorage(child: currentScreen, bucket: _bucket),
      // body: IndexedStack(index: currentPage, children: screens),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentPage,
          onTap: (i) => {
                setState(() {
                  currentPage = i;
                  currentScreen = screens[i];
                  if (i > 4) {
                    currentPage = 4;
                    currentScreen = screens[i];
                  }
                })
              },
          items: this.initSalomonBottomBar()),
    );
  }

  initSalomonBottomBar() {
    screens = [
      HomeScreen(key: PageStorageKey('homeScreen')),
      CalendarScreen(key: PageStorageKey('calendarScreen')),
      NotificationScreen(key: PageStorageKey('notificationScreen')),
      SettingsScreen(key: PageStorageKey('settingScreen'))
    ];
    return [
      SalomonBottomBarItem(
        icon: Icon(Icons.home),
        title: Text("Home"),
        selectedColor: Theme.of(context).primaryColor,
      ),
      SalomonBottomBarItem(
        icon: Icon(Icons.calendar_today),
        title: Text("Lịch"),
        selectedColor: Theme.of(context).primaryColor,
      ),
      SalomonBottomBarItem(
        icon: Stack(
          children: <Widget>[
            new Icon(Icons.notifications),
            Visibility(
                visible:
                    this._notificationProvider.getCountNotificationUnread > 0,
                child: new Positioned(
                  right: 0,
                  child: new Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: new Text(
                      this
                          ._notificationProvider
                          .getCountNotificationUnread
                          .toString(),
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ))
          ],
        ),
        title: Text("Thông báo"),
        selectedColor: Theme.of(context).primaryColor,
      ),
      SalomonBottomBarItem(
        icon: Icon(Icons.settings),
        title: Text("Cấu hình"),
        selectedColor: Theme.of(context).primaryColor,
      )
    ];
  }

  Future checkAvatar() async {
    final saveFileService = new SaveFileService();
    saveFileService.checkAvatar();
  }

  Future<void> submitOfflineApp() async {
    try {
      if (!MyConnectivity.instance.isOffline) {
        final boxTicketModelOffline =
            await HiveDBService.openBox(HiveDBConstant.CHECK_IN_OFFLINE);
        if (HiveDBService.checkValuesInBoxesIsNotEmpty(boxTicketModelOffline)) {
          final boxValues = HiveDBService.getValuesData(boxTicketModelOffline);
          if (boxValues.isEmpty) {
            return;
          }
          List<int> lstRequestComplete = [];
          for (int index = 0; index < boxValues.length; index++) {
            CheckInOfflineModel dataT = boxTicketModelOffline.getAt(index);
            CheckInOfflineModel data =
                CheckInOfflineModel.fromJson(dataT.toJson());
            data.offlineInfo['submitTime'] =
                DateTime.now().microsecondsSinceEpoch;
            String address = await this._mapService.getAddressFromLongLatVMap(
                data?.latitude ?? 0, data.longitude ?? 0, context);
            if (address.isNotEmpty) {
              data.address = address;
            } else {
              continue;
            }
            if (Utils.checkIsNotNull(data)) {
              Response res;
              if (data.actionGroupName ==
                  AppStateConfigConstant.REFUSE_TO_PAY) {
                res =
                    await this._collectionService.checkInRefuse(data.toJson());
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
                    if (Utils.isArray(dataError['validateResult'])) {
                      final validateResult = dataError['validateResult'];
                      if (Utils.checkIsNotNull(validateResult['offlineUuid'])) {
                        lstRequestComplete.add(index);
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
          }
        }
        if (boxTicketModelOffline.isOpen) {
          await boxTicketModelOffline.close();
        }
      }
    } catch (e) {
      if (Utils.checkIsNotNull(e)) {
        WidgetCommon.generateDialogOKGet(content: e.toString());
      }
      CrashlysticServices.instance.log(e.toString());
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    this.subscription?.cancel();
  }
}
