import 'dart:async';

import '../../common/config/app_config.dart';
import '../../common/constants/routes.dart';
import '../../widgets/common/common.dart';
import '../utils.dart';

class IdieActivity {
  // Private constructor for singleton pattern
  IdieActivity._internal();
  static final IdieActivity _instance = IdieActivity._internal();
  static IdieActivity get instance => _instance;

  // Mark as late or nullable with initialization
  LogoutTimerModel? timerModel; 
  Timer? logoutTimer;
  bool isLogout = false;
  bool isFirstTime = true;
  bool isLoginPage = false;

  // void initIdieActivity() {
  //   timerModel = LogoutTimerModel();
  //   timerModel?.updateTimestamp(DateTime.now());
    
  //   logoutTimer = Timer.periodic(Duration(minutes: 1), (time) {
  //     final currentTime = DateTime.now();
      
  //     // Check if timeout has been reached
  //   if (timerModel != null &&
  //         timerModel?.timestamp != null &&
  //         currentTime.difference(timerModel!.timestamp).inMinutes >=
  //             APP_CONFIG.TIME_OUT_MINUTES_APP) {
        
  //       timerModel?.updateTimestamp(DateTime.now());
  //       if (isLogout == false) {
  //         isLogout = true;
  //         isFirstTime = false;
          
  //         WidgetCommon.generateDialogOKGet(
  //           content: 'Phiên đăng nhập đã hết hạn',
  //           callback: () {
  //             Utils.offAllNamePage(RouteList.LOGIN_IDILE_SCREEN);
  //           }
  //         );
  //       }
  //     }
  //   });
  // }
  void initIdieActivity() {
    timerModel = LogoutTimerModel();
    timerModel?.updateTimestamp(DateTime.now());

    logoutTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      final currentTime = DateTime.now();

      if (timerModel != null &&
          timerModel?.timestamp != null &&
          currentTime.difference(timerModel!.timestamp).inMinutes >=
              APP_CONFIG.TIME_OUT_MINUTES_APP) {
        // Đảm bảo chỉ logout 1 lần
        if (!isLogout) {
          isLogout = true;
          isFirstTime = false;

          WidgetCommon.generateDialogOKGet(
            content: 'Phiên đăng nhập đã hết hạn',
            callback: () {
              Utils.offAllNamePage(RouteList.LOGIN_IDILE_SCREEN);
            },
          );
        }

        // Cập nhật lại timestamp để tránh gọi lại liên tục sau đó
        timerModel?.updateTimestamp(DateTime.now());
      }
    });
  }

  bool checkTimer() {
    return logoutTimer?.isActive ?? false;
  }
  
  void stopCheckIdieActivity() {
    logoutTimer?.cancel();
    logoutTimer = null;
  }
  
  void setTimerModel() {
    timerModel?.updateTimestamp(DateTime.now());
  }
}

class LogoutTimerModel {
  // Initialize timestamp with current time
  DateTime timestamp = DateTime.now();

  void updateTimestamp(DateTime newTimestamp) {
    timestamp = newTimestamp;
  }
}