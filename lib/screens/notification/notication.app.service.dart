import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';

import '../../utils/navigation/navigation.service.dart';

class NotificationApp {
  void goDetail(context, aggId) async {
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => {}),
    // );
  }

  Future<Response> postServer(String username, String typeOs,
      String registrationId, String uuid, String appCode, String companyCode) {
    // var dataJson = 'cmd=' +
    //     Uri.encodeComponent('{"username":"' +
    //         username +
    //         '",  "typeOs":"' +
    //         typeOs +
    //         '",  "registrationId":"' +
    //         registrationId +
    //         '",  "uuid":"' +
    //         uuid +
    //         '",  "appCode":"' +
    //         appCode +
    //         '",  "companyCode":"' +
    //         companyCode +
    //         '"}');
    var dataJson = {
      "username": username,
      "typeOs": typeOs,
      "registrationId": registrationId,
      "uuid": uuid,
      "appCode": appCode,
      "companyCode": companyCode
    };
    return HttpHelper.postJSON(NOTIFICATION_SERVICE_URL.SAVE_UPDATE_DEVICE,
        body: dataJson);
  }

  requestNotification(context) async {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        final notification = message.notification;
        final data = message.data;
        if (data.containsKey('forceUpdate')) {
          var forceUpdate = data['forceUpdate'];
          if (forceUpdate == "true") {
            var version;
            var forceLogout = data['forceLogout'];
            if (Platform.isAndroid) {
              version = data['versionAndroid'];
              checkVersionAndroid(version, forceLogout, context);
            } else {
              version = data['versionIOS'];
              checkVersionIOS(version, forceLogout, context, notification);
            }
            return;
          }
        }

        if (data.containsKey('aggId')) {
          WidgetCommon.generateDialogOKCancelGet(S.of(context).Notification_msg,
              callbackOK: () {
            final aggId = data['aggId'];
            this.goDetail(context, aggId);
          }, callbackCancel: () {});
        } else {
          if (data.containsKey('sender') && data.containsKey('channel')) {
            return;
          }
          if (notification != null && Utils.checkIsNotNull(notification)) {
            if (notification.title != null) {
              WidgetCommon.generateDialogNotification(context,
                  title: notification?.title ?? '',
                  textBtnClose: S.of(context).close,
                  content: notification?.body ?? '');
            }
          }
        }
      });
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        final notification = message.notification;
        final data = message.data;
        if (data.containsKey('forceUpdate')) {
          var forceUpdate = data['forceUpdate'];
          if (forceUpdate == "true") {
            var version;
            var forceLogout = data['forceLogout'];
            if (Platform.isAndroid) {
              version = data['versionAndroid'];
              checkVersionAndroid(version, forceLogout, context);
            } else {
              version = data['versionIOS'];
              checkVersionIOS(version, forceLogout, context, notification);
            }
            return;
          }
        }

        if (data.containsKey('aggId')) {
          WidgetCommon.generateDialogOKCancelGet(S.of(context).Notification_msg,
              callbackOK: () {
            final aggId = data['aggId'];
            this.goDetail(context, aggId);
          }, callbackCancel: () {});
        } else {
          if (notification != null && Utils.checkIsNotNull(notification)) {
            if (notification.title != null) {
              WidgetCommon.generateDialogNotification(context,
                  title: notification?.title ?? '',
                  textBtnClose: S.of(context).close,
                  content: notification?.body ?? '');
            }
          }
        }
      });

      // disable init background current here
      // FirebaseMessaging.onBackgroundMessage((message) async {
      //   await Firebase.initializeApp();

      //   final notification = message.notification;
      //   final data = message.data;
      //   if (data.containsKey('forceUpdate')) {
      //     var forceUpdate = data['forceUpdate'];
      //     if (forceUpdate == "true") {
      //       var version;
      //       var forceLogout = data['forceLogout'];
      //       if (Platform.isAndroid) {
      //         version = data['versionAndroid'];
      //         checkVersionAndroid(version, forceLogout, context);
      //       } else {
      //         version = data['versionIOS'];
      //         checkVersionIOS(version, forceLogout, context, notification);
      //       }
      //       return;
      //     }
      //   }

      //   if (data.containsKey('aggId')) {
      //     WidgetCommon.generateDialogOKCancel(context,
      //         content: S.of(context).Notification_msg, callbackOK: () {
      //       final aggId = data['aggId'];
      //       this.goDetail(context, aggId);
      //     }, callbackCancel: () {});
      //   } else {
      //     if (Utils.checkIsNotNull(notification)) {
      //       if (notification.title != null) {
      //         WidgetCommon.generateDialogNotification(context,
      //             title: notification.title,
      //             textBtnClose: S.of(context).close,
      //             content: notification.body);
      //       }
      //     }
      //   }
      // });
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          sound: true, badge: true, alert: true);
      FirebaseMessaging.instance.getToken().then((String? token) {
        if (token != null && token.isNotEmpty) {
          StorageHelper.getString(AppStateConfigConstant.TOKEN_FIREBASE)
              .then((usbToken) {
            if (usbToken == token) {
              return;
            }
            String type = 'android';
            if (Platform.isIOS) {
              type = 'ios';
            }
            postKeyToServer(type, token);
          });
        }
      });
      FirebaseMessaging.instance
          .subscribeToTopic(NotificationConstant.FE_ICOLLECT_TOPIC);
    } catch (e) {}
  }
