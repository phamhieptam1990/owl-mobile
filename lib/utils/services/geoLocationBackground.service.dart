import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/tracking/tracking.model.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:background_fetch/background_fetch.dart';

class GeoLocationBackground {
  final FirebaseFirestore instance = FirebaseFirestore.instance;
  String? userName;
  String? appCode;
  String? companyCode;
  String? pathFB = 'tracking/users/';

  Future<void> getUsername() async {
    String username =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    if (username.isNotEmpty) {
      userName = username;
    }
    appCode = APP_CONFIG.APP_CODE;

    companyCode =
        await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE) ??
            APP_CONFIG.COMPANY_CODE;
    ;
  }

  //**Event to save current position of user (in real time) */
  Future _savePosition(TrackingModel trackingModel) async {
    try {
      await instance.collection((pathFB ??"") + (userName??"")).add({
        "appCode": appCode,
        "tenantCode": companyCode,
        "deviceId": trackingModel.deviceId,
        "coordinates": trackingModel.coordinates,
        // "ticketId": trackingModel.ticketId,
        // "ticketCode": trackingModel.ticketCode,
        // "unitCode": trackingModel.unitCode,
        // "userName": trackingModel.userName,
        "makerDate": trackingModel.makerDate,
        "trackDate": trackingModel.trackDate
      });
    } on PlatformException catch (e) {
      print(
          'Unespected error with message: ${e.message}, with stacktrace: ${e.stacktrace}');
    }
  }

  //**Callback to set actual position when location is changed*/
  void onPositionChange(var location) async {
    // model.setPosition(
    //     location.coords.latitude, double, location.coords.longitude);
    // await _savePosition(location.odometer);
    GeoPoint coordinates =
        new GeoPoint(location.coords.latitude, location.coords.longitude);
    await _savePosition(new TrackingModel(
        appCode??"",
        companyCode??"",
        coordinates,
        location.uuid,
        DateTime.now(),
        // "ticket123",
        // "ticketCode321",
        // "unitCode",
        DateTime.now(),
        ""
        // userName
        ));
  }

  void backgroundFetchHeadlessTask(String taskId) async {
    BackgroundFetch.finish(taskId);
  }

  void _onBackgroundFetch(String taskId) async {}

  Future startLocationService() async {
    BackgroundFetch.configure(
            BackgroundFetchConfig(
              minimumFetchInterval: 1,
              forceAlarmManager: false,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.NONE,
            ),
            _onBackgroundFetch)
        .then((int status) {
      BackgroundFetch.start().then((int status) {}).catchError((e) {});
    }).catchError((e) {});
    // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

    // bg.BackgroundGeolocation.onLocation(
    //     onPositionChange); //callback "onPositionChange" is called
    // bg.BackgroundGeolocation.onMotionChange(
    //     onPositionChange); //callback "onPositionChange" is called
    // bg.BackgroundGeolocation.ready(bg.Config(
    //         // backgroundPermissionRationale: PermissionRationale(
    //         //     title:
    //         //         "Allow access to this device's location in the background?",
    //         //     message:
    //         //         "In order to allow X, Y and Z in the background, please enable 'Allow all the time' permission",
    //         //     positiveAction: "Change to Allow all the time",
    //         //     negativeAction: "Cancel"),
    //         desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    //         distanceFilter: 1.0,
    //         locationAuthorizationRequest: 'Always',
    //         stopOnTerminate: false,
    //         disableElasticity: true,
    //         startOnBoot: true,
    //         // foregroundService: true,
    //         // distanceFilter: 0,
    //         locationUpdateInterval: 5000,
    //         debug: true,
    //         locationTimeout: 5000,
    //         logLevel: bg.Config.LOG_LEVEL_VERBOSE))
    //     .then((bg.State state) {
    //   if (!state.enabled) {
    //     bg.BackgroundGeolocation.start();
    //     stateApp = state;
    //   }
    // });
  }

  void stopTracking() {
    // bg.BackgroundGeolocation+.stop();
  }

  static final GeoLocationBackground _instance = GeoLocationBackground._internal();


  factory GeoLocationBackground() {
    return _instance;
  }

  GeoLocationBackground._internal();
}
