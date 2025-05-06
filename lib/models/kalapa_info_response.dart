import 'dart:convert';

KalapaDasboarFeedResponse kalapaDasboarFeedResponseFromJson(String str) =>
    KalapaDasboarFeedResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String kalapaDasboarFeedResponseToJson(KalapaDasboarFeedResponse data) =>
    json.encode(data.toJson());

class KalapaDasboarFeedResponse {
  KalapaDasboarFeedResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<KalapaDashboardData>? data;

  factory KalapaDasboarFeedResponse.fromJson(Map<String, dynamic> json) =>
      KalapaDasboarFeedResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<KalapaDashboardData>.from(
                (json["data"] as List).map(
                  (x) => KalapaDashboardData.fromJson(x as Map<String, dynamic>),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.map((x) => x.toJson()).toList(),
      };
}

class KalapaDashboardData {
  KalapaDashboardData({
    this.activatedFlg,
    this.code,
    this.allowUsedService,
    this.fee,
    this.description,
    this.numDayHistory,
    this.serviceEndpoint,
    this.tenantCode,
    this.modNo,
    this.id,
    this.createDate,
    this.channelCode,
    this.numDayExpired,
    this.authStatus,
    this.recordStatus,
    this.name,
    this.channelName,
    this.aggId,
    this.checkerDate,
    this.makerId,
    this.makerDate,
    this.checkerId,
  });

  final int? activatedFlg;
  final String? code;
  final int? allowUsedService;
  final int? fee;
  final String? description;
  final int? numDayHistory;
  final String? serviceEndpoint;
  final String? tenantCode;
  final int? modNo;
  final int? id;
  final int? createDate;
  final String? channelCode;
  final int? numDayExpired;
  final String? authStatus;
  final String? recordStatus;
  final String? name;
  final String? channelName;
  final String? aggId;
  final int? checkerDate;
  final String? makerId;
  final int? makerDate;
  final String? checkerId;

  factory KalapaDashboardData.fromJson(Map<String, dynamic> json) =>
      KalapaDashboardData(
        activatedFlg: json["activatedFlg"],
        code: json["code"],
        allowUsedService: json["allowUsedService"],
        fee: json["fee"],
        description: json["description"],
        numDayHistory: json["numDayHistory"],
        serviceEndpoint: json["serviceEndpoint"],
        tenantCode: json["tenantCode"],
        modNo: json["modNo"],
        id: json["id"],
        createDate: json["createDate"],
        channelCode: json["channelCode"],
        numDayExpired: json["numDayExpired"],
        authStatus: json["authStatus"],
        recordStatus: json["recordStatus"],
        name: json["name"],
        channelName: json["channelName"],
        aggId: json["aggId"],
        checkerDate: json["checkerDate"],
        makerId: json["makerId"],
        makerDate: json["makerDate"],
        checkerId: json["checkerId"],
      );

  Map<String, dynamic> toJson() => {
        "activatedFlg": activatedFlg,
        "code": code,
        "allowUsedService": allowUsedService,
        "fee": fee,
        "description": description,
        "numDayHistory": numDayHistory,
        "serviceEndpoint": serviceEndpoint,
        "tenantCode": tenantCode,
        "modNo": modNo,
        "id": id,
        "createDate": createDate,
        "channelCode": channelCode,
        "numDayExpired": numDayExpired,
        "authStatus": authStatus,
        "recordStatus": recordStatus,
        "name": name,
        "channelName": channelName,
        "aggId": aggId,
        "checkerDate": checkerDate,
        "makerId": makerId,
        "makerDate": makerDate,
        "checkerId": checkerId,
      };
}