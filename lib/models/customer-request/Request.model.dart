class RequestModel {
  int? makerDate;
  String? authStatus;
  String? categoryCode;
  String? categoryName;
  String? recordStatus;
  String? aggId;
  String? subcategoryCode;
  String? subCategoryName;
  String? makerId;
  String? issueName;
  int? id;
  int? subCategoryId;
  int? issueClassId;
  String? issueClassCode;
  String? issueClassName;
  String? tenantCode;
  String? statusCode;
  String? issueCode;
  String? assignee;
  String? productCode;
  RequestModel(
      {this.makerDate,
      this.authStatus,
      this.categoryCode,
      this.categoryName,
      this.recordStatus,
      this.aggId,
      this.subcategoryCode,
      this.subCategoryName,
      this.makerId,
      this.issueName,
      this.id,
      this.subCategoryId,
      this.issueClassId,
      this.issueClassCode,
      this.issueClassName,
      this.tenantCode,
      this.statusCode,
      this.issueCode,
      this.assignee,
      this.productCode});

  RequestModel.fromJson(Map<String, dynamic> json) {
    makerDate = json['makerDate'] ?? null;
    authStatus = json['authStatus'] ?? '';
    categoryCode = json['categoryCode'] ?? '';
    categoryName = json['categoryName'] ?? '';
    recordStatus = json['recordStatus'] ?? '';
    aggId = json['aggId'] ?? '';
    subcategoryCode = json['subcategoryCode'] ?? '';
    subCategoryName = json['subCategoryName'] ?? '';
    makerId = json['makerId'] ?? '';
    issueName = json['issueName'] ?? '';
    id = json['id'] ?? null;
    subCategoryId = json['subCategoryId'] ?? null;
    issueClassId = json['issueClassId'] ?? null;
    issueClassCode = json['issueClassCode'] ?? '';
    issueClassName = json['issueClassName'] ?? '';
    tenantCode = json['tenantCode'] ?? '';
    statusCode = json['statusCode'] ?? '';
    issueCode = json['issueCode'] ?? '';
    assignee = json['assignee'] ?? '';
    productCode = json['properties.fcsp_productcode'] != null
        ? json['properties.fcsp_productcode']
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['makerDate'] = this.makerDate;
    // data['pegaCaseId'] = this.pegaCaseId;
    // data['authStatus'] = this.authStatus;
    // data['remark'] = this.remark;
    // data['categoryCode'] = this.categoryCode;
    // data['categoryName'] = this.categoryName;
    // data['customerName'] = this.customerName;
    // data['productName'] = this.productName;
    // data['attributeCode'] = this.attributeCode;
    // data['casetypeName'] = this.casetypeName;
    // data['subcategoryName'] = this.subcategoryName;
    // data['phoneNumber'] = this.phoneNumber;
    // data['productCode'] = this.productCode;
    // data['recordStatus'] = this.recordStatus;
    // data['casetypeCode'] = this.casetypeCode;
    // data['attributeName'] = this.attributeName;
    // data['aggId'] = this.aggId;
    // data['subcategoryCode'] = this.subcategoryCode;
    // data['makerId'] = this.makerId;
    return data;
  }
}
