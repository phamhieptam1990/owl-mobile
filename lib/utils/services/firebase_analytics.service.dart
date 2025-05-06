import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:athena/common/constants/general.dart';
import 'dart:io';

import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsService {
  static final appState = new AppState();
  static  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static initFirebaseAnalytics() {
    if (Utils.checkIsNotNull(analytics)) {
      return;
    }
    analytics = FirebaseAnalytics.instance;
  }

  static sendAnalyticsEvent(
      {required String name,
      Map<String, dynamic>? parameters,
      AnalyticsCallOptions? callOptions}) async {
    if (MyConnectivity.instance.isOffline) {
      return;
    }
    if (!Utils.checkIsNotNull(AppState.firebaseApp)) {
      return;
    }
    initFirebaseAnalytics();
    try {
      await analytics.logEvent(
          name: name, parameters: parameters, callOptions: callOptions);
    } catch (e) {}
  }

  static logcheckin() async {
    if (MyConnectivity.instance.isOffline) {
      return;
    }
    if (!Utils.checkIsNotNull(AppState.firebaseApp)) {
      return;
    }
    initFirebaseAnalytics();
    await FirebaseAnalytics.instance.logBeginCheckout(
        value: 10.0,
        currency: 'USD',
        items: [
          AnalyticsEventItem(
              itemName: 'Socks', itemId: 'xjw73ndnw', price: 10.0),
        ],
        coupon: '10PERCENTOFF');
  }

  static sendAnalyticsScreenView(
      {String? screenClass,
      String? screenName,
      AnalyticsCallOptions? callOptions}) async {
    try {
      if (MyConnectivity.instance.isOffline) {
        return;
      }
      if (!Utils.checkIsNotNull(AppState.firebaseApp)) {
        return;
      }
      initFirebaseAnalytics();
      await analytics.logScreenView(
          screenClass: screenClass,
          screenName: screenName,
          callOptions: callOptions);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> sendAnalyticsSetCurrentScreen({
    String? screenName,
    String screenClassOverride = 'Flutter',
    AnalyticsCallOptions? callOptions,
  }) async {
    try {
      if (MyConnectivity.instance.isOffline || AppState.firebaseApp == null) {
        return;
      }

      initFirebaseAnalytics();
      await analytics.setCurrentScreen(
          screenName: screenName,
          screenClassOverride: screenClassOverride,
          callOptions: callOptions);
    } catch (e) {
      debugPrint('Error setting current screen: $e');
    }
  }

  static Future<void> sendAnalyticsEventPushPage(
      String page, dynamic params) async {
    final userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    final platform = Platform.isAndroid ? 'ANDROID' : 'IOS';

    await sendAnalyticsEvent(name: 'pushPage', parameters: <String, dynamic>{
      'eventName': 'pushPage',
      'getCurrentRoute': Utils.getCurrentRoute(),
      'getScreen': Utils.getScreen(),
      'userName': userName,
      'platform': platform,
      'versionApp': Utils.showVersionApp(),
      'pageNext': page
    });

    await sendAnalyticsScreenView(
        screenClass: Utils.getCurrentRoute(), screenName: Utils.getScreen());
  }

  static Future<void> onResponseSendAnalytics(String path) async {
    try {
      final userName =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      final platform = Platform.isAndroid ? 'ANDROID' : 'IOS';
      final url = path.split('?').first;

      await sendAnalyticsEvent(
          name: 'onResponseSendAnalytics',
          parameters: <String, Object>{
            'eventName': 'onResponse',
            'getCurrentRoute': Utils.getCurrentRoute(),
            'getScreen': Utils.getScreen(),
            'userName': userName,
            'platform': platform,
            'versionApp': Utils.showVersionApp(),
            'response': url,
          });
    } catch (e) {
      debugPrint('Error sending response analytics: $e');
    }
  }

  static Future<void> onErrorSendAnalytics(String path, dynamic code) async {
    try {
      final userName =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      final platform = Platform.isAndroid ? 'ANDROID' : 'IOS';
      final url = path.split('?').first;

      await sendAnalyticsEvent(
          name: 'onErrorSendAnalytics',
          parameters: <String, dynamic>{
            'eventName': 'onError',
            'getCurrentRoute': Utils.getCurrentRoute(),
            'getScreen': Utils.getScreen(),
            'userName': userName,
            'platform': platform,
            'versionApp': Utils.showVersionApp(),
            'url': url,
            'errorCode': code?.toString() ?? ''
          });
    } catch (e) {
      debugPrint('Error sending error analytics: $e');
    }
  }
}
