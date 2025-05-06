import 'dart:convert';

QueryLinkPaymentEwalletResponse queryLinkPaymentEwalletResponseFromJson(
        String str) =>
    QueryLinkPaymentEwalletResponse.fromJson(
        json.decode(str) as Map<String, dynamic>);

String queryLinkPaymentEwalletResponseToJson(
        QueryLinkPaymentEwalletResponse data) =>
    json.encode(data.toJson());

class QueryLinkPaymentEwalletResponse {
  QueryLinkPaymentEwalletResponse({
    required this.status,
    required this.data,
  });

  final int status;
  final QueryLinkPaymentEwalletResponseData data;

  QueryLinkPaymentEwalletResponse copyWith({
    int? status,
    QueryLinkPaymentEwalletResponseData? data,
  }) =>
      QueryLinkPaymentEwalletResponse(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory QueryLinkPaymentEwalletResponse.fromJson(Map<String, dynamic> json) =>
      QueryLinkPaymentEwalletResponse(
        status: json["status"] as int? ?? 0,
        data: json["data"] == null
            ? QueryLinkPaymentEwalletResponseData(
                errorMessage: '',
                errorCode: '',
                aggId: '',
                data: null)
            : QueryLinkPaymentEwalletResponseData.fromJson(
                json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class QueryLinkPaymentEwalletResponseData {
  QueryLinkPaymentEwalletResponseData({
    required this.errorMessage,
    required this.errorCode,
    required this.aggId,
    this.data,
  });

  final String errorMessage;
  final String errorCode;
  final String aggId;
  final QueryLinkData? data;

  factory QueryLinkPaymentEwalletResponseData.fromJson(
          Map<String, dynamic> json) =>
      QueryLinkPaymentEwalletResponseData(
        errorMessage: json["errorMessage"] as String? ?? '',
        errorCode: json["errorCode"] as String? ?? '',
        aggId: json["aggId"] as String? ?? '',
        data: json["data"] == null
            ? null
            : QueryLinkData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "errorMessage": errorMessage,
        "errorCode": errorCode,
        "aggId": aggId,
        "data": data?.toJson(),
      };
}

class QueryLinkData {
  QueryLinkData({
    required this.linkageUrl,
    required this.scheme,
    required this.packageId,
  });

  final String linkageUrl;
  final String scheme;
  final String packageId;

  factory QueryLinkData.fromJson(Map<String, dynamic> json) => QueryLinkData(
        linkageUrl: json["linkageUrl"] as String? ?? '',
        scheme: json["scheme"] as String? ?? '',
        packageId: json["packageId"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "linkageUrl": linkageUrl,
        "scheme": scheme,
        "packageId": packageId,
      };
}