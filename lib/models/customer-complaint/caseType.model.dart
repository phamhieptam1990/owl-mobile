class CaseTypeModel {
  final String? casetypeName;
  final String? productCode;
  final String? casetypeCode;
  final String? casetypeValue;
  final String? description;
  final String? categoryCode;
  // final int id;
  CaseTypeModel({
    this.casetypeName,
    this.productCode,
    this.casetypeCode,
    this.casetypeValue,
    this.description,
    this.categoryCode,
    // this.id
  });

  factory CaseTypeModel.fromJson(Map<String, dynamic> json) {
    return CaseTypeModel(
        casetypeName: json['casetypeName'] as String,
        productCode: json['productCode'] as String,
        casetypeCode: json['casetypeCode'] as String,
        casetypeValue: json['casetypeValue'] as String,
        categoryCode: json['categoryCode'] as String,
        description: json['description'] as String);
    // id: DateTime.now().microsecondsSinceEpoch);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['casetypeName'] = this.casetypeName;
    data['productCode'] = this.productCode;
    data['casetypeCode'] = this.casetypeCode;
    data['casetypeValue'] = this.casetypeValue;
    data['categoryCode'] = this.categoryCode;
    data['description'] = this.description;
    // data['id'] = this.id;
    return data;
  }
}
