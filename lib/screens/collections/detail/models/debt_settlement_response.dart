// To parse this JSON data, do
//
//     final debtSettlementResponse = debtSettlementResponseFromJson(jsonString);

import 'dart:convert';

DebtSettlementResponse debtSettlementResponseFromJson(String str) =>
    DebtSettlementResponse.fromJson(json.decode(str));

String debtSettlementResponseToJson(DebtSettlementResponse data) =>
    json.encode(data.toJson());

class DebtSettlementResponse {
  final int? status;
  final DebtSettlementData? data;

  DebtSettlementResponse({
    this.status,
    this.data,
  });

  factory DebtSettlementResponse.fromJson(Map<String, dynamic> json) =>
      DebtSettlementResponse(
        status: json["status"],
        data: DebtSettlementData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class DebtSettlementData {
  final String? debt2Bonus1;
  final dynamic remainIntCurr;
  final dynamic remainLpi;
  final dynamic debt4Max;
  final String? debt2Bonus2;
  final dynamic debt3Max;
  final String? debt3Bonus2;
  final dynamic debt2Max;
  final String? debt3Bonus1;
  final dynamic paidAmt;
  final String? debt4Bonus2;
  final dynamic remainPrincipalCurr;
  final dynamic debt1Min;
  final String? debt4Bonus1;
  final dynamic debt4Min;
  final dynamic debt3Min;
  final dynamic debt2Min;
  final dynamic remainPaidAmt;
  final dynamic totalDebtSettlement;
  final dynamic debt1Max;
  final String? debt1Bonus2;
  final String? debt1Bonus1;

  DebtSettlementData({
    this.debt2Bonus1,
    this.remainIntCurr,
    this.remainLpi,
    this.debt4Max,
    this.debt2Bonus2,
    this.debt3Max,
    this.debt3Bonus2,
    this.debt2Max,
    this.debt3Bonus1,
    this.paidAmt,
    this.debt4Bonus2,
    this.remainPrincipalCurr,
    this.debt1Min,
    this.debt4Bonus1,
    this.debt4Min,
    this.debt3Min,
    this.debt2Min,
    this.remainPaidAmt,
    this.totalDebtSettlement,
    this.debt1Max,
    this.debt1Bonus2,
    this.debt1Bonus1,
  });

  factory DebtSettlementData.fromJson(Map<String, dynamic> json) =>
      DebtSettlementData(
        debt2Bonus1: json["debt2Bonus1"],
        remainIntCurr: json["remainIntCurr"],
        remainLpi: json["remainLpi"],
        debt4Max: json["debt4Max"],
        debt2Bonus2: json["debt2Bonus2"],
        debt3Max: json["debt3Max"],
        debt3Bonus2: json["debt3Bonus2"],
        debt2Max: json["debt2Max"],
        debt3Bonus1: json["debt3Bonus1"],
        paidAmt: json["paidAmt"],
        debt4Bonus2: json["debt4Bonus2"],
        remainPrincipalCurr: json["remainPrincipalCurr"],
        debt1Min: json["debt1Min"],
        debt4Bonus1: json["debt4Bonus1"],
        debt4Min: json["debt4Min"],
        debt3Min: json["debt3Min"],
        debt2Min: json["debt2Min"],
        remainPaidAmt: json["remainPaidAmt"],
        totalDebtSettlement: json["totalDebtSettlement"],
        debt1Max: json["debt1Max"],
        debt1Bonus2: json["debt1Bonus2"],
        debt1Bonus1: json["debt1Bonus1"],
      );

  Map<String, dynamic> toJson() => {
        "debt2Bonus1": debt2Bonus1,
        "remainIntCurr": remainIntCurr,
        "remainLpi": remainLpi,
        "debt4Max": debt4Max,
        "debt2Bonus2": debt2Bonus2,
        "debt3Max": debt3Max,
        "debt3Bonus2": debt3Bonus2,
        "debt2Max": debt2Max,
        "debt3Bonus1": debt3Bonus1,
        "paidAmt": paidAmt,
        "debt4Bonus2": debt4Bonus2,
        "remainPrincipalCurr": remainPrincipalCurr,
        "debt1Min": debt1Min,
        "debt4Bonus1": debt4Bonus1,
        "debt4Min": debt4Min,
        "debt3Min": debt3Min,
        "debt2Min": debt2Min,
        "remainPaidAmt": remainPaidAmt,
        "totalDebtSettlement": totalDebtSettlement,
        "debt1Max": debt1Max,
        "debt1Bonus2": debt1Bonus2,
        "debt1Bonus1": debt1Bonus1,
      };
}
