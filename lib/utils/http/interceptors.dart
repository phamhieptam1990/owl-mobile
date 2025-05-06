import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  @override
  Future<dynamic> onError(
      DioException dioError, ErrorInterceptorHandler handler) async {}

  @override
  Future<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    response.headers.forEach((k, v) => print('$k: $v'));
  }
}
