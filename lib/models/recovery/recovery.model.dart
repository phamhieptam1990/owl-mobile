import 'package:athena/utils/utils.dart';

class RecoveryModel {
  String? applId;
  DateTime? runDate;
  var noOfInstOverdue;
  String? notes;
  double? amountOutstanding;
  double? installmentAmt;
  String? type;
  String? idNo;
  int? number;
  String? perProvince;
  var creditLimit;
  int? id;
  String? issuePlace;
  int? noOfPaidMonth;
  String? perAddress;
  var currentChargeOutstanding;
  double? outDebts;
  DateTime? disbursalDate;
  double? lastDuedayPayAmt;
  double? totalPaidAmt;
  double? amountOverdue;
  String? collectorMobile;
  var currentPrincipleOutstanding;
  var ftsValue;
  DateTime? birthday;
  String? clientName;
  double? interestMonthly;
  String? templateCode;
  String? numberCode;
  DateTime? firstDuedate;
  String? collector;
  String? actMobile;
  int? modNo;
  var productletter;
  int? tenor;
  double? totalMoneyLms;
  DateTime? lastPaidDate;
  String? assignToUnit;
  DateTime? checkerDate;
  int? dpd;
  DateTime? issueDate;
  String? perDistrict;
  String? makerId;
  DateTime? createDate;
  double? interestRate;
  var agencyAdd;
  DateTime? makerDate;
  String? templateDesc;
  String? authStatus;
  DateTime? activedDate;
  var accountNumber;
  double? loanAmount;
  String? agencyName;
  String? recordStatus;
  int? duedate;
  int? checkerId;
  var currentIntOutstanding;
  String? assignToEmail;
  var assigneeData;
  var customerData;
  RecoveryModel({
    this.applId,
    this.runDate,
    this.noOfInstOverdue,
    this.notes,
    this.amountOutstanding,
    this.installmentAmt,
    this.type,
    this.idNo,
    this.number,
    this.perProvince,
    this.creditLimit,
    this.id,
    this.issuePlace,
    this.noOfPaidMonth,
    this.perAddress,
    this.currentChargeOutstanding,
    this.outDebts,
    this.disbursalDate,
    this.lastDuedayPayAmt,
    this.totalPaidAmt,
    this.amountOverdue,
    this.collectorMobile,
    this.currentPrincipleOutstanding,
    this.ftsValue,
    this.birthday,
    this.clientName,
    this.interestMonthly,
    this.templateCode,
    this.numberCode,
    this.firstDuedate,
    this.collector,
    this.actMobile,
    this.modNo,
    this.productletter,
    this.tenor,
    this.totalMoneyLms,
    this.lastPaidDate,
    this.assignToUnit,
    this.checkerDate,
    this.dpd,
    this.issueDate,
    this.perDistrict,
    this.makerId,
    this.createDate,
    this.interestRate,
    this.agencyAdd,
    this.makerDate,
    this.templateDesc,
    this.authStatus,
    this.activedDate,
    this.accountNumber,
    this.loanAmount,
    this.agencyName,
    this.recordStatus,
    this.duedate,
    this.checkerId,
    this.currentIntOutstanding,
    this.assignToEmail,
    this.assigneeData,
    this.customerData,
  });

