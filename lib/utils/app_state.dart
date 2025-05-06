import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/deviceInfo.model.dart';
import 'package:athena/screens/calendar/calendar/calendar.provider.dart';
import 'package:athena/screens/collections/collection/collections.provider.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/screens/filter/collections/hierarchy/hiearchy.provider.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/login/login.service.dart';
import 'package:athena/screens/notification/notification.provider.dart';
import 'package:athena/screens/notification/notification.service.dart';
import 'package:athena/screens/settings/setting.prodiver.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/geolocation.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';

import '../getit.dart';
import 'global-store/user_info_store.dart';
import 'idie/idieActivity.service.dart';

class AppState {
  static double height = 0;
  static double width = 0;
  static String versionIOS = (IS_PRODUCTION_APP)
      ? APP_CONFIG.VERSION_IOS_PROD
      : APP_CONFIG.VERSION_IOS;
  // static String versionAndroid = APP_CONFIG.VERSION_ANDROID;
  static String versionAndroid = (IS_PRODUCTION_APP)
      ? APP_CONFIG.VERSION_ANDROID_PROD
      : APP_CONFIG.VERSION_ANDROID;
  final _collectionProvider = getIt<CollectionProvider>();
  final _userInfoProvider = getIt<UserInfoStore>();
  final _calendarProvider = getIt<CalendarProvider>();
  final _homeProvider = getIt<HomeProvider>();
  final _notificationProvider = getIt<NotificationProvider>();
  final _categoryProvider = new CategorySingeton();
  final notificationService = new NotificationService();
  final _geoPositionBackgroundService = new GeoPositionBackgroundService();
  final filterCollectionProvider = getIt<FilterCollectionsProvider>();
  final _hiearchyProvider = getIt<HiearchyProvider>();
  final SettingProvider _settingProvider = new SettingProvider();
  // final _chatProvider = new ChatProvider();
  static dynamic menuData;
  static  DeviceInfo? deviceInfo;
  static bool checkMenuTracking = false;
  static  FirebaseApp? firebaseApp;
  static LoginService loginService = new LoginService();
  String pathFileAvatar = '';
  bool isShowTitleUpdate = false;
  bool isCheckShowAvatarComplete = false;
  bool isFirstEnter = true;
  String accessToken = '';
  String idToken = '';
  String serverToken = '';
  String refreshToken = '';
  String titleUpdateApp = '';
  static dynamic versionApp;
  setMenuTracking(check) {
    checkMenuTracking = check;
  }

  getMenuTracking() {
    return checkMenuTracking;
  }

  static setDeviceInfo(DeviceInfo? _deviceInfo) {
    deviceInfo = _deviceInfo;
  }

  static getDeviceInfo() {
    return deviceInfo;
  }

  static getHeightDevice(BuildContext context) {
    if (height == 0) {
      height = MediaQuery.of(context).size.height;
    }
    return height;
  }

  static getWidthDevice(BuildContext context) {
    if (width == 0) {
      width = MediaQuery.of(context).size.width;
    }
    return width;
  }

  static setVerionIOS(String version) {
    versionIOS = version;
  }

  static setVerionAndroid(String version) {
    versionAndroid = version;
  }

  static bool checkVersionCanSubmitRequest(BuildContext context) {
    return true;
  }

  void logOut() async {
    try {
      isShowTitleUpdate = false;
      isFirstEnter = true;
      titleUpdateApp = '';
      IdieActivity.instance.stopCheckIdieActivity();
      if (_geoPositionBackgroundService.stateApp?.enabled ?? false) {
        _geoPositionBackgroundService.stopTracking();
        _geoPositionBackgroundService.initTracking = false;
        if (Utils.checkIsNotNull(bg.BackgroundGeolocation)) {
          bg.BackgroundGeolocation.stop();
        }
      }
          _geoPositionBackgroundService.stopTrackingTimer();

      FlutterAppBadge.count(0);
      // AwesomeNotifications().resetGlobalBadge();
      String userName =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      await callLogout(userName);
      await Amplify.Auth.signOut(
          options: const SignOutOptions(globalSignOut: false));
      final tokenJWT =
          await StorageHelper.getString(AppStateConfigConstant.JWT);
      if (Utils.checkIsNotNull(tokenJWT)) {
        await StorageHelper.setString(AppStateConfigConstant.JWT_BK, tokenJWT ?? '');
      }
    } catch (e) {
      print(e);
    }
  }

  void logOutNew() async {
    try {
      isShowTitleUpdate = false;
      titleUpdateApp = '';
      pathFileAvatar = '';
      isCheckShowAvatarComplete = false;
      isFirstEnter = true;
      String userName =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      IdieActivity.instance.stopCheckIdieActivity();
      await HiveDBService.clearAllBox();
      _calendarProvider.clearData();
      _homeProvider.clearData();
      _notificationProvider.clearData();
      _collectionProvider.clearData();
      _userInfoProvider.clearStore();
      _categoryProvider.clearData();
      _settingProvider.clearData();
      filterCollectionProvider.clearData();
      _hiearchyProvider.clearData();
      String typeOS = '';
      if (_geoPositionBackgroundService.stateApp?.enabled ?? false) {
        _geoPositionBackgroundService.stopTracking();
        _geoPositionBackgroundService.initTracking = false;
        if (Utils.checkIsNotNull(bg.BackgroundGeolocation)) {
          bg.BackgroundGeolocation.stop();
        }
      }
          _geoPositionBackgroundService.stopTrackingTimer();
      if (Platform.isIOS) {
        typeOS = 'ios';
      }
      final tokenJWT =
          await StorageHelper.getString(AppStateConfigConstant.JWT_BK);
      if (Utils.checkIsNotNull(tokenJWT)) {
        await StorageHelper.setString(AppStateConfigConstant.JWT, tokenJWT ?? '');
        callLogout(userName);
      }

      await StorageHelper.remove(AppStateConfigConstant.USER_NAME);
      await StorageHelper.remove(AppStateConfigConstant.USER_TOKEN);

      FlutterAppBadge.count(0);
// AwesomeNotifications().resetGlobalBadge();
      await Amplify.Auth.signOut(
          options: const SignOutOptions(globalSignOut: false));

      // final tokenFirebase =
      //     await StorageHelper.getString(AppStateConfigConstant.TOKEN_FIREBASE);
      await FirebaseMessaging.instance
          .unsubscribeFromTopic(NotificationConstant.FE_ICOLLECT_TOPIC);
      await StorageHelper.remove(AppStateConfigConstant.TOKEN_FIREBASE);
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (typeOS == 'ios') {
        final value = await deviceInfo.iosInfo;
        if (Utils.checkIsNotNull(value)) {
          removeToken(value.identifierForVendor);
        }
      } else {
        final value = await deviceInfo.androidInfo;
        if (Utils.checkIsNotNull(value)) {
          await removeToken(value.serialNumber);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  removeToken(String? uuid) async {
    await notificationService.deleteUserDevice(uuid, APP_CONFIG.APP_CODE);
  }

  Future<Response?> callLogout(String username) async {
    final params = {"username": username};
    await HttpHelper.post(LoginServiceUrl.LOGOUT_SERVICE, body: params);
    await StorageHelper.remove(AppStateConfigConstant.JWT);
  }

  Future<Response> getAttributeValue(String attribute) {
    String dataJson = 'attribute=' + attribute;
    return HttpHelper.get(USER_SERVICE_URL.ATTRIBUTE_GET + dataJson,
        timeout: 30000, typeContent: 1);
  }

  Future<Response> setAttributeValue(String attribute, String value) {
    String dataJson = 'attribute=' + attribute + '&attrValue=' + value;
    return HttpHelper.postForm(USER_SERVICE_URL.ATTRIBUTE_SET,
        body: dataJson, timeout: 30000, typeContent: 1);
  }

  Future<Response> getMenuApp() {
    return HttpHelper.get(USER_SERVICE_URL.GET_MENU);
  }

  static void setMenuData(var _menuData) {
    menuData = _menuData;
  }

  void clearData() {
    menuData = null;
  }

  dynamic getUserInfoStore() {
    if (Utils.checkIsNotNull(_userInfoProvider)) {
      if (Utils.checkIsNotNull(_userInfoProvider.user)) {
        return _userInfoProvider.user;
      }
    }
    return null;
  }

  dynamic getMoreInfoUserInfoStore() {
    final userInfo = getUserInfoStore();
    if (Utils.checkIsNotNull(userInfo)) {
      if (Utils.checkIsNotNull(userInfo.moreInfo)) {
        return userInfo.moreInfo;
      }
    }
    return null;
  }

  static checkTime(BuildContext context, Function? _callBack) async {
    try {
      Response response = await loginService.getTimeSys();
      if (response.data != null) {
        var dateTimeSystemInt = response.data['data'];
        if (Utils.checkIsNotNull(dateTimeSystemInt)) {
          DateTime dateTimeSystem = Utils.converLongToDate(dateTimeSystemInt);
          if (dateTimeSystem == null) {
            return false;
          }
          String? stringDateSys = Utils.getTimeFromDate(dateTimeSystemInt);
          var minutes =
              Utils.diffInDaysGetMinues(DateTime.now(), dateTimeSystem);
          if (minutes > 2 || minutes < -2) {
            WidgetCommon.generateDialogOKGet(
                title: 'Thời gian trên thiết bị không hợp lệ!',
                content:
                    'Thời gian hệ thống: ' + '\n' + stringDateSys.toString(),
                callback: _callBack);
            return false;
          }
        }
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  static final AppState _appState = AppState._internal();

  factory AppState() {
    return _appState;
  }

  AppState._internal();
}
