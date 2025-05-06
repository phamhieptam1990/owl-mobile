// To parse this JSON data, do
//
//     final ewalletPaymentHistoryResponse = ewalletPaymentHistoryResponseFromJson(jsonString);

import 'dart:convert';

EwalletPaymentHistoryResponse ewalletPaymentHistoryResponseFromJson(
        String str) =>
    EwalletPaymentHistoryResponse.fromJson(json.decode(str));

String ewalletPaymentHistoryResponseToJson(
        EwalletPaymentHistoryResponse data) =>
    json.encode(data.toJson());

class EwalletPaymentHistoryResponse {
  EwalletPaymentHistoryResponse({
    this.status,
    this.data,
  });

  int? status;
  List<EwalletPaymentHistoryItem>? data;

  factory EwalletPaymentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      EwalletPaymentHistoryResponse(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<EwalletPaymentHistoryItem>.from(
                json["data"].map((x) => EwalletPaymentHistoryItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data":
            data == null ? [] : List<dynamic>.from((data??[]).map((x) => x.toJson())),
      };
}

class EwalletPaymentHistoryItem {
  EwalletPaymentHistoryItem({
    this.id,
    this.empCode,
    this.amount,
    this.contractId,
    this.transRefNo,
    this.paymentDate,
    this.paymentStatus,
  });

  int? id;
  String? empCode;
  dynamic amount;
  String? contractId;
  String? transRefNo;
  String? paymentDate;
  String? paymentStatus;

  factory EwalletPaymentHistoryItem.fromJson(Map<String, dynamic> json) =>
      EwalletPaymentHistoryItem(
        id: json["id"],
        empCode: json["empCode"],
        amount: json["amount"],
        contractId: json["contractId"],
        transRefNo: json["transRefNo"],
        paymentDate: json["paymentDate"],
        paymentStatus: json["paymentStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "empCode": empCode,
        "amount": amount,
        "contractId": contractId,
        "transRefNo": transRefNo,
        "paymentDate": paymentDate,
        "paymentStatus": paymentStatus,
      };
}
