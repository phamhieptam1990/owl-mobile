import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'package:android_intent/android_intent.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
// import 'package:device_apps/device_apps.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' as Get;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_utsname_ext/extension.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/devices_info_model.dart';
import 'package:athena/models/permission/permission.model.dart';
import 'package:athena/models/userInfo.model.dart';
import 'package:athena/utils/services/firebase_analytics.service.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../generated/l10n.dart';
import '../models/deviceInfo.model.dart';
import 'app_state.dart';
import 'common/permission._app.service.dart';
import 'log/crashlystic_services.dart';
import 'navigation/navigation.service.dart';
import 'storage/storage_helper.dart';

class Utils {
  // static String encodeGenerateHexStr(String key) {
  //   return base32.encodeHexString(key);
  // }

  // static String decodeGenerateHexStr(String key) {
  //   return base32.decodeAsHexString(key);
  // }
  static void offAllNamePage(String page, {var params}) {
    // NavigationService.instance.navigateToReplacement(page, params: params);
    Get.Get.offAllNamed(page, arguments: params);
  }

  static returnDataStrNew(dynamic value, {dynamic errorReturn = ''}) {
    if (Utils.checkIsNotNull(value)) {
      return value;
    }
    return errorReturn;
  }

  static Future<dynamic> getDeviceInfoModel() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        return _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        return _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
      return DeviceInfoModel();
    } on PlatformException {
      return DeviceInfoModel();
    }
  }

  static double formatDouble(dynamic value) => value * 1.0;

  static formatDateString(String date) {
    // DateTime timeFormat = DateTime.parse(date);
    // final timeDif = DateTime.now().difference(timeFormat);
    // return timeago.format(DateTime.now().subtract(timeDif), locale: 'en');
  }
  static bool checkMapIsNotEmpty(dynamic mapCheck) {
    return mapCheck.isNotEmpty;
  }

  static cancelSubscription(StreamSubscription? subscription) {
    subscription?.cancel();
  }

  static disposeGlobalKey(GlobalKey<ScaffoldState> scaffoldState) {
    if (scaffoldState.currentState != null) {
      scaffoldState.currentState?.dispose();
    }
    }

  static checkIsImage(exp) {
    var list = [
      'jpg',
      'jpeg',
      'gif',
      'png',
      'eps',
      'raw',
      'cr2',
      'nef',
      'orf',
      'sr2'
    ];
    var returnValue = false;
    list.forEach((item) {
      if (exp.toLowerCase().trim() == item) {
        returnValue = true;
      }
    });
    return returnValue;
  }

  static convertDataToDouble(var data) {
    if (Utils.checkIsNotNull(data)) {
      if (Utils.checkValueIsDouble(data)) {
        return data;
      }
      return double.tryParse(data.toString());
    }
    return null;
  }

  static isArray(var array) {
    if (array != null) {
      if (array.length > 0) {
        return true;
      }
    }
    return false;
  }

  static bool checkIsNull(var value) {
    if (value == null || value == '') {
      return false;
    }
    return true;
  }

  static genApplicaionID(String username, String typeAction) async {
    try {
      String appId = username +
          '_' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          typeAction;
      appId = appId.replaceAll('.', '');
      appId = appId.replaceAll('@', '');
      return appId.toString();
    } catch (e) {
      return '';
    }
  }

  static checkDataIsNull(var data) {
    if (data == null) {
      return 0;
    }
    return data;
  }

  static bool checkIsNotNull(var value) {
    if (value == null || value == '') {
      return false;
    }
    if (value == 'null') {
      return false;
    }
    return true;
  }

  static bool checkIsNumber(var result) {
    if (result == null) {
      return false;
    }

    return int.tryParse(result) != null;
  }

  static String convertTime(int time,
      {String dateFormat = 'dd/MM/yyyy', String timeFormat = 'HH:mm:ss'}) {
    final df = new DateFormat(dateFormat + ' ' + timeFormat);
    return df.format(new DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String convertTimeWithoutTime(int? time,
      {String dateFormat = 'dd/MM/yyyy'}) {
        if(time == null){
          return '';
        }
    final df = new DateFormat(dateFormat);
    return df.format(new DateTime.fromMillisecondsSinceEpoch(time!));
  }
    static String convertTimeWithoutTimeNow(
      {String dateFormat = 'dd/MM/yyyy'}) {
    final df = new DateFormat(dateFormat);
    return df.format(new DateTime.now());
  }

  static convertTimeStampToDate(String givenDateTime,
      {String dateFormat = 'dd/MM/yyyy'}) {
    if (!Utils.checkIsNotNull(givenDateTime)) {
      return null;
    }
    final DateTime docDateTime =
        DateTime.parse(givenDateTime).add(Duration(hours: 7));
    return docDateTime;
  }

  static String convertDateStringToString(String givenDateTime,
      {String dateFormat = 'dd/MM/yyyy'}) {
    try {
      final DateTime docDateTime =
          DateTime.parse(givenDateTime).add(Duration(hours: 7));

      return DateFormat(dateFormat).format(docDateTime);
    } catch (_) {
      return '';
    }
  }

  static String convertDateStringToStringWithout(String givenDateTime,
      {String dateFormat = 'dd/MM/yyyy'}) {
    try {
      final DateTime docDateTime =
          DateTime.parse(givenDateTime);

      return DateFormat(dateFormat).format(docDateTime);
    } catch (_) {
      return '';
    }
  }

  static String convertTimeToSearch(DateTime? date, {String pattern = '-'}) {
    if(date == null){
      return '';
    }
    String year = date.year.toString();
    String month =
        (date.month > 9) ? date.month.toString() : "0" + date.month.toString();
    String day =
        (date.day > 9) ? date.day.toString() : "0" + date.day.toString();
    return year + pattern + month + pattern + day;
  }

  static String convertTimehasDay(int time,
      {String dateFormat = 'dd/MM/yyyy'}) {
    final date = new DateTime.fromMillisecondsSinceEpoch(time);
    String days =
        (date.day > 9) ? date.day.toString() : "0" + date.day.toString();
    String month = (date.month > 9)
        ? date.month.toString()
        : "0" + date.month.toString();
    String year =
        (date.year > 9) ? date.year.toString() : "0" + date.year.toString();
    String weekday =
        (date.weekday == 7) ? "CN" : "T." + (date.weekday + 1).toString();
    return weekday + ", " + days + "/" + month + "/" + year;
  }

  static String getOnlyTimeFromDate(int time,
      {String dateFormat = 'dd/MM/yyyy', String timeFormat = 'HH:mm:ss'}) {
    final date = new DateTime.fromMillisecondsSinceEpoch(time);
    String hour =
        (date.hour > 9) ? date.hour.toString() : "0" + date.hour.toString();
    String minute = (date.minute > 9)
        ? date.minute.toString()
        : "0" + date.minute.toString();
    return hour + ":" + minute;
  }

  static converString10(int number) {
    return number > 9 ? number.toString() : '0' + number.toString();
  }

  static String formatDuration(int number) {
    var d = Duration(seconds: number);
    var seconds = d.inSeconds;
    final days = seconds ~/ Duration.secondsPerDay;
    seconds -= days * Duration.secondsPerDay;
    final hours = seconds ~/ Duration.secondsPerHour;
    seconds -= hours * Duration.secondsPerHour;
    final minutes = seconds ~/ Duration.secondsPerMinute;
    seconds -= minutes * Duration.secondsPerMinute;

    final List<String> tokens = [];
    if (days != 0) {
      tokens.add(converString10(days) + ' ngày ');
    }
    if (tokens.isNotEmpty || hours != 0) {
      tokens.add(converString10(hours) + ' giờ ');
    }
    if (tokens.isNotEmpty || minutes != 0) {
      tokens.add(converString10(minutes) + ' phút ');
    }
    tokens.add(converString10(seconds) + ' giây ');

    return tokens.join('');
  }

  static String? getTimeFromDate(int? time,
      {String dateFormat = 'dd/MM/yyyy', String timeFormat = 'HH:mm:ss'}) {
    if (time == null) {
      return '';
    }
    final df = new DateFormat(dateFormat + ' ' + timeFormat);
    return df.format(new DateTime.fromMillisecondsSinceEpoch(time));
  }

  static int? convertTimeStampToDateEnhance(String? givenDateTime,
      {String dateFormat = 'dd/MM/yyyy'}) {
    if (givenDateTime == null || !Utils.checkIsNotNull(givenDateTime) || givenDateTime == "0") {
      return null;
    }
    final DateTime docDateTime = DateTime.parse(givenDateTime);
    return docDateTime.millisecondsSinceEpoch;
  }

   static String handleExtrainfoData(var data, String type,
      {String dateFormat = 'dd/MM/yyyy'}) {
    if(data == null){
      return '';
    }
    if (type == 'date') {
      return Utils.convertDateStringToString(data);
    }
    return data;
  }

  static String? convertToIso8601String(String givenDateTime,
      {String dateFormat = 'dd/MM/yyyy'}) {
    if (!Utils.checkIsNotNull(givenDateTime)) {
      return null;
    }
    final DateTime docDateTime = DateTime.parse(givenDateTime);
    return docDateTime.toIso8601String();
  }

  static DateTime converLongToDate(int time,
      {String dateFormat = 'dd/MM/yyyy', String hourFormat = 'HH:mm:ss'}) {
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  checkKeyItem(list, key, value) {
    for (var item in list) {
      if (item[key] == value) {
        return true;
      }
    }
    return false;
  }

  static String removeStringEx(str) {
    if (str == null || str == '') {
      return '';
    }
    var arr = str.split('@');
    String chuoi;
    if (arr[0] != null || arr[0] != '') {
      chuoi = arr[0];
    } else {
      chuoi = str;
    }
    // return chuoi.replaceAll(new RegExp(r'[^.,!?\w\s|=_#$"~`-]+'), '');
    return chuoi.replaceAll(new RegExp(r'[.!@#$%^&]'), '');
  }

  static bool checkMenuCol(list, String col, String value) {
    for (var item in list) {
      if (item[col] == value) {
        return true;
      } else if (item['children'].length > 0) {
        for (var itemSubLv1 in item['children']) {
          if (itemSubLv1[col] == value) {
            return true;
          } else if (itemSubLv1['children'].length > 0) {
            for (var itemSubLv2 in itemSubLv1['children']) {
              if (itemSubLv2[col] == value) {
                return true;
              } else if (itemSubLv2['children'].length > 0) {
                for (var itemSubLv3 in itemSubLv2['children']) {
                  if (itemSubLv3[col] == value) {
                    return true;
                  } else if (itemSubLv3['children'].length > 0) {
                    for (var itemSubLv4 in itemSubLv3['children']) {
                      if (itemSubLv4[col] == value) {
                        return true;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return false;
  }

  static String retunDataStr(var data) {
    if (data == null || data == 'null') {
      return '';
    }
    return data;
  }

   static double? retunDataDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    
    try {
      if (value is double) {
        return value;
      } else if (value is int) {
        return value.toDouble();
      } else if (value is String) {
        // Try to parse the string as a double
        return double.tryParse(value);  // Returns null if parsing fails
      } else {
        // For any other type, try to convert to string first
        return double.tryParse(value.toString());  // Returns null if parsing fails
      }
    } catch (e) {
      print('Error in retunDataDouble: $e');
      return null;
    }
  }

  /// check tablet screen
  static bool isTablet(MediaQueryData query) {
    var size = query.size;
    var diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  // push and remove all route child
  static void pushAndRemoveUntil(String page, {dynamic params}) {
    FirebaseAnalyticsService.sendAnalyticsEventPushPage(page, params);
    NavigationService.instance.navigateToReplacement(page, arguments: params);
  }

  // // navigateToReplacement
  // static void navigateToReplacement(var context, String page, {dynamic params}) {
  //   FirebaseAnalyticsService.sendAnalyticsEventPushPage(page, params);
  //   NavigationService.instance.navigateToReplacement(page, params: params);
  // }
  // Fix 4: Improve navigateToReplacement with better type signature
  static void navigateToReplacement(BuildContext context, String page, {dynamic params}) {
    FirebaseAnalyticsService.sendAnalyticsEventPushPage(page, params);
    NavigationService.instance.navigateToReplacement(page, arguments: params);
  }

  static void popPage(BuildContext context, {dynamic result}) {
    NavigationService.instance.goback(result: result);
  }

  // // push and remove all route child
  // static void pushName(var context, String page, {dynamic params}) {
  //   FirebaseAnalyticsService.sendAnalyticsEventPushPage(page, params);
  //   NavigationService.instance.navigateTo(page, params: params);
  // }

// Fix 3: Improve pushName with better type signature
static void pushName(BuildContext context, String page, {dynamic params}) {
  FirebaseAnalyticsService.sendAnalyticsEventPushPage(page, params);
  NavigationService.instance.navigateTo(page, arguments: params);
}

  static String? validateEmail(context, String value) {
    return !value.contains('@') ? S.of(context).email : null;
  }

  static String? isRequire(context, String value) {
    return value.length == 0 ? S.of(context).pleaseInputRequire : null;
  }

  static String? isRequireForTenant(context, String value, _userInfoStore) {
      if (Utils.isTenantTnex(_userInfoStore)) {
        return Utils.isRequire(context, value);
      }  
    return null; 
  }

  static String? isRequireSelectDuration(context, String value) {
    return value == S.of(context).select
        ? S.of(context).pleaseInputRequire
        : null;
  }

  static String? isRequireSelect(context, var value) {
    return value == null ? S.of(context).pleaseInputRequire : null;
  }

  static Color? backgroundGreyOpacity(BuildContext context) {
    return Theme.of(context).iconTheme.color?.withOpacity(
        Theme.of(context).brightness == Brightness.light ? 0.10 : 0.20);
  }

  static Future<ConnectivityResult?> networkIsConnective() async {
    final results = await Connectivity().checkConnectivity();

    // Nếu không có kết nối nào được phát hiện
    if (results.isEmpty) return null;

    // Trả về phần tử đầu tiên phù hợp (mobile/wifi/ethernet)
    for (var result in results) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet) {
        return result;
      }
    }

    return null; // Nếu không có kết nối nào hợp lệ
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static int buildOffsetConfig(int currentPage) {
    int lengthCurrent = APP_CONFIG.LIMIT_QUERY;
    int offsetCurrent = (currentPage - 1) * lengthCurrent;
    if (offsetCurrent <= 0) {
      offsetCurrent = 0;
    }
    return offsetCurrent;
  }

  static String repplaceCharacter(String value,
      {String oldPattern = '.', String newPattern = ''}) {
    return value.replaceAll(oldPattern, newPattern);
  }

  static bool checkValueIsDouble(var value) {
    if (value is double) {
      return true;
    }
    return false;
  }

  static getDeviceInfo(bool isAndroid) async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (isAndroid) {
      AndroidDeviceInfo deviceAndroid = await deviceInfo.androidInfo;
      return deviceAndroid;
    } else {
      IosDeviceInfo deviceIOS = await deviceInfo.iosInfo;
      return deviceIOS;
    }
  }

  static Future<dynamic> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath).then(convert.jsonDecode);
  }

  static UserInfoModel? setUserInfo(var responseUserInfo) {
    List<PermissionModel> lstPermission = [];
    var permissions;
    UserInfoModel userInfoModel;
    try {
      if (responseUserInfo.data != null) {
        permissions = responseUserInfo.data['permissions'];
        for (var per in permissions) {
          lstPermission.add(new PermissionModel(
              action: per['action'], target: per['target']));
        }
        List<Authority> authorities =
            (responseUserInfo.data['authorities'] as List)
                .map((e) => Authority.fromJson(e))
                .toList();
        userInfoModel = new UserInfoModel(
          username: responseUserInfo.data['username'],
          fullName: responseUserInfo.data['fullName'],
          moreInfo: responseUserInfo.data['moreInfo'],
          userCode: responseUserInfo.data['userCode'],
          permissions: lstPermission,
          authorities: authorities,
        );
        return userInfoModel;
      }
      return null;
    } catch (e) {
      permissions = responseUserInfo['permissions'];
      for (var per in permissions) {
        lstPermission.add(
            new PermissionModel(action: per['action'], target: per['target']));
      }
      userInfoModel = new UserInfoModel(
        username: responseUserInfo['username'],
        fullName: responseUserInfo['fullName'],
        moreInfo: responseUserInfo['moreInfo'],
        userCode: responseUserInfo['userCode'],
        permissions: lstPermission,
        authorities: responseUserInfo['authorities'],
      );
      return userInfoModel;
    }
  }

  static UserInfoModel setUserInfoOffline(var responseUserInfo) {
    List<PermissionModel> lstPermission = [];
    var permissions = responseUserInfo['permissions'];
    for (var per in permissions) {
      lstPermission.add(
          new PermissionModel(action: per['action'], target: per['target']));
    }
    return new UserInfoModel(
      username: responseUserInfo['username'],
      fullName: responseUserInfo['fullName'],
      moreInfo: responseUserInfo['moreInfo'],
      userCode: responseUserInfo['userCode'],
      permissions: lstPermission,
    );
  }

  static encodeJSON(var data) {
    return json.encode(data);
  }

  static decodeJSON(var data) {
    return json.decode(data);
  }

  static encodeJSONToString(var data) {
    return jsonEncode(data);
  }

  static decodeJSONToString(var data) {
    return jsonDecode(data);
  }

  static int convertDoubleToInt(var data) {
    if (Utils.checkIsNotNull(data)) {
      if (data is double) {
        return data.toInt();
      }
    }
    return data;
  }

  static String encodeRequestJson(Map<String, dynamic> dataJson) {
    return Uri.encodeComponent(jsonEncode(dataJson));
  }

  static convertDataDoubleToInt(var valAmount) {
    if (valAmount is double) {
      return Utils.convertDoubleToInt(valAmount);
    }
    return valAmount;
  }

  static String convertDateXSTU(dynamic value) {
    String tempDate = value.date;
    tempDate = tempDate.replaceAll('-', '/');
    var inputFormat = DateFormat('dd/MM/yyyy');
    DateTime dateTime = inputFormat.parse(tempDate);
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    var parts = value.time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    var fromdate = DateTime(year, month, day, hour, minute);
    var toDate =
        fromdate.add(Duration(minutes: int.parse(value.durationInMins)));
    String retureString = Utils.convertTime(fromdate.millisecondsSinceEpoch,
            timeFormat: 'HH:mm') +
        ' - ' +
        Utils.convertTime(toDate.millisecondsSinceEpoch, timeFormat: 'HH:mm');
    return retureString;
  }

  static String returnData(var data, {String type = '', String field = ''}) {
    try {
      if (data == null) {
        return '';
      }
      if (data == 'null') {
        return '';
      }
      if (type == 'phone') {
        if ((data as String).substring(0, 2) == '84') {
          return '0' + (data).substring(2, (data).length);
        }
      }
      if (field == 'byProductModel' || field == 'insuranceApplicable') {
        if (data.toString() == "true") return 'Có';
        return 'Không';
      }

      if (field == 'gender') {
        if (data.toString().toLowerCase() == 'male' || data.toString().toLowerCase() == 'm' || data.toString().toLowerCase() == 'nam') {
          return 'Nam';
        } else if (data.toString().toLowerCase() == 'fmale' || data.toString().toLowerCase() == 'f' || data.toString().toLowerCase() == 'nữ') {
          return 'Nữ';
        } else {
          return 'Không xác định';
        }
        // return data.toString();
      }
      if (type == 'date') {
        if (Utils.checkIsNotNull(data)) {
          if (data is num) {
          return Utils.convertTimeWithoutTime(data.toInt()).toString();
          }
          return Utils.convertTimeWithoutTime(
                  DateTime.parse(data).millisecondsSinceEpoch)
              .toString();
        }
        return data;
      }
      if (type == 'dateTodate') {
        if (Utils.checkIsNotNull(data)) {
          return Utils.convertDateXSTU(data);
        }
        return '';
      }
      if (type == 'dateTimeStamp') {
        if (Utils.checkIsNotNull(data)) {
          return Utils.convertTimeWithoutTime(
              Utils.convertTimeStampToDate(data));
        }
        return data;
      }
      if (type == 'money') {
        if (Utils.checkIsNotNull(data)) {
          var money = data;
          if (money is double) {
            money = Utils.convertDataDoubleToInt(data).toString();
          } else if (money is num) {
            money = data.toString();
          } else {
            money = int.parse(data).toString();
          }
          return Utils.formatPrice(money).toString();
        }
      }
      return Utils.checkIsNull(data) ? data.toString() : '';
    } catch (e) {
      return data.toString();
    }
  }

  static actionPhone(String value, String type) {
    if (type == ActionPhone.CALL) {
      UrlLauncher.launchUrl(Uri.parse('tel:${value.toString()}'));
    } else if (type == ActionPhone.EMAIL) {
      UrlLauncher.launchUrl(Uri.parse('mailto:${value.toString()}'));
    } else if (type == ActionPhone.SMS) {
      UrlLauncher.launchUrl(Uri.parse('sms:${value.toString()}'));
    }
  }

  static List<String> splitCharacter(String value, String pattern) {
    return value.split(pattern);
  }

  static String timeAgo(DateTime time, {String locale = 'vi'}) {
    return '';
    // return timeago.format(time, locale: locale, allowFromNow: true);
  }

  static bool checkRequestIsComplete(Response? response) {
    if (response?.data != null &&
        response?.data['status'] == HttpHelperConstant.STATUS_REQUEST_OK) {
      return true;
    }
    return false;
  }

  static bool checkRequestIsCompleteEnhace(Response response) {
    if (response.statusCode == HttpHelperConstant.STATUS_REQUEST_200) {
      return true;
    }
    return false;
  }
  
  static Map<String, dynamic>? getValidationResponse(Response? response) {
  if (response?.data == null) return null;
  
  if (response?.data['status'] == HttpHelperConstant.STATUS_REQUEST_FAILED) {
    final data = response?.data['data'];
    if (data == null) return null;

    try {
      Map<String, dynamic>? validationData;
      data.forEach((k, v) {
        if (k == ValidationConstant.VALIDATERESULT) {
          validationData = Map<String, dynamic>.from(v);
        }
      });
      return validationData;
    } catch (e) {
      debugPrint('Error parsing validation response: $e');
      return null;
    }
  }
  return null;
}

  static dynamic handleRequestData(Response response) {
    if (response.data['data'] != null) {
      return response.data['data'];
    }
    return null;
  }

  static dynamic handleRequestDataLV1(Response response) {
    if (response.data != null) {
      return response.data;
    }
    return null;
  }

  static bool checkRequestDataImage(Response response) {
    if (response.data != null) {
      return true;
    }
    return false;
  }

  static dynamic handleRequestData2Level(Response response) {
    if (response.data['data'] != null) {
      return response.data['data']['data'];
    }
    return null;
  }

  static String formatPrice(String value, {bool hasVND = false}) {
    if (value == '' || value == 'null') {
      return hasVND ? '0 VND' : '';
    }
    final f = NumberFormat.currency(locale: 'vi', decimalDigits: 0, symbol: '');
    final number = int.parse(value.replaceAll('.', ''));
    final newString = f.format(number).trim();
    return newString + (hasVND ? ' VND' : '');
  }

  static String formatPriceDouble(double? value) {
    String? valueNew = value?.toStringAsFixed(0) ?? '0';
    final f = NumberFormat.currency(locale: 'vi', decimalDigits: 0, symbol: '');
    final number = int.parse(valueNew?.replaceAll('.', '') as String);
    final newString = f.format(number).trim();
    return newString;
  }

  static compareDateStr(DateTime date1, DateTime date2) {
    if (date1.month == date2.month &&
        date1.year == date2.year &&
        date1.day == date2.day) {
      return true;
    }
    return false;
  }

  static String buildTextFromTime(String text) {
    if (text.length == 1) {
      return '0' + text;
    }
    return text;
  }

  static bool isPhoneValid(String phone) {
    if (phone.length == 0) {
      return false;
    }
    if (phone[0] != '0') {
      return false;
    }
    if (phone.length < 10 || phone.length > 11) {
      return false;
    }
    return true;
  }

  static bool isPhoneValidExt(String phone) {
    if (phone.length == 0) {
      return false;
    }
    if (phone[0] != '0') {
      return false;
    }
    if (phone.length < 10 || phone.length > 11) {
      return false;
    }
    return true;
  }

  static Future<void> checkUpdateIOS(BuildContext context,
      {  VoidCallback? nextTask}) async {
    if (IS_PRODUCTION_APP) {
      try {
        bool isCheckVersion =
            await StorageHelper.getBool(AppStateConfigConstant.CHECK_VERSION) ?? true;
        String skipVersion =
            await StorageHelper.getString(AppStateConfigConstant.SKIP_VERSION) ?? "";
        final newVersion = NewVersionPlus();
        final status = await newVersion.getVersionStatus();
        if (status != null && status.localVersion != status.storeVersion) {
          int localMajorVersion =
              int.tryParse(status.localVersion.split(".").first) ?? 0;
          int storeMajorVersion =
              int.tryParse(status.storeVersion.split(".").first) ?? 0;
          if (localMajorVersion < storeMajorVersion) {
            if (Platform.isAndroid) {
              // InAppUpdate.checkForUpdate().then((value) {
              //   InAppUpdate.performImmediateUpdate()
              //       .then((AppUpdateResult value) {
              //     if (value != AppUpdateResult.success) {
              //       WidgetCommon.generateDialogOK(context,
              //           content: S.of(context).force_update, callback: () {
              //         FlutterExitApp.exitApp(iosForceExit: true);
              //       });
              //     }
              //   });
              // });
            } else {
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
            }
          } else if (isCheckVersion && status.storeVersion != skipVersion && localMajorVersion == storeMajorVersion) {
            int localVersion = int.tryParse(status.localVersion.replaceAll(".", "0")) ?? 0;
            int storeVersion = int.tryParse(status.storeVersion.replaceAll(".", "0")) ?? 0;
            if (localVersion < storeVersion) {
              if (Platform.isAndroid) {
                // InAppUpdate.checkForUpdate().then((value) {
                //   InAppUpdate.startFlexibleUpdate().then((value) async {
                //     if (value == AppUpdateResult.userDeniedUpdate) {
                //       await StorageHelper.setString(AppStateConfigConstant.SKIP_VERSION,
                //           status.storeVersion);
                //     }
                //     if (nextTask != null) {
                //       nextTask();
                //     }
                //   });
                // });
              } else {
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
                      await StorageHelper.setString(AppStateConfigConstant.SKIP_VERSION,
                          status.storeVersion);
                      nextTask?.call();
                                        });
              }
            } else {
              nextTask?.call();
                        }
          } else {
            nextTask?.call();
                    }
        } else {
          nextTask?.call();
                }
      } catch (e) {
        nextTask?.call();
            }
    } else {
      nextTask?.call();
        }
  }
  static String getLinkDownLoadAppAndroid() {
    if (IS_PRODUCTION_APP) {
      // if (IS_INSTALLED_BY_STORE) {
      //   return APP_CONFIG.PLAY_STORE;
      // }
      return APP_CONFIG.PRODUCTION_LINK_ANDROID;
    }
    return APP_CONFIG.UAT_LINK_ANDROID;
  }

  static String getLinkDownLoadAppIOS() {
    if (IS_PRODUCTION_APP) {
      if (IS_INSTALLED_BY_STORE) {
        return APP_CONFIG.APP_STORE;
      }
      return APP_CONFIG.PRODUCTION_LINK_IOS;
    }
    return APP_CONFIG.UAT_LINK_IOS;
  }

  static String getVersionAndroid() {
    if (IS_PRODUCTION_APP) {
      return APP_CONFIG.VERSION_ANDROID_PROD;
    }
    return APP_CONFIG.VERSION_ANDROID;
  }

  static getCurrentRoute() {
    return Get.Get.currentRoute.toString();
  }

  static String getScreen() {
    // String currentScreen =
    //     SCREEN_APP.screenApp_ScreenSecurity[getCurrentRoute()];
    String currentScreen = getCurrentRoute();
    return currentScreen ?? '';
  }

  static String showVersionApp() {
    if (Platform.isAndroid) {
      return APP_CONFIG.VERSION_ANDROID_HOT_FIX;
    }
    if (Platform.isIOS) {
      return APP_CONFIG.VERSION_IOS_HOT_FIX;
    }
    return '';
  }

  static bool isCheckInTimeValid() {
    final time = new DateTime.now();
    final hour = time.hour;
    if (hour == 21 ||
        hour == 22 ||
        hour == 23 ||
        hour == 0 ||
        hour == 1 ||
        hour == 2 ||
        hour == 3 ||
        hour == 4 ||
        hour == 5 ||
        hour == 6) {
      return false;
    }
    return true;
  }

  static openIntentApp(String app, String type, var value) {
    if (type == 'MAPS') {
      final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull('google.navigation:q=$value'),
          package: app);
      intent.launch();
      return;
    }
    if (type == 'MARKET') {
      AndroidIntent intentApp = AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull("market://details?id=$value"),
          package: app);
      intentApp.launch();
    }
  }

  static viewMakerGoogleMap({LatLng? curentMarker}) {
    var uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {
      'q': '${curentMarker?.latitude},${curentMarker?.longitude}'
    });
    launchUrl(uri);
    return;
  }

  static buildFilterRecordStatus(var statusFiler) {
    // if (statusFiler != '') {
    //   newStatusFilter =
    //       '"recordStatus": {"type": "${FilterType.EQUALS}", "filter": "O","filterType": "${FilterType.TEXT}"},' +
    //           statusFiler;
    // } else {
    //   newStatusFilter =
    //       '"recordStatus": {"type": "${FilterType.EQUALS}", "filter": "O","filterType": "${FilterType.TEXT}"}';
    // }
    return statusFiler;
  }

  static int diffInDaysGetMinues(DateTime date1, DateTime date2) {
    Duration difference = date1.difference(date2);
    return difference.inMinutes;
  }

  static bool isString(var result) {
    if (result is String) {
      return true;
    }

    return false;
  }

  static String returnDataDateTime(DateTime date) {
    if (Utils.checkIsNotNull(date)) {
      return Utils.convertTimeWithoutTime(date.millisecondsSinceEpoch);
    }
    return '';
  }

  static int buildOffset(int offsetCurrent,
      {int limit = APP_CONFIG.LIMIT_QUERY}) {
    if (offsetCurrent == 0) {
      return offsetCurrent + 1 + limit;
    }
    return offsetCurrent + limit;
  }

  static int buildEndrow(int offsetCurrent,
      {int limit = APP_CONFIG.LIMIT_QUERY}) {
    if (offsetCurrent == 0) {
      return offsetCurrent = limit;
    }
    return (offsetCurrent - 1) + limit;
  }

  static checkValueIsHTMLContent(String value) {
    final reg = new RegExp(
        r'<(?=.*? .*?\/ ?>|br|hr|input|!--|wbr)[a-z]+.*?>|<([a-z]+).*?<\/\1>');
    return reg.hasMatch(value);
  }

  static DeviceInfoModel _readAndroidBuildData(AndroidDeviceInfo androidInfo) {
  final systemOsVersion = double.tryParse(androidInfo.version.release ?? '0.0') ?? 0.0;

    return DeviceInfoModel(
        imei: androidInfo.serialNumber,
        model: androidInfo.model,
        deviceName: androidInfo.manufacturer,
        systemName: 'Android ${androidInfo.version.release}',
        systemVersion: systemOsVersion);
  }

  static DeviceInfoModel _readIosDeviceInfo(IosDeviceInfo data) {
    double systemOsVersion = double.tryParse(data.systemVersion ?? '0.0') ?? 0.0;

    return DeviceInfoModel(
        imei: data.identifierForVendor,
        model: data.model,
        deviceName: data.name,
        systemName: data.systemName,
        systemVersion: systemOsVersion);
  }

  static lauchFacebook(String url) async {
    if (!Utils.checkIsNotNull(url) || url.isEmpty) {
      return await WidgetCommon.showSnackbarWithoutScaffoldKey(
          'Không có dữ liệu');
    }
    String fallbackUrl = '';

    try {
      String facebookId = '';
      if (url.indexOf('facebook.com') > -1) {
        facebookId =
            url.substring(url.indexOf('facebook.com/') + 13, url.length);
      }
      // String fbProtocolUrl = 'fb://page/id=' + facebookId;
      String fbProtocolUrl = 'fb://profile/' + facebookId ?? '';
      bool launched = await UrlLauncher.launchUrl(Uri.parse(fbProtocolUrl));
      if (!launched) {
        await UrlLauncher.launchUrl(Uri.parse(fallbackUrl));
      }
    } catch (e) {
      await UrlLauncher.launchUrl(Uri.parse(fallbackUrl));
    }
  }

  static String timestamptoSting(int timestamp) {
    try {
      var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);

      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
  }

  static String timestamptoStingInput(int timestamp) {
    try {
      var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);

      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  static String parsePhoneNumber84(String phone) {
    try {
      if (phone.isEmpty) return '';

      String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regExp = RegExp(pattern);

      if (!regExp.hasMatch(phone)) {
        return '';
      }
      if (phone[0] == '0') return phone;
      if (phone[0] == '8' && phone[1] == '4') {
        return '0' + phone.substring(2);
      }
      return phone;
    } catch (_) {
      return '';
    }
  }

  static String convertStringDateToStandard(String date) {
    try {
      if (date.isEmpty ?? true) return '';
      return DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(date));
    } catch (_) {
      return '';
    }
  }

  static int? tryToParseInt(dynamic value) {
  if (value == null) return null;
  
  try {
    if (value is int) return value;
    if (value is double) return value.toInt();
    
    final stringValue = value.toString().trim();
    if (stringValue.isEmpty) return null;
    
    // Try parsing as double first (handles both integer and decimal strings)
    return double.parse(stringValue).toInt();
  } catch (e) {
    debugPrint('Error parsing int value: $e');
    return null;
  }
}

  static Future<void> submitLocation(
      {String action = 'dev-test-tracking'}) async {
    String userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    try {
      if (userName.isEmpty) return;

      if (!Utils.checkIsNotNull(AppState.getDeviceInfo())) {
        return;
      }
      final checkPermission = await PermissionAppService.checkPermission();
      if (checkPermission) {
        Position? position = await PermissionAppService.getCurrentPosition();
        if (position != null && Utils.checkIsNotNull(position)) {
          GeoPoint coordinates =
              new GeoPoint(position.latitude, position.longitude);
          PermissionAppService.lastPosition = position;
          DateTime now = DateTime.now();
          DeviceInfo device = AppState.getDeviceInfo();
          if (Utils.checkIsNotNull(device)) {
            String companyCode = await StorageHelper.getString(
                    AppStateConfigConstant.TENANT_CODE) ??
                APP_CONFIG.COMPANY_CODE;
            FirebaseFirestore.instance
                .collection('tracking/users/' + userName)
                .add({
              "appCode": APP_CONFIG.APP_CODE,
              "tenantCode": companyCode,
              "deviceId": device.imei,
              "coordinates": coordinates,
              "makerDate": now,
              "trackDate": now,
              "action": action
            });
          }
        }
      }
    } on PlatformException catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.message}, user $userName');
    } catch (e) {
      CrashlysticServices.instance
          .log('savePosition ${e.toString()}, user $userName');
    }
  }

   getExtrainInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();

      Map<String, dynamic> extraInfo = {};
      if (Platform.isAndroid) {
        final deviceAndroid = await deviceInfo.androidInfo;
        extraInfo['platform'] = 'Android';
        extraInfo['model'] = deviceAndroid.model ?? '';
        extraInfo['manufacture'] = deviceAndroid.manufacturer ?? '';
        extraInfo['appVersion'] = showVersionApp() ?? ' ';
        extraInfo['deviceVersion'] =
            deviceAndroid.version.release?.toString() ?? '';
        extraInfo['isInstalledByStore'] = IS_INSTALLED_BY_STORE ?? '';
      } else {
        final deviceIOS = await deviceInfo.iosInfo;
        final machineId = deviceIOS.utsname.machine;
        final productName = machineId?.iOSProductName;
        extraInfo['platform'] = 'iPhone';
        extraInfo['model'] = productName ?? '';
        extraInfo['manufacture'] = deviceIOS.name ?? '';
        extraInfo['appVersion'] = showVersionApp() ?? ' ';
        extraInfo['deviceVersion'] =
            (deviceIOS.systemName ?? '') + (deviceIOS.systemVersion ?? '');
        extraInfo['isInstalledByStore'] = false;
      }
      return extraInfo;
    } catch (_) {
      return {};
    }
  }

  Future<String> getImeiDevices() async {
    final userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo deviceAndroid = await deviceInfo.androidInfo;
      String flatform = 'isAndroid';
      String model = deviceAndroid.model ?? '';
      String hardware = deviceAndroid.hardware ?? '';

      String metaData = 'UserDevice($flatform, $model, $hardware, $userName)';
      final bytesImei = utf8.encode(metaData);

      final hashImei = sha256.convert(bytesImei);

      String imei = hashImei.toString() ?? 'unknown';
      return imei;
    } else {
      String udid = await FlutterUdid.udid;

      String imei = udid ?? '';

      return imei;
    }
  }
  
