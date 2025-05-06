import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';

ThemeData themeApp(String _theme) {
  switch (_theme) {
    case 'main':
      //set color appBar
      AppColor.appBar = AppColor.appBarOn;
      AppColor.appBarTop = AppColor.appBarOnTop;
      AppColor.appBarCenter = AppColor.appBarOnCenter;
      AppColor.appBarBottom = AppColor.appBarOnBottom;

      return ThemeData(
        // primaryColor: AppColor.primary,
        primaryColor: AppColor.appBarOn,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          elevation: 0,
        ),
      );
    case 'offline':
      // AppColor.appBar = AppColor.appBarOn;
      // AppColor.appBarTop = AppColor.appBarOffTop;
      // AppColor.appBarCenter = AppColor.appBarOffCenter;
      // AppColor.appBarBottom = AppColor.appBarOffBottom;
      AppColor.appBar = AppColor.appBarOff;
      AppColor.appBarTop = AppColor.appBarOffTop;
      AppColor.appBarCenter = AppColor.appBarOffCenter;
      AppColor.appBarBottom = AppColor.appBarOffBottom;
      return ThemeData(primaryColor: AppColor.danger
          // primaryColor: AppColor.appBar
          );
    default:
      AppColor.appBar = AppColor.appBarOn;
      AppColor.appBarTop = AppColor.appBarOnTop;
      AppColor.appBarCenter = AppColor.appBarOnCenter;
      AppColor.appBarBottom = AppColor.appBarOnBottom;

      return ThemeData(
        primaryColor: AppColor.appBarOn,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          elevation: 0,
        ),
      );
  }
}
