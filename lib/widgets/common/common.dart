import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:get/get.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/screens/login/login.service.dart';
import 'package:athena/utils/log/firebaseCrash.service.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/utils.dart';

import '../../utils/app_state.dart';
import '../../utils/common/internet_connectivity.dart';
import 'loading-button.widget.dart';

class WidgetCommon {
  static void disposeGlobalFormFieldState(var key) {
    if (key != null) {
      if (key.currentState != null) {
        key.currentState.dispose();
      }
    }
  }

  static void resetGlobalFormFieldState(var key) {
    if (key != null) {
      if (key.currentState != null) {
        key.currentState.reset();
      }
    }
  }

  static generateMessageError(var data,
      {String title = 'Thông báo',
      Function? callback,
      String textBtnClose = 'Đóng',
      bool barrierDismissible = false}) {
    if (Utils.checkIsNotNull(data)) {
      if (Utils.checkIsNotNull(data?.message)) {
        generateDialogOKGet(content: data?.message);
        FirebaseCrashlyticsService.sendLog(data?.message);
        return;
      }
      generateDialogOKGet(content: 'Vui lòng thử lại');
      FirebaseCrashlyticsService.sendLog(data?.message ?? data._message);
    }
    generateDialogOKGet(content: 'Vui lòng thử lại');
  }

