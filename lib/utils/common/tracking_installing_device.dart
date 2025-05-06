import 'dart:io';

import 'package:athena/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:device_apps/device_apps.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:athena/utils/log/crashlystic_services.dart';
import 'package:athena/utils/offline/hive.service.dart';

import '../../common/constants/general.dart';
import '../../models/tracking/app_install.dart/apps_installed.dart';
import '../storage/storage_helper.dart';

class TrackingInstallingDevice {
  FirebaseFirestore? _firestore;

  // TrackingInstallingDevice._(this._firestore);

  // static final TrackingInstallingDevice _instance =
  //     TrackingInstallingDevice._(FirebaseFirestore.instance);

  // static TrackingInstallingDevice get instance => _instance;
  static TrackingInstallingDevice? _instance;

  factory TrackingInstallingDevice() {
    _instance ??= TrackingInstallingDevice._internal();
    return _instance!;
  }

  TrackingInstallingDevice._internal() {
    _firestore = FirebaseFirestore.instance;
  }

  Map<String, dynamic> currentBlacklist = {};

  Future<void> writeAppInstalled({
    String recordType = 'login',
    List<AppsInstalledElement>? apps,
  }) async {
    // //write with only Android
    // if (!Platform.isAndroid) return;

    // //get current time
    // DateTime _currentDate = DateTime.now();
    // String _dateString = DateFormat('dd/MM/yyyy HH:mm').format(_currentDate);

    // //getUserName
    // String userName =
    //     await StorageHelper.getString(AppStateConfigConstant.USER_NAME);

    // //validate userName
    // if (userName?.isEmpty ?? false) return;

    // // init AppsInstalled
    // AppsInstalled appsInstalled = AppsInstalled(
    //     excuteTinme: _dateString,
    //     recordType: recordType,
    //     appsInstalled: await _getAppsInstalled());

    // //compare cache and current apps installed
    // if (await _enableToWrite(appsInstalled)) {
    //   //write
    //   _firestoreWrite(appsInstalled, userName);
    // }
    return;
  }

  Stream getBlacklistStream() {
    final _blacklistStream =
        _firestore?.collection('app').doc('blacklist').snapshots();

    return _blacklistStream!;
  }

  void _firestoreWrite(AppsInstalled appsInstalled, String userName,
      {String collection = 'app_installed'}) {
    _firestore!
        .collection(collection)
        .doc(userName)
        .set(appsInstalled.toJson())
        .then((value) => {_saveAppsInstalled(appsInstalled)})
        .catchError((e) => {CrashlysticServices.instance.log(e?.toString() ?? 'Unknow Error')});
  }

  // Future<List<AppsInstalledElement>> _getAppsInstalled() async {
  //   List<AppsInstalledElement> appsInstalled = [];

  //   try {
  //     List<Application> apps = await DeviceApps.getInstalledApplications();
  //     appsInstalled = apps
  //         .map((e) => AppsInstalledElement(
  //             appName: e.appName ?? 'unknows',
  //             packageName: e.packageName ?? 'unknows',
  //             versionName: e.versionName ?? 'unknows',
  //             installTimeMillis: e.installTimeMillis ?? 0))
  //         .toList();

  //     return appsInstalled;
  //   } catch (_) {
  //     return [];
  //   }
  // }

  Future<bool> _enableToWrite(AppsInstalled appsInstalledDevices) async {
    try {
      final box = await HiveDBService.openAppInstall();
      final AppsInstalled? appsInstalledBoxValue =
          box.get(HiveDBConstant.APPS_INSTALLED_KEY);
          
      // If we have no saved data, allow write
      if (appsInstalledBoxValue == null) return true;
      
      // If app counts differ, allow write
      if (appsInstalledDevices.appsInstalled?.length !=
              appsInstalledBoxValue.appsInstalled?.length) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error checking if write is enabled: $e');
      return false;
    }
  }

  Future<void> _saveAppsInstalled(AppsInstalled value) async {
    final _appsInstallBox = await HiveDBService.openAppInstall();
    await _appsInstallBox.put(HiveDBConstant.APPS_INSTALLED_KEY, value);
  }

  void blacklistListen() {
    try {
      if (!Platform.isAndroid) return;
      
      _firestore?.collection('app').doc('checkBlackList').snapshots().listen(
        (checkBlackList) {
          final data = checkBlackList.data();
          if (data != null && data['isCheck'] == true) {
            _firestore?.collection('app').doc('blacklist').snapshots().listen(
              (event) {
                final eventData = event.data();
                if (eventData != null) {
                  currentBlacklist = eventData;
                }
              },
              onError: (e) => debugPrint('Error listening to blacklist: $e'),
            );
          }
        },
        onError: (e) => debugPrint('Error listening to checkBlackList: $e'),
      );
    } catch (e) {
      debugPrint('Error setting up blacklist listener: $e');
    }
  
  }

  Future<void> writeErrorsPagingList(Response? response) async {
    try {
      // Get current time
      final DateTime currentDate = DateTime.now();
      final String dateString = DateFormat('dd-MM-yyyy HH:mm:ss').format(currentDate);

      // Get username
      final String? userName =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME)??'';
      final String safeUsername = userName ?? 'unknown';

      await _firestore!
          .collection('app')
          .doc('errors')
          .collection(safeUsername)
          .doc(dateString)
          .set({
            'excuteTimne': currentDate,
            'username': safeUsername,
            'path': response?.requestOptions.path,
            'params': response?.requestOptions.data ?? 'unknown',
            'statusCode': response?.statusCode,
            'statusMessage': response?.statusMessage,
            'error-data': response?.data
          })
          .then((value) => {})
          .catchError((e) => CrashlysticServices.instance.log(e?.toString() ?? "Unknown error"));
    } catch (e) {
      debugPrint('Error writing errors paging list: $e');
    }
  }
}
