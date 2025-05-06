class LastDayUpdatedKalapa {
  LastDayUpdatedKalapa({
    this.reUseFlag,
    this.lastUpdatedDate,
  });

  final String? reUseFlag;
  final DateTime? lastUpdatedDate;

  factory LastDayUpdatedKalapa.fromJson(Map<String, dynamic> json) =>
      LastDayUpdatedKalapa(
        reUseFlag: json["RE_USE_FLAG"] == null ? null : json["RE_USE_FLAG"],
        lastUpdatedDate: json["LAST_UPDATED_DATE"] == null
            ? null
            : DateTime.parse(json["LAST_UPDATED_DATE"]),
      );

  Map<String, dynamic> toJson() => {
        "RE_USE_FLAG": reUseFlag == null ? null : reUseFlag,
        "LAST_UPDATED_DATE":
            lastUpdatedDate == null ? null : lastUpdatedDate?.toIso8601String(),
      };
}
