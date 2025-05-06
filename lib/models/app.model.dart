import 'package:flutter/material.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/utils/storage/storage_helper.dart';

class AppModel with ChangeNotifier {
  Map<String, dynamic>? appConfig;
  bool isLoading = true;
  String? message;
  bool darkTheme = false;
  String locale = 'vi';
  String? productListLayout;
  String? currency; //USD, VND
  bool showDemo = false;
  String username = '';
  bool isInit = false;
  Function(int)? navigateTab;

  AppModel();

  void updateNavigateTab(Function(int) value) {
    navigateTab = value;
    notifyListeners();
  }

  void updateUsername(String user) {
    username = user;
    notifyListeners();
  }

  Future<Locale> getLocale() async {
    final locale = await StorageHelper.getString('locale') ?? 'vi';
    return Locale(locale);
  }

  Future<void> setLocale(String localeText) async {
    locale = localeText;
    await StorageHelper.setString(AppStateConfigConstant.LANGUAGE, localeText);
    notifyListeners();
  }
}

class App {
  final Map<String, dynamic> appConfig;

  App(this.appConfig);
}