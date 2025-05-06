import 'dart:async';

import 'package:athena/config/session_timeout/session_config.dart';
import 'package:athena/config/session_timeout/session_timeout_manager.dart';
// import 'package:athena/utils/navigation/navigation.service.dart';

import '../../common/constants/routes.dart';
import '../../utils/app_state.dart';
import '../../utils/common/internet_connectivity.dart';
import '../../utils/utils.dart';

class AppSessionManager {
  static AppSessionManager? _instance;
  static AppSessionManager get instance {
    _instance ??= AppSessionManager._internal();
    return _instance!;
  }
  
  static SessionConfig? sessionConfig;
  
  factory AppSessionManager() {
    _instance ??= AppSessionManager._internal();
    return _instance!;  // Add non-null assertion here
  }

  static StreamController<SessionState>? sessionStateStream;

  AppSessionManager._internal() {
    sessionStateStream = StreamController<SessionState>.broadcast();
    sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 15),
      invalidateSessionForUserInactivity: const Duration(minutes: 15),
    );
  }

  static void onTimeOutListen() {
    // sessionConfig?.dispose();
    sessionConfig?.stream.listen((SessionTimeoutState timeoutEvent) {
      // stop listening
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        // handle user  inactive timeout
        sessionStateStream?.add(SessionState.stopListening);
        _onTimeOut();
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        // handle user  appFocus Timeout
        sessionStateStream?.add(SessionState.stopListening);

        _onTimeOut();
      }
    });
  }

  static void _onTimeOut() {
    if (MyConnectivity.instance.isOffline) {
      return;
    }
    // final context = NavigationService.instance.navigationKey.currentContext;
    AppState().logOut();
    Utils.pushAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN);
  }

  static void startListening() =>
      sessionStateStream?.add(SessionState.startListening);
  static void stopListening() =>
      sessionStateStream?.add(SessionState.stopListening);
}