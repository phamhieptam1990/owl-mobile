class ComplaintModel {
  int? makerDate;
  String? pegaCaseId;
  String? authStatus;
  String? remark;
  String? categoryCode;
  String? categoryName;
  String? customerName;
  String? productName;
  String? attributeCode;
  String? casetypeName;
  String? subcategoryName;
  String? phoneNumber;
  String? productCode;
  String? recordStatus;
  String? casetypeCode;
  String? attributeName;
  String? aggId;
  String? subcategoryCode;
  String? makerId;

  ComplaintModel(
      {this.makerDate,
      this.pegaCaseId,
      this.authStatus,
      this.remark,
      this.categoryCode,
      this.categoryName,
      this.customerName,
      this.productName,
      this.attributeCode,
      this.casetypeName,
      this.subcategoryName,
      this.phoneNumber,
      this.productCode,
      this.recordStatus,
      this.casetypeCode,
      this.attributeName,
      this.aggId,
      this.subcategoryCode,
      this.makerId});

  ComplaintModel.fromJson(Map<String, dynamic> json) {
    makerDate = json['makerDate'];
    pegaCaseId = json['pegaCaseId'];
    authStatus = json['authStatus'];
    remark = json['remark'];
    categoryCode = json['categoryCode'];
    categoryName = json['categoryName'];
    customerName = json['customerName'];
    productName = json['productName'];
    attributeCode = json['attributeCode'];
    casetypeName = json['casetypeName'];
    subcategoryName = json['subcategoryName'];
    phoneNumber = json['phoneNumber'];
    productCode = json['productCode'];
    recordStatus = json['recordStatus'];
    casetypeCode = json['casetypeCode'];
    attributeName = json['attributeName'];
    aggId = json['aggId'];
    subcategoryCode = json['subcategoryCode'];
    makerId = json['makerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['makerDate'] = this.makerDate;
    data['pegaCaseId'] = this.pegaCaseId;
    data['authStatus'] = this.authStatus;
    data['remark'] = this.remark;
    data['categoryCode'] = this.categoryCode;
    data['categoryName'] = this.categoryName;
    data['customerName'] = this.customerName;
    data['productName'] = this.productName;
    data['attributeCode'] = this.attributeCode;
    data['casetypeName'] = this.casetypeName;
    data['subcategoryName'] = this.subcategoryName;
    data['phoneNumber'] = this.phoneNumber;
    data['productCode'] = this.productCode;
    data['recordStatus'] = this.recordStatus;
    data['casetypeCode'] = this.casetypeCode;
    data['attributeName'] = this.attributeName;
    data['aggId'] = this.aggId;
    data['subcategoryCode'] = this.subcategoryCode;
    data['makerId'] = this.makerId;
    return data;
  }
}
