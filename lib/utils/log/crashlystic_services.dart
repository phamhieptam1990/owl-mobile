import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../common/constants/general.dart';
import '../storage/storage_helper.dart';

class CrashlysticServices {
  final FirebaseCrashlytics _servicesInstance;

  CrashlysticServices._(this._servicesInstance);

  static final CrashlysticServices _instance =
      CrashlysticServices._(FirebaseCrashlytics.instance);

  static CrashlysticServices get instance => _instance;

  Future<void> initializeFlutterFire() async {
    _servicesInstance.sendUnsentReports();
    String userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    _servicesInstance.setUserIdentifier(userName ?? 'unknow_user');
    await _servicesInstance.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  Future<void> recordError(
    Object errs,
    StackTrace stackTrace, {
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    String userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    _servicesInstance.setUserIdentifier(userName ?? 'unknow_user');
    _servicesInstance.recordError(errs, stackTrace,
        reason: reason,
        information: information,
        printDetails: printDetails,
        fatal: fatal);
  }

  void setCustomKey(String key, Object value) {
    _servicesInstance.setCustomKey(key, value);
  }

  Future<void> log(String msg) async {
    String userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    _servicesInstance.setUserIdentifier(userName ?? 'unknow_user');
    _servicesInstance.log(msg);
  }

  void crashes() {
    _servicesInstance.crash();
  }
}
