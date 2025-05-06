import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/widgets/spinning_line_widget.dart';

import '../utils/navigation/navigation.service.dart';

class AppLoading {
  static bool _isShowing = false;

  static Future<void> show() async {
    //set up the AlertDialog
    if (_isShowing) {
    } else {
      _isShowing = true;
    final context = NavigationService.instance.navigationKey.currentContext;
    if (context == null) return;
      AlertDialog alert = AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: WillPopScope(
          onWillPop: () async => false,
          child: Align(
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.8),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: SpinKitSpinningLines(
                color: AppColor.primary,
                duration: Duration(milliseconds: 2200),
              ),
            ),
          ),
        ),
      );
      showDialog(
        //prevent outside touch
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          //prevent Back button press
          return alert;
        },
      );
    }
  }

  static void dismiss() {
    if (!_isShowing) return;
    
    final context = NavigationService.instance.navigationKey.currentContext;
    if (context == null) return;
    
    _isShowing = false;
    Navigator.of(context).pop();
  }
}
