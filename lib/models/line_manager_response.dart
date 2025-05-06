class LineManagerResponse {
  LineManagerResponse({
    this.status,
    this.lineManagers,
  });

  final int? status;
  final List<LineManagerData>? lineManagers;

  factory LineManagerResponse.fromJson(Map<String, dynamic> json) =>
      LineManagerResponse(
        status: json["status"] == null ? null : json["status"],
        lineManagers: json["data"] == null
            ? null
            : List<LineManagerData>.from(
                json["data"].map((x) => LineManagerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": lineManagers == null
            ? null
            : List<dynamic>.from((lineManagers??[]).map((x) => x.toJson())),
      };
}

class LineManagerData {
  LineManagerData({
    this.empCode,
    this.level,
    this.fullName,
    this.id,
  });

  final String? empCode;
  final int? level;
  final String? fullName;
  final int? id;

  factory LineManagerData.fromJson(Map<String, dynamic> json) =>
      LineManagerData(
        empCode: json["empCode"] == null ? null : json["empCode"],
        level: json["level"] == null ? null : json["level"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toJson() => {
        "empCode": empCode == null ? null : empCode,
        "level": level == null ? null : level,
        "fullName": fullName == null ? null : fullName,
        "id": id == null ? null : id,
      };
}
