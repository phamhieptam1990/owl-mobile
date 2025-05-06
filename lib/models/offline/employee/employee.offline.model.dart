import 'package:hive/hive.dart';
part 'employee.offline.model.g.dart';

@HiveType(typeId: 4)
class EmployeeOfflineModel {
  @HiveField(0)
  String? lastName;
  @HiveField(1)
  int? agentId;
  @HiveField(2)
  int? gender;
  @HiveField(3)
  String? workEmail;
  @HiveField(4)
  String? personalMail;
  @HiveField(5)
  int? empLevel;
  @HiveField(6)
  String? tenantCode;
  @HiveField(7)
  int? modNo;
  @HiveField(8)
  int? checkerDate;
  @HiveField(9)
  int? hrtmPosition;
  @HiveField(10)
  int? id;
  @HiveField(11)
  String? makerId;
  @HiveField(12)
  int? makerDate;
  @HiveField(13)
  String? authStatus;
  @HiveField(14)
  String? fullName;
  @HiveField(15)
  String? userName;
  @HiveField(16)
  int? birthDate;
  @HiveField(17)
  String? firstName;
  @HiveField(18)
  String? recordStatus;
  @HiveField(19)
  String? mobilePhone;
  @HiveField(20)
  String? empCode;
  @HiveField(21)
  String? workPhone;
  @HiveField(22)
  String? aggId;
  EmployeeOfflineModel(
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
        'workPhone': workPhone
      };
  factory EmployeeOfflineModel.fromJson(Map<dynamic, dynamic> employeeModel) {
    return EmployeeOfflineModel(
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
