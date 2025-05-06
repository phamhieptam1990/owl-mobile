import 'package:get/get.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/notifications/notification.model.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/utils.dart';
import 'notification.provider.dart';
import 'notification.service.dart';
import 'package:dio/dio.dart' as DIO;

class NotificationController extends GetxController {
  final notificationService = new NotificationService();
  final notificationProvider = getIt<NotificationProvider>();
  final userInfoStore = getIt<UserInfoStore>();
  bool enablePullUp = true;

  @override
  void onReady() {
    super.onReady();
    notificationProvider.clearData();
  }

  Future<void> handleFirstLayout() async {
    try {} catch (e) {
    } finally {
      updateScreen();
    }
  }

  Future<void> handleRequestData({bool isUnread = false}) async {
    try {
      final DIO.Response response = await notificationService.getPagingList(
          notificationProvider.currentPage, notificationProvider.keyword,
          isUnread: isUnread);
      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData2Level(response);
        if (lstData.length < APP_CONFIG.LIMIT_QUERY) {
          enablePullUp = false;
        } else {
          enablePullUp = true;
          notificationProvider.currentPage =
              notificationProvider.currentPage + 1;
        }
        if (lstData != null) {
          for (var data in lstData) {
            notificationProvider.getLstNoticationModel
                .add(NotificationModel.fromJson(data));
          }
        }
      }
    } catch (e) {
    } finally {
      if (notificationProvider.isFirstEnter == true) {
        notificationProvider.isFirstEnter = false;
      }
      updateScreen();
    }
  }

  void updateScreen() {
    update([
      'NotificationScreen',
    ]);
  }

  void updateNotificationItem() {
    update([
      'NotiticationItem',
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    notificationProvider.clearData();
  }
}

class NotificationDetailController extends GetxController {
   NotificationModel? detail;
   NotificationModel? parent;
  final notificationService = new NotificationService();
  bool isHTMLContent = false;
  @override
  void onReady() {
    super.onReady();
    this.handleFirstLayout();
  }

  Future<void> handleFirstLayout() async {
    try {
      final res = await notificationService.getDetailNotification(parent?.aggId ?? '');
      if (Utils.checkIsNotNull(res)) {
        final data = Utils.handleRequestData(res);
        if (Utils.checkIsNotNull(data)) {
          detail = NotificationModel.fromJson(data);
          if (detail?.title == detail?.content) {
            detail?.content = "";
          } else if (Utils.checkValueIsHTMLContent(detail?.content)) {
            isHTMLContent = true;
          }
        }
      } else {
        detail = parent;
        detail?.content = "";
      }
    } catch (e) {
      print(e);
    } finally {
      update([
        'NotificationDetailScreen',
      ]);
    }

   
  }
   @override
    void onClose() {
      super.onClose();
      isHTMLContent = false;
    }
}
