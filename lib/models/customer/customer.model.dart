class CustomerModel {
  String? lastName;
  String? code;
  int? agentId;
  String? gender;
  int? sex;
  String? workEmail;
  String? personalMail;
  int? empLevel;
  String? tenantCode;
  int? modNo;
  String? checkerDate;
  int? hrtmPosition;
  int? id;
  String? makerId;
  String? makerDate;
  String? authStatus;
  String? fullName;
  String? idNo;
  String? userName;
  String? birthDate;
  String? firstName;
  String? recordStatus;
  String? mobilePhone;
  String? empCode;
  String? workPhone;
  String? aggId;
  int? appId;
  String? idno;
  String? jobDescription;
  String? cellPhone;
  String? idnoDate;
  String? idnoPlace;
  var pltbAddresses;
  var extraInfo;
  CustomerModel(
      {this.lastName,
      this.agentId,
      this.workEmail,
      this.personalMail,
      this.empLevel,
      this.tenantCode,
      this.id,
      this.makerId,
      this.makerDate,
      this.jobDescription,
      this.fullName,
      this.userName,
      this.birthDate,
      this.firstName,
      this.recordStatus,
      this.mobilePhone,
      this.empCode,
      this.workPhone,
      this.idNo,
      this.appId,
      this.cellPhone,
      this.idno,
      this.pltbAddresses,
      this.sex,
      this.gender,
      this.code,
      this.idnoPlace,
      this.extraInfo,
      this.idnoDate,
      this.aggId});

  Map toJson() => {
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
        'workPhone': workPhone,
        'idNo': idNo,
        'idno': idno,
        'jobDescription': jobDescription,
        'cellPhone': cellPhone,
        'pltbAddresses': pltbAddresses,
        'aggId': aggId,
        'sex': sex,
        'code': code,
        'idnoDate': idnoDate,
        'extraInfo' :extraInfo,
        'idnoPlace': idnoPlace
      };
  factory CustomerModel.fromJson(Map<String, dynamic> customerModel) {
    return CustomerModel(
        birthDate: customerModel['birthDate'],
        lastName: customerModel['lastName'].toString(),
        agentId: customerModel['agentId'],
        gender: customerModel['gender'],
        workEmail: customerModel['workEmail'].toString(),
        personalMail: customerModel['personalMail'].toString(),
        empLevel: customerModel['empLevel'],
        tenantCode: customerModel['tenantCode'].toString(),
        id: customerModel['id'],
        idno: customerModel['idno'],
        fullName: customerModel['fullName'].toString(),
        firstName: customerModel['firstName'].toString(),
        recordStatus: customerModel['recordStatus'].toString(),
        mobilePhone: customerModel['mobilePhone'].toString(),
        empCode: customerModel['empCode'].toString(),
        workPhone: customerModel['workPhone'].toString(),
        idNo: customerModel['idNo'].toString(),
        cellPhone: customerModel['cellPhone'].toString(),
        jobDescription: customerModel['jobDescription'].toString(),
        pltbAddresses: customerModel['pltbAddresses'],
        aggId: customerModel['aggId'],
        code: customerModel['code'],
        sex: customerModel['sex'],
        idnoDate: customerModel['idnoDate'],
        idnoPlace: customerModel['idnoPlace'],
        extraInfo: customerModel['extraInfo']);
  }
}
