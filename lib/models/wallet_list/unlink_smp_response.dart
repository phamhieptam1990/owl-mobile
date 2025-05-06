import 'dart:convert';

UnlinkSmpResponse unlinkSmpResponseFromJson(String str) =>
    UnlinkSmpResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String unlinkSmpResponseToJson(UnlinkSmpResponse data) =>
    json.encode(data.toJson());

class UnlinkSmpResponse {
  UnlinkSmpResponse({
    required this.status,
    required this.data,
  });

  final int status;
  final UnlinkSmpResponseData data;

  factory UnlinkSmpResponse.fromJson(Map<String, dynamic> json) =>
      UnlinkSmpResponse(
        status: json["status"] as int? ?? 0,
        data: UnlinkSmpResponseData.fromJson(
            json["data"] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class UnlinkSmpResponseData {
  UnlinkSmpResponseData({
    required this.errorMessage,
    required this.errorCode,
    required this.aggId,
    required this.accountCode,
    required this.status,
    required this.data,
  });

  final String errorMessage;
  final String errorCode;
  final String aggId;
  final String accountCode;
  final String status;
  final SubUnlinkSmpResponseData data;

  factory UnlinkSmpResponseData.fromJson(Map<String, dynamic> json) =>
      UnlinkSmpResponseData(
        errorMessage: json["errorMessage"] as String? ?? '',
        errorCode: json["errorCode"] as String? ?? '',
        aggId: json["aggId"] as String? ?? '',
        accountCode: json["accountCode"] as String? ?? '',
        status: json["status"] as String? ?? '',
        data: SubUnlinkSmpResponseData.fromJson(
            json["data"] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "errorMessage": errorMessage,
        "errorCode": errorCode,
        "aggId": aggId,
        "accountCode": accountCode,
        "status": status,
        "data": data.toJson(),
      };
}

class SubUnlinkSmpResponseData {
  SubUnlinkSmpResponseData({
    required this.resultCode,
  });

  final String resultCode;

  factory SubUnlinkSmpResponseData.fromJson(Map<String, dynamic> json) =>
      SubUnlinkSmpResponseData(
        resultCode: json["resultCode"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "resultCode": resultCode,
      };
}