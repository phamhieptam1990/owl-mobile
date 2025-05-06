import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:athena/utils/common/internet_connectivity.dart';

class FirebaseCrashlyticsService {
  // Make instance static late final for null safety
  static  FirebaseCrashlytics? instance;
  
  /// Initialize the Firebase Crashlytics service
  static void initCrashService() {
    try {
      instance = FirebaseCrashlytics.instance;
    } catch (e) {
      debugPrint('Error initializing Firebase Crashlytics: $e');
    }
  }

  /// Send a log message to Firebase Crashlytics
  static void sendLog(String log) {
    if (MyConnectivity.instance.isOffline) {
      return;
    }
    
    try {
      initCrashService();
      instance?.log(log);
    } catch (e) {
      debugPrint('Error sending log to Crashlytics: $e');
    }
  }

  /// Record an error with stack trace to Firebase Crashlytics
  void sendRecordError(dynamic error, StackTrace? stackTrace) {
    if (MyConnectivity.instance.isOffline) {
      return;
    }
    
    try {
      initCrashService();
      instance?.recordError(
        error, 
        stackTrace ?? StackTrace.current,
        reason: 'Caught application error'
      );
    } catch (e) {
      debugPrint('Error recording error to Crashlytics: $e');
    }
  }

  /// Set custom user identifier for crash reports
  static Future<void> setUserIdentifier(String userId) async {
    if (MyConnectivity.instance.isOffline) {
      return;
    }
    
    try {
      initCrashService();
      await instance?.setUserIdentifier(userId);
    } catch (e) {
      debugPrint('Error setting user identifier: $e');
    }
  }

  /// Singleton implementation
  static final FirebaseCrashlyticsService _firebaseCrashlyticsService =
      FirebaseCrashlyticsService._internal();

  factory FirebaseCrashlyticsService() {
    return _firebaseCrashlyticsService;
  }

  FirebaseCrashlyticsService._internal();
}