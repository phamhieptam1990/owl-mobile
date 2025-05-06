import '../../utils/utils.dart';

class ContractForeclosureModel {
  var advice;
  var noinstallmentsoverdue;
  int? penalty;
  int? overduecharges;
  var description;
  String? tenantCode;
  var principalbalance;
  var totalpayable;
  var chargesoverdue;
  int? modNo;
  var totaloverdueamount;
  var installmentsremaining;
  var interfund;
  var checkerDate;
  var closuredate;
  var totalreceivable;
  var excessprincipal;
  var nettotal;
  int? dpd;
  int? id;
  String? ftsStringValue;
  String? createDate;
  String? makerId;
  var totalinstallmentpaid;
  String? makerDate;
  String? authStatus;
  var totalprincipalpaid;
  var residualvalue;
  var advanceinstallment;
  var restexcessamounts;
  var additionalamount;
  var penaltycalculatedon;
  Props? props;
  var bucket;
  var tentativeforeclouseamount;
  var prepaymentpenalty;
  var payadvice;
  String? recordStatus;
  var unbilledinstallment;
  var totalinterestpaid;
  double? installment;
  int? contractId;
  var checkerId;
  var lmtbContract;
  var ftsValue;
  int? interestoverdue;
  var othercharges;
  int? principaloverdue;

  ContractForeclosureModel(
      {this.advice,
      this.noinstallmentsoverdue,
      this.penalty,
      this.overduecharges,
      this.description,
      this.tenantCode,
      this.principalbalance,
      this.totalpayable,
      this.chargesoverdue,
      this.modNo,
      this.totaloverdueamount,
      this.installmentsremaining,
      this.interfund,
      this.checkerDate,
      this.closuredate,
      this.totalreceivable,
      this.excessprincipal,
      this.nettotal,
      this.dpd,
      this.id,
      this.ftsStringValue,
      this.createDate,
      this.makerId,
      this.totalinstallmentpaid,
      this.makerDate,
      this.authStatus,
      this.totalprincipalpaid,
      this.residualvalue,
      this.advanceinstallment,
      this.restexcessamounts,
      this.additionalamount,
      this.penaltycalculatedon,
      this.props,
      this.bucket,
      this.tentativeforeclouseamount,
      this.prepaymentpenalty,
      this.payadvice,
      this.recordStatus,
      this.unbilledinstallment,
      this.totalinterestpaid,
      this.installment,
      this.contractId,
      this.checkerId,
      this.lmtbContract,
      this.ftsValue,
      this.interestoverdue,
      this.othercharges,
      this.principaloverdue});

  ContractForeclosureModel.fromJson(Map<String, dynamic> json) {
    try{
advice = json['advice'];
    noinstallmentsoverdue = json['noinstallmentsoverdue'];
    penalty = json['penalty'];
    overduecharges = json['overduecharges'];
    description = json['description'];
    tenantCode = json['tenantCode'];
    principalbalance = json['principalbalance'];
    totalpayable = json['totalpayable'];
    chargesoverdue = json['chargesoverdue'];
    modNo = json['modNo'];
    totaloverdueamount = json['totaloverdueamount'];
    installmentsremaining = json['installmentsremaining'];
    interfund = json['interfund'];
    checkerDate = json['checkerDate'];
    closuredate = json['closuredate'];
    totalreceivable = json['totalreceivable'];
    excessprincipal = json['excessprincipal'];
    nettotal = json['nettotal'];
    dpd = json['dpd'];
    id = json['id'];
    ftsStringValue = json['ftsStringValue'];
    createDate = json['createDate'];
    makerId = json['makerId'];
    totalinstallmentpaid = json['totalinstallmentpaid'];
    makerDate = json['makerDate'];
    authStatus = json['authStatus'];
    totalprincipalpaid = json['totalprincipalpaid'];
    residualvalue = json['residualvalue'];
    advanceinstallment = json['advanceinstallment'];
    restexcessamounts = json['restexcessamounts'];
    additionalamount = json['additionalamount'];
    penaltycalculatedon = json['penaltycalculatedon'];
    props = json['props'] != null  ? new Props.fromJson(json['props']) : null;
    bucket = json['bucket'];
    tentativeforeclouseamount = json['tentativeforeclouseamount'];
    prepaymentpenalty = json['prepaymentpenalty'];
    payadvice = json['payadvice'];
    recordStatus = json['recordStatus'];
    unbilledinstallment = json['unbilledinstallment'];
    totalinterestpaid = json['totalinterestpaid'];
    installment = Utils.convertDataToDouble(json['installment']);
    contractId = json['contractId'];
    checkerId = json['checkerId'];
    lmtbContract = json['lmtbContract'];
    ftsValue = json['ftsValue'];
    interestoverdue = json['interestoverdue'];
    othercharges = json['othercharges'];
    principaloverdue = json['principaloverdue'];
    }catch(e){
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advice'] = this.advice;
    data['noinstallmentsoverdue'] = this.noinstallmentsoverdue;
    data['penalty'] = this.penalty;
    data['overduecharges'] = this.overduecharges;
    data['description'] = this.description;
    data['tenantCode'] = this.tenantCode;
    data['principalbalance'] = this.principalbalance;
    data['totalpayable'] = this.totalpayable;
    data['chargesoverdue'] = this.chargesoverdue;
    data['modNo'] = this.modNo;
    data['totaloverdueamount'] = this.totaloverdueamount;
    data['installmentsremaining'] = this.installmentsremaining;
    data['interfund'] = this.interfund;
    data['checkerDate'] = this.checkerDate;
    data['closuredate'] = this.closuredate;
    data['totalreceivable'] = this.totalreceivable;
    data['excessprincipal'] = this.excessprincipal;
    data['nettotal'] = this.nettotal;
    data['dpd'] = this.dpd;
    data['id'] = this.id;
    data['ftsStringValue'] = this.ftsStringValue;
    data['createDate'] = this.createDate;
    data['makerId'] = this.makerId;
    data['totalinstallmentpaid'] = this.totalinstallmentpaid;
    data['makerDate'] = this.makerDate;
    data['authStatus'] = this.authStatus;
    data['totalprincipalpaid'] = this.totalprincipalpaid;
    data['residualvalue'] = this.residualvalue;
    data['advanceinstallment'] = this.advanceinstallment;
    data['restexcessamounts'] = this.restexcessamounts;
    data['additionalamount'] = this.additionalamount;
    data['penaltycalculatedon'] = this.penaltycalculatedon;
    data['props'] = this.props?.toJson();
    data['bucket'] = this.bucket;
    data['tentativeforeclouseamount'] = this.tentativeforeclouseamount;
    data['prepaymentpenalty'] = this.prepaymentpenalty;
    data['payadvice'] = this.payadvice;
    data['recordStatus'] = this.recordStatus;
    data['unbilledinstallment'] = this.unbilledinstallment;
    data['totalinterestpaid'] = this.totalinterestpaid;
    data['installment'] = this.installment;
    data['contractId'] = this.contractId;
    data['checkerId'] = this.checkerId;
    data['lmtbContract'] = this.lmtbContract;
    data['ftsValue'] = this.ftsValue;
    data['interestoverdue'] = this.interestoverdue;
    data['othercharges'] = this.othercharges;
    data['principaloverdue'] = this.principaloverdue;
    return data;
  }
}

class Props {
  String? lASTPAY;
  String? lASTPAY2;
  String? lASTPAYDATE;
  String? nGAYTRAKY1;
  double? lASTPAYMENTAMT;
  double? sOTIENTRAKY1;
  var LAST_PAYMENT_AMOUNT;
  var LAST_PAYMENT_DATE;
  var TOTAL_PAID;
  var PRINCIPLE_OVERDUE;
  var OTHER_CHARGES;
  var TOTAL_REPAYMENT;
  var REMAIN_TOTAL;
  var BALANCE_AMOUNT;
  var PENALTY;
  var DEAL_DATE;
  Props(
      {this.lASTPAY,
      this.lASTPAY2,
      this.lASTPAYDATE,
      this.nGAYTRAKY1,
      this.lASTPAYMENTAMT,
      this.sOTIENTRAKY1,
      this.LAST_PAYMENT_AMOUNT,
      this.LAST_PAYMENT_DATE,
      this.TOTAL_PAID,
      this.PRINCIPLE_OVERDUE,
      this.OTHER_CHARGES,
      this.BALANCE_AMOUNT
      });

  Props.fromJson(Map<String, dynamic> json) {
    lASTPAY = json['LAST_PAY'];
    lASTPAY2 = json['LAST_PAY_2'];
    lASTPAYDATE = json['LAST_PAY_DATE'];
    nGAYTRAKY1 = json['NGAY_TRA_KY_1'];
    lASTPAYMENTAMT = json['LAST_PAYMENT_AMT'];
    sOTIENTRAKY1 = json['SO_TIEN_TRA_KY_1'];
    LAST_PAYMENT_AMOUNT = json['LAST_PAYMENT_AMOUNT'];
    LAST_PAYMENT_DATE = json['LAST_PAYMENT_DATE'];
    TOTAL_PAID = json['TOTAL_PAID'];
    BALANCE_AMOUNT = json['BALANCE_AMOUNT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LAST_PAY'] = this.lASTPAY;
    data['LAST_PAY_2'] = this.lASTPAY2;
    data['LAST_PAY_DATE'] = this.lASTPAYDATE;
    data['NGAY_TRA_KY_1'] = this.nGAYTRAKY1;
    data['LAST_PAYMENT_AMT'] = this.lASTPAYMENTAMT;
    data['LAST_PAYMENT_DATE'] = this.LAST_PAYMENT_DATE;
    data['TOTAL_PAID'] = this.TOTAL_PAID;
    data['BALANCE_AMOUNT'] = this.BALANCE_AMOUNT;
    // data['LAST_PAYMENT_AMT'] = this.lASTPAYMENTAMT;
    // data['SO_TIEN_TRA_KY_1'] = this.sOTIENTRAKY1;
    return data;
  }
}