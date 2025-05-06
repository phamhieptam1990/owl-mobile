
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:athena/widgets/common/common.dart';
import '../../common/config/app_config.dart';
import '../../common/constants/general.dart';
import '../../generated/l10n.dart';
import '../../models/firebase_store.dart';
import '../log/crashlystic_services.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import '../storage/storage_helper.dart';
import '../utils.dart';

class InAppUpdateServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  InAppUpdateServices._();

  static Future<AppUpdateInfo> checkForUpdate() async {
    try {
      return await InAppUpdate.checkForUpdate();
    } catch (e) {
      CrashlysticServices.instance.log(e.toString());

      rethrow;
    }
  }

  static Future<void> performImmediateUpdate() async {
    try {
      final _appUpdateInfo = await checkForUpdate();
      if (_appUpdateInfo.updateAvailability ==
              UpdateAvailability.updateAvailable) {
        WidgetCommon.generateDialogOKCancelGet(
            'Đã có phiên bản mới trên CH Play bạn có muốn cập nhật không ?',
            textBtnOK: 'Cập nhật ngay',
            textBtnClose: 'Để sau', callbackOK: () {
          InAppUpdate.performImmediateUpdate();
        });
      }
    } catch (e) {
      CrashlysticServices.instance.log(e.toString());
      rethrow;
    }
  }

  static getIsCheckVersion() async {
    bool value =
        await StorageHelper.getBool(AppStateConfigConstant.CHECK_VERSION) ?? false;
    return value ?? false;
  }

  static void linkAndroid() async {
    CollectionReference configAppTemp =
        FirebaseFirestore.instance.collection('app');
    final querySnapshot = await configAppTemp.get();
    if (Utils.checkIsNotNull(querySnapshot)) {
      for (var doc in querySnapshot.docs) {
        if (doc.id == 'store_version') {
          final data = doc.data();
          if (Utils.checkIsNotNull(data)) {
            final app =
                FirebaseStoreModel.fromJson(data as Map<String, dynamic>);
            var linkAndroid = app.link ?? APP_CONFIG.PRODUCTION_LINK_ANDROID;
            await StorageHelper.setString(
                AppStateConfigConstant.LINK_ANDROID, linkAndroid);
          }
        }
      }
    }
    ;
  }

  static void checkUpdateAndroid(context) async {
    if (IS_PRODUCTION_APP) {
      try {
        CollectionReference configAppTemp =
            FirebaseFirestore.instance.collection('app');
        final querySnapshot = await configAppTemp.get();
        if (Utils.checkIsNotNull(querySnapshot)) {
          for (var doc in querySnapshot.docs) {
            if (doc.id == 'store_version') {
              final data = doc.data();
              if (Utils.checkIsNotNull(data)) {
                final app =
                    FirebaseStoreModel.fromJson(data as Map<String, dynamic>);
                final skipVersion = StorageHelper.getString(
                        AppStateConfigConstant.SKIP_VERSION) ?? '';
                final currentVersion = app.storeversion ?? '';
                String linkAndroid = await StorageHelper.getString(
                        AppStateConfigConstant.LINK_ANDROID) ??
                    APP_CONFIG.PRODUCTION_LINK_ANDROID;
                // final newVersion = NewVersionPlus();
                // final status = await newVersion.getVersionStatus();
                final localVersion = Utils.showVersionApp();
                final localMajorVersion =
                    int.tryParse(localVersion.split(".").first) ?? 0;
                final storeMajorVersion = int.tryParse(currentVersion.split(".").firstOrNull ?? '0') ?? 0;

                if (localMajorVersion < storeMajorVersion) {
                  await WidgetCommon.generateDialogOKGet(
                      title: S.of(context).update_title,
                      textBtnClose: S.of(context).update_button_text,
                      content: S
                          .of(context)
                          .update_content(localVersion, currentVersion),
                      callback: () async {
                        await WidgetCommon.openWebBrowser(linkAndroid);
                      });
                } else if (currentVersion != skipVersion &&
                    localVersion != currentVersion &&
                    localMajorVersion == storeMajorVersion) {
                  await WidgetCommon.generateDialogOKCancelGet(
                    S.of(context).update_content(localVersion, currentVersion),
                    title: S.of(context).update_title,
                    callbackOK: () async {
                      await WidgetCommon.openWebBrowser(linkAndroid);
                    },
                    callbackCancel: () async {
                      await StorageHelper.setString(
                          AppStateConfigConstant.SKIP_VERSION, currentVersion);
                    },
                    textBtnClose: S.of(context).dismiss_button_text,
                    textBtnOK: S.of(context).update_button_text,
                  );
                }
              }
            }
          }
        }
      } catch (e) {}
    }
  }

  static Future<void> checkUpdateISO(BuildContext context) async {
    if (IS_PRODUCTION_APP) {
      try {
        // StorageHelper storageHelper = getIt<StorageHelper>();
        bool isCheckVersion = true;
        String skipVersion = await StorageHelper.getString(
                AppStateConfigConstant.SKIP_VERSION) ??
            "";
        final newVersion = NewVersionPlus();
        final status = await newVersion.getVersionStatus();
        if (status != null && status.localVersion != status.storeVersion) {
          int localMajorVersion =
              int.tryParse(status.localVersion.split(".").first) ?? 0;
          int storeMajorVersion =
              int.tryParse(status.storeVersion.split(".").first) ?? 0;
          if (localMajorVersion < storeMajorVersion) {
            newVersion.showUpdateDialog(
                context: context,
                versionStatus: status,
                dismissButtonText: S.of(context).dismiss_button_text,
                updateButtonText: S.of(context).update_button_text,
                dialogTitle: S.of(context).update_title,
                dialogText: S
                    .of(context)
                    .update_content(status.localVersion, status.storeVersion),
                allowDismissal: false);
          } else if (isCheckVersion &&
              status.storeVersion != skipVersion &&
              localMajorVersion == storeMajorVersion) {
            int localVersion =
                int.tryParse(status.localVersion.replaceAll(".", "0")) ?? 0;
            int storeVersion =
                int.tryParse(status.storeVersion.replaceAll(".", "0")) ?? 0;
            if (localVersion < storeVersion) {
              newVersion.showUpdateDialog(
                  context: context,
                  versionStatus: status,
                  dismissButtonText: S.of(context).dismiss_button_text,
                  updateButtonText: S.of(context).update_button_text,
                  dialogTitle: S.of(context).update_title,
                  dialogText: S
                      .of(context)
                      .update_content(status.localVersion, status.storeVersion),
                  allowDismissal: true,
                  dismissAction: () async {
                    await StorageHelper.setString(
                        AppStateConfigConstant.SKIP_VERSION,
                        status.storeVersion);
                  });
            }
          }
        }
      } catch (e) {}
    }
  }
}
