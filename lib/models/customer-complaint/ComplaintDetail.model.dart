class ComplaintDetailModel {
  int? accountNumber;
  String? casetypeCode;
  String? casetypeName;
  String? categoryCode;
  String? categoryName;
  String? channel;
  String? customerName;
  String? custtypeCode;
  String? custtypeName;
  String? email;
  int? nationalId;
  String? pegaCaseId;
  String? phoneNumber;
  String? productCode;
  String? productName;
  String? remark;
  String? subcategoryCode;
  String? subcategoryName;
  String? tenantCode;
  String? attributeName;
  String? attributeCode;
  ComplaintDetailModel(
      {this.accountNumber,
      this.casetypeCode,
      this.casetypeName,
      this.categoryCode,
      this.categoryName,
      this.channel,
      this.customerName,
      this.custtypeCode,
      this.custtypeName,
      this.email,
      this.nationalId,
      this.pegaCaseId,
      this.phoneNumber,
      this.productCode,
      this.productName,
      this.remark,
      this.subcategoryCode,
      this.subcategoryName,
      this.attributeCode,
      this.attributeName,
      this.tenantCode});

  ComplaintDetailModel.fromJson(Map<String, dynamic> json) {
    accountNumber = json['accountNumber'];
    casetypeCode = json['casetypeCode'];
    casetypeName = json['casetypeName'];
    categoryCode = json['categoryCode'];
    categoryName = json['categoryName'];
    channel = json['channel'];
    customerName = json['customerName'];
    custtypeCode = json['custtypeCode'];
    custtypeName = json['custtypeName'];
    email = json['email'];
    nationalId = json['nationalId'];
    pegaCaseId = json['pegaCaseId'];
    phoneNumber = json['phoneNumber'];
    productCode = json['productCode'];
    productName = json['productName'];
    remark = json['remark'];
    subcategoryCode = json['subcategoryCode'];
    subcategoryName = json['subcategoryName'];
    tenantCode = json['tenantCode'];
    attributeName = json['attributeName'];
    attributeCode = json['attributeCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountNumber'] = this.accountNumber;
    data['casetypeCode'] = this.casetypeCode;
    data['casetypeName'] = this.casetypeName;
    data['categoryCode'] = this.categoryCode;
    data['categoryName'] = this.categoryName;
    data['channel'] = this.channel;
    data['customerName'] = this.customerName;
    data['custtypeCode'] = this.custtypeCode;
    data['custtypeName'] = this.custtypeName;
    data['email'] = this.email;
    data['nationalId'] = this.nationalId;
    data['pegaCaseId'] = this.pegaCaseId;
    data['phoneNumber'] = this.phoneNumber;
    data['productCode'] = this.productCode;
    data['productName'] = this.productName;
    data['remark'] = this.remark;
    data['subcategoryCode'] = this.subcategoryCode;
    data['subcategoryName'] = this.subcategoryName;
    data['tenantCode'] = this.tenantCode;
    data['attributeName'] = this.attributeName;
    data['attributeCode'] = this.attributeCode;
    return data;
  }
}