  RecoveryModel.fromJson(Map<String, dynamic> json) {
    applId = json['applId'];
    clientName = json['clientName'];
    runDate = Utils.checkIsNotNull(json['runDate'])
        ? Utils.convertTimeStampToDate((json['runDate']))
        : null;
    noOfInstOverdue = json['noOfInstOverdue'];
    notes = json['notes'];
    // amountOutstanding = json['amountOutstanding'];
    if (Utils.checkIsNotNull(json['amountOutstanding'])) {
      amountOutstanding = Utils.checkValueIsDouble(json['amountOutstanding'])
          ? json['amountOutstanding']
          : double.tryParse(json['amountOutstanding'].toString());
    } else {
      amountOutstanding = null;
    }
    // installmentAmt = json['installmentAmt'];
    if (Utils.checkIsNotNull(json['installmentAmt'])) {
      installmentAmt = Utils.checkValueIsDouble(json['installmentAmt'])
          ? json['installmentAmt']
          : double.tryParse(json['installmentAmt'].toString());
    } else {
      installmentAmt = null;
    }
    type = json['type'];
    idNo = json['idNo'];
    number = json['number'];
    perProvince = json['perProvince'];
    creditLimit = json['creditLimit'];
    id = json['id'];
    issuePlace = json['issuePlace'];
    noOfPaidMonth = json['noOfPaidMonth'];
    perAddress = json['perAddress'];
    currentChargeOutstanding = json['currentChargeOutstanding'];
    // outDebts = json['outDebts'];
    if (Utils.checkIsNotNull(json['outDebts'])) {
      outDebts = Utils.checkValueIsDouble(json['outDebts'])
          ? json['outDebts']
          : double.tryParse(json['outDebts'].toString());
    } else {
      outDebts = null;
    }
    // disbursalDate = json['disbursalDate'];
    disbursalDate = Utils.checkIsNotNull(json['disbursalDate'])
        ? Utils.convertTimeStampToDate((json['disbursalDate']))
        : null;
    // lastDuedayPayAmt = json['lastDuedayPayAmt'];
    if (Utils.checkIsNotNull(json['lastDuedayPayAmt'])) {
      lastDuedayPayAmt = Utils.checkValueIsDouble(json['lastDuedayPayAmt'])
          ? json['lastDuedayPayAmt']
          : double.tryParse(json['lastDuedayPayAmt'].toString());
    } else {
      lastDuedayPayAmt = null;
    }

    // totalPaidAmt = json['totalPaidAmt'];
    if (Utils.checkIsNotNull(json['totalPaidAmt'])) {
      totalPaidAmt = Utils.checkValueIsDouble(json['totalPaidAmt'])
          ? json['totalPaidAmt']
          : double.tryParse(json['totalPaidAmt'].toString());
    } else {
      totalPaidAmt = null;
    }
    // amountOverdue = json['amountOverdue'];
    if (Utils.checkIsNotNull(json['amountOverdue'])) {
      amountOverdue = Utils.checkValueIsDouble(json['amountOverdue'])
          ? json['amountOverdue']
          : double.tryParse(json['amountOverdue'].toString());
    } else {
      amountOverdue = null;
    }
    collectorMobile = Utils.checkIsNotNull(json['collectorMobile'])
        ? json['collectorMobile']
        : '';
    currentPrincipleOutstanding = json['currentPrincipleOutstanding'];
    ftsValue = json['ftsValue'];
    // birthday = json['birthday'];
    birthday = Utils.checkIsNotNull(json['birthday'])
        ? Utils.convertTimeStampToDate((json['birthday']))
        : null;

    if (Utils.checkIsNotNull(json['interestMonthly'])) {
      interestMonthly = Utils.checkValueIsDouble(json['interestMonthly'])
          ? json['interestMonthly']
          : double.tryParse(json['interestMonthly'].toString());
    } else {
      interestMonthly = null;
    }
    templateCode = json['templateCode'];
    numberCode = json['numberCode'];
    // firstDuedate = json['firstDuedate'];
    firstDuedate = Utils.checkIsNotNull(json['firstDuedate'])
        ? Utils.convertTimeStampToDate((json['firstDuedate']))
        : null;
    collector =
        Utils.checkIsNotNull(json['collector']) ? json['collector'] : '';
    actMobile = json['actMobile'];
    modNo = json['modNo'];
    productletter = json['productletter'];
    tenor = json['tenor'];
    // totalMoneyLms = json['totalMoneyLms'];
    if (Utils.checkIsNotNull(json['totalMoneyLms'])) {
      totalMoneyLms = Utils.checkValueIsDouble(json['totalMoneyLms'])
          ? json['totalMoneyLms']
          : double.tryParse(json['totalMoneyLms'].toString());
    } else {
      totalMoneyLms = null;
    }
    // lastPaidDate = json['lastPaidDate'];
    lastPaidDate = Utils.checkIsNotNull(json['lastPaidDate'])
        ? Utils.convertTimeStampToDate((json['lastPaidDate']))
        : null;
    assignToUnit = json['assignToUnit'];
    // checkerDate = json['checkerDate'];
    checkerDate = Utils.checkIsNotNull(json['checkerDate'])
        ? Utils.convertTimeStampToDate((json['checkerDate']))
        : null;
    dpd = json['dpd'];
    // issueDate = json['issueDate'];
    issueDate = Utils.checkIsNotNull(json['issueDate'])
        ? Utils.convertTimeStampToDate((json['issueDate']))
        : null;
    perDistrict = json['perDistrict'];
    makerId = json['makerId'];
    // createDate = json['createDate'];
    createDate = Utils.checkIsNotNull(json['createDate'])
        ? Utils.convertTimeStampToDate((json['createDate']))
        : null;
    if (Utils.checkIsNotNull(json['interestRate'])) {
      interestRate = Utils.checkValueIsDouble(json['interestRate'])
          ? json['interestRate']
          : double.tryParse(json['interestRate'].toString());
    } else {
      interestRate = null;
    }
    // interestRate = json['interestRate'];
    agencyAdd = json['agencyAdd'];
    // makerDate = json['makerDate'];
    makerDate = Utils.checkIsNotNull(json['makerDate'])
        ? Utils.convertTimeStampToDate((json['makerDate']))
        : null;
    templateDesc = json['templateDesc'];
    authStatus = json['authStatus'];
    activedDate = Utils.checkIsNotNull(json['activedDate'])
        ? Utils.convertTimeStampToDate((json['activedDate']))
        : null;
    accountNumber = json['accountNumber'];
    // loanAmount = json['loanAmount'];
    if (Utils.checkIsNotNull(json['loanAmount'])) {
      loanAmount = Utils.checkValueIsDouble(json['loanAmount'])
          ? json['loanAmount']
          : double.tryParse(json['loanAmount'].toString());
    } else {
      loanAmount = null;
    }
    agencyName = json['agencyName'];
    recordStatus = json['recordStatus'];
    duedate = json['duedate'];
    // duedate = Utils.checkIsNotNull(json['duedate'])
    //     ? Utils.convertTimeStampToDate((json['duedate']))
    //     : null;
    checkerId = json['checkerId'];
    currentIntOutstanding = json['currentIntOutstanding'];
    assignToEmail = json['assignToEmail'];
    assigneeData = json['assigneeData'];
    customerData = json['customerData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applId'] = this.applId;
    data['runDate'] = this.runDate;
    data['noOfInstOverdue'] = this.noOfInstOverdue;
    data['notes'] = this.notes;
    data['amountOutstanding'] = this.amountOutstanding;
    data['installmentAmt'] = this.installmentAmt;
    data['type'] = this.type;
    data['idNo'] = this.idNo;
    data['number'] = this.number;
    data['perProvince'] = this.perProvince;
    data['creditLimit'] = this.creditLimit;
    data['id'] = this.id;
    data['issuePlace'] = this.issuePlace;
    data['noOfPaidMonth'] = this.noOfPaidMonth;
    data['perAddress'] = this.perAddress;
    data['currentChargeOutstanding'] = this.currentChargeOutstanding;
    data['outDebts'] = this.outDebts;
    data['disbursalDate'] = this.disbursalDate;
    data['lastDuedayPayAmt'] = this.lastDuedayPayAmt;
    data['totalPaidAmt'] = this.totalPaidAmt;
    data['amountOverdue'] = this.amountOverdue;
    data['collectorMobile'] = this.collectorMobile;
    data['currentPrincipleOutstanding'] = this.currentPrincipleOutstanding;
    data['ftsValue'] = this.ftsValue;
    data['birthday'] = this.birthday;
    data['clientName'] = this.clientName;
    data['interestMonthly'] = this.interestMonthly;
    data['templateCode'] = this.templateCode;
    data['numberCode'] = this.numberCode;
    data['firstDuedate'] = this.firstDuedate;
    data['collector'] = this.collector;
    data['actMobile'] = this.actMobile;
    data['modNo'] = this.modNo;
    data['productletter'] = this.productletter;
    data['tenor'] = this.tenor;
    data['totalMoneyLms'] = this.totalMoneyLms;
    data['lastPaidDate'] = this.lastPaidDate;
    data['assignToUnit'] = this.assignToUnit;
    data['checkerDate'] = this.checkerDate;
    data['dpd'] = this.dpd;
    data['issueDate'] = this.issueDate;
    data['perDistrict'] = this.perDistrict;
    data['makerId'] = this.makerId;
    data['createDate'] = this.createDate;
    data['interestRate'] = this.interestRate;
    data['agencyAdd'] = this.agencyAdd;
    data['makerDate'] = this.makerDate;
    data['templateDesc'] = this.templateDesc;
    data['authStatus'] = this.authStatus;
    data['activedDate'] = this.activedDate;
    data['accountNumber'] = this.accountNumber;
    data['loanAmount'] = this.loanAmount;
    data['agencyName'] = this.agencyName;
    data['recordStatus'] = this.recordStatus;
    data['duedate'] = this.duedate;
    data['checkerId'] = this.checkerId;
    data['currentIntOutstanding'] = this.currentIntOutstanding;
    data['assignToEmail'] = this.assignToEmail;
    data['assigneeData'] = this.assigneeData;
    data['customerData'] = this.customerData;
    return data;
  }
}
