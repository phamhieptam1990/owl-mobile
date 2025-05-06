import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/devices_info_model.dart';
import 'package:athena/models/tracking/tracking.model.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:athena/models/deviceInfo.model.dart' as DEVICE;
import 'package:athena/widgets/common/common.dart';
import '../app_state.dart';
import '../log/crashlystic_services.dart';
import '../utils.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'background_location_with_timer.dart';

class GeoPositionBackgroundService {
  FirebaseFirestore? instance;
  String userName = '';
  String appCode = APP_CONFIG.APP_CODE;
  String companyCode = '';
  State? stateApp;
  bool initTracking = false;
  String pathFB = 'tracking/users/';
  // final _userInfoStore = getIt<UserInfoStore>();

  Future<void> getUsername() async {
    instance = FirebaseFirestore.instance;
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
      if (userName.isEmpty) {
        String username =
            await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ??
                '';
        if (username.isNotEmpty) {
          userName = username;
        }
      }
      if (Utils.checkIsNotNull(trackingModel.coordinates)) {
        if (trackingModel.coordinates.longitude == 0.0 ||
            trackingModel.coordinates.latitude == 0.0 ||
            trackingModel.coordinates.longitude == 0 ||
            trackingModel.coordinates.latitude == 0) {
          Position? position =
              await PermissionAppService.getCurrentPositionLogin();
          if (position != null &&
              position.longitude != 0.0 &&
              position.latitude != 0.0 &&
              position.longitude != 0 &&
              position.latitude != 0) {
            trackingModel.coordinates =
                new GeoPoint(position.latitude, position.longitude);
          }
        }
      }
      await instance?.collection(pathFB + userName).add({
        "appCode": appCode,
        "tenantCode": companyCode,
        "deviceId": trackingModel.deviceId,
        "coordinates": trackingModel.coordinates,
        "makerDate": trackingModel.makerDate,
        "trackDate": trackingModel.trackDate,
        "action": trackingModel.action
      });
    } on PlatformException catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.message}, user $userName');
    } catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.toString()}, user $userName');
    }
  }

  //**Callback to set actual position when location is changed*/
  void onPositionChange(Location location,
      {String eventChange = TrackingModelConstant.onPositionChange}) async {
    try {
      if (!Utils.checkIsNotNull(location)) {
        return;
      }
      if (!Utils.checkIsNotNull(location.coords)) {
        return;
      }
      if (Utils.checkIsNotNull(location.coords.latitude) &&
          Utils.checkIsNotNull(location.coords.longitude)) {
        if (location.coords.latitude == 0.0 ||
            location.coords.longitude == 0.0 ||
            location.coords.latitude == 0 ||
            location.coords.longitude == 0) {
          Position? position =
              await PermissionAppService.getCurrentPositionLogin();
          if (position != null &&
              position.longitude != 0.0 &&
              position.latitude != 0.0 &&
              position.longitude != 0 &&
              position.latitude != 0) {
            location.coords.latitude = position.latitude;
            location.coords.longitude = position.longitude;
          }
        }
      }
      GeoPoint coordinates =
          new GeoPoint(location.coords.latitude, location.coords.longitude);
      DateTime now = DateTime.now();
      DateTime markerDate = now;
      DateTime trackerDate = now;
      await _savePosition(new TrackingModel(appCode, companyCode, coordinates,
          location.uuid, trackerDate, markerDate, eventChange));
    } on PlatformException catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.message}, user $userName');
    }
  }

  void onHeartbeat(HeartbeatEvent event) async {
    try {
      final location = event.location;
      if (event.location != null) {
        if (location == null || location.coords == null) {
          debugPrint('Invalid location data received in heartbeat');
          return;
        }
        final coords = location.coords;
        if (coords.latitude == 0 || coords.longitude == 0) {
          final position = await PermissionAppService.getCurrentPositionLogin();
          if (position != null &&
              position.longitude != 0 &&
              position.latitude != 0) {
            coords.latitude = position.latitude;
            coords.longitude = position.longitude;
          } else {
            debugPrint('Invalid coordinates received from current position');
            return;
          }
        }

        final now = DateTime.now();
        final coordinates = GeoPoint(coords.latitude, coords.longitude);

        await _savePosition(new TrackingModel(appCode, companyCode, coordinates,
            location.uuid, now, now, TrackingModelConstant.onHeartbeat));
      }
    } on PlatformException catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.message}, user $userName');
    }
  }

  Future<void> handlePermission() async {
    bg.ProviderChangeEvent providerState =
        await bg.BackgroundGeolocation.providerState;

    if ((providerState.status ==
        bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS)) {
      return;
    }

    try {
      await WidgetCommon.generateDialogOKCancelGet(
        'Athena Owl cần cấp quyền truy cập vị trí của thiết bị ở chế độ luôn luôn, để tính toán quãng đường bạn di chuyển từ đó sẽ đề ra những hợp đồng phù hợp với bạn nhất sau này',
        callbackOK: () async {
          //Kiểm trả popup không bao giờ hiện lên nữa
          if (await PermissionHandler
              .Permission.locationAlways.isPermanentlyDenied) {
            await openAppSettings();
            return;
          }
          await [
            PermissionHandler.Permission.locationWhenInUse,
          ].request();
          await [
            PermissionHandler.Permission.locationAlways,
          ].request();

          providerState = await bg.BackgroundGeolocation.providerState;

          if ((providerState.status !=
              bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS)) {
            //of dinh vi alwas
            // await Geolocator.openLocationSettings();
            await WidgetCommon.generateDialogOKCancelGet(
                'Bạn không cho phép úng dụng truy cập vị trí của thiết bị ở chế độ luôn luôn! Vui lòng bật để sử dụng tính năng này!',
                callbackOK: () async {
              await Geolocator.openLocationSettings();
            });
          }
        },
      );
    } catch (e) {
      // await Geolocator.openLocationSettings();
      await WidgetCommon.generateDialogOKCancelGet(
          'Bạn không cho phép úng dụng truy cập vị trí của thiết bị ở chế độ luôn luôn! Vui lòng bật để sử dụng tính năng này!',
          callbackOK: () async {
        await Geolocator.openLocationSettings();
      });
      print(e.toString());
    }
  }

  Future startLocationService() async {
    bool checkPermission =
        await PermissionAppService.checkServiceEnabledLocationWithoutContext();
    if (!checkPermission) {
      return;
    }
    // if (_userInfoStore?.user?.permissions?.isNotEmpty ?? false) {
    //   if (!_userInfoStore.checkPerimission(ScreenPermission.TRACKING_DEVICE)) {
    //     return;
    //   }
    // }
    if (stateApp != null && (stateApp?.enabled ?? false)) {
      return;
    }
    initTracking = true;

    try {
      // await loginFireBase();
      DeviceInfoModel deviceInfo = await Utils.getDeviceInfoModel();

      if (Platform.isIOS) {
        final systemVersion = deviceInfo.systemVersion?.toInt() ?? 0;
        if (systemVersion == 11) {
          setupBackgroundTimer();
        } else {
          setupBackgroundLocation();
        }
      } else if (Platform.isAndroid) {
        final systemVersion = deviceInfo.systemVersion?.toInt() ?? 0;
        if (systemVersion == 6 || systemVersion == 7 || systemVersion == 8) {
          setupBackgroundTimer();
        } else {
          setupBackgroundLocation();
        }
      }
      getFirstPositionWhenInApp();
      //  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    } on PlatformException catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.message}, user $userName');
    }
  }

  void setupBackgroundLocation() async {
    BackgroundGeolocation.onHeartbeat(onHeartbeat);

    BackgroundGeolocation.ready(Config(
            showsBackgroundLocationIndicator: false,
            backgroundPermissionRationale: PermissionRationale(
                title:
                    "Athena Owl sẽ thu nhập dữ liệu vị trí của bạn dù bạn có tắt ứng dụng hay không sử dụng",
                message:
                    "Chức năng này thu nhập dữ liệu vị trí của bạn để tính toán quãng đường bạn di chuyển từ đó sẽ đề ra những hợp đồng phù hợp với bạn nhất sau này",
                positiveAction: 'Change to Athena Owl',
                negativeAction: 'Cancel'),
            locationAuthorizationAlert: {
              "titleWhenNotEnabled": "Change to Athena Owl",
              "titleWhenOff":
                  "Allow Athena Owl to access this device's location even when the app is closed or not in use.",
              "instructions":
                  "This app collects location data to enable recording your trips to work and calculate distance-travelled. You must enable 'Always' in location-services",
              "cancelButton": "Hủy",
              "settingsButton": "Cài đặt"
            },
            desiredAccuracy: Config.DESIRED_ACCURACY_HIGH,
            locationAuthorizationRequest: 'Always',
            stopOnTerminate: false,
            disableElasticity: true,
            startOnBoot: true,
            // foregroundService: true,
            distanceFilter: 20,
            heartbeatInterval: 420,
            reset: true,
            enableHeadless: true,
            notificationPriority: Config.NOTIFICATION_PRIORITY_HIGH,
            // locationUpdateInterval: 240000,
            fastestLocationUpdateInterval: 420000,
            debug: false,
            preventSuspend: true,
            // schedule: [
            //   '1-7 07:00-21:00',
            // ],
            autoSync: false,
            useSignificantChangesOnly: true,
            // notification: Notification(
            //   sticky: false,
            //   priority: Config.NOTIFICATION_PRIORITY_LOW,
            // ),
            logLevel: Config.LOG_LEVEL_INFO))
        .then((State state) {
      if (!state.enabled) {
        BackgroundGeolocation.start();
        stateApp = state;
      }
    });
  }

  void setupBackgroundTimer() {
    BackgroundLocationWithTimer.start(
        duration: Duration(seconds: 15),
        callback: () async {
          try {
            // // Location location = await BackgroundGeolocation.getCurrentPosition(
            // //     samples: 1, persist: true);
            final checkPermission =
                await PermissionAppService.checkPermission();
            if (checkPermission) {
              Position? location =
                  await PermissionAppService.getCurrentPosition();
              if (location == null) {
                return;
              }
              DateTime now = DateTime.now();
              DateTime markerDate = now;
              DateTime trackerDate = now;
              // GeoPoint coordinates =
              GeoPoint coordinates =
                  new GeoPoint(location.latitude, location.longitude);
              await _savePosition(TrackingModel(
                  appCode,
                  companyCode,
                  coordinates,
                  DateTime.now().toString(),
                  trackerDate,
                  markerDate,
                  TrackingModelConstant.onTimer));
            }
          } catch (_) {}
        });
  }

  // First time login app we call get position;
  Future getFirstPositionWhenInApp() async {
    try {
      if (userName.isEmpty) {
        String username =
            await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ??
                '';
        if (username.isNotEmpty) {
          userName = username;
        }
      }
      if (!Utils.checkIsNotNull(userName)) {
        return;
      }
      if (!Utils.checkIsNotNull(AppState.getDeviceInfo())) {
        return;
      }
      final checkPermission = await PermissionAppService.checkPermission();
      if (checkPermission) {
        Position? position = await PermissionAppService.getCurrentPosition();
        if (position != null && Utils.checkIsNotNull(position)) {
          GeoPoint coordinates =
              new GeoPoint(position.latitude, position.longitude);
          PermissionAppService.lastPosition = position;
          DateTime now = DateTime.now();
          DEVICE.DeviceInfo device = AppState.getDeviceInfo();
          if (Utils.checkIsNotNull(device)) {
            instance?.collection(pathFB + userName).add({
              "appCode": appCode,
              "tenantCode": companyCode,
              "deviceId": device.imei,
              "coordinates": coordinates,
              "makerDate": now,
              "trackDate": now,
              "action": 'FIRST_TIME'
            });
          }
        }
      }
    } on PlatformException catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.message}, user $userName');
    } catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.toString()}, user $userName');
    }
  }

  void logoutFireBase() {
    // FirebaseAuth.instance.signOut();
  }

  // /// Receive events from BackgroundFetch in Headless state.
  void backgroundFetchHeadlessTask(String taskId) async {}

  void headlessTask(HeadlessEvent headlessEvent) async {
    // headlessEvent.event
    try {
      // // Implement a `case` for only those events you're interested in.
      switch (headlessEvent.name) {
        case Event.HEARTBEAT:
          HeartbeatEvent event = headlessEvent.event;
          onHeartbeat(event);
          break;
        case Event.LOCATION:
          Location location = headlessEvent.event;
          onPositionChange(location,
              eventChange: TrackingModelConstant.onPositionChange);
          break;
        case Event.MOTIONCHANGE:
          Location location = headlessEvent.event;
          onPositionChange(location,
              eventChange: TrackingModelConstant.onMotionChange);
          break;
        case Event.GEOFENCE:
          GeofenceEvent geofenceEvent = headlessEvent.event;
          onPositionChange(geofenceEvent.location,
              eventChange: TrackingModelConstant.onMotionChange);
          break;
        default:
          break;
      }
    } on PlatformException catch (e) {
      CrashlysticServices.instance.log('savePosition ${e.message}');
    } catch (e) {
      CrashlysticServices.instance.log('savePosition ${e.toString()}');
    }
  }

  Future<Location> getLastestCurrentPosition() async {
    return await BackgroundGeolocation.getCurrentPosition();
  }

  void stopTracking() {
    BackgroundGeolocation.stop();
  }

  void stopTrackingTimer() {
    BackgroundLocationWithTimer.stop();
  }

  static final GeoPositionBackgroundService _geoPositionBackgroundService =
      GeoPositionBackgroundService._internal();

  factory GeoPositionBackgroundService() {
    return _geoPositionBackgroundService;
  }

  // Add the missing _internal constructor
  GeoPositionBackgroundService._internal()  {
    // Initialize the instance
    instance = FirebaseFirestore.instance;
    // Set default values for other required fields
    appCode = APP_CONFIG.APP_CODE;
    companyCode = APP_CONFIG.COMPANY_CODE;

    // Initialize stateApp with a default state
  }
}
