// To parse this JSON data, do
//
//     final allByEmpCodeResponse = allByEmpCodeResponseFromJson(jsonString);

import 'dart:convert';

AllByEmpCodeResponse allByEmpCodeResponseFromJson(String str) =>
    AllByEmpCodeResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String allByEmpCodeResponseToJson(AllByEmpCodeResponse data) =>
    json.encode(data.toJson());

class AllByEmpCodeResponse {
  AllByEmpCodeResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<AllByEmpCodeData>? data;

  factory AllByEmpCodeResponse.fromJson(Map<String, dynamic> json) =>
      AllByEmpCodeResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<AllByEmpCodeData>.from(
                (json["data"] as List).map(
                  (x) => AllByEmpCodeData.fromJson(x as Map<String, dynamic>),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? null
            : List<dynamic>.from((data??[]).map((x) => x.toJson())),
      };
}

class AllByEmpCodeData {
  AllByEmpCodeData({
    this.methodCode,
    this.makerDate,
    this.authStatus,
    this.providerNo,
    this.providerCode,
    this.providerName,
    this.appCode,
    this.tenantCode,
    this.recordStatus,
    this.empCode,
    this.checkerDate,
    this.checkerId,
    this.id,
    this.aggId,
    this.statusCode,
    this.makerId,
  });

  final String? methodCode;
  final int? makerDate;
  final String? authStatus;
  final String? providerNo;
  final String? providerCode;
  final String? providerName;
  final String? appCode;
  final String? tenantCode;
  final String? recordStatus;
  final String? empCode;
  final int? checkerDate;
  final String? checkerId;
  final int? id;
  String? aggId;
  final String? statusCode;
  final String? makerId;

  StatusCodeLinked get statusCodeLinked => _parsingStatusCode();
  WalletType get walletType => getWalletType();
  String get statusCodeString => getStatusCodeString();

  StatusCodeLinked _parsingStatusCode() {
    if (statusCode == null) return StatusCodeLinked.failed;
    
    switch (statusCode) {
      case 'PROCESSING':
        return StatusCodeLinked.processing;
      case 'SUCCESS':
        return StatusCodeLinked.success;
      case 'UNLINK':
        return StatusCodeLinked.unlink;
      case 'FAILED':
        return StatusCodeLinked.failed;
      default:
        return StatusCodeLinked.failed;
    }
  }

  WalletType getWalletType() {
    if (providerCode == null) return WalletType.unknow;
    
    switch (providerCode) {
      case 'SMARTPAY-EWALLET':
        return WalletType.smartPay;
      case 'MOMO-EWALLET':
        return WalletType.momo;
      case 'MOCA-EWALLET':
        return WalletType.moca;
      default:
        return WalletType.unknow;
    }
  }

  String getStatusCodeString() {
    if (statusCode == null) return 'Chưa liên kết';
    
    switch (statusCode) {
      case 'SUCCESS':
        return 'Đã liên kết';
      case 'PROCESSING':
        return 'Đang liên kết';
      case 'FAILED':
        return 'Chưa liên kết';
      case 'UNLINK':
        return 'Chưa liên kết';
      default:
        return 'Chưa liên kết';
    }
  }

  factory AllByEmpCodeData.fromJson(Map<String, dynamic> json) =>
      AllByEmpCodeData(
        methodCode: json["methodCode"],
        makerDate: json["makerDate"],
        authStatus: json["authStatus"],
        providerNo: json["providerNo"],
        providerCode: json["providerCode"],
        providerName: json["providerName"],
        appCode: json["appCode"],
        tenantCode: json["tenantCode"],
        recordStatus: json["recordStatus"],
        empCode: json["empCode"],
        checkerDate: json["checkerDate"],
        checkerId: json["checkerId"],
        id: json["id"],
        aggId: json["aggId"],
        statusCode: json["statusCode"],
        makerId: json["makerId"],
      );

  Map<String, dynamic> toJson() => {
        "methodCode": methodCode,
        "makerDate": makerDate,
        "authStatus": authStatus,
        "providerNo": providerNo,
        "providerCode": providerCode,
        "providerName": providerName,
        "appCode": appCode,
        "tenantCode": tenantCode,
        "recordStatus": recordStatus,
        "empCode": empCode,
        "checkerDate": checkerDate,
        "checkerId": checkerId,
        "id": id,
        "aggId": aggId,
        "statusCode": statusCode,
        "makerId": makerId,
      };

  AllByEmpCodeData copyWith({
    String? methodCode,
    int? makerDate,
    String? authStatus,
    String? providerNo,
    String? providerCode,
    String? providerName,
    String? appCode,
    String? tenantCode,
    String? recordStatus,
    String? empCode,
    int? checkerDate,
    String? checkerId,
    int? id,
    String? aggId,
    String? statusCode,
    String? makerId,
  }) =>
      AllByEmpCodeData(
        methodCode: methodCode ?? this.methodCode,
        makerDate: makerDate ?? this.makerDate,
        authStatus: authStatus ?? this.authStatus,
        providerNo: providerNo ?? this.providerNo,
        providerCode: providerCode ?? this.providerCode,
        providerName: providerName ?? this.providerName,
        appCode: appCode ?? this.appCode,
        tenantCode: tenantCode ?? this.tenantCode,
        recordStatus: recordStatus ?? this.recordStatus,
        empCode: empCode ?? this.empCode,
        checkerDate: checkerDate ?? this.checkerDate,
        checkerId: checkerId ?? this.checkerId,
        id: id ?? this.id,
        aggId: aggId ?? this.aggId,
        statusCode: statusCode ?? this.statusCode,
        makerId: makerId ?? this.makerId,
      );
}

enum StatusCodeLinked { processing, success, unlink, failed, unknow }

enum WalletType { smartPay, momo, moca, unknow }