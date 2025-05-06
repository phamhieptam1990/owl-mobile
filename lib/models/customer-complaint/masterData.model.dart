class MasterDataComplain {
  String? attributeValue;
  String? categoryCode;
  String? categoryName;
  String? productName;
  String? casetypeName;
  String? attributeCode;
  String? subcategoryName;
  String? productCode;
  String? productValue;
  String? subcategoryValue;
  String? casetypeCode;
  String? categoryValue;
  String? casetypeValue;
  String? attributeName;
  String? subcategoryCode;
  // int id;
  MasterDataComplain(
      {this.attributeValue,
      this.categoryCode,
      this.categoryName,
      this.productName,
      this.casetypeName,
      this.attributeCode,
      this.subcategoryName,
      this.productCode,
      this.productValue,
      this.subcategoryValue,
      this.casetypeCode,
      this.categoryValue,
      this.casetypeValue,
      this.attributeName,
      // this.id,
      this.subcategoryCode});

  MasterDataComplain.fromJson(Map<String, dynamic> json) {
    attributeValue = json['attributeValue'] as String;
    categoryCode = json['categoryCode'] as String;
    categoryName = json['categoryName'] as String;
    productName = json['productName'] as String;
    casetypeName = json['casetypeName'] as String;
    attributeCode = json['attributeCode'] as String;
    subcategoryName = json['subcategoryName'] as String;
    productCode = json['productCode'] as String;
    productValue = json['productValue'] as String;
    subcategoryValue = json['subcategoryValue'] as String;
    casetypeCode = json['casetypeCode'] as String;
    categoryValue = json['categoryValue'] as String;
    casetypeValue = json['casetypeValue'] as String;
    attributeName = json['attributeName'] as String;
    subcategoryCode = json['subcategoryCode'] as String;
    // id = DateTime.now().microsecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attributeValue'] = this.attributeValue;
    data['categoryCode'] = this.categoryCode;
    data['categoryName'] = this.categoryName;
    data['productName'] = this.productName;
    data['casetypeName'] = this.casetypeName;
    data['attributeCode'] = this.attributeCode;
    data['subcategoryName'] = this.subcategoryName;
    data['productCode'] = this.productCode;
    data['productValue'] = this.productValue;
    data['subcategoryValue'] = this.subcategoryValue;
    data['casetypeCode'] = this.casetypeCode;
    data['categoryValue'] = this.categoryValue;
    data['casetypeValue'] = this.casetypeValue;
    data['attributeName'] = this.attributeName;
    data['subcategoryCode'] = this.subcategoryCode;
    return data;
  }
}
