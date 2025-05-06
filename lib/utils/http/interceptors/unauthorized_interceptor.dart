import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/utils/http/errors/unauthorized_error.dart';
import 'package:athena/utils/idie/idieActivity.service.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/utils/utils.dart';

class UnauthorizedInterceptor extends Interceptor {
  @override
  Future onError(DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      IdieActivity.instance.isLogout = true;
      final token =
          await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN)??'';
      final username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME)??'';
      // Nếu đang ở page login thì ta ko cần check điều kiện này
      if (IdieActivity.instance.isLoginPage == false) {
        if (Utils.checkIsNotNull(token) && Utils.checkIsNotNull(username)) {
          // Truong hop da login 1 lan
          NavigationService.instance.navigationKey.currentState
              ?.pushNamedAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN,
                  (Route<dynamic> route) => false);
          return null;
        }
        if (!Utils.checkIsNotNull(token) || !Utils.checkIsNotNull(username)) {
          NavigationService.instance.navigationKey.currentState
              ?.pushNamedAndRemoveUntil(
                  RouteList.LOGIN_SCREEN, (Route<dynamic> route) => false);
          return null;
        }
      }
      return null;
    }
    if (error.response?.statusCode == 403) {
      return UnauthorizedError();
    }
    return UnauthorizedError();
    // return null;
  }
}
