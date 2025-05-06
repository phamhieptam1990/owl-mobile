import 'dart:convert';

LinkPaymentEwalletResponse linkPaymentEwalletResponseFromJson(String str) =>
    LinkPaymentEwalletResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String linkPaymentEwalletResponseToJson(LinkPaymentEwalletResponse data) =>
    json.encode(data.toJson());

class LinkPaymentEwalletResponse {
  LinkPaymentEwalletResponse({
    this.status,
    this.data,
  });

  final int? status;
  final LinkPaymentEwalletResponseData? data;

  LinkPaymentEwalletResponse copyWith({
    int? status,
    LinkPaymentEwalletResponseData? data,
  }) =>
      LinkPaymentEwalletResponse(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory LinkPaymentEwalletResponse.fromJson(Map<String, dynamic> json) =>
      LinkPaymentEwalletResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : LinkPaymentEwalletResponseData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class LinkPaymentEwalletResponseData {
  LinkPaymentEwalletResponseData({
    this.errorMessage,
    this.errorCode,
    this.aggId,
    this.transId,
    this.accountCode,
    this.status,
    this.data,
  });

  final String? errorMessage;
  final String? errorCode;
  final String? aggId;
  final String? transId;
  final String? accountCode;
  final String? status;
  final SmpData? data;

  LinkPaymentEwalletResponseData copyWith({
    String? errorMessage,
    String? errorCode,
    String? aggId,
    String? transId,
    String? accountCode,
    String? status,
    SmpData? data,
  }) =>
      LinkPaymentEwalletResponseData(
        errorMessage: errorMessage ?? this.errorMessage,
        errorCode: errorCode ?? this.errorCode,
        aggId: aggId ?? this.aggId,
        transId: transId ?? this.transId,
        accountCode: accountCode ?? this.accountCode,
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory LinkPaymentEwalletResponseData.fromJson(Map<String, dynamic> json) =>
      LinkPaymentEwalletResponseData(
        errorMessage: json["errorMessage"],
        errorCode: json["errorCode"],
        aggId: json["aggId"],
        transId: json["transId"],
        accountCode: json["accountCode"],
        status: json["status"],
        data: json["data"] == null ? null : SmpData.fromJson(json["data"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "errorMessage": errorMessage,
        "errorCode": errorCode,
        "aggId": aggId,
        "transId": transId,
        "accountCode": accountCode,
        "status": status,
        "data": data?.toJson(),
      };
}

class SmpData {
  SmpData({
    this.resultCode,
    this.scheme,
    this.linkageUrl,
    this.packageId,
  });

  final String? resultCode;
  final String? scheme;
  final String? linkageUrl;
  final String? packageId;

  SmpData copyWith({
    String? resultCode,
    String? scheme,
    String? linkageUrl,
    String? packageId,
  }) =>
      SmpData(
        resultCode: resultCode ?? this.resultCode,
        scheme: scheme ?? this.scheme,
        linkageUrl: linkageUrl ?? this.linkageUrl,
        packageId: packageId ?? this.packageId,
      );

  factory SmpData.fromJson(Map<String, dynamic> json) => SmpData(
        resultCode: json["resultCode"],
        scheme: json["scheme"],
        linkageUrl: json["linkageUrl"],
        packageId: json["packageId"],
      );

  Map<String, dynamic> toJson() => {
        "resultCode": resultCode,
        "scheme": scheme,
        "linkageUrl": linkageUrl,
        "packageId": packageId,
      };
}