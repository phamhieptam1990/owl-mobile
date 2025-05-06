class KalapaBudgetDashboardResponse {
  KalapaBudgetDashboardResponse({
    this.status,
    this.data,
  });

  final int? status;
  final KalapaBudgetDashboardData? data;

  factory KalapaBudgetDashboardResponse.fromJson(Map<String, dynamic> json) =>
      KalapaBudgetDashboardResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : KalapaBudgetDashboardData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data?.toJson(),
      };
}

class KalapaBudgetDashboardData {
  KalapaBudgetDashboardData({
    this.activatedFlg,
    this.totalBudget,
    this.year,
    this.modNo,
    this.checkerDate,
    this.unitCode,
    this.unitTypeName,
    this.unitId,
    this.id,
    this.channelId,
    this.createDate,
    this.makerId,
    this.channelCode,
    this.makerDate,
    this.unitName,
    this.totalBalance,
    this.authStatus,
    this.budgetStandard,
    this.fullName,
    this.budgetId,
    this.unitTypeCode,
    this.recordStatus,
    this.month,
    this.empCode,
    this.budgetExtra,
    this.totalUsed,
    this.checkerId,
    this.effectiveDate,
  });

  final int? activatedFlg;
  final  totalBudget;
  final int? year;
  final int? modNo;
  final int? checkerDate;
  final String? unitCode;
  final String? unitTypeName;
  final int? unitId;
  final int? id;
  final int? channelId;
  final int? createDate;
  final String? makerId;
  final String? channelCode;
  final int? makerDate;
  final String? unitName;
  final  totalBalance;
  final String? authStatus;
  final int? budgetStandard;
  final String? fullName;
  final int? budgetId;
  final String? unitTypeCode;
  final String? recordStatus;
  final int? month;
  final String? empCode;
  final int? budgetExtra;
  final  totalUsed;
  final String? checkerId;
  final int? effectiveDate;

  int get amountSpent => totalBudget - totalBalance;

  double get balancePercent => totalBalance / totalBudget;

  double get amountPercent => (totalBudget - totalBalance) / balancePercent;

  factory KalapaBudgetDashboardData.fromJson(Map<String, dynamic> json) =>
      KalapaBudgetDashboardData(
        activatedFlg:
            json["activatedFlg"] == null ? null : json["activatedFlg"],
        totalBudget: json["totalBudget"] == null ? null : json["totalBudget"],
        year: json["year"] == null ? null : json["year"],
        modNo: json["modNo"] == null ? null : json["modNo"],
        checkerDate: json["checkerDate"] == null ? null : json["checkerDate"],
        unitCode: json["unitCode"] == null ? null : json["unitCode"],
        unitTypeName:
            json["unitTypeName"] == null ? null : json["unitTypeName"],
        unitId: json["unitId"] == null ? null : json["unitId"],
        id: json["id"] == null ? null : json["id"],
        channelId: json["channelId"] == null ? null : json["channelId"],
        createDate: json["createDate"] == null ? null : json["createDate"],
        makerId: json["makerId"] == null ? null : json["makerId"],
        channelCode: json["channelCode"] == null ? null : json["channelCode"],
        makerDate: json["makerDate"] == null ? null : json["makerDate"],
        unitName: json["unitName"] == null ? null : json["unitName"],
        totalBalance:
            json["totalBalance"] == null ? null : json["totalBalance"],
        authStatus: json["authStatus"] == null ? null : json["authStatus"],
        budgetStandard:
            json["budgetStandard"] == null ? null : json["budgetStandard"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        budgetId: json["budgetId"] == null ? null : json["budgetId"],
        unitTypeCode:
            json["unitTypeCode"] == null ? null : json["unitTypeCode"],
        recordStatus:
            json["recordStatus"] == null ? null : json["recordStatus"],
        month: json["month"] == null ? null : json["month"],
        empCode: json["empCode"] == null ? null : json["empCode"],
        budgetExtra: json["budgetExtra"] == null ? null : json["budgetExtra"],
        totalUsed: json["totalUsed"] == null ? null : json["totalUsed"],
        checkerId: json["checkerId"] == null ? null : json["checkerId"],
        effectiveDate:
            json["effectiveDate"] == null ? null : json["effectiveDate"],
      );

  Map<String, dynamic> toJson() => {
        "activatedFlg": activatedFlg == null ? null : activatedFlg,
        "totalBudget": totalBudget == null ? null : totalBudget,
        "year": year == null ? null : year,
        "modNo": modNo == null ? null : modNo,
        "checkerDate": checkerDate == null ? null : checkerDate,
        "unitCode": unitCode == null ? null : unitCode,
        "unitTypeName": unitTypeName == null ? null : unitTypeName,
        "unitId": unitId == null ? null : unitId,
        "id": id == null ? null : id,
        "channelId": channelId == null ? null : channelId,
        "createDate": createDate == null ? null : createDate,
        "makerId": makerId == null ? null : makerId,
        "channelCode": channelCode == null ? null : channelCode,
        "makerDate": makerDate == null ? null : makerDate,
        "unitName": unitName == null ? null : unitName,
        "totalBalance": totalBalance == null ? null : totalBalance,
        "authStatus": authStatus == null ? null : authStatus,
        "budgetStandard": budgetStandard == null ? null : budgetStandard,
        "fullName": fullName == null ? null : fullName,
        "budgetId": budgetId == null ? null : budgetId,
        "unitTypeCode": unitTypeCode == null ? null : unitTypeCode,
        "recordStatus": recordStatus == null ? null : recordStatus,
        "month": month == null ? null : month,
        "empCode": empCode == null ? null : empCode,
        "budgetExtra": budgetExtra == null ? null : budgetExtra,
        "totalUsed": totalUsed == null ? null : totalUsed,
        "checkerId": checkerId == null ? null : checkerId,
        "effectiveDate": effectiveDate == null ? null : effectiveDate,
      };
}
