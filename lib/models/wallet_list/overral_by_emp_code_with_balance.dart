// To parse this JSON data, do
//
//     final overallByEmpCodeWithBalanceResponse = overallByEmpCodeWithBalanceResponseFromJson(jsonString);

import 'dart:convert';

OverallByEmpCodeWithBalanceResponse overallByEmpCodeWithBalanceResponseFromJson(
        String str) =>
    OverallByEmpCodeWithBalanceResponse.fromJson(
        json.decode(str) as Map<String, dynamic>);

String overallByEmpCodeWithBalanceResponseToJson(
        OverallByEmpCodeWithBalanceResponse data) =>
    json.encode(data.toJson());

class OverallByEmpCodeWithBalanceResponse {
  OverallByEmpCodeWithBalanceResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<OverallByEmpCodeWithBalanceData>? data;

  OverallByEmpCodeWithBalanceResponse copyWith({
    int? status,
    List<OverallByEmpCodeWithBalanceData>? data,
  }) =>
      OverallByEmpCodeWithBalanceResponse(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory OverallByEmpCodeWithBalanceResponse.fromJson(
          Map<String, dynamic> json) =>
      OverallByEmpCodeWithBalanceResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<OverallByEmpCodeWithBalanceData>.from(
                (json["data"] as List).map(
                  (x) => OverallByEmpCodeWithBalanceData.fromJson(
                      x as Map<String, dynamic>),
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

class OverallByEmpCodeWithBalanceData {
  OverallByEmpCodeWithBalanceData({
    this.providerName,
    this.tenantCode,
    this.appCode,
    this.empCode,
    this.methodCode,
    this.methodName,
    this.priority,
    this.balance,
    this.id,
    this.providerCode,
    this.statusCode,
    this.resultCode,
    this.accountNo,
    this.aggId,
    this.createDate,
  });

  final String? providerName;
  final String? tenantCode;
  final String? appCode;
  final String? empCode;
  final String? methodCode;
  final String? methodName;
  final int? priority;
  final int? balance;
  final int? id;
  final String? providerCode;
  final String? statusCode;
  final String? resultCode;
  final String? accountNo;
  final String? aggId;
  final int? createDate;
  
  bool get showBalance => statusCode == 'SUCCESS';
  bool get enableFocus =>
      providerCode == 'CASH' ||
      (statusCode == 'SUCCESS' && balance != null && balance! > 0);

  bool get isWallet => providerCode != 'CASH';
  
  WalletType getWalletType() {
    if (providerCode == null) return WalletType.unknow;
    
    switch (providerCode) {
      case 'CASH':
        return WalletType.cash;
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

  OverallByEmpCodeWithBalanceData copyWith({
    String? providerName,
    String? tenantCode,
    String? appCode,
    String? empCode,
    String? methodCode,
    String? methodName,
    int? priority,
    int? balance,
    int? id,
    String? providerCode,
    String? statusCode,
    String? resultCode,
    String? accountNo,
    String? aggId,
    int? createDate,
  }) =>
      OverallByEmpCodeWithBalanceData(
        providerName: providerName ?? this.providerName,
        tenantCode: tenantCode ?? this.tenantCode,
        appCode: appCode ?? this.appCode,
        empCode: empCode ?? this.empCode,
        methodCode: methodCode ?? this.methodCode,
        methodName: methodName ?? this.methodName,
        priority: priority ?? this.priority,
        balance: balance ?? this.balance,
        id: id ?? this.id,
        providerCode: providerCode ?? this.providerCode,
        statusCode: statusCode ?? this.statusCode,
        resultCode: resultCode ?? this.resultCode,
        accountNo: accountNo ?? this.accountNo,
        aggId: aggId ?? this.aggId,
        createDate: createDate ?? this.createDate,
      );

  factory OverallByEmpCodeWithBalanceData.fromJson(Map<String, dynamic> json) =>
      OverallByEmpCodeWithBalanceData(
        providerName: json["providerName"],
        tenantCode: json["tenantCode"],
        appCode: json["appCode"],
        empCode: json["empCode"],
        methodCode: json["methodCode"],
        methodName: json["methodName"],
        priority: json["priority"],
        balance: json["balance"],
        id: json["id"],
        providerCode: json["providerCode"],
        statusCode: json["statusCode"],
        resultCode: json["resultCode"],
        accountNo: json["accountNo"],
        aggId: json["aggId"],
        createDate: json["createDate"],
      );

  Map<String, dynamic> toJson() => {
        "providerName": providerName,
        "tenantCode": tenantCode,
        "appCode": appCode,
        "empCode": empCode,
        "methodCode": methodCode,
        "methodName": methodName,
        "priority": priority,
        "balance": balance,
        "id": id,
        "providerCode": providerCode,
        "statusCode": statusCode,
        "resultCode": resultCode,
        "accountNo": accountNo,
        "aggId": aggId,
        "createDate": createDate,
      };
}

enum WalletType { cash, smartPay, momo, moca, unknow }