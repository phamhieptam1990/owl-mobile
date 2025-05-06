import 'dart:convert';

PaymentMethodsResponse paymentMethodsResponseFromJson(String str) =>
    PaymentMethodsResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String paymentMethodsResponseToJson(PaymentMethodsResponse data) =>
    json.encode(data.toJson());

class PaymentMethodsResponse {
  PaymentMethodsResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<PaymentMethodsData>? data;

  factory PaymentMethodsResponse.fromJson(Map<String, dynamic> json) =>
      PaymentMethodsResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<PaymentMethodsData>.from(
                (json["data"] as List).map(
                  (x) => PaymentMethodsData.fromJson(x as Map<String, dynamic>),
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

class PaymentMethodsData {
  PaymentMethodsData({
    this.id,
    this.tenantCode,
    this.appCode,
    this.methodCode,
    this.description,
  });

  final int? id;
  final String? tenantCode;
  final String? appCode;
  final String? methodCode;
  final String? description;

  factory PaymentMethodsData.fromJson(Map<String, dynamic> json) =>
      PaymentMethodsData(
        id: json["id"],
        tenantCode: json["tenantCode"],
        appCode: json["appCode"],
        methodCode: json["methodCode"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tenantCode": tenantCode,
        "appCode": appCode,
        "methodCode": methodCode,
        "description": description,
      };
}