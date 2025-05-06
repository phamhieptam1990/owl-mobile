import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

import '../../../common/constants/general.dart';
import '../../storage/storage_helper.dart';

class DioFirebasePerformanceInterceptor extends Interceptor {
  DioFirebasePerformanceInterceptor({
    List<String>? trackingEndpoint,
    this.requestContentLengthMethod = defaultRequestContentLength,
    this.responseContentLengthMethod = defaultResponseContentLength,
  }) : _trackingEndpoint = trackingEndpoint ?? [];

  final Map<int, HttpMetric> _map = {};
  final List<String> _trackingEndpoint;
  final RequestContentLengthMethod requestContentLengthMethod;
  final ResponseContentLengthMethod responseContentLengthMethod;
  String userAttribute = "User";

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final url = options.path;
    if (isTracking(url)) {
      final metric = FirebasePerformance.instance.newHttpMetric(
          options.uri.normalized(), options.method.asHttpMethod() ?? HttpMethod.Get);

      final requestKey = options.extra.hashCode;
      _map[requestKey] = metric;
      final requestContentLength = requestContentLengthMethod(options);
      String userName =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      metric.putAttribute(userAttribute, userName);
      await metric.start();
      if (requestContentLength != null) {
        metric.requestPayloadSize = requestContentLength;
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    var url = response.requestOptions.path;
    if (isTracking(url)) {
      final requestKey = response.requestOptions.extra.hashCode;
      final metric = _map[requestKey];
      if (metric != null) {
        metric.setResponse(response, responseContentLengthMethod);
        await metric.stop();
        _map.remove(requestKey);
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String url = err.requestOptions.path;
    if (isTracking(url)) {
      final requestKey = err.requestOptions.extra.hashCode;
      final metric = _map[requestKey];
      if (metric != null && err.response != null) {
        metric.setResponse(err.response!, responseContentLengthMethod);
        await metric.stop();
        _map.remove(requestKey);
      }
    }
    handler.next(err);
  }

  bool isTracking(String url) {
    try {
      for (var element in _trackingEndpoint) {
        if (url.trim().contains(element.trim())) {
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error in isTracking: $e');
      return false;
    }
  }
}

typedef RequestContentLengthMethod = int? Function(RequestOptions options);
int? defaultRequestContentLength(RequestOptions options) {
  if (options.data is String || options.data is Map) {
    return options.headers.toString().length +
        (options.data?.toString().length ?? 0);
  }
  return null;
}

typedef ResponseContentLengthMethod = int? Function(Response options);
int? defaultResponseContentLength(Response response) {
  if (response.data is String) {
    return (response.headers.toString().length) + (response.data as String).length;
  }
  return null;
}

extension _ResponseHttpMetric on HttpMetric {
  void setResponse(
      Response value, ResponseContentLengthMethod responseContentLengthMethod) {
    final responseContentLength = responseContentLengthMethod(value);
    if (responseContentLength != null) {
      responsePayloadSize = responseContentLength;
    }
    
    final contentType = value.headers.value(Headers.contentTypeHeader);
    if (contentType != null) {
      responseContentType = contentType;
    }
    
    httpResponseCode = value.statusCode;
  }
}

extension _UriHttpMethod on Uri {
  String normalized() {
    return "$scheme://$host$path";
  }
}

extension _StringHttpMethod on String {
  HttpMethod? asHttpMethod() {
    switch (toUpperCase()) {
      case "POST":
        return HttpMethod.Post;
      case "GET":
        return HttpMethod.Get;
      case "DELETE":
        return HttpMethod.Delete;
      case "PUT":
        return HttpMethod.Put;
      case "PATCH":
        return HttpMethod.Patch;
      case "OPTIONS":
        return HttpMethod.Options;
      default:
        return null;
    }
  }
}