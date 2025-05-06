class CommentByContractIdResponse {
  CommentByContractIdResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<CommentByContractIdData>? data;

  factory CommentByContractIdResponse.fromJson(Map<String, dynamic> json) =>
      CommentByContractIdResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<CommentByContractIdData>.from(
                json["data"].map((x) => CommentByContractIdData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from((data??[]).map((x) => x.toJson())),
      };
}

class CommentByContractIdData {
  CommentByContractIdData({
    this.makerDate,
    this.authStatus,
    this.description,
    this.modNo,
    this.recordStatus,
    this.checkerDate,
    this.cstbService,
    this.contractId,
    this.checkerId,
    this.id,
    this.cstbCommentType,
    this.channelId,
    this.makerId,
  });

  final int? makerDate;
  final String? authStatus;
  final String? description;
  final int? modNo;
  final String? recordStatus;
  final int? checkerDate;
  final CstbService? cstbService;
  final String? contractId;
  final String? checkerId;
  final int? id;
  final CstbCommentType? cstbCommentType;
  final int? channelId;
  final String? makerId;

  factory CommentByContractIdData.fromJson(Map<String, dynamic> json) =>
      CommentByContractIdData(
        makerDate: json["makerDate"] == null ? null : json["makerDate"],
        authStatus: json["authStatus"] == null ? null : json["authStatus"],
        description: json["description"] == null ? null : json["description"],
        modNo: json["modNo"] == null ? null : json["modNo"],
        recordStatus:
            json["recordStatus"] == null ? null : json["recordStatus"],
        checkerDate: json["checkerDate"] == null ? null : json["checkerDate"],
        cstbService: json["cstbService"] == null
            ? null
            : CstbService.fromJson(json["cstbService"]),
        contractId: json["contractId"] == null ? null : json["contractId"],
        checkerId: json["checkerId"] == null ? null : json["checkerId"],
        id: json["id"] == null ? null : json["id"],
        cstbCommentType: json["cstbCommentType"] == null
            ? null
            : CstbCommentType.fromJson(json["cstbCommentType"]),
        channelId: json["channelId"] == null ? null : json["channelId"],
        makerId: json["makerId"] == null ? null : json["makerId"],
      );

  Map<String, dynamic> toJson() => {
        "makerDate": makerDate == null ? null : makerDate,
        "authStatus": authStatus == null ? null : authStatus,
        "description": description == null ? null : description,
        "modNo": modNo == null ? null : modNo,
        "recordStatus": recordStatus == null ? null : recordStatus,
        "checkerDate": checkerDate == null ? null : checkerDate,
        "cstbService": cstbService == null ? null : cstbService?.toJson(),
        "contractId": contractId == null ? null : contractId,
        "checkerId": checkerId == null ? null : checkerId,
        "id": id == null ? null : id,
        "cstbCommentType":
            cstbCommentType == null ? null : cstbCommentType?.toJson(),
        "channelId": channelId == null ? null : channelId,
        "makerId": makerId == null ? null : makerId,
      };
}

class CstbCommentType {
  CstbCommentType({
    this.activatedFlg,
    this.otherFlg,
    this.authStatus,
    this.priority,
    this.recordStatus,
    this.name,
    this.id,
  });

  final int? activatedFlg;
  final int? otherFlg;
  final String? authStatus;
  final int? priority;
  final String? recordStatus;
  final String? name;
  final int? id;

  factory CstbCommentType.fromJson(Map<String, dynamic> json) =>
      CstbCommentType(
        activatedFlg:
            json["activatedFlg"] == null ? null : json["activatedFlg"],
        otherFlg: json["otherFlg"] == null ? null : json["otherFlg"],
        authStatus: json["authStatus"] == null ? null : json["authStatus"],
        priority: json["priority"] == null ? null : json["priority"],
        recordStatus:
            json["recordStatus"] == null ? null : json["recordStatus"],
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "activatedFlg": activatedFlg == null ? null : activatedFlg,
        "otherFlg": otherFlg == null ? null : otherFlg,
        "authStatus": authStatus == null ? null : authStatus,
        "priority": priority == null ? null : priority,
        "recordStatus": recordStatus == null ? null : recordStatus,
        "name": name == null ? null : name,
        "id": id == null ? null : id,
      };
}

class CstbService {
  CstbService({
    this.activatedFlg,
    this.makerDate,
    this.code,
    this.numDayExpired,
    this.allowUsedService,
    this.authStatus,
    this.fee,
    this.description,
    this.serviceEndpoint,
    this.tenantCode,
    this.modNo,
    this.recordStatus,
    this.checkerDate,
    this.name,
    this.checkerId,
    this.id,
    this.aggId,
    this.makerId,
  });

  final int? activatedFlg;
  final int? makerDate;
  final String? code;
  final int? numDayExpired;
  final int? allowUsedService;
  final String? authStatus;
  final int? fee;
  final String? description;
  final String? serviceEndpoint;
  final String? tenantCode;
  final int? modNo;
  final String? recordStatus;
  final int? checkerDate;
  final String? name;
  final String? checkerId;
  final int? id;
  final String? aggId;
  final String? makerId;

  factory CstbService.fromJson(Map<String, dynamic> json) => CstbService(
        activatedFlg:
            json["activatedFlg"] == null ? null : json["activatedFlg"],
        makerDate: json["makerDate"] == null ? null : json["makerDate"],
        code: json["code"] == null ? null : json["code"],
        numDayExpired:
            json["numDayExpired"] == null ? null : json["numDayExpired"],
        allowUsedService:
            json["allowUsedService"] == null ? null : json["allowUsedService"],
        authStatus: json["authStatus"] == null ? null : json["authStatus"],
        fee: json["fee"] == null ? null : json["fee"],
        description: json["description"] == null ? null : json["description"],
        serviceEndpoint:
            json["serviceEndpoint"] == null ? null : json["serviceEndpoint"],
        tenantCode: json["tenantCode"] == null ? null : json["tenantCode"],
        modNo: json["modNo"] == null ? null : json["modNo"],
        recordStatus:
            json["recordStatus"] == null ? null : json["recordStatus"],
        checkerDate: json["checkerDate"] == null ? null : json["checkerDate"],
        name: json["name"] == null ? null : json["name"],
        checkerId: json["checkerId"] == null ? null : json["checkerId"],
        id: json["id"] == null ? null : json["id"],
        aggId: json["aggId"] == null ? null : json["aggId"],
        makerId: json["makerId"] == null ? null : json["makerId"],
      );

  Map<String, dynamic> toJson() => {
        "activatedFlg": activatedFlg == null ? null : activatedFlg,
        "makerDate": makerDate == null ? null : makerDate,
        "code": code == null ? null : code,
        "numDayExpired": numDayExpired == null ? null : numDayExpired,
        "allowUsedService": allowUsedService == null ? null : allowUsedService,
        "authStatus": authStatus == null ? null : authStatus,
        "fee": fee == null ? null : fee,
        "description": description == null ? null : description,
        "serviceEndpoint": serviceEndpoint == null ? null : serviceEndpoint,
        "tenantCode": tenantCode == null ? null : tenantCode,
        "modNo": modNo == null ? null : modNo,
        "recordStatus": recordStatus == null ? null : recordStatus,
        "checkerDate": checkerDate == null ? null : checkerDate,
        "name": name == null ? null : name,
        "checkerId": checkerId == null ? null : checkerId,
        "id": id == null ? null : id,
        "aggId": aggId == null ? null : aggId,
        "makerId": makerId == null ? null : makerId,
      };
}
