class RequestDetailModel {
  int? makerDate;
  String? authStatus;
  int? categoryId;
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
  int? createDate;
  dynamic properties;
  int? statusId;
  String? statusCode;
  String? assignee;
  
  RequestDetailModel({
    this.makerDate,
    this.authStatus,
    this.categoryId,
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
    this.createDate,
    this.properties,
    this.statusCode,
    this.assignee,
    this.statusId,
  });

  RequestDetailModel.fromJson(Map<String, dynamic> json) {
    makerDate = json['makerDate'];
    authStatus = json['authStatus'];
    categoryId = json['categoryId'];
    categoryCode = json['categoryCode'];
    categoryName = json['categoryName'];
    recordStatus = json['recordStatus'];
    aggId = json['aggId'];
    subcategoryCode = json['subcategoryCode'];
    subCategoryName = json['subCategoryName'];
    makerId = json['makerId'];
    issueName = json['issueName'];
    id = json['id'];
    subCategoryId = json['subCategoryId'];
    issueClassId = json['issueClassId'];
    issueClassCode = json['issueClassCode'];
    issueClassName = json['issueClassName'];
    tenantCode = json['tenantCode'];
    createDate = json['createDate'];
    properties = json['properties'];
    statusId = json['statusId'];
    statusCode = json['statusCode'];
    assignee = json['assignee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['makerDate'] = makerDate;
    data['authStatus'] = authStatus;
    data['categoryId'] = categoryId;
    data['categoryCode'] = categoryCode;
    data['categoryName'] = categoryName;
    data['recordStatus'] = recordStatus;
    data['aggId'] = aggId;
    data['subcategoryCode'] = subcategoryCode;
    data['subCategoryName'] = subCategoryName;
    data['makerId'] = makerId;
    data['issueName'] = issueName;
    data['id'] = id;
    data['subCategoryId'] = subCategoryId;
    data['issueClassId'] = issueClassId;
    data['issueClassCode'] = issueClassCode;
    data['issueClassName'] = issueClassName;
    data['tenantCode'] = tenantCode;
    data['createDate'] = createDate;
    data['properties'] = properties;
    data['statusId'] = statusId;
    data['statusCode'] = statusCode;
    data['assignee'] = assignee;
    return data;
  }
}