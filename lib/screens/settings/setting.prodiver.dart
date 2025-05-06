import 'package:flutter/material.dart';

class SettingProvider with ChangeNotifier {
  bool isFinterPrint = false;
  bool isLocationManager = false;
  bool isFirstInit = true;
  String timeFetchOffline = '';
  int settingPage = 0;
  int get getsettingPage => settingPage;
  void setIsFingerPrint(bool _isFinterPrint) {
    this.isFinterPrint = _isFinterPrint;
  }

  void setIsLocationManager(bool _locationManager) {
    this.isLocationManager = _locationManager;
  }

  setSettingPage(int settingPage) {
    this.settingPage = settingPage;
    notifyListeners();
  }

  void setTimeFetchOffline(String _timeFetchOffline) {
    this.timeFetchOffline = timeFetchOffline;
  }

  clearData() {
    isFinterPrint = false;
    isFirstInit = true;
    isLocationManager = false;
    timeFetchOffline = '';
    settingPage = 0;
  }

  static final SettingProvider _categorySingeton = SettingProvider._internal();

  factory SettingProvider() {
    return _categorySingeton;
  }

  SettingProvider._internal();
}
