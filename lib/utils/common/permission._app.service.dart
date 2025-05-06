import 'dart:async';
import 'dart:io';

// import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart'
    as PermissionHandler;
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/models/mock-location-app/MockLocationApp.model.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/utils/common/tracking_installing_device.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../getit.dart';
import '../app_state.dart';
import '../log/firebaseRemoteConfig.service.dart';
import '../services/flutter_jailbreak_detection.dart';

class PermissionAppService {
  static final LocalAuthentication auth = LocalAuthentication();
  static final _homeProvider = getIt<HomeProvider>();
  static String versionApp = '';
  final _appState = AppState();
  static Position? lastPosition;

  static Future<bool> checkServiceEnabledLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled == false) {
        WidgetCommon.generateDialogOKCancelGet(
            'Vui lòng cấp quyền cho Athena Owl truy cập vị trí',
            callbackOK: () async => {await Geolocator.openLocationSettings()});
        return false;
      }
      // check app installed
      if (Platform.isAndroid) {
        // check device app instaleed here
        // bool isMockLocation = await TrustLocation.isMockLocation;
        // Neu 2 version # nhau ta se fetch tu server ve;
        versionApp = '';
        if (versionApp.isEmpty) {
          if (IS_PRODUCTION_APP) {
            versionApp = await StorageHelper.getString(
                    FirebaseRemoteConfigConstant.ANDROID_PRODUCTION_VERISON) ??
                '';
          } else {
            versionApp = await StorageHelper.getString(
                    FirebaseRemoteConfigConstant.ANDROID_UAT_VERISON) ??
                '';
          }
          // Neu verions chua dc sttore ta se store lai
          if (versionApp.isEmpty) {
            if (IS_PRODUCTION_APP) {
              versionApp = APP_CONFIG.VERSION_ANDROID_PROD;
              await StorageHelper.setString(
                  FirebaseRemoteConfigConstant.ANDROID_PRODUCTION_VERISON,
                  APP_CONFIG.VERSION_ANDROID_PROD);
            } else {
              versionApp = APP_CONFIG.VERSION_ANDROID;
              await StorageHelper.setString(
                  FirebaseRemoteConfigConstant.ANDROID_UAT_VERISON,
                  APP_CONFIG.VERSION_ANDROID);
            }
          }
        }
        if (!Utils.isArray(mockLocations) || !compareVersionAndroidApp()) {
          await getMockLocationApps();
        }
        bool hasFakeGpsApp = await checkMockLocationApps();
        if (hasFakeGpsApp) {
          WidgetCommon.generateDialogOKGet(
            title: 'Ứng dụng Fake GPS',
            textBtnClose: 'Đồng ý',
            content:
                'Bạn vui lòng xóa ứng dụng định vị giả mạo để tiếp tục thao tác.',
            callback: () async => await PermissionAppService().callLogOut(),
          );
          return false;
        }
      }
      bg.ProviderChangeEvent providerState =
          await bg.BackgroundGeolocation.providerState;

      if ((providerState.status ==
          bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS)) {
        return true;
      }
      String username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      if (providerState.status ==
              bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE &&
          username.contains('product@athenafs.io')) {
        return true;
      }

      await WidgetCommon.generateDialogOKCancelGet(
          'Bạn không cho phép úng dụng truy cập vị trí của thiết bị ở chế độ luôn luôn! Vui lòng bật để sử dụng tính năng này!',
          callbackOK: () async {
        await Geolocator.openLocationSettings();
      });
      return false;
    } catch (e) {
      await WidgetCommon.generateDialogOKCancelGet(
          'Bạn không cho phép úng dụng truy cập vị trí của thiết bị ở chế độ luôn luôn! Vui lòng bật để sử dụng tính năng này!',
          callbackOK: () async {
        await Geolocator.openLocationSettings();
      });
      debugPrint('Error: $e');
      return false;
    }
  }

  static Future<bool> checkMockLocationApps() async {
    for (final mock in mockLocations) {
      var package = mock.id;
      final Uri intentUri =
          Uri.parse("intent://$package#Intent;scheme=package;end");
      if (await canLaunchUrl(intentUri)) {
        // App tồn tại trên máy
        return true;
      }
    }

    return false;
  }

  static Future<bool> checkPermission() async {
    LocationPermission permissions = await Geolocator.checkPermission();
    if (permissions == LocationPermission.denied ||
        permissions == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  static Future<bool> checkServiceEnabledLocationWithoutContext() async {
    try {
      bg.ProviderChangeEvent providerState =
          await bg.BackgroundGeolocation.providerState;
      if ((providerState.status ==
          bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS)) {
        return true;
      }
      String username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      if (providerState.status ==
              bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE &&
          username.contains('product@athenafs.io')) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  static Future<bool> checkAppInstalled(BuildContext context) async {
    // Implementation removed due to commented code
    return true;
  }

  static Future<bool> detectAppMockLocation(BuildContext context,
      {Function? onDetected}) async {
    // Implementation removed due to commented code
    return true;
  }

  // static bool _hasBacklist(Application app) {
  //   try {
  //     final _blacklist = TrackingInstallingDevice().currentBlacklist;
  //     if (_blacklist.containsKey(app.packageName)) {
  //       if (_blacklist[app.packageName] == true) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  static Future<bool> isDeveloperMode() async {
    if (Platform.isIOS) {
      return false;
    }
    try {
      bool isTurnning =
          await FlutterJailbreakDetectionState.isTurnningOnDeveloperMode;
      BuildContext? context =
          NavigationService.instance.navigationKey.currentContext;

      if (isTurnning && context != null) {
        WidgetCommon.generateDialogOKGet(
            title: 'Thiết bị đang bật chế độ nhà phát triển',
            textBtnClose: 'Đồng ý',
            content: 'Vui lòng tắt tính năng này trên thiết bị.',
            callback: () async {
              Navigator.of(context).pop();
            });
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  Future<void> callLogOut() async {
    _appState.logOut();
    await Future.delayed(const Duration(seconds: 1));
    Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
  }

  static Future<bool> checkDeviceHasBiometric(BuildContext context) async {
    bool serviceEnabled = await auth.canCheckBiometrics;
    if (serviceEnabled == false) {
      WidgetCommon.generateDialogOKCancelGet(
          'Vui lòng bật chức năng đăng nhập bằng vân tay',
          callbackOK: () async => {});
      return false;
    }
    return true;
  }

  static Future<Position?> getCurrentPositionLogin() async {
    try {
      bool permission = await checkPermission();
      if (!permission) {
        await WidgetCommon.generateDialogOKCancelGet(
            'Bạn không cho phép úng dụng truy cập vị trí của thiết bị ở chế độ luôn luôn! Vui lòng bật để sử dụng tính năng này!',
            callbackOK: () async {
          await Geolocator.openLocationSettings();
        });
        return null;
      }
      Position? position;
      if (Platform.isIOS) {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: Duration(
              seconds: APP_CONFIG.FETCH_POSITION_TIME_OUT,
            ));
      } else {
        bool isLocationManager = await StorageHelper.getBool(
                AppStateConfigConstant.LOCATION_MANAGER) ??
            false;

        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            forceAndroidLocationManager: isLocationManager,
            timeLimit: Duration(
              seconds: APP_CONFIG.FETCH_POSITION_TIME_OUT,
            ));
      }
      lastPosition = position;
      return position;
    } catch (exception) {
      debugPrint('Error: $exception');
      return null;
    }
  }

  static Future<bool> checkServiceLoginBiometric(BuildContext context) async {
    try {
      bool serviceEnabled = await checkDeviceHasBiometric(context);
      if (!serviceEnabled) {
        return false;
      }

      return await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true,
          biometricOnly: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
              cancelButton: 'cancel',
              goToSettingsButton: 'settings',
              goToSettingsDescription: 'Please set up your Touch ID.',
              signInTitle: 'Scan your fingerprint to authenticate')
        ],
      );
    } on PlatformException catch (e) {
      debugPrint('PlatformException: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  static Future<PermissionStatus> initPermissionSpeech() async {
    try {
      // Use microphone permission instead of speech since speech might not be available
      return await Permission.microphone.request();
    } catch (e) {
      debugPrint('Error requesting microphone permission: $e');
      return PermissionStatus.denied;
    }
  }

  static Future<void> stopSpeech() async {
    // Implementation removed due to commented code
  }

  static Future<bool?> checkSpeech(
      Function callbackOK, Function callBackError) async {
    // Implementation removed due to commented code
    return null;
  }

  static bool compareVersionAndroidApp() {
    if (IS_PRODUCTION_APP) {
      if (versionApp != APP_CONFIG.VERSION_ANDROID_PROD) {
        return false;
      }
    } else {
      if (versionApp != APP_CONFIG.VERSION_ANDROID) {
        return false;
      }
    }
    return true;
  }

  static getMockLocationApps() async {
    // Implementation removed due to commented code
  }

  static Future<Position?> getCurrentPosition() async {
    try {
      Position position;
      if (Platform.isIOS) {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: Duration(
              seconds: APP_CONFIG.FETCH_POSITION_TIME_OUT,
            ));
      } else {
        bool isLocationManager = await StorageHelper.getBool(
                AppStateConfigConstant.LOCATION_MANAGER) ??
            false;

        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: isLocationManager,
            timeLimit: Duration(
              seconds: APP_CONFIG.FETCH_POSITION_TIME_OUT,
            ));
      }
      lastPosition = position;
      return position;
    } catch (exception) {
      debugPrint('Error in getCurrentPosition: $exception');
      try {
        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: Duration(
              milliseconds: APP_CONFIG.QUERY_TIME_OUT,
            ));
        lastPosition = position;
        return position;
      } catch (e) {
        debugPrint('Second error in getCurrentPosition: $e');
        return null;
      }
    }
  }

  static Future<Position?> getLastKnowPosition() async {
    try {
      if (_homeProvider.appDataConfig != null) {
        Position? position;
        if (Platform.isIOS) {
          if (_homeProvider.appDataConfig['useLastKnowPositionIOS'] == true) {
            position = await Geolocator.getLastKnownPosition();
          }
        } else {
          if (_homeProvider.appDataConfig['useLastKnowPositionAndroid'] ==
              true) {
            bool isLocationManager = await StorageHelper.getBool(
                    AppStateConfigConstant.LOCATION_MANAGER) ??
                false;

            position = await Geolocator.getLastKnownPosition(
                forceAndroidLocationManager: isLocationManager);
          }
        }

        if (position != null) {
          lastPosition = position;
          return position;
        }
      }
      return await getCurrentPosition();
    } catch (exception) {
      debugPrint('Error in getLastKnowPosition: $exception');
      try {
        final position = await Geolocator.getLastKnownPosition();
        if (position != null) {
          lastPosition = position;
        }
        return position;
      } catch (e) {
        debugPrint('Second error in getLastKnowPosition: $e');
        return null;
      }
    }
  }

  static List<String> androidManufacturer = [
    "OPPO",
    "Xiaomi",
    "Realme",
    "Huawei",
    "Vivo",
    "Meizu",
    "Honor",
    "OnePlus",
    "LeNovo",
    "Gionee"
  ];

  static List<MockLocationAppModel> mockLocations = [
    // Omitting the long list of MockLocationAppModel instances for brevity
    MockLocationAppModel(id: "com.blogspot.newapphorizons.fakegps"),
    // ... other entries
  ];

  static Future<PermissionHandler.PermissionStatus>
      initPermissionStorage() async {
    return await PermissionHandler.Permission.storage.request();
  }

  static final PermissionAppService _permissionAppService =
      PermissionAppService._internal();

  factory PermissionAppService() {
    return _permissionAppService;
  }

  PermissionAppService._internal();
}