bool _isRequestingPermission = false;

  Future<void> initFirebase(BuildContext context) async {
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;

    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        requestNotification(context);
      }
    } catch (e) {
      print("❌ Request permission error: $e");
    } finally {
      _isRequestingPermission = false;
    }
  }

  // initFirebase(BuildContext context) {
  //   FirebaseMessaging.instance.requestPermission().then((value) {
  //     requestNotification(context);
  //       });
  // }

  postkey(username, typeOS, token, id, appCode, companyCode) async {
    final Response reponse = await this
        .postServer(username, typeOS, token, id, appCode, companyCode);
    if (reponse.data != null && reponse.data['status'] == 0) {
      StorageHelper.setString(AppStateConfigConstant.TOKEN_FIREBASE, token);
    }
  }

  Future<void> postKeyToServer(String typeOS, String token) async {
    try {
      final companyCode =
          await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE) ??
              '';
      final username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME)??'';

      if (username == null) {
        debugPrint("Username is null, aborting postKey");
        return;
      }

      final deviceInfo = DeviceInfoPlugin();
      final appCode = APP_CONFIG.APP_CODE;
      String? deviceId;

      if (typeOS == 'ios') {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.serialNumber; // ⚠️ Tránh dùng serialNumber
      }

      if (deviceId == null || deviceId.isEmpty) {
        debugPrint("Device ID is null or empty");
        return;
      }

      postkey(username, typeOS, token, deviceId, appCode, companyCode);
    } catch (e) {
      debugPrint("postKeyToServer error: $e");
    }
  }


  checkVersionAndroid(version, forceLogout, BuildContext context) async {
    if (IS_PRODUCTION_APP) {
      if (version != APP_CONFIG.VERSION_ANDROID_PROD) {
        if (forceLogout == "true") {
          await forceLogoutApp(context);
        }
        WidgetCommon.generateDialogOKGet(
            title: 'Ứng dụng đã có phiên bản mới',
            textBtnClose: S.of(context).btOk,
            callback: () {
              if (Platform.isAndroid) {
                WidgetCommon.openPage(Utils.getLinkDownLoadAppAndroid(), null);
              }
            },
            content: 'Phiên bản ' + version);
      }
      return;
    }
    if (version != APP_CONFIG.VERSION_ANDROID) {
      if (forceLogout == "true") {
        await forceLogoutApp(context);
      }
      WidgetCommon.generateDialogOKGet(
          title: 'Ứng dụng đã có phiên bản mới',
          textBtnClose: S.of(context).btOk,
          callback: () {
            if (Platform.isAndroid) {
              WidgetCommon.openPage(Utils.getLinkDownLoadAppAndroid(), null);
            }
          },
          content: 'Phiên bản ' + version);
    }
  }

  checkVersionIOS(
      version, forceLogout, BuildContext context, notification) async {
    if (Utils.checkIsNotNull(version)) {
      if (IS_PRODUCTION_APP) {
        if (version != APP_CONFIG.VERSION_IOS_PROD) {
          if (forceLogout == "true") {
            await forceLogoutApp(context);
          }
          WidgetCommon.generateDialogOKGet(
              title: notification['title'],
              textBtnClose: S.of(context).btOk,
              callback: () {
                if (Platform.isAndroid) {
                  WidgetCommon.openPage(Utils.getLinkDownLoadAppIOS(), null);
                }
              },
              content: notification['body']);
        }
      }
    } else {
      if (version != APP_CONFIG.VERSION_IOS) {
        if (forceLogout == "true") {
          await forceLogoutApp(context);
        }
        WidgetCommon.generateDialogOKGet(
            title: notification['title'],
            textBtnClose: S.of(context).btOk,
            callback: () {
              if (Platform.isAndroid) {
                WidgetCommon.openPage(Utils.getLinkDownLoadAppIOS(), null);
              }
            },
            content: notification['body']);
      }
    }
  }

  Future<void> forceLogoutApp(BuildContext context) async {
    final userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME)??'';
    final password =
        await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN);
    if (Utils.checkIsNotNull(userName) && Utils.checkIsNull(password)) {
      Utils.pushAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN);
    } else {
      Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
    }
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // await Firebase.initializeApp();
    // AppState.firebaseApp = await Firebase.initializeApp();
    Future.delayed(Duration(seconds: 10), () async {
      BuildContext? context =
          NavigationService.instance.navigationKey.currentContext;
      if(context == null) {
        return;
      }
      final notification = message.notification;
      final data = message.data;
      if (data.containsKey('forceUpdate')) {
        var forceUpdate = data['forceUpdate'];
        if (forceUpdate == "true") {
          var version;
          var forceLogout = data['forceLogout'];
          if (Platform.isAndroid) {
            version = data['versionAndroid'];
            checkVersionAndroid(version, forceLogout, context);
          } else {
            version = data['versionIOS'];
            checkVersionIOS(version, forceLogout, context, notification);
          }
          return;
        }
      }

      if (data.containsKey('aggId')) {
        WidgetCommon.generateDialogOKCancelGet(S.of(context).Notification_msg,
            callbackOK: () {
          final aggId = data['aggId'];
          this.goDetail(context, aggId);
        }, callbackCancel: () {});
      } else {
        if (notification != null && Utils.checkIsNotNull(notification)) {
          if (notification.title! != null) {
            WidgetCommon.generateDialogNotification(context,
                title: notification.title ?? '',
                textBtnClose: S.of(context).close,
                content: notification.body ?? '');
          }
        }
      }
    });
  }
}
