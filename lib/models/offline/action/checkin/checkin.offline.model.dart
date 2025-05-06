import 'package:hive/hive.dart';

part 'checkin.offline.model.g.dart';

@HiveType(typeId: 0)
class CheckInOfflineModel {
  @HiveField(0)
  String? aggId;

  @HiveField(1)
  int? contactModeId;

  @HiveField(2)
  int? contactPlaceId;

  @HiveField(3)
  int? contactPersonId;

  @HiveField(4)
  var paymentAmount;

  @HiveField(5)
  String? paymentBy;

  @HiveField(6)
  int? paymentUnit;

  @HiveField(7)
  String? clientPhone;

  @HiveField(8)
  String? description;

  @HiveField(9)
  int? fieldActionId;

  @HiveField(10)
  String? address;

  @HiveField(11)
  double? longitude;

  @HiveField(12)
  double? latitude;

  @HiveField(13)
  double? accuracy;

  @HiveField(14)
  String? date;

  @HiveField(15)
  String? durationInMins;

  @HiveField(16)
  String? actionGroupName;

  @HiveField(17)
  List<dynamic>? attachments;

  @HiveField(18)
  var offlineInfo;

  @HiveField(19)
  String? time;

  @HiveField(20)
  String? customerName;

  @HiveField(21)
  String? actionName;

  @HiveField(22)
  String? contractId;

  @HiveField(23)
  String? employeeInfomation;

  @HiveField(24)
  int? actionAttributeId;

  @HiveField(25)
  String? contactName;

  @HiveField(26)
  String? contactMobile;

  @HiveField(27)
  int? contactProvinceId;

  @HiveField(28)
  int? contactDistrictId;

  @HiveField(29)
  int? contactWardId;

  @HiveField(30)
  String? contactAddress;

  @HiveField(31)
  String? contactFullAddress;

  @HiveField(32)
  String? actionGroupCode;

  @HiveField(33)
  String? customerAttitude;

  @HiveField(34)
  int? subAttributeId;

  @HiveField(35)
  var currentIncomeAmount;

  @HiveField(36)
  var loanAmount;

  @HiveField(37)
  var lastIncomeAmount;

  @HiveField(38)
  bool? isRefusePayment;

  @HiveField(39)
  Map<dynamic, dynamic>? extraInfo;

  @HiveField(40)
  int? subAttributeGroupId;

  @HiveField(41)
  List<String>? selfie;

  CheckInOfflineModel({
    this.aggId,
    this.contactModeId,
    this.contactPlaceId,
    this.contactPersonId,
    this.paymentAmount,
    this.paymentBy,
    this.paymentUnit,
    this.clientPhone,
    this.description,
    this.fieldActionId,
    this.address,
    this.longitude,
    this.latitude,
    this.accuracy,
    this.date,
    this.durationInMins,
    this.actionGroupName,
    this.attachments,
    this.time,
    this.customerName,
    this.actionName,
    this.offlineInfo,
    this.contractId,
    this.employeeInfomation,
    this.actionAttributeId,
    this.contactName,
    this.contactMobile,
    this.contactProvinceId,
    this.contactDistrictId,
    this.contactWardId,
    this.contactAddress,
    this.actionGroupCode,
    this.customerAttitude,
    this.contactFullAddress,
    this.extraInfo,
    this.subAttributeId,
    this.currentIncomeAmount,
    this.loanAmount,
    this.lastIncomeAmount,
    this.isRefusePayment,
    this.subAttributeGroupId,
    this.selfie,
  });

