class EmployeeHierachyModel {
  String? workEmail;
  String? appCode;
  String? tenantCode;
  String? unitCode;
  int? unitId;
  int? id;
  String? makerId;
  String? unitName;
  String? authStatus;
  String? fullName;
  String? userName;
  String? reportEmpCode;
  String? recordStatus;
  int? reportEmpId;
  String? mobilePhone;
  String? empCode;
  String? reportFullName;
  int? flagAltUnit;
  String? usRecordStatus;
  String? usAuthStatus;
  String? positionCode;
  EmployeeHierachyModel(
      {this.workEmail,
      this.appCode,
      this.tenantCode,
      this.unitCode,
      this.unitId,
      this.id,
      this.makerId,
      this.unitName,
      this.authStatus,
      this.fullName,
      this.userName,
      this.reportEmpCode,
      this.recordStatus,
      this.reportEmpId,
      this.mobilePhone,
      this.empCode,
      this.reportFullName,
      this.flagAltUnit,
      this.usRecordStatus,
      this.positionCode,
      this.usAuthStatus});

  EmployeeHierachyModel.fromJson(Map<String, dynamic> json) {
    workEmail = json['workEmail'];
    appCode = json['appCode'];
    tenantCode = json['tenantCode'];
    unitCode = json['unitCode'];
    unitId = json['unitId'];
    id = json['id'];
    makerId = json['makerId'];
    unitName = json['unitName'];
    authStatus = json['authStatus'];
    fullName = json['fullName'];
    userName = json['userName'];
    reportEmpCode = json['reportEmpCode'];
    recordStatus = json['recordStatus'];
    reportEmpId = json['reportEmpId'];
    mobilePhone = json['mobilePhone'];
    empCode = json['empCode'];
    reportFullName = json['reportFullName'];
    flagAltUnit = json['flagAltUnit'];
    usRecordStatus = json['usRecordStatus'];
    usAuthStatus = json['usAuthStatus'];
    positionCode = json['positionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workEmail'] = this.workEmail;
    data['appCode'] = this.appCode;
    data['tenantCode'] = this.tenantCode;
    data['unitCode'] = this.unitCode;
    data['unitId'] = this.unitId;
    data['id'] = this.id;
    data['makerId'] = this.makerId;
    data['unitName'] = this.unitName;
    data['authStatus'] = this.authStatus;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['reportEmpCode'] = this.reportEmpCode;
    data['recordStatus'] = this.recordStatus;
    data['reportEmpId'] = this.reportEmpId;
    data['mobilePhone'] = this.mobilePhone;
    data['empCode'] = this.empCode;
    data['reportFullName'] = this.reportFullName;
    data['flagAltUnit'] = this.flagAltUnit;
    data['usRecordStatus'] = this.usRecordStatus;
    data['usAuthStatus'] = this.usAuthStatus;
    data['positionCode'] = this.positionCode;
    return data;
  }
}
