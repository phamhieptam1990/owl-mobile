// To parse this JSON data, do
//
//     final recoveryInfoResponse = recoveryInfoResponseFromJson(jsonString);

import 'dart:convert';

RecoveryInfoResponse recoveryInfoResponseFromJson(String str) =>
    RecoveryInfoResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String recoveryInfoResponseToJson(RecoveryInfoResponse data) =>
    json.encode(data.toJson());

class RecoveryInfoResponse {
  RecoveryInfoResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<RecoveryInfoData>? data;

  factory RecoveryInfoResponse.fromJson(Map<String, dynamic> json) =>
      RecoveryInfoResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<RecoveryInfoData>.from(
                json["data"].map((x) => RecoveryInfoData.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? null
            : List<dynamic>.from((data??[]).map((x) => x.toJson())),
      };
}

class RecoveryInfoData {
  RecoveryInfoData({
    this.applId,
    this.monthBom,
    this.accountNumber,
    this.vat,
    this.insuranceFee,
    this.dpdBom,
    this.posBom,
    this.totalPaid,
    this.extantPos,
    this.totalChargesOverdue,
    this.interestOverdue,
    this.totalOverdueNopos,
    this.totalOverdueNopos30,
    this.emi1,
    this.lpi1,
  });

  final String? applId;
  final String? monthBom;
  final String? accountNumber;
  final dynamic vat;
  final dynamic insuranceFee;
  final dynamic dpdBom;
  final dynamic posBom;
  final dynamic totalPaid;
  final dynamic extantPos;
  final dynamic totalChargesOverdue;
  final dynamic interestOverdue;
  final dynamic totalOverdueNopos;
  final dynamic totalOverdueNopos30;
  final dynamic emi1;
  final dynamic lpi1;

  factory RecoveryInfoData.fromJson(Map<String, dynamic> json) =>
      RecoveryInfoData(
        applId: json["applId"],
        monthBom: json["monthBom"],
        accountNumber: json["accountNumber"],
        vat: json["vat"],
        insuranceFee: json["insuranceFee"],
        dpdBom: json["dpdBom"],
        posBom: json["posBom"],
        totalPaid: json["totalPaid"],
        extantPos: json["extantPos"],
        totalChargesOverdue: json["totalChargesOverdue"],
        interestOverdue: json["interestOverdue"],
        totalOverdueNopos: json["totalOverdueNopos"],
        totalOverdueNopos30: json["totalOverdueNopos30"] == null
            ? null
            : (json["totalOverdueNopos30"] is num
                ? (json["totalOverdueNopos30"] as num).toDouble()
                : null),
        emi1: json["emi1"],
        lpi1: json["lpi1"],
      );

  Map<String, dynamic> toJson() => {
        "applId": applId,
        "monthBom": monthBom,
        "accountNumber": accountNumber,
        "vat": vat,
        "insuranceFee": insuranceFee,
        "dpdBom": dpdBom,
        "posBom": posBom,
        "totalPaid": totalPaid,
        "extantPos": extantPos,
        "totalChargesOverdue": totalChargesOverdue,
        "interestOverdue": interestOverdue,
        "totalOverdueNopos": totalOverdueNopos,
        "totalOverdueNopos30": totalOverdueNopos30,
        "emi1": emi1,
        "lpi1": lpi1,
      };
}