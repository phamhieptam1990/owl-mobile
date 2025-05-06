class KalapaDasboarFeedResponse {
  KalapaDasboarFeedResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<KalapaDashboardData>? data;

  factory KalapaDasboarFeedResponse.fromJson(Map<String, dynamic> json) =>
      KalapaDasboarFeedResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<KalapaDashboardData>.from(
                json["data"].map((x) => KalapaDashboardData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from((data??[]).map((x) => x.toJson())),
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
        activatedFlg:
            json["activatedFlg"] == null ? null : json["activatedFlg"],
        code: json["code"] == null ? null : json["code"],
        allowUsedService:
            json["allowUsedService"] == null ? null : json["allowUsedService"],
        fee: json["fee"] == null ? null : json["fee"],
        description: json["description"] == null ? null : json["description"],
        numDayHistory:
            json["numDayHistory"] == null ? null : json["numDayHistory"],
        serviceEndpoint:
            json["serviceEndpoint"] == null ? null : json["serviceEndpoint"],
        tenantCode: json["tenantCode"] == null ? null : json["tenantCode"],
        modNo: json["modNo"] == null ? null : json["modNo"],
        id: json["id"] == null ? null : json["id"],
        createDate: json["createDate"] == null ? null : json["createDate"],
        channelCode: json["channelCode"] == null ? null : json["channelCode"],
        numDayExpired:
            json["numDayExpired"] == null ? null : json["numDayExpired"],
        authStatus: json["authStatus"] == null ? null : json["authStatus"],
        recordStatus:
            json["recordStatus"] == null ? null : json["recordStatus"],
        name: json["name"] == null ? null : json["name"],
        channelName: json["channelName"] == null ? null : json["channelName"],
        aggId: json["aggId"] == null ? null : json["aggId"],
        checkerDate: json["checkerDate"] == null ? null : json["checkerDate"],
        makerId: json["makerId"] == null ? null : json["makerId"],
        makerDate: json["makerDate"] == null ? null : json["makerDate"],
        checkerId: json["checkerId"] == null ? null : json["checkerId"],
      );

  Map<String, dynamic> toJson() => {
        "activatedFlg": activatedFlg == null ? null : activatedFlg,
        "code": code == null ? null : code,
        "allowUsedService": allowUsedService == null ? null : allowUsedService,
        "fee": fee == null ? null : fee,
        "description": description == null ? null : description,
        "numDayHistory": numDayHistory == null ? null : numDayHistory,
        "serviceEndpoint": serviceEndpoint == null ? null : serviceEndpoint,
        "tenantCode": tenantCode == null ? null : tenantCode,
        "modNo": modNo == null ? null : modNo,
        "id": id == null ? null : id,
        "createDate": createDate == null ? null : createDate,
        "channelCode": channelCode == null ? null : channelCode,
        "numDayExpired": numDayExpired == null ? null : numDayExpired,
        "authStatus": authStatus == null ? null : authStatus,
        "recordStatus": recordStatus == null ? null : recordStatus,
        "name": name == null ? null : name,
        "channelName": channelName == null ? null : channelName,
        "aggId": aggId == null ? null : aggId,
        "checkerDate": checkerDate == null ? null : checkerDate,
        "makerId": makerId == null ? null : makerId,
        "makerDate": makerDate == null ? null : makerDate,
        "checkerId": checkerId == null ? null : checkerId,
      };
}
