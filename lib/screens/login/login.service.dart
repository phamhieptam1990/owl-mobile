import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/models/deviceInfo.model.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/idie/idieActivity.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import '../../utils/utils.dart';

class LoginService {
  Future<dynamic> getToken(BuildContext context, String idToken,
      String accessToken, DeviceInfo? deviceInfo, Position? position) {
    final params = {
      'idToken': idToken,
      'accessToken': accessToken,
      'appCode': APP_CONFIG.APP_CODE,
      // 'tenantCode': APP_CONFIG.TENANT_CODE,
      'deviceInfo': {
        'imageNumber': deviceInfo?.imei,
        'os': deviceInfo?.typeOS,
        'appVersion': Utils.showVersionApp(),
        'deviceManufacture': deviceInfo?.manufacter,
        'deviceModel': deviceInfo?.model,
        'osVersion': deviceInfo?.version,
        'location': null
        // 'location': {
        //   'lng': position?.longitude,
        //   'lat': position?.latitude,
        //   'accuracy': position?.accuracy
        // }
      }
    };
    return HttpHelper.newPostJSON(LoginServiceUrl.LOGIN_NORMAL,
        body: params, timeout: 60000, typeContent: 0);
  }

  Future<Response> loginFace(String username, String password,
      DeviceInfo deviceInfo, Position position) async {
    var loginObject = {
      'password': password,
      'rememberMe': false,
      'username': username,
      'deviceInfo': {
        'appVersion': Utils.showVersionApp(),
      },
    };
    loginObject = {
      'password': password,
      'rememberMe': false,
      'username': username,
      'deviceInfo': {
        'imageNumber': deviceInfo.imei,
        'os': deviceInfo.typeOS,
        'appVersion': Utils.showVersionApp(),
        'deviceManufacture': deviceInfo.manufacter,
        'deviceModel': deviceInfo.model,
        'osVersion': deviceInfo.version
      },
    };
      if (Utils.checkIsNotNull(position)) {
      loginObject = {
        'password': password,
        'rememberMe': false,
        'username': username,
        'deviceInfo': {
          'imageNumber': deviceInfo.imei,
          'os': deviceInfo.typeOS,
          'appVersion': Utils.showVersionApp(),
          'deviceManufacture': deviceInfo.manufacter,
          'deviceModel': deviceInfo.model,
          'osVersion': deviceInfo.version,
          "location": {
            "lng": position.longitude,
            "lat": position.latitude,
            "accuracy": position.accuracy
          }
        },
      };
    }
    return HttpHelper.postJSON(LoginServiceUrl.LOGIN_FACE,
        body: loginObject, timeout: 40000, typeContent: 0);
  }

  Future<void> handleFaceAuthen(
      UserInfoStore _userInfoStore,
      String username,
      String password,
      AppState _appState,
      HomeProvider _homeProvider,
      BuildContext context) async {}

  Future<void> handleLoginComplete(
      UserInfoStore _userInfoStore,
      String username,
      String password,
      AppState _appState,
      HomeProvider _homeProvider,
      BuildContext context) async {
    Response responseUserInfo = await getUserInfo(username, '');
    if (responseUserInfo.data != null) {
      final userInfoTemo = Utils.setUserInfo(responseUserInfo);
      if (userInfoTemo == null) {
        return;
      }
      _userInfoStore.updateUser(userInfoTemo);
      final newJson = jsonEncode(responseUserInfo.data);
      await StorageHelper.setString(AppStateConfigConstant.USER_INFO, newJson);
      await StorageHelper.setString(AppStateConfigConstant.USER_NAME, username);
      await StorageHelper.setString(
          AppStateConfigConstant.USER_TOKEN, password);
      StorageHelper.setInt(AppStateConfigConstant.LOGIN_TIME,
          DateTime.now().millisecondsSinceEpoch);
      StorageHelper.setInt(AppStateConfigConstant.COUNT_LOGIN_OFFLINE, 1);
      // await _appState.initFirebase(context);
      _homeProvider.setIsLogined = true;
      IdieActivity.instance.setTimerModel();
      IdieActivity.instance.isLogout = false;
      IdieActivity.instance.isLoginPage = false;
      IdieActivity.instance.initIdieActivity();
      Utils.offAllNamePage(RouteList.TAB_SCREEN);
    }
  }

  Future<Response> getUserInfo(String _username, String token) {
    return HttpHelper.get(LoginServiceUrl.PROFILE_INFO,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }

  Future<Response> getVersionAppp() {
    return HttpHelper.get(NOTIFICATION_SERVICE_URL.GET_VERSION_APP,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }

  Future<Response> getMenuApp() {
    return HttpHelper.get(USER_SERVICE_URL.GET_MENU);
  }

  Future<Response> getTimeSys() {
    return HttpHelper.get(USER_SERVICE_URL.TIME_SYSTEM,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }
}

// ignore: camel_case_types
class LoginServiceUrl {
  static String LOGIN_FACE = APP_CONFIG.HOST_NAME + 'api/mfa/authenticate';
  static String FACE_AUTHEN = APP_CONFIG.HOST_NAME + 'api/auth/faceauthen';
  static String FACE_AUTHEN_BASE64 =
      APP_CONFIG.HOST_NAME + 'api/auth/faceauthen/base64';

  static String LOGIN_NORMAL =
      APP_CONFIG.HOST_NAME + 'api/authenticateWithToken';
  static String LOGIN_SERVICE_PRODUCTION =
      APP_CONFIG.HOST_NAME_API + 'authenticateWithToken';
  static String LOGOUT_SERVICE = APP_CONFIG.HOST_NAME_API + 'logout';
  static String PROFILE_INFO = APP_CONFIG.HOST_NAME_API + 'profileInfo';
}
