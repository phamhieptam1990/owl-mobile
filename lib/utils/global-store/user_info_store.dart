import 'package:flutter/widgets.dart';
import '../../models/userInfo.model.dart';

class UserInfoStore with ChangeNotifier {
  // Make user nullable and initialize with late
  late UserInfoModel _userEntity;
  UserInfoModel? user;

  bool unread = false;
  String totalLength = '0';
  List<dynamic> lstRoles = [];

  bool get aActive => unread;
  String get getTotalLength => totalLength;

  UserInfoStore() {
    _userEntity = UserInfoModel(); // Khởi tạo _userEntity mặc định
    getUser();
  }

  // setTotalLength
  void setTotalLength(BuildContext context, String value, String title) {
    totalLength = value;
    notifyListeners();
  }

  void setUnread(bool value) {
    unread = value;
    notifyListeners();
  }

  void updateUser(UserInfoModel entity) {
    _userEntity = entity;
    user = entity;
    // MyApp.initScopeSentry(
    //     user?.username, user?.fullName, user?.moreInfo['empCode']);
    notifyListeners();
  }

  UserInfoModel getUser() {
    // Nếu _userEntity vẫn là giá trị mặc định, bạn có thể tạo logic khởi tạo lại ở đây
    if (_userEntity == UserInfoModel()) {
      // Xử lý khi _userEntity chưa được gán giá trị đúng
    }
    return _userEntity;
  }

  void clearStore() {
    user = null;
    lstRoles = [];
    notifyListeners();
  }

  bool checkPerimission(String name) {
    if (user == null) {
      return false;
    }

    // Check if permissions exists and is not empty
    if (user?.permissions?.isNotEmpty ?? false) {
      for (var item in user!.permissions!) {
        if (item.target == name) {
          return true;
        }
      }
    }

    return false;
  }

  bool checkRoles(String name) {
    // Check if user is null
    try {
      if (user == null) {
        return false;
      }

      // Get authorities with null safety
      lstRoles = user?.authorities ?? [];

      for (final role in lstRoles) {
        if (role?.authority == name) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String getTenantCode() {
    // Check if user is null using safe navigation
    if (user == null) {
      return '';
    }

    // Access moreInfo safely
    final moreInfo = user?.moreInfo;
    if (moreInfo == null) {
      return '';
    }

    // Access tenantCode safely
    final tenantCode = moreInfo['tenantCode'];
    if (tenantCode == null) {
      return '';
    }

    return tenantCode.toString();
  }
}
