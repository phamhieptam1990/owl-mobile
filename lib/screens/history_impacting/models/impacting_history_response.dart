class ImpactingHistoryResponse {
  ImpactingHistoryResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<ImpactingHistoryItem>? data;

  factory ImpactingHistoryResponse.fromJson(Map<String, dynamic> json) =>
      ImpactingHistoryResponse(
        status: json["status"],
        data: List<ImpactingHistoryItem>.from(
            json["data"].map((x) => ImpactingHistoryItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from((data??[]).map((x) => x.toJson())),
      };
}

class ImpactingHistoryItem {
  ImpactingHistoryItem({
    this.actionCode,
    this.actionDate,
    this.phone,
    this.nextActionDate,
    this.paymentAmount,
    this.personContact,
    this.contactBy,
    this.remarks,
  });

  final String? actionCode;
  final int? actionDate;
  final String? phone;
  final int? nextActionDate;
  final dynamic paymentAmount;
  final String? personContact;
  final String? contactBy;
  final String? remarks;

  factory ImpactingHistoryItem.fromJson(Map<String, dynamic> json) =>
      ImpactingHistoryItem(
        actionCode: json["actionCode"],
        actionDate: json["actionDate"],
        phone: json["phone"],
        nextActionDate: json["nextActionDate"],
        paymentAmount: json["paymentAmount"],
        personContact: json["personContact"],
        contactBy: json["contactBy"],
        remarks: json["remarks"],
      );

  Map<String, dynamic> toJson() => {
        "actionCode": actionCode,
        "actionDate": actionDate,
        "phone": phone,
        "nextActionDate": nextActionDate,
        "paymentAmount": paymentAmount,
        "personContact": personContact,
        "contactBy": contactBy,
        "remarks": remarks,
      };
}