  static double widthCreen(context, style, screen, value, valuecurent) {
    if (style == 'height') {
      return MediaQuery.of(context).size.height >= screen ? value : valuecurent;
    } else
      return MediaQuery.of(context).size.width >= screen ? value : valuecurent;
  }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  static generateDialogOK(BuildContext context,
      {String content = '',
      String title = 'Thông báo',
      VoidCallback? callback,
      VoidCallback? callbackConfirm,
      String textBtnClose = 'Đóng',
      String txtBtnConfirm = 'Đồng ý',
      bool barrierDismissible = false,
      bool hasConfirm = false,
      bool canPop = true}) {
    // flutter defined function
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.all(20.0),
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            Visibility(
                visible: hasConfirm,
                child: buttonDialog(
                    // colorBg: Colors.red,
                    colorBg: Colors.white,
                    border: true,
                    color: Colors.black,
                    action: () {
                      Navigator.of(context).pop();
                      callbackConfirm?.call();
                    },
                    title: txtBtnConfirm)),
            buttonDialog(
                colorBg: Colors.red,
                action: () {
                  Navigator.of(context).pop();
                  callback?.call();
                },
                title: textBtnClose),
          ],
        );
      },
    );
  }

  static generateDialogNotification(BuildContext context,
      {String content = '',
      String title = 'Thông báo',
      VoidCallback? callback,
      String textBtnClose = 'Đóng',
      bool barrierDismissible = false,
      bool canPop = true}) {
    // flutter defined function
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          contentPadding: EdgeInsets.all(20.0),
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            buttonDialog(
                colorBg: Colors.red,
                action: () {
                  Navigator.of(context).pop();
                  callback?.call();
                },
                title: textBtnClose),
          ],
        );
      },
    );
  }

  static generateDialogOKGet(
      {String content = '',
      String title = 'Thông báo',
      Function? callback,
      Function? callbackConfirm,
      String textBtnClose = 'Đóng',
      String txtBtnConfirm = 'Đồng ý',
      bool barrierDismissible = false,
      bool hasConfirm = false,
      bool canPop = true}) {
    // flutter defined function
    return Get.defaultDialog(
      title: title,
      barrierDismissible: barrierDismissible,
      content: Text(content),
      actions: [
        hasConfirm
            ? buttonDialog(
                colorBg: Colors.white,
                action: () {
                  Get.back();
                  if (callbackConfirm != null) {
                    callbackConfirm();
                  }
                },
                title: txtBtnConfirm)
            : SizedBox(),
        buttonDialog(
            colorBg: Colors.red,
            action: () {
              Get.back();
              if (callback != null) {
                callback();
              }
            },
            title: textBtnClose),
      ],
    );
  }

  static showSnackbarSuccessGet(String message,
      {Color color = Colors.blue,
      String title = 'Thông báo',
      Color colorText = Colors.white,
      int timeout = 3,
      SnackPosition position = SnackPosition.BOTTOM,
      required VoidCallback callback,
      required Icon icon}) {
    Get.snackbar(message, title,
        colorText: colorText,
        duration: Duration(seconds: timeout),
        snackPosition: position,
        backgroundColor: color,
        mainButton: TextButton(
          onPressed: () {},
          child: icon,
        ), onTap: (abc) {
      callback.call();
    }, margin: EdgeInsets.only(bottom: 10, left: 10, right: 10));
  }

  static void showSnackbar(GlobalKey<ScaffoldState>? key, String msg,
      {Color backgroundColor = Colors.red, int seconds = 5} // Added backgroundColor parameter
      ) {
    if (key?.currentContext != null) {
      ScaffoldMessenger.of(key?.currentContext as BuildContext).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(seconds: seconds),
          backgroundColor: backgroundColor, // Use the backgroundColor
        ),
      );
    }
  }

  static hideSnackbar(GlobalKey<ScaffoldState> scaffoldKey) {
    try {
      final context = scaffoldKey?.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      debugPrint('Error hiding snackbar: $e');
    }
  }

  static showSnackbarAdvance(
    GlobalKey<ScaffoldState> scaffoldKey,
    String text, {
    int secondss = 4,
    Color backgroundColor = Colors.blueAccent,
  }) {
    final snackbar = new SnackBar(
      content: new Text(text),
      duration: Duration(seconds: secondss),
      backgroundColor: backgroundColor,
    );
    try {
      final context = scaffoldKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      debugPrint('Error hiding snackbar: $e');
    }
  }

  static showSnackbarErrorGet(String message,
      {Color color = Colors.red,
      String title = 'Thông báo',
      Color colorText = Colors.white,
      int timeout = 3,
      SnackPosition position = SnackPosition.BOTTOM}) {
    Get.snackbar(title, message,
        colorText: colorText,
        duration: Duration(seconds: timeout),
        snackPosition: position,
        backgroundColor: color,
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        icon: Icon(Icons.warning, color: Colors.white));
  }

  static showSnackbarGetChat(String message, Function(GetSnackBar)? event,
      {Color color = Colors.white,
      String title = 'Thông báo',
      Color colorText = Colors.black,
      int timeout = 5,
      SnackPosition position = SnackPosition.TOP}) {
    Get.snackbar(title, message,
        colorText: colorText,
        duration: Duration(seconds: timeout),
        snackPosition: position,
        backgroundColor: color,
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        icon: Icon(Icons.chat, color: Colors.red),
        onTap: event);
  }

  static showSnackbarOffline(String title,
      {Color color = Colors.red,
      String message = '',
      Color colorText = Colors.white,
      int timeout = 5,
      SnackPosition position = SnackPosition.BOTTOM}) {
    Get.snackbar(title, message,
        colorText: colorText,
        duration: Duration(seconds: timeout),
        snackPosition: position,
        backgroundColor: color,
        icon: Icon(Icons.no_cell, color: Colors.white));
  }

  static showLoading({String status = 'Loading', bool dismissOnTap = true}) {
    EasyLoading.show(status: status, dismissOnTap: dismissOnTap);
  }

  static loadingButton() {
    stateButtonOnlyText = ButtonState.loading;
  }

  static ideButton() {
    stateButtonOnlyText = ButtonState.idle;
  }

  static dismissLoading() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
  }

  static Widget buildCircleLoading(
      {double pWidth = 300.0,
      double heightSB = 50.0,
      double widthSB = 50.0,
      EdgeInsets pdgeInsets = const EdgeInsets.only(top: 30.0)}) {
    return Container(
        width: pWidth,
        margin: pdgeInsets,
        child: Stack(
          children: <Widget>[
            Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                height: heightSB,
                width: widthSB,
              ),
            )
          ],
        ));
  }

  static Future<void> openPage(String url, _scaffoldKey) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (Utils.checkIsNotNull(_scaffoldKey)) {
        showSnackbar(_scaffoldKey, "Không thể mở trang web");
      }
    }
  }

  static Future<void> openWebBrowser(String url) async {
    return await FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: AppColor.primary,
        secondaryToolbarColor: Colors.green,
        navigationBarColor: Colors.white,
        addDefaultShareMenuItem: false,
        instantAppsEnabled: false,
        showTitle: false,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.green,
        preferredControlTintColor: Colors.white,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  static Future<void> showBottomSheet(Widget _widget, BuildContext context,
      {double height = 0.0, Color background = Colors.white}) async {
    if (height == 0.0) {
      height = MediaQuery.of(context).size.height * 0.4;
    }
    return await Get.bottomSheet(Container(
      height: height,
      child: Center(),
      color: background,
    ));
  }

  static Future<void> checkNewVersion(
      BuildContext context, _scaffoldKey) async {
    bool isVersionValid = false;
    bool isAndroid = true;
    final _loginService = new LoginService();
    if (Platform.isIOS) {
      isAndroid = false;
    }
    showLoading(status: 'Kiểm tra phiên bản');
    try {
      Map<String, String> versionApp = {
        "android": "",
        "ios": "",
        "releaseNoteIOS": "",
        "releaseNoteAndroid": ""
      };
      String version = "";
      String releaseNote = '';
      final response = await _loginService.getVersionAppp();
      dismissLoading();
      if (Utils.checkIsNotNull(response.data)) {
        var data = json.decode(response.data['data']);
        AppState.versionApp = data;
        if (IS_INSTALLED_BY_STORE) {
          versionApp = {
            "android": data['androidStore'],
            "ios": data['iosStore'],
            "releaseNoteIOS": data['releaseNoteIOS'],
            "releaseNoteAndroid": data['releaseNoteAndroid'],
            "androidHotFix": data['androidHotFix'],
            "iosHotFix": data['iosHotFix']
          };
        } else {
          versionApp = {
            "android": data['androidLink'],
            "ios": data['iosLink'],
            "releaseNoteIOS": data['releaseNoteIOS'],
            "releaseNoteAndroid": data['releaseNoteAndroid'],
            "androidHotFix": data['androidHotFix'],
            "iosHotFix": data['iosHotFix']
          };
        }
      } else {
        return;
      }
      if (isAndroid) {
        version = versionApp["android"] ?? '';
        releaseNote = versionApp["releaseNoteAndroid"] ?? '';
        if (Utils.checkIsNotNull(version)) {
          if (IS_PRODUCTION_APP) {
            if (APP_CONFIG.VERSION_ANDROID_PROD != version) {
              isVersionValid = true;
            }
          } else {
            if (APP_CONFIG.VERSION_ANDROID != version) {
              isVersionValid = true;
            }
          }
        }
        if (!isVersionValid && APP_CONFIG.VERSION_ANDROID_HOT_FIX != '') {
          final versionHotFix = versionApp['androidHotFix'];
          if (APP_CONFIG.VERSION_ANDROID_HOT_FIX != versionHotFix &&
              Utils.checkIsNotNull(versionHotFix)) {
            isVersionValid = true;
          }
        }
      } else {
        version = versionApp["ios"] ?? '';
        releaseNote = versionApp["releaseNoteIOS"] ?? '';
        if (Utils.checkIsNotNull(version)) {
          if (IS_PRODUCTION_APP) {
            if (APP_CONFIG.VERSION_IOS_PROD != version) {
              isVersionValid = true;
            }
          } else {
            if (APP_CONFIG.VERSION_IOS != version) {
              isVersionValid = true;
            }
          }
        }
        if (!isVersionValid && APP_CONFIG.VERSION_IOS_HOT_FIX != '') {
          final versionHotFix = versionApp['iosHotFix'];
          if (APP_CONFIG.VERSION_IOS_HOT_FIX != versionHotFix &&
              Utils.checkIsNotNull(versionHotFix)) {
            isVersionValid = true;
          }
        }
      }
      if (isVersionValid) {
        if (Utils.checkIsNotNull(releaseNote)) {
          if (releaseNote.toString().indexOf('\\n') > -1) {
            final releaseTemp = releaseNote.split('\\n');
            releaseNote = '';
            for (var re in releaseTemp) {
              releaseNote += re + '\n';
            }
          }
        }
        generateDialogOKCancelGet(releaseNote,
            title: 'Bạn vui lòng cập nhật phiên bản mới', callbackOK: () {
          if (isAndroid) {
            WidgetCommon.openPage(
                Utils.getLinkDownLoadAppAndroid(), _scaffoldKey);
          } else if (Platform.isIOS) {
            WidgetCommon.openPage(Utils.getLinkDownLoadAppIOS(), _scaffoldKey);
          }
        });
        return;
      }
      showSnackbar(_scaffoldKey, 'Ứng dụng hiện tại là phiên bản mới nhất',
          backgroundColor: Colors.blue);
    } catch (err) {
      dismissLoading();
    } finally {}
  }

  static showSnackbarWithoutScaffoldKey(String text,
      {int secondss = 4, Color backgroundColor = Colors.redAccent}) {
    try {
      final snackbar = new SnackBar(
        content: new Text(text),
        duration: Duration(seconds: secondss),
        backgroundColor: backgroundColor,
      );
      final context = NavigationService.instance.navigationKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {}
  }

  static Widget flexibleSpaceAppBar() {
    if (MyConnectivity.instance.isOffline) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 227, 7, 7),
              Color.fromARGB(180, 176, 5, 5),
              Color.fromARGB(255, 66, 3, 3),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 58, 184, 62),
            Color.fromARGB(255, 38, 134, 45),
            Color.fromARGB(255, 6, 51, 9),
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
      ),
    );
  }

  static Widget buttonDialog(
      {action,
      title,
      colorBg = Colors.green,
      color = Colors.white,
      border = false}) {
    return GestureDetector(
      onTap: () {
        action.call();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 1, bottom: 8, left: 1),
        child: roundedButton(title, const EdgeInsets.only(), colorBg, color,
            border: border),
      ),
    );
  }

  static Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor,
      {border = false}) {
    var loginBtn = Container(
      margin: margin,
      padding: const EdgeInsets.only(top: 10, left: 22, right: 22, bottom: 10),
      // alignment: FractionalOffset.center,
      // width: 100,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(
          color: border ? Colors.grey : Colors.white,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      child: Text(
        buttonLabel,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 16.0,
        ),
      ),
    );
    return loginBtn;
  }

  static generateDialogOKCancelGet(String content,
      {VoidCallback? callbackOK,
      String title = 'Thông báo',
      String textBtnClose = 'Đóng',
      VoidCallback? callbackCancel,
      String textBtnOK = 'Đồng ý'}) {
    // flutter defined function
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      contentPadding: EdgeInsets.all(20.0),
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        buttonDialog(
            colorBg: Colors.red,
            action: () {
              Get.back();
              callbackCancel?.call();
            },
            title: textBtnClose),
        buttonDialog(
            action: () {
              Get.back();
              callbackOK?.call();
            },
            title: textBtnOK),
      ],
    ));
  }
}
