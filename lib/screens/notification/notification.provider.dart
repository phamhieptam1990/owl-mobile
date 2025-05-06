import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:athena/models/notifications/notification.model.dart' as model;
import 'package:athena/screens/notification/notification.service.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/models/events.dart';

import '../../utils/log/crashlystic_services.dart';

class NotificationProvider with ChangeNotifier {
  NotificationService _notificationService = new NotificationService();
  // FirebaseCrashlyticsService _firebaseCrashlyticsService =
  //     new FirebaseCrashlyticsService();
  List<model.NotificationModel> lstNoticationModel = [];
  List<model.NotificationModel> get getLstNoticationModel => lstNoticationModel;

    // Fix the setter to handle the proper type
  set setLstNoticationModel(List<dynamic> list) {
    // Convert dynamic list to NotificationModel list
    lstNoticationModel = List<model.NotificationModel>.from(
      list.map((item) => item is model.NotificationModel 
        ? item 
        : model.NotificationModel.fromJson(item)
      )
    );
    notifyListeners();
  }

  int countNotificationUnread = 0;
  int get getCountNotificationUnread => countNotificationUnread;

  int currentPage = 1;
  String keyword = '';
  bool isFirstEnter = true;
  setCountNotificationUnread(int countNotificationUnread) {
    this.countNotificationUnread = countNotificationUnread;
    notifyListeners();
  }

  void clearData() {
    this.currentPage = 1;
    this.keyword = '';
    this.lstNoticationModel = [];
    this.countNotificationUnread = 0;
    this.isFirstEnter = true;
  }

  Future<void> getCountNotification() async {
    try {
      if (MyConnectivity.instance.isOffline) {
        return null;
      }
      // final Response response = await _notificationService.getCountUnread();
      // if (Utils.checkRequestIsComplete(response)) {
      //   var numberBadge = response.data['data'];
      //   if (Utils.checkIsNotNull(numberBadge)) {
      //     if (this.countNotificationUnread != response.data['data']) {
      //       this.countNotificationUnread = response.data['data'];
      //       eventBus.fire(ReloadNotification('ReloadNotification'));
      //       FlutterAppBadger.updateBadgeCount(this.countNotificationUnread);
      //     }
      //   }
      // }
      _notificationService.getCountUnread().then((response) {
        if (Utils.checkRequestIsComplete(response)) {
          var numberBadge = response.data['data'];
          if (Utils.checkIsNotNull(numberBadge)) {
            if (this.countNotificationUnread != response.data['data']) {
              this.countNotificationUnread = response.data['data'];
              eventBus.fire(ReloadNotification('ReloadNotification'));
              // AwesomeNotifications().setGlobalBadgeCounter(this.countNotificationUnread);
              FlutterAppBadge.count(this.countNotificationUnread);
            }
          }
        }
      });
    } on PlatformException catch (e) {
      CrashlysticServices.instance.log('${e.message} , ${e.stacktrace}');
    }
  }
}
