// To parse this JSON data, do
//
//     final eWalletPaymentInfo = eWalletPaymentInfoFromJson(jsonString);

import 'dart:convert';

EWalletPaymentInfo eWalletPaymentInfoFromJson(String str) =>
    EWalletPaymentInfo.fromJson(json.decode(str) as Map<String, dynamic>);

String eWalletPaymentInfoToJson(EWalletPaymentInfo data) =>
    json.encode(data.toJson());

class EWalletPaymentInfo {
  EWalletPaymentInfo({
    required this.isEwalletPayment,
    required this.aggId,
  });

  final bool isEwalletPayment;
  final String aggId;

  EWalletPaymentInfo copyWith({
    bool? isEwalletPayment,
    String? aggId,
  }) =>
      EWalletPaymentInfo(
        isEwalletPayment: isEwalletPayment ?? this.isEwalletPayment,
        aggId: aggId ?? this.aggId,
      );

  factory EWalletPaymentInfo.fromJson(Map<String, dynamic> json) =>
      EWalletPaymentInfo(
        isEwalletPayment: json["isEwalletPayment"] as bool? ?? false,
        aggId: json["aggId"] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        "isEwalletPayment": isEwalletPayment,
        "aggId": aggId,
      };
}