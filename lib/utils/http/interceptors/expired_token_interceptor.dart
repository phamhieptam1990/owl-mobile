// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// import '../../../common/constants/general.dart';
// import '../../../common/constants/routes.dart';
// import '../../idie/idieActivity.service.dart';
// import '../../navigation/navigation.service.dart';
// import '../../storage/storage_helper.dart';
// import '../../utils.dart';

// class ExpriedTokenInterceptor extends InterceptorsWrapper {
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     super.onResponse(response, handler);
//   }

//   @override
//   void onError(DioError err, ErrorInterceptorHandler handler) async {
//     if (err?.response?.statusCode == 401) {
//       IdieActivity.instance.isLogout = true;
//       final token =
//           await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN);
//       final username =
//           await StorageHelper.getString(AppStateConfigConstant.USER_NAME);
//       // Nếu đang ở page login thì ta ko cần check điều kiện này
//       if (IdieActivity.instance.isLoginPage == false) {
//         if (Utils.checkIsNotNull(token) && Utils.checkIsNotNull(username)) {
//           // Truong hop da login 1 lan
//           NavigationService.instance.navigationKey.currentState
//               .pushNamedAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN,
//                   (Route<dynamic> route) => false);
//         } else if (!Utils.checkIsNotNull(token) ||
//             !Utils.checkIsNotNull(username)) {
//           NavigationService.instance.navigationKey.currentState
//               .pushNamedAndRemoveUntil(
//                   RouteList.LOGIN_SCREEN, (Route<dynamic> route) => false);
//         }
//       }
//     }
//     super.onError(err, handler);
//   }


//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     // TODO: implement onRequest
//     super.onRequest(options, handler);
//   }
// }