  Map toJson() => {
        'aggId': aggId,
        'contactModeId': contactModeId,
        'contactPlaceId': contactPlaceId,
        'contactPersonId': contactPersonId,
        'paymentAmount': paymentAmount,
        'paymentBy': paymentBy,
        'paymentUnit': paymentUnit,
        'clientPhone': clientPhone,
        'description': description,
        'fieldActionId': fieldActionId,
        'actionAttributeId': actionAttributeId,
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'accuracy': accuracy,
        'date': date,
        'durationInMins': durationInMins,
        'actionGroupName': actionGroupName,
        'attachments': attachments,
        'offlineInfo': offlineInfo,
        'time': time,
        'customerName': customerName,
        'actionName': actionName,
        'contractId': contractId,
        'employeeInfomation': employeeInfomation,
        'contactMobile': contactMobile,
        'contactName': contactName,
        'contactProvinceId': contactProvinceId,
        'contactDistrictId': contactDistrictId,
        'contactWardId': contactWardId,
        'contactAddress': contactAddress,
        'contactFullAddress': contactFullAddress,
        'actionGroupCode': actionGroupCode,
        'customerAttitude': customerAttitude,
        'extraInfo': extraInfo,
        'subAttributeId': subAttributeId,
        'currentIncomeAmount': currentIncomeAmount,
        'loanAmount': loanAmount,
        'lastIncomeAmount': lastIncomeAmount,
        'isRefusePayment': isRefusePayment,
        'subAttributeGroupId': subAttributeGroupId,
        'selfie': selfie
      };
  factory CheckInOfflineModel.fromJson(
      Map<dynamic, dynamic> _checkInOfflineModel) {
    return CheckInOfflineModel(
      aggId: _checkInOfflineModel['aggId'],
      contactModeId: _checkInOfflineModel['contactModeId'],
      contactPlaceId: _checkInOfflineModel['contactPlaceId'],
      contactPersonId: _checkInOfflineModel['contactPersonId'],
      paymentAmount: _checkInOfflineModel['paymentAmount'],
      paymentBy: _checkInOfflineModel['paymentBy'],
      paymentUnit: _checkInOfflineModel['paymentUnit'],
      clientPhone: _checkInOfflineModel['clientPhone'],
      description: _checkInOfflineModel['description'],
      fieldActionId: _checkInOfflineModel['fieldActionId'],
      address: _checkInOfflineModel['address'],
      longitude: _checkInOfflineModel['longitude'],
      latitude: _checkInOfflineModel['latitude'],
      accuracy: _checkInOfflineModel['accuracy'],
      date: _checkInOfflineModel['date'],
      durationInMins: _checkInOfflineModel['durationInMins'],
      actionGroupName: _checkInOfflineModel['actionGroupName'],
      attachments: _checkInOfflineModel['attachments'],
      offlineInfo: _checkInOfflineModel['offlineInfo'],
      time: _checkInOfflineModel['time'],
      customerName: _checkInOfflineModel['customerName'],
      contractId: _checkInOfflineModel['contractId'],
      actionAttributeId: _checkInOfflineModel['actionAttributeId'],
      employeeInfomation: _checkInOfflineModel['employeeInfomation'],
      actionName: _checkInOfflineModel['actionName'],
      contactName: _checkInOfflineModel['contactName'],
      contactProvinceId: _checkInOfflineModel['contactProvinceId'],
      contactDistrictId: _checkInOfflineModel['contactDistrictId'],
      contactWardId: _checkInOfflineModel['contactWardId'],
      contactAddress: _checkInOfflineModel['contactAddress'],
      actionGroupCode: _checkInOfflineModel['actionGroupCode'],
      contactMobile: _checkInOfflineModel['contactMobile'],
      customerAttitude: _checkInOfflineModel['customerAttitude'],
      contactFullAddress: _checkInOfflineModel['contactFullAddress'],
      extraInfo: _checkInOfflineModel['extraInfo'],
      subAttributeId: _checkInOfflineModel['subAttributeId'],
      currentIncomeAmount: _checkInOfflineModel['currentIncomeAmount'],
      loanAmount: _checkInOfflineModel['loanAmount'],
      lastIncomeAmount: _checkInOfflineModel['lastIncomeAmount'],
      isRefusePayment: _checkInOfflineModel['isRefusePayment'],
      subAttributeGroupId: _checkInOfflineModel['subAttributeGroupId'],
      selfie: _checkInOfflineModel['selfie'],
    );
  }
}
