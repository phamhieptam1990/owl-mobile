import 'package:flutter/material.dart';

// class Settings {
//   String mainColor;
//   String mainDarkColor;
//   String secondColor;
//   String secondDarkColor;
//   String accentColor;
//   String accentDarkColor;
//   String scaffoldDarkColor;
//   String scaffoldColor;
// }

class AppColor {
  static const Color primary = Color(0xFF018747);
  static const Color secondary = Color(0xFF2EA8FA);
  static const Color red = Color.fromRGBO(255, 43, 69, 1);
  static const Color danger = Color(0xFFE53E3E);
  static const Color orange = Color(0xFFF67264);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color paper = Color(0xFFF5F5F5);
  static const Color priorityLevel2 = Color(0xFFFF9800);
  static const Color lightGrey = Color(0xFFDDDDDD);
  static const Color darkGrey = Color(0xFF333333);
  static const Color grey = Color(0xFF888888);
  static const Color blue = Color(0xFF3688FF);
  static const Color golden = Color(0xff8B7961);
  static const Color black = Colors.black;
  static final Color blackOpacity = Colors.black.withOpacity(0.4);
  static final Color blackOpacity06 = Colors.black.withOpacity(0.6);
  static final Color backgroundGrey = Colors.grey[50] ?? Colors.grey;
  static const Color dashBoard1 = Color(0xff13d38e);
  static const Color dashBoard2 = Color(0xfff8b250);
  static const Color dashBoard3 = Color(0xff845bef);
  static const Color dashBoard4 = Color(0xFFFF2B45);
  static const Color dashBoard5 = Color(0xFFF67264);
  static const Color dashBoard6 = Color(0xff0293ee);
  static const Color tiltleColor = Color(0x0088CC);
  //theme new
  static Color appBar = Colors.green[600]!;
  static Color appBarTop = Colors.teal[700]!;
  static Color appBarCenter = Colors.greenAccent[700]!;
  static Color appBarBottom = Colors.lightGreen[50]!;

  ///online
  static Color appBarOn = Colors.green[700]!;
  static Color appBarOnTop = Colors.teal[700]!;
  static Color appBarOnCenter = Colors.greenAccent[700]!;
  static Color appBarOnBottom = Colors.lightGreen[50]!;

  //offline
  // static Color appBarOff = Colors.red;
  // static Color appBarOffTop = Colors.red;
  // static Color appBarOffCenter = Color(0xFFE64C85);
  // static Color appBarOffBottom = Colors.red[50];
  static const Color kPrimaryColor = Color(0xFF6F35A5);
  static const Color kPrimaryLightColor = Color(0xFFF1E6FF);

  static const Color appBarOff = Color(0xFFE53E3E);
  static const Color appBarOffTop = Color(0xFFE53E3E);
  static const Color appBarOffCenter = Color(0xFFE53E3E);
  static Color appBarOffBottom = Colors.red[50] ?? Colors.red;

  //wallet
  static const Color processing = Color.fromARGB(255, 255, 160, 0);
  static const Color linkedFailed = Color.fromARGB(0, 240, 158, 5);

  static Color mainColor(double opacity) {
    try {
      return Color(int.parse("#25D366".replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  static Color secondColor(double opacity) {
    try {
      return Color(int.parse("#043832".replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  static Color accentColor(double opacity) {
    try {
      return Color(int.parse("#8c98a8".replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  static Color mainDarkColor(double opacity) {
    try {
      return Color(int.parse("#25D366".replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  static Color secondDarkColor(double opacity) {
    try {
      return Color(int.parse("#ccccdd".replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  static Color accentDarkColor(double opacity) {
    try {
      return Color(int.parse("#9999aa".replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  static Color scaffoldColor(double opacity) {
    try {
      return Color(int.parse("#2c2c2c".replaceAll("#", "0xFF")))
          .withOpacity(opacity);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity);
    }
  }

  static Color greyCopyWith({double opacity = 1.0}) =>
      grey.withOpacity(opacity);
}