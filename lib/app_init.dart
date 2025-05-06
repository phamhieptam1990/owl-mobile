import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GETX;
import 'package:athena/aws/amplifyconfiguration.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/login/idile-login.dart';
import 'package:athena/screens/tab/tab.screen.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';

import 'common/constants/general.dart';
import 'getit.dart';
import 'models/deviceInfo.model.dart';
// import 'models/offline/action/checkin/checkin.offline.model.dart';
import 'models/events.dart';
import 'models/offline/action/checkin/checkin.offline.model.dart';
import 'screens/login/login.dart';
import 'utils/common/internet_connectivity.dart';
// import 'utils/log/firebaseCrash.service.dart';
import 'utils/log/crashlystic_services.dart';
import 'utils/utils.dart';
import 'widgets/common/common.dart';

class AppInit extends StatefulWidget {
  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> with AfterLayoutMixin<AppInit> {
  bool isFirstSeen = false;
  bool isFirstEnter = false;
  int checkStatus = 0;
  String isLoggedIn = '';
  Map appConfig = {};

  final _mapService = new VietMapService();
  final _collectionService = new CollectionService();
  final _homeProvider = getIt<HomeProvider>();
  final _userInfoStore = getIt<UserInfoStore>();
  @override
  initState() {
    super.initState();
    try {
      Future.delayed(
        Duration(seconds: 2),
        () {
          // IdieActivity.instance.initIdieActivity(context);
          MyConnectivity.instance.initialise();
          MyConnectivity.instance.myStream.listen((onData) {
            // if (onData != null) {
            if (checkStatus < 2) {
              checkStatus = checkStatus + 1;
              return;
            }
            checkConnection();
            // }
          });
        },
      );
      loadInitData().then((value) => setState(() {}));
      // FirebaseAuthServices.instance.initialize();
    } catch (e) {}
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
            final context =
                NavigationService.instance.navigationKey.currentContext;
            String address = '';
            if (context != null &&
                data.latitude != null &&
                data.longitude != null) {
              address = await this._mapService.getAddressFromLongLatVMap(
                  data.latitude!, data.longitude!, context);
            }
            if (address.isNotEmpty) {
              data.address = address;
            } else {
              continue;
            }
            if (Utils.checkIsNotNull(data)) {
              Response res;
              if (data.actionGroupName ==
                      AppStateConfigConstant.REFUSE_TO_PAY ||
                  (data.isRefusePayment == true)) {
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

  _initAmplifyFlutter() async {
    if (Amplify.isConfigured) {
      return;
    }
    if (MyConnectivity.instance.isOffline) {
      return;
    }
    // AmplifyAPI api = AmplifyAPI();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    await Amplify.addPlugin(authPlugin);
    // await Amplify.addPlugin(api);
    // await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyAPI()]);
    try {
      if (IS_PRODUCTION_APP) {
        await Amplify.configure(amplifyconfig_prod);
      } else {
        await Amplify.configure(amplifyconfig);
      }
    } on AmplifyAlreadyConfiguredException {
      // print(
      //     "Amplify was already configured. Looks like app restarted on android.");
    }
    // print("Amplify was already configured Complete ");
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await _initAmplifyFlutter();
  }

  Future<void> loadInitData() async {
    String username;
    var deviceInfo;
    DeviceInfo deviceInfoTemp;
    bool isHandledLogin = false;
    await StorageHelper.setString(AppStateConfigConstant.JWT, '');
    try {
      if (!HiveDBService.hiveInit) {
        await HiveDBService.initHiveDB();
      }
      // isFirstEnter =
      //     await StorageHelper.getBool(AppStateConfigConstant.IS_FIRST_ENTER) ??
      //         false;
      // if (!isFirstEnter) {
      //   isLoggedIn = '';
      //   isFirstSeen = true;
      //   return;
      // }
      username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      isLoggedIn =
          await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN) ??
              '';
      if (username == '' || isLoggedIn == '') {
        isLoggedIn = '';
        isFirstSeen = true;
        return;
      }
      final tokenJWT =
          await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
      if (Utils.checkIsNotNull(tokenJWT) || Utils.checkIsNotNull(username)) {
        isLoggedIn = 'IDILE';
        isFirstSeen = true;
        return;
      }
      // else if (!Utils.isCheckInTimeValid()) {
      //   isLoggedIn = 'IDILE';
      //   isFirstSeen = true;
      //   return;
      // }
      deviceInfo =
          await StorageHelper.getString(AppStateConfigConstant.DEVICE_INFO) ??
              null;
      if (deviceInfo != null) {
        deviceInfoTemp =
            DeviceInfo.fromJson(Utils.decodeJSONToString(deviceInfo));
        AppState.setDeviceInfo(deviceInfoTemp);
      }
      // if (deviceInfoTemp == null) {
      //   isLoggedIn = '';
      //   isFirstSeen = true;
      //   return;
      // }
      final loginTime =
          await StorageHelper.getInt(AppStateConfigConstant.LOGIN_TIME);
      if (Utils.checkIsNotNull(loginTime)) {
        DateTime lastLogin =
            DateTime.fromMillisecondsSinceEpoch(loginTime ?? 0);
        DateTime now = DateTime.now();
        Duration calculate = now.difference(lastLogin);
        // Neu lan login cuoi qua 450p sesstion là 8h ta se login lai
        if (!MyConnectivity.instance.isOffline) {
          if (calculate.inMinutes >= 15) {
            isLoggedIn = 'IDILE';
          }
        } else {
          if (calculate.inMinutes >= 15) {
            isLoggedIn = 'IDILE';
          }
        }
      }
      if (!isHandledLogin) {
        final userInfo =
            await StorageHelper.getString(AppStateConfigConstant.USER_INFO);
        if (userInfo != null && Utils.checkIsNotNull(userInfo)) {
          final newJson = jsonDecode(userInfo);
          final userInfoModel = Utils.setUserInfo(newJson);
          // Only update if we got a valid user info model
          if (userInfoModel != null) {
            _userInfoStore.updateUser(userInfoModel);
          } else {
            // Handle the case where user info couldn't be parsed properly
            debugPrint('Warning: Could not parse user information');
            Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
            return;
          }
          // this._userInfoStore.updateUser(Utils.setUserInfo(newJson));
        } else {
          Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
          return;
        }
      }
      isFirstSeen = true;
    } catch (e) {
      isFirstSeen = true;
    } finally {
      if (!isHandledLogin) {
        if (deviceInfo != null) {
          // _loginService
          //     .login(username, isLoggedIn,
          //         DeviceInfo.fromJson(Utils.decodeJSONToString(deviceInfo)))
          //     .then((responseLogin) {
          //   handleLogin(responseLogin);
          // });
        }
      }
    }
  }

  Widget onNextScreen() {
    // if (!Utils.checkIsNotNull(isFirstEnter) && IS_INSTALLED_BY_STORE) {
    //   return OnBoardScreen();
    // }
    if (!Utils.checkIsNotNull(isLoggedIn)) {
      return LoginScreen();
    }
    if (isLoggedIn == 'IDILE') {
      return IdileLogin();
    }
    return TabScreen();
  }

  Future<void> handleLogin(responseLogin) async {
    if (responseLogin.data != null) {
      await StorageHelper.setString(
          AppStateConfigConstant.JWT, responseLogin.data['id_token']);
      _homeProvider.setIsLogined = true;
      await StorageHelper.setInt(AppStateConfigConstant.LOGIN_TIME,
          DateTime.now().millisecondsSinceEpoch);
      StorageHelper.setInt(AppStateConfigConstant.COUNT_LOGIN_OFFLINE, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirstSeen) {
      return Scaffold(
        appBar: new AppBar(
          title: Text('Athena Owl'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 58, 184, 62),
                  Color.fromARGB(255, 38, 134, 45),
                  Color.fromARGB(255, 6, 51, 9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
        ),
        body: Center(
          child: WidgetCommon.buildCircleLoading(),
        ),
      );
    } else {
      return onNextScreen();
    }
  }

  Future<void> checkConnection() async {
    bool hasConnection = true;
    var result;
    try {
      result = await InternetAddress.lookup('https://athenahunt.athenafs.io');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }
    if (!hasConnection) {
      try {
        result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          hasConnection = true;
        } else {
          hasConnection = false;
        }
      } on SocketException catch (_) {
        hasConnection = false;
      }
    }
    try {
      if (hasConnection == false) {
        MyConnectivity.instance.isOffline = true;
        GETX.Get.changeTheme(themeApp('offline'));
        if (MyConnectivity.instance.isShow == false) {
          MyConnectivity.instance.isShow = true;
          WidgetCommon.showSnackbarOffline('Thông báo',
              message: 'Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại');
          eventBus.fire(TriggerEventOffline(true));
        }
        // setState(() {});
      } else {
        MyConnectivity.instance.isOffline = false;
        GETX.Get.changeTheme(themeApp('main'));
        eventBus.fire(TriggerEventOffline(false));
        if (MyConnectivity.instance.isShow == true) {
          MyConnectivity.instance.isShow = false;
          // submitOfflineApp();
        }
      }
    } catch (e) {
      MyConnectivity.instance.isOffline = true;
    }
  }
}
