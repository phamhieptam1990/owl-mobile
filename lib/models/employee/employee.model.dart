class EmployeeModel {
  String? lastName;
  int? agentId;
  int? gender;
  String? workEmail;
  String? personalMail;
  int? empLevel;
  String? tenantCode;
  int? modNo;
  int? checkerDate;
  int? hrtmPosition;
  int? id;
  String? makerId;
  int? makerDate;
  String? authStatus;
  String? fullName;
  String? userName;
  int? birthDate;
  String? firstName;
  String? recordStatus;
  String? mobilePhone;
  String? empCode;
  String? workPhone;
  String? aggId;
  EmployeeModel(
      {this.lastName,
      this.agentId,
      this.gender,
      this.workEmail,
      this.personalMail,
      this.empLevel,
      this.tenantCode,
      this.id,
      this.makerId,
      this.makerDate,
      this.fullName,
      this.userName,
      this.birthDate,
      this.firstName,
      this.recordStatus,
      this.mobilePhone,
      this.empCode,
      this.workPhone,
      this.aggId});

  Map<String, dynamic> toJson() => {
        'birthDate': birthDate,
        'lastName': lastName,
        'agentId': agentId,
        'gender': gender,
        'workEmail': workEmail,
        'personalMail': personalMail,
        'empLevel': empLevel,
        'tenantCode': tenantCode,
        'id': id,
        'fullName': fullName,
        'firstName': firstName,
        'recordStatus': recordStatus,
        'mobilePhone': mobilePhone,
        'empCode': empCode,
        'workPhone': workPhone
      };
  factory EmployeeModel.fromJson(Map<dynamic, dynamic> employeeModel) {
    return EmployeeModel(
      birthDate: employeeModel['birthDate'],
      lastName: employeeModel['lastName'].toString(),
      agentId: employeeModel['agentId'],
      gender: employeeModel['gender'],
      workEmail: employeeModel['workEmail'].toString(),
      personalMail: employeeModel['personalMail'].toString(),
      empLevel: employeeModel['empLevel'],
      tenantCode: employeeModel['tenantCode'].toString(),
      id: employeeModel['id'],
      fullName: employeeModel['fullName'].toString(),
      firstName: employeeModel['firstName'].toString(),
      recordStatus: employeeModel['recordStatus'].toString(),
      mobilePhone: employeeModel['mobilePhone'].toString(),
      empCode: employeeModel['empCode'].toString(),
      workPhone: employeeModel['workPhone'].toString(),
    );
  }
}
