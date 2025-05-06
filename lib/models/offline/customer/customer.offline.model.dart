import 'package:hive/hive.dart';
part 'customer.offline.model.g.dart';

@HiveType(typeId: 2)
class CustomerOfflineModel {
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
  String? checkerDate;
  @HiveField(9)
  int? hrtmPosition;
  @HiveField(10)
  int? id;
  @HiveField(11)
  String? makerId;
  @HiveField(12)
  String? makerDate;
  @HiveField(13)
  String? authStatus;
  @HiveField(14)
  String? fullName;
  @HiveField(15)
  String? idNo;
  @HiveField(16)
  String? userName;
  @HiveField(17)
  String? birthDate;
  @HiveField(18)
  String? firstName;
  @HiveField(19)
  String? recordStatus;
  @HiveField(20)
  String? mobilePhone;
  @HiveField(21)
  String? empCode;
  @HiveField(22)
  String? workPhone;
  @HiveField(23)
  String? aggId;
  @HiveField(24)
  int? appId;
  @HiveField(25)
  String? idno;
  @HiveField(26)
  String? jobDescription;
  @HiveField(27)
  String? cellPhone;
  @HiveField(28)
  var pltbAddresses;
  CustomerOfflineModel(
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
      this.aggId});
}
