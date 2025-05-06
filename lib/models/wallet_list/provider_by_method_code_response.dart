import 'dart:convert';

ProviderByMethodCodeResponse providerByMethodCodeResponseFromJson(String str) =>
    ProviderByMethodCodeResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String providerByMethodCodeResponseToJson(ProviderByMethodCodeResponse data) =>
    json.encode(data.toJson());

class ProviderByMethodCodeResponse {
  ProviderByMethodCodeResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<ProviderByMethodCodeData>? data;

  factory ProviderByMethodCodeResponse.fromJson(Map<String, dynamic> json) =>
      ProviderByMethodCodeResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<ProviderByMethodCodeData>.from(
                (json["data"] as List).map(
                  (x) => ProviderByMethodCodeData.fromJson(x as Map<String, dynamic>),
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

class ProviderByMethodCodeData {
  ProviderByMethodCodeData({
    this.id,
    this.tenantCode,
    this.appCode,
    this.providerCode,
    this.description,
    this.field,
  });

  final int? id;
  final String? tenantCode;
  final String? appCode;
  final String? providerCode;
  final String? description;
  final Field? field;

  factory ProviderByMethodCodeData.fromJson(Map<String, dynamic> json) =>
      ProviderByMethodCodeData(
        id: json["id"],
        tenantCode: json["tenantCode"],
        appCode: json["appCode"],
        providerCode: json["providerCode"],
        description: json["description"],
        field: json["field"] == null ? null : Field.fromJson(json["field"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tenantCode": tenantCode,
        "appCode": appCode,
        "providerCode": providerCode,
        "description": description,
        "field": field?.toJson(),
      };
}

class Field {
  Field({
    this.accountValueType,
    this.fields,
  });

  final String? accountValueType;
  final List<dynamic>? fields;

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        accountValueType: json["accountValueType"],
        fields: json["fields"] == null
            ? null
            : List<dynamic>.from((json["fields"] as List).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "accountValueType": accountValueType,
        "fields": fields == null ? null : List<dynamic>.from((fields??[]).map((x) => x)),
      };
}