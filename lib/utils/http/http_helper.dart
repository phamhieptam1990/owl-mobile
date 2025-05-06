import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/config/enviroment/environment.dart';
import 'package:athena/models/devices_info_model.dart';
import 'package:athena/utils/http/interceptors/dio_logger.dart';
import 'package:athena/utils/idie/idieActivity.service.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import '../../widgets/common/common.dart';
import '../utils.dart';
import 'errors/unauthenticated_error.dart';
import 'errors/unauthorized_error.dart';
import 'interceptors/dio_firebase_performmance.dart';

class HttpHelper {
  static late Dio _client =Dio();
  static late DeviceInfoModel deviceInfo= DeviceInfoModel();
  static final HttpHelper _dioClient = HttpHelper._internal();
  static final BaseOptions baseOptions = BaseOptions();
  final Dio _dio = new Dio(baseOptions);
  Dio get dio => _dio;

  factory HttpHelper() {
    return _dioClient;
  }
  HttpHelper._internal();
  // final metric = FirebasePerformance.instance.newHttpMetric();
  static Future<Dio> _getInstance(
      {int typeContent = 1,
      bool withCookie = true,
      bool withToken = true,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      String methodType = HttpHelperConstant.METHOD_GET,
      var customHeader = ''}) async {
    try {
      final storageToken =
          await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
      _client.interceptors.clear();
      var headers = await buildHeaders(customHeader);
      if (methodType == HttpHelperConstant.METHOD_GET) {
        headers[APP_CONFIG.AUTHORIZATION] =
            APP_CONFIG.KEY_JWT + '$storageToken';
      } else {
        if (typeContent == HttpHelperConstant.INPUT_TYPE_JSON) {
          headers["Content-Type"] = HttpHelperConstant.APPLICATION_JSON;
          if (storageToken != '') {
            headers[APP_CONFIG.AUTHORIZATION] =
                APP_CONFIG.KEY_JWT + '$storageToken';
          }
        } else if (typeContent == HttpHelperConstant.INPUT_TYPE_FORM) {
          headers["Content-Type"] =
              HttpHelperConstant.APPLICATION_FORM_URLENCODED;
          headers[APP_CONFIG.AUTHORIZATION] =
              APP_CONFIG.KEY_JWT + '$storageToken';
        }
      }
      _client.options.connectTimeout = Duration(milliseconds: timeout);
      _client.options.headers = headers;
      if (Environment.value.enableLogger && !IS_PRODUCTION_APP) {
        _client.interceptors.add(PrettyDioLogger(requestBody: true));
      }
      _client.interceptors.add(getDioFirebasePerformanceInterceptor);
      // _client.httpClientAdapter = DefaultHttpClientAdapter()
      //   ..onHttpClientCreate = (HttpClient client) {
      //     CertSecurityContext certSecurityContext = getIt<CertSecurityContext>();
      //     return HttpClient(context: certSecurityContext.sc);
      //   };
      _client.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) {
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        return handler.next(response); // continue
      }, onError: (DioException error, handler) async {
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
            } else if (!Utils.checkIsNotNull(token) ||
                !Utils.checkIsNotNull(username)) {
              NavigationService.instance.navigationKey.currentState
                  ?.pushNamedAndRemoveUntil(
                      RouteList.LOGIN_SCREEN, (Route<dynamic> route) => false);
            }
          }
        }
        if (error.response?.statusCode == 403) {
          final storageToken2 =
              await StorageHelper.getString(AppStateConfigConstant.JWT);
          String page = Utils.getCurrentRoute();
          if (Utils.isString(error.response?.data) &&
              Utils.checkValueIsHTMLContent(error.response?.data)) {
            if (!page.contains('login') &&
                Utils.checkIsNotNull(storageToken2)) {
              if (error.response?.statusCode?.toString() != '403') {
                WidgetCommon.generateDialogOKGet(
    content: 'Vui lòng thử lại thao tác này. ${error.response?.statusCode ?? ''}'
                        );
              }
            }
          } else {
            if (!page.contains('login') &&
                Utils.checkIsNotNull(storageToken2)) {
              String path = '';
              if (Utils.checkIsNotNull(error.requestOptions.path)) {
                path = error.requestOptions.path;
              } else {
                path = Utils.returnDataStrNew(error.response?.data['path']);
              }
              WidgetCommon.generateDialogOKGet(
                      content: 'Bạn không có quyền truy cập chức năng này ${error.response?.statusCode ?? ''} ${path}'
                  );
            }
          }
        }
        if (error.type == DioExceptionType.connectionTimeout) {
          _client.close(force: true);
        }
        return handler.next(error); //continue
      }));
      return _client;
    } catch (e) {
      throw e;
    }
  }

  static Future<Dio> _getInstanceNew(
      {String token = '',
      int typeContent = 1,
      bool withCookie = true,
      bool withToken = true,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      String methodType = HttpHelperConstant.METHOD_GET,
      var customHeader = ''}) async {
    try {
      _client.interceptors.clear();
      var headers = await buildHeaders(customHeader);
      if (methodType == HttpHelperConstant.METHOD_GET) {
        headers[APP_CONFIG.AUTHORIZATION] = APP_CONFIG.KEY_JWT + '$token';
      } else {
        if (typeContent == HttpHelperConstant.INPUT_TYPE_JSON) {
          headers["Content-Type"] = HttpHelperConstant.APPLICATION_JSON;
          if (token != '') {
            headers[APP_CONFIG.AUTHORIZATION] = APP_CONFIG.KEY_JWT + '$token';
          }
        } else if (typeContent == HttpHelperConstant.INPUT_TYPE_FORM) {
          headers["Content-Type"] =
              HttpHelperConstant.APPLICATION_FORM_URLENCODED;
          headers[APP_CONFIG.AUTHORIZATION] = APP_CONFIG.KEY_JWT + '$token';
        }
      }
      _client.options.connectTimeout = Duration(milliseconds: timeout);
      _client.options.headers = headers;
      if (Environment.value.enableLogger && !IS_PRODUCTION_APP) {
        _client.interceptors.add(PrettyDioLogger(requestBody: true));
      }
      _client.interceptors.add(getDioFirebasePerformanceInterceptor);
      // _client.httpClientAdapter = DefaultHttpClientAdapter()
      //   ..onHttpClientCreate = (HttpClient client) {
      //     CertSecurityContext certSecurityContext = getIt<CertSecurityContext>();
      //     return HttpClient(context: certSecurityContext.sc);
      //   };
      _client.interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) {
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        return handler.next(response); // continue
      }, onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          IdieActivity.instance.isLogout = true;
          final token =
              await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN);
          final username =
              await StorageHelper.getString(AppStateConfigConstant.USER_NAME);
          // Nếu đang ở page login thì ta ko cần check điều kiện này
          if (IdieActivity.instance.isLoginPage == false) {
            if (Utils.checkIsNotNull(token) && Utils.checkIsNotNull(username)) {
              // Truong hop da login 1 lan
              NavigationService.instance.navigationKey.currentState
                  ?.pushNamedAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN,
                      (Route<dynamic> route) => false);
            } else if (!Utils.checkIsNotNull(token) ||
                !Utils.checkIsNotNull(username)) {
              NavigationService.instance.navigationKey.currentState
                  ?.pushNamedAndRemoveUntil(
                      RouteList.LOGIN_SCREEN, (Route<dynamic> route) => false);
            }
          }
        }
        return handler.next(error); //continue
      }));
      return _client;
    } catch (e) {
      throw e;
    }
  }

  static buildHeaders(String customeHeader) async {
    var headers = {'Accept': HttpHelperConstant.ACCEPT_ALL};
    bool isAndroid = Platform.isAndroid ? true : false;
    if (!Utils.checkIsNotNull(deviceInfo)) {
      deviceInfo = await Utils.getDeviceInfoModel();
    }
    String location = '';
    // if (PermissionAppService.lastPosition != null && Utils.checkIsNotNull(PermissionAppService.lastPosition)) {
    //   location = PermissionAppService.lastPosition?.longitude?.toString() +
    //       ',' +
    //       PermissionAppService.lastPosition.latitude.toString() +
    //       ',' +
    //       PermissionAppService.lastPosition.accuracy.toString();
    // }
    String screen = '';
    String module = '';
    headers['x-athena-app-version'] = Utils.showVersionApp();
    if (isAndroid) {
      headers['x-athena-os'] = 'Android';
    } else {
      headers['x-athena-os'] = 'IOS';
    }
    if (Utils.checkIsNotNull(deviceInfo.systemVersionStr)) {
      headers['x-athena-os-version'] = deviceInfo.systemVersionStr.toString();
    } else {
      headers['x-athena-os-version'] = deviceInfo.systemVersion.toString();
    }
    headers['x-athena-imei'] = deviceInfo.imei ?? '';
    headers['x-athena-model'] = deviceInfo.model ?? '';
    headers['x-athena-manufacter'] = '';
    headers['x-athena-trace-location'] = location;
    headers['x-athena-module-type'] = module;
    headers['x-athena-screen'] = screen;
    return headers;
  }

  static Future<Response> get(String url,
      {int typeContent = HttpHelperConstant.INPUT_TYPE_FORM,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      bool withCookie = true,
      bool withToken = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: withCookie,
          withToken: withToken,
          methodType: HttpHelperConstant.METHOD_GET);

      final response = await instance.get(url);
      // if (response.data != null) {
      //   final d = await _client.fetch(response.data);
      //   print(d);
      // }
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      throw e;
    }
  }

  static Future<Response> getWithoutToken(String url,
      {int typeContent = HttpHelperConstant.INPUT_TYPE_FORM,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      bool withCookie = true,
      bool withToken = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: false,
          withToken: false,
          methodType: HttpHelperConstant.METHOD_GET);
      Response response = await instance.get(url);
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      throw e;
    }
  }

  static Future<Response<dynamic>> getList(String url,
      {int typeContent = 1,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      bool withCookie = true,
      bool withToken = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: withCookie,
          withToken: withToken,
          methodType: HttpHelperConstant.METHOD_GET);
      return instance.get(url);
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      throw e;
    }
  }

  static Future<Response> post(String url,
      {dynamic body,
      int typeContent = 1,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      bool withToken = true,
      bool withCookie = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: true,
          withToken: true,
          methodType: HttpHelperConstant.METHOD_POST);
      final response = await instance.post(url,
          data: body,
          options:
              new Options(contentType: HttpHelperConstant.APPLICATION_JSON));
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      throw e;
    }
  }

  static Future<Response> postForm(String url,
      {dynamic body,
      int typeContent = 1,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      bool withToken = true,
      bool withCookie = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: true,
          withToken: true,
          methodType: HttpHelperConstant.METHOD_POST);
      Response response = await instance.post(url,
          data: body,
          options: new Options(
              contentType: HttpHelperConstant.APPLICATION_FORM_URLENCODED));
      //  metric
      //     ..responsePayloadSize = response.contentLength
      //     ..responseContentType = response.headers['Content-Type']
      //     ..requestPayloadSize = request.contentLength
      //     ..httpResponseCode = response.statusCode;
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      throw e;
    }
  }

  // handle new postfrom tra ve data not json
  static Future<Response> newPostForm(String url,
      {dynamic body,
      int typeContent = 1,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      bool withToken = true,
      bool withCookie = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: withCookie,
          withToken: withToken,
          methodType: HttpHelperConstant.METHOD_POST);
          
      final response = await instance.post(
        url,
        data: body,
        options: Options(
          contentType: HttpHelperConstant.APPLICATION_FORM_URLENCODED
        )
      );
      
      if (Utils.checkRequestIsComplete(response)) {
        final data = Utils.handleRequestData2Level(response);
        return data;
      }
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      throw e;
    }
  }

  // handle new postJSON tra ve data not json
  static Future<Response> newPostJSON(String url,
      {dynamic body,
      int typeContent = 1,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      bool withToken = true,
      bool withCookie = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: withCookie,
          withToken: withToken,
          methodType: HttpHelperConstant.METHOD_POST);

      final response = await instance.post(
        url,
        data: body,
        options: Options(contentType: HttpHelperConstant.APPLICATION_JSON)
      );
      
      if (Utils.checkRequestIsComplete(response)) {
        return Utils.handleRequestData2Level(response);
      }
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      debugPrint('Error in newPostJSON for URL: $url - ${e.toString()}');
      throw e;
    }
  }

  static Future<Response> postJSON(String url,
      {dynamic body,
      int typeContent = 1,
      int timeout = APP_CONFIG.COMMAND_TIME_OUT_60,
      bool withToken = true,
      bool withCookie = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: withCookie,
          withToken: withToken,
          methodType: HttpHelperConstant.METHOD_POST);

      final response = await instance.post(
        url,
        data: body,
        options: Options(contentType: HttpHelperConstant.APPLICATION_JSON)
      );
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      debugPrint('Error in postJSON for URL: $url - ${e.toString()}');
      throw e;
    }
  }

  static Future<Response> postJSONNew(String url,
      {dynamic body,
      String token = '',
      int typeContent = 1,
      int timeout = APP_CONFIG.COMMAND_TIME_OUT_60,
      bool withToken = true,
      bool withCookie = true}) async {
    try {
      final instance = await _getInstanceNew(
          token: token,
          timeout: timeout,
          typeContent: typeContent,
          withCookie: withCookie,
          withToken: withToken,
          methodType: HttpHelperConstant.METHOD_POST);

      final response = await instance.post(
        url,
        data: body,
        options: Options(contentType: HttpHelperConstant.APPLICATION_JSON)
      );
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      debugPrint('Error in postJSONNew for URL: $url - ${e.toString()}');
      throw e;
    }
  }

  static Future<Response> getJSONNew(String url,
      {dynamic body,
      String token = '',
      int typeContent = 1,
      int timeout = APP_CONFIG.COMMAND_TIME_OUT_60,
      bool withToken = true,
      bool withCookie = true}) async {
    try {
      final instance = await _getInstanceNew(
          token: token,
          timeout: timeout,
          typeContent: typeContent,
          withCookie: true,
          withToken: true,
          methodType: HttpHelperConstant.METHOD_GET);

      final response = await instance.get(url,
          options:
              new Options(contentType: HttpHelperConstant.APPLICATION_JSON));
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      print(url);
      throw e;
    }
  }

  static Future<Response> postFormBaseReponse(String url,
      {dynamic body,
      int typeContent = 1,
      int timeout = APP_CONFIG.QUERY_TIME_OUT,
      bool withToken = true,
      bool withCookie = true}) async {
    try {
      final instance = await _getInstance(
          timeout: timeout,
          typeContent: typeContent,
          withCookie: true,
          withToken: true,
          methodType: HttpHelperConstant.METHOD_POST);
      final response = await instance.post(url,
          data: body,
          options: new Options(
              contentType: HttpHelperConstant.APPLICATION_FORM_URLENCODED));
      return response;
    } on UnauthorizedError {
      throw UnauthenticatedError();
    } on DioException catch (e) {
      throw e;
    }
  }

  static DioFirebasePerformanceInterceptor
      get getDioFirebasePerformanceInterceptor =>
          DioFirebasePerformanceInterceptor(trackingEndpoint: [
            MCR_TICKET_SERVICE_URL.CHECK_IN,
            MCR_CUSTOMER_SERVICE_URL.GET_CONTRACT_BY_AGGID,
            DMS_SERVICE_URL.UPLOAD_FILE,
            MCR_FEA_URL.GET_APPIDS_NEW,
            MCR_FEA_URL.GET_DOC_ID,
            MCR_FEA_URL.REVERSE_MAP,
            MCR_TICKET_SERVICE_URL.PIVOT_PAGING,
            MCR_TICKET_SERVICE_URL.GET_TICKET,
          ]);
}
