class CommentTypeResponse {
  CommentTypeResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<CommentTypeList>? data;

  factory CommentTypeResponse.fromJson(Map<String, dynamic> json) =>
      CommentTypeResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<CommentTypeList>.from(
                json["data"].map((x) => CommentTypeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from((data??[]).map((x) => x.toJson())),
      };
}

class CommentTypeList {
  CommentTypeList({
    this.activatedFlg,
    this.otherFlg,
    this.authStatus,
    this.priority,
    this.recordStatus,
    this.name,
    this.id,
    this.createDate,
  });

  final int? activatedFlg;
  final int? otherFlg;
  final String? authStatus;
  final int? priority;
  final String? recordStatus;
  final String? name;
  final int? id;
  final int? createDate;

  factory CommentTypeList.fromJson(Map<String, dynamic> json) =>
      CommentTypeList(
        activatedFlg:
            json["activatedFlg"] == null ? null : json["activatedFlg"],
        otherFlg: json["otherFlg"] == null ? null : json["otherFlg"],
        authStatus: json["authStatus"] == null ? null : json["authStatus"],
        priority: json["priority"] == null ? null : json["priority"],
        recordStatus:
            json["recordStatus"] == null ? null : json["recordStatus"],
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
        createDate: json["createDate"] == null ? null : json["createDate"],
      );

  Map<String, dynamic> toJson() => {
        "activatedFlg": activatedFlg == null ? null : activatedFlg,
        "otherFlg": otherFlg == null ? null : otherFlg,
        "authStatus": authStatus == null ? null : authStatus,
        "priority": priority == null ? null : priority,
        "recordStatus": recordStatus == null ? null : recordStatus,
        "name": name == null ? null : name,
        "id": id == null ? null : id,
        "createDate": createDate == null ? null : createDate,
      };
}
