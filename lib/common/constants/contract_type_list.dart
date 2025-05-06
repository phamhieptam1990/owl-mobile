class ContractTypeInfoListResponse {
  ContractTypeInfoListResponse({
    required this.status,
    required this.data,
  });

  final int status;
  final List<ContractTypeInfo> data;

  factory ContractTypeInfoListResponse.fromJson(Map<String, dynamic> json) =>
      ContractTypeInfoListResponse(
        status: json["status"] ?? 0,
        data: json["data"] == null
            ? []
            : List<ContractTypeInfo>.from(
                json["data"].map((x) => ContractTypeInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ContractTypeInfo {
  ContractTypeInfo({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;

  factory ContractTypeInfo.fromJson(Map<String, dynamic> json) =>
      ContractTypeInfo(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
      };
}