static int? parseDoubleStringToInt(String? value) {
  try {
    final cleanValue = value?.removeAllWhitespaces ?? '';
    final parsedValue = int.tryParse(Utils.repplaceCharacter(cleanValue!));
    return parsedValue;
  } catch (e) {
    debugPrint('Error parsing double string to int: $e');
    return null;
  }
}

  static String formatPriceDefault0(String? value, {bool hasVND = false}) {
    if (value == '' || value == 'null') {
      return hasVND ? '0 VND' : '0';
    }
    final f = NumberFormat.currency(locale: 'vi', decimalDigits: 0, symbol: '');
    final number = int.parse(value!.replaceAll('.', ''));
    final newString = f.format(number).trim();

    return newString.isEmpty ?? false
        ? '0'
        : (newString + (hasVND ? ' VND' : ''));
  }

  static String? convertFormatPhone(String phone) {
    if (Utils.checkIsNotNull(phone)) {
      if ((phone![0] + phone[1]) == '84') {
        phone = '0' + phone.replaceFirst(RegExp(r'84'), '');
      } else if ((phone[0] + phone[1] + phone[2] == '+84')) {
        phone = '0' + phone.replaceFirst(RegExp(r'+84'), '');
      } else if ((phone[0] + phone[1] + phone[2] == '084')) {
        phone = '0' + phone.replaceFirst(RegExp(r'084'), '');
      } else if (phone[0] != '0') {
        phone = '0' + phone;
      }
    }
    return phone;
  }

  static bool isTenantTnex(var _userInfoStore){
    try { 
    if(_userInfoStore?.user?.moreInfo['tenantCode'] == "TNEX"){
      return true;
      }
      return false;
    } catch (e) {
      return false;
    }
    // return false;
  }

  static Future<void> openGoogleMaps(String? cusFullAddress,
      {LatLng? curentMarker}) async {
    if (!Utils.checkIsNotNull(cusFullAddress) || cusFullAddress == 'null') {
      return WidgetCommon.generateDialogOKGet(
          content: 'Không tìm thấy địa chỉ.');
    }

    try {
      if (Platform.isAndroid) {
        // Mở Google Maps bằng geo URI
        final uri = Uri(
          scheme: 'geo',
          host: '0,0',
          queryParameters: {'q': cusFullAddress},
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          // Nếu không mở được => mở Google Maps trên Play Store
          final marketUri =
              Uri.parse("market://details?id=com.google.android.apps.maps");
          if (await canLaunchUrl(marketUri)) {
            await launchUrl(marketUri);
          } else {
            return WidgetCommon.generateDialogOKGet(
              content: 'Không thể mở Google Maps. Vui lòng cài đặt ứng dụng.',
            );
          }
        }
      } else if (Platform.isIOS) {
        // Thử mở bằng scheme của Google Maps app
        final comgooglemapsUrl = Uri.parse(
          "comgooglemaps://?q=${Uri.encodeComponent(cusFullAddress!)}",
        );

        final fallbackWebUrl = Uri.parse(
          "https://www.google.com/maps/search/?hl=vi-VN&api=1&query=${Uri.encodeComponent(curentMarker != null ? '${curentMarker.latitude},${curentMarker.longitude}' : cusFullAddress)}",
        );

        if (await canLaunchUrl(comgooglemapsUrl)) {
          await launchUrl(comgooglemapsUrl);
        } else if (await canLaunchUrl(fallbackWebUrl)) {
          await launchUrl(fallbackWebUrl);
        } else {
          throw 'Không thể mở Google Maps.';
        }
      }
    } catch (e) {
      CrashlysticServices.instance.log('Open app Google Maps error: $e');
    }
  }
}

extension StringRemoveWhitespace on String {
  String get removeAllWhitespaces => replaceAll(' ', '');
}
