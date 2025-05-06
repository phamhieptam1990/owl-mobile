class ModelBriefByContractNo {
  var lastPaymentAmt;
  var customerTitle;
  String? contractDate;
  var lmtbContractAssets;
  int? noOfInstOverdue;
  var installmentAmt;
  var idnumber;
  String? disbursalchanel;
  var lmtmContractStatus;
  var lmtbContractReversals;
  var appId;
  int? id;
  var lmtbContractBalances;
  LmtbScheme? lmtbScheme;
  var lmtbContractPaysches;
  String? disbursalDate;
  Props? props;
  var firstName;
  int? companyId;
  var disbursalbranchcode;
  var amountOverdue;
  var lmtbContractBasics;
  var ftsValue;
  var saleunitcode;
  String? cifCode;
  String? schemeCode;
  var lastName;
  int? nfuFlag;
  String? city;
  String? contractNo;
  var lmtbTransactions;
  var lmtbContractGuarantors;
  var description;
  String? delinquencyString;
  String? tenantCode;
  int? principleOutstanding;
  var lmtbContractPayments;
  int? modNo;
  var businessDate;
  var lmtbContractOverdues;
  var checkerDate;
  String? lastPaymentDate;
  String? installmentDueDate;
  int? dpd;
  String? ftsStringValue;
  String? createDate;
  String? makerId;
  LmtmCompany? lmtmCompany;
  String? makerDate;
  String? product;
  String? contractStatus;
  var installmentAmtOverdue;
  String? authStatus;
  var fullName;
  var lmtbIpatTransactions;
  var loanAmount;
  var lmtbPaymentSchedules;
  var lmtbContractForeclosures;
  String? recordStatus;
  var originalPos;
  var checkerId;
  var collectedAmt;
  var middleName;
  String? aggId;
  String? contractCode;

  ModelBriefByContractNo(
      {this.lastPaymentAmt,
      this.customerTitle,
      this.contractDate,
      this.lmtbContractAssets,
      this.noOfInstOverdue,
      this.installmentAmt,
      this.idnumber,
      this.disbursalchanel,
      this.lmtmContractStatus,
      this.lmtbContractReversals,
      this.appId,
      this.id,
      this.lmtbContractBalances,
      this.lmtbScheme,
      this.lmtbContractPaysches,
      this.disbursalDate,
      this.props,
      this.firstName,
      this.companyId,
      this.disbursalbranchcode,
      this.amountOverdue,
      this.lmtbContractBasics,
      this.ftsValue,
      this.saleunitcode,
      this.cifCode,
      this.schemeCode,
      this.lastName,
      this.nfuFlag,
      this.city,
      this.contractNo,
      this.lmtbTransactions,
      this.lmtbContractGuarantors,
      this.description,
      this.delinquencyString,
      this.tenantCode,
      this.principleOutstanding,
      this.lmtbContractPayments,
      this.modNo,
      this.businessDate,
      this.lmtbContractOverdues,
      this.checkerDate,
      this.lastPaymentDate,
      this.installmentDueDate,
      this.dpd,
      this.ftsStringValue,
      this.createDate,
      this.makerId,
      this.lmtmCompany,
      this.makerDate,
      this.product,
      this.contractStatus,
      this.installmentAmtOverdue,
      this.authStatus,
      this.fullName,
      this.lmtbIpatTransactions,
      this.loanAmount,
      this.lmtbPaymentSchedules,
      this.lmtbContractForeclosures,
      this.recordStatus,
      this.originalPos,
      this.checkerId,
      this.collectedAmt,
      this.middleName,
      this.aggId,
      this.contractCode});

  ModelBriefByContractNo.fromJson(Map<String, dynamic> json) {
    try{
      lastPaymentAmt = json['lastPaymentAmt'];
    customerTitle = json['customerTitle'];
    contractDate = json['contractDate'];
    lmtbContractAssets = json['lmtbContractAssets'];
    noOfInstOverdue = json['noOfInstOverdue'];
    installmentAmt = json['installmentAmt'];
    idnumber = json['idnumber'];
    disbursalchanel = json['disbursalchanel'];
    lmtmContractStatus = json['lmtmContractStatus'];
    lmtbContractReversals = json['lmtbContractReversals'];
    appId = json['appId'];
    id = json['id'];
    lmtbContractBalances = json['lmtbContractBalances'];
    lmtbScheme = json['lmtbScheme'] == null
        ? null
        : LmtbScheme.fromJson(json['lmtbScheme']);
    lmtbContractPaysches = json['lmtbContractPaysches'];
    disbursalDate = json['disbursalDate'];
    props = json['props'] == null ? null : new Props.fromJson(json['props']);
    firstName = json['firstName'];
    companyId = json['companyId'];
    disbursalbranchcode = json['disbursalbranchcode'];
    amountOverdue = json['amountOverdue'];
    lmtbContractBasics = json['lmtbContractBasics'];
    ftsValue = json['ftsValue'];
    saleunitcode = json['saleunitcode'];
    cifCode = json['cifCode'];
    schemeCode = json['schemeCode'];
    lastName = json['lastName'];
    nfuFlag = json['nfuFlag'];
    city = json['city'];
    contractNo = json['contractNo'];
    lmtbTransactions = json['lmtbTransactions'];
    lmtbContractGuarantors = json['lmtbContractGuarantors'];
    description = json['description'];
    delinquencyString = json['delinquencyString'];
    tenantCode = json['tenantCode'];
    principleOutstanding = json['principleOutstanding'];
    lmtbContractPayments = json['lmtbContractPayments'];
    modNo = json['modNo'];
    businessDate = json['businessDate'];
    lmtbContractOverdues = json['lmtbContractOverdues'];
    checkerDate = json['checkerDate'];
    lastPaymentDate = json['lastPaymentDate'];
    installmentDueDate = json['installmentDueDate'];
    dpd = json['dpd'];
    ftsStringValue = json['ftsStringValue'];
    createDate = json['createDate'];
    makerId = json['makerId'];
    lmtmCompany = json['lmtmCompany'] == null
        ? null
        : new LmtmCompany.fromJson(json['lmtmCompany']);
    makerDate = json['makerDate'];
    product = json['product'];
    contractStatus = json['contractStatus'];
    installmentAmtOverdue = json['installmentAmtOverdue'];
    authStatus = json['authStatus'];
    fullName = json['fullName'];
    lmtbIpatTransactions = json['lmtbIpatTransactions'];
    loanAmount = json['loanAmount'];
    lmtbPaymentSchedules = json['lmtbPaymentSchedules'];
    lmtbContractForeclosures = json['lmtbContractForeclosures'];
    recordStatus = json['recordStatus'];
    originalPos = json['originalPos'];
    checkerId = json['checkerId'];
    collectedAmt = json['collectedAmt'];
    middleName = json['middleName'];
    aggId = json['aggId'];
    contractCode = json['contractCode'];
    }catch(e){
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try{
      data['lastPaymentAmt'] = this.lastPaymentAmt;
    data['customerTitle'] = this.customerTitle;
    data['contractDate'] = this.contractDate;
    data['lmtbContractAssets'] = this.lmtbContractAssets;
    data['noOfInstOverdue'] = this.noOfInstOverdue;
    data['installmentAmt'] = this.installmentAmt;
    data['idnumber'] = this.idnumber;
    data['disbursalchanel'] = this.disbursalchanel;
    data['lmtmContractStatus'] = this.lmtmContractStatus;
    data['lmtbContractReversals'] = this.lmtbContractReversals;
    data['appId'] = this.appId;
    data['id'] = this.id;
    data['lmtbContractBalances'] = this.lmtbContractBalances;
    data['lmtbScheme'] = this.lmtbScheme?.toJson();
    data['lmtbContractPaysches'] = this.lmtbContractPaysches;
    data['disbursalDate'] = this.disbursalDate;
    data['props'] = this.props?.toJson();
    data['firstName'] = this.firstName;
    data['companyId'] = this.companyId;
    data['disbursalbranchcode'] = this.disbursalbranchcode;
    data['amountOverdue'] = this.amountOverdue;
    data['lmtbContractBasics'] = this.lmtbContractBasics;
    data['ftsValue'] = this.ftsValue;
    data['saleunitcode'] = this.saleunitcode;
    data['cifCode'] = this.cifCode;
    data['schemeCode'] = this.schemeCode;
    data['lastName'] = this.lastName;
    data['nfuFlag'] = this.nfuFlag;
    data['city'] = this.city;
    data['contractNo'] = this.contractNo;
    data['lmtbTransactions'] = this.lmtbTransactions;
    data['lmtbContractGuarantors'] = this.lmtbContractGuarantors;
    data['description'] = this.description;
    data['delinquencyString'] = this.delinquencyString;
    data['tenantCode'] = this.tenantCode;
    data['principleOutstanding'] = this.principleOutstanding;
    data['lmtbContractPayments'] = this.lmtbContractPayments;
    data['modNo'] = this.modNo;
    data['businessDate'] = this.businessDate;
    data['lmtbContractOverdues'] = this.lmtbContractOverdues;
    data['checkerDate'] = this.checkerDate;
    data['lastPaymentDate'] = this.lastPaymentDate;
    data['installmentDueDate'] = this.installmentDueDate;
    data['dpd'] = this.dpd;
    data['ftsStringValue'] = this.ftsStringValue;
    data['createDate'] = this.createDate;
    data['makerId'] = this.makerId;
    data['lmtmCompany'] = this.lmtmCompany?.toJson();
    data['makerDate'] = this.makerDate;
    data['product'] = this.product;
    data['contractStatus'] = this.contractStatus;
    data['installmentAmtOverdue'] = this.installmentAmtOverdue;
    data['authStatus'] = this.authStatus;
    data['fullName'] = this.fullName;
    data['lmtbIpatTransactions'] = this.lmtbIpatTransactions;
    data['loanAmount'] = this.loanAmount;
    data['lmtbPaymentSchedules'] = this.lmtbPaymentSchedules;
    data['lmtbContractForeclosures'] = this.lmtbContractForeclosures;
    data['recordStatus'] = this.recordStatus;
    data['originalPos'] = this.originalPos;
    data['checkerId'] = this.checkerId;
    data['collectedAmt'] = this.collectedAmt;
    data['middleName'] = this.middleName;
    data['aggId'] = this.aggId;
    data['contractCode'] = this.contractCode;
    return data;
    }catch(e){
      print(e);
      return data;
    }
  }
}

class LmtbScheme {
  String? schemeCode;
  int? principalPercentage;
  String? description;
  String? tenantCode;
  var lmtbPairingHierarchies;
  var modNo;
  var lmtbSchemeLedgers;
  String? checkerDate;
  int? interest;
  var term;
  var id;
  var createDate;
  var expirationDate;
  String? makerId;
  String? makerDate;
  String? authStatus;
  String? schemeName;
  var props;
  String? recordStatus;
  var lmtbContracts;
  int? penaltyFee;
  String? checkerId;
  String? aggId;
  var ftsValue;
  var effectiveDate;

  LmtbScheme(
      {this.schemeCode,
      this.principalPercentage,
      this.description,
      this.tenantCode,
      this.lmtbPairingHierarchies,
      this.modNo,
      this.lmtbSchemeLedgers,
      this.checkerDate,
      this.interest,
      this.term,
      this.id,
      this.createDate,
      this.expirationDate,
      this.makerId,
      this.makerDate,
      this.authStatus,
      this.schemeName,
      this.props,
      this.recordStatus,
      this.lmtbContracts,
      this.penaltyFee,
      this.checkerId,
      this.aggId,
      this.ftsValue,
      this.effectiveDate});

  LmtbScheme.fromJson(Map<String, dynamic> json) {
    schemeCode = json['schemeCode'];
    principalPercentage = json['principalPercentage'];
    description = json['description'];
    tenantCode = json['tenantCode'];
    lmtbPairingHierarchies = json['lmtbPairingHierarchies'];
    modNo = json['modNo'];
    lmtbSchemeLedgers = json['lmtbSchemeLedgers'];
    checkerDate = json['checkerDate'];
    interest = json['interest'];
    term = json['term'];
    id = json['id'];
    createDate = json['createDate'];
    expirationDate = json['expirationDate'];
    makerId = json['makerId'];
    makerDate = json['makerDate'];
    authStatus = json['authStatus'];
    schemeName = json['schemeName'];
    props = json['props'];
    recordStatus = json['recordStatus'];
    lmtbContracts = json['lmtbContracts'];
    penaltyFee = json['penaltyFee'];
    checkerId = json['checkerId'];
    aggId = json['aggId'];
    ftsValue = json['ftsValue'];
    effectiveDate = json['effectiveDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schemeCode'] = this.schemeCode;
    data['principalPercentage'] = this.principalPercentage;
    data['description'] = this.description;
    data['tenantCode'] = this.tenantCode;
    data['lmtbPairingHierarchies'] = this.lmtbPairingHierarchies;
    data['modNo'] = this.modNo;
    data['lmtbSchemeLedgers'] = this.lmtbSchemeLedgers;
    data['checkerDate'] = this.checkerDate;
    data['interest'] = this.interest;
    data['term'] = this.term;
    data['id'] = this.id;
    data['createDate'] = this.createDate;
    data['expirationDate'] = this.expirationDate;
    data['makerId'] = this.makerId;
    data['makerDate'] = this.makerDate;
    data['authStatus'] = this.authStatus;
    data['schemeName'] = this.schemeName;
    data['props'] = this.props;
    data['recordStatus'] = this.recordStatus;
    data['lmtbContracts'] = this.lmtbContracts;
    data['penaltyFee'] = this.penaltyFee;
    data['checkerId'] = this.checkerId;
    data['aggId'] = this.aggId;
    data['ftsValue'] = this.ftsValue;
    data['effectiveDate'] = this.effectiveDate;
    return data;
  }
}

class Props {
  String? tITLE;
  String? iDNUMBER;
  String? fULLNAME;
  String? lASTNAME;
  var fIRSTNAME;
  String? mIDDLENAME;
  var PAID_TERM;
  var ACCOUNT_NUMBER;
  var PRINCIPLE_OVERDUE;
  var OTHER_CHARGES;
  var REMAIN_TOTAL;
  var BALANCE_AMOUNT;
  var DISBURSEMENT_AMT;
  var LAST_PAYMENT_DATE;
  var FIRST_DUE_DATE;
  var DEBT_SALE_DATE;
  var TOTAL_REPAYMENT;

  Props(
      {this.tITLE,
      this.iDNUMBER,
      this.fULLNAME,
      this.lASTNAME,
      this.fIRSTNAME,
      this.PAID_TERM,
      this.ACCOUNT_NUMBER,
      this.PRINCIPLE_OVERDUE,
      this.OTHER_CHARGES,
      this.REMAIN_TOTAL,
      this.BALANCE_AMOUNT,
      this.DISBURSEMENT_AMT,
      this.LAST_PAYMENT_DATE,
      this.FIRST_DUE_DATE,
      this.DEBT_SALE_DATE,
      this.TOTAL_REPAYMENT,
      this.mIDDLENAME,

      });

  Props.fromJson(Map<String, dynamic> json) {

    tITLE = json['TITLE'];
    iDNUMBER = json['IDNUMBER'];
    fULLNAME = json['FULL_NAME'];
    lASTNAME = json['LAST_NAME'];
    PAID_TERM = json['PAID_TERM'];
    fIRSTNAME = json['FIRST_NAME'];
    mIDDLENAME = json['MIDDLE_NAME'];
    PRINCIPLE_OVERDUE = json['PRINCIPLE_OVERDUE'];
    ACCOUNT_NUMBER = json['ACCOUNT_NUMBER'];
    OTHER_CHARGES = json['OTHER_CHARGES'];
    REMAIN_TOTAL = json['REMAIN_TOTAL'];
    BALANCE_AMOUNT = json['BALANCE_AMOUNT'];
    DISBURSEMENT_AMT = json['DISBURSEMENT_AMT'];
    LAST_PAYMENT_DATE = json['LAST_PAYMENT_DATE'];
    FIRST_DUE_DATE = json['FIRST_DUE_DATE'];
    DEBT_SALE_DATE = json['DEBT_SALE_DATE'];
    TOTAL_REPAYMENT = json['TOTAL_REPAYMENT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TITLE'] = this.tITLE;
    data['IDNUMBER'] = this.iDNUMBER;
    data['FULL_NAME'] = this.fULLNAME;
    data['LAST_NAME'] = this.lASTNAME;
    data['FIRST_NAME'] = this.fIRSTNAME;
    data['MIDDLE_NAME'] = this.mIDDLENAME;
    data['PAID_TERM'] = this.PAID_TERM;
    data['ACCOUNT_NUMBER'] = this.ACCOUNT_NUMBER;
    data['PRINCIPLE_OVERDUE'] = this.PRINCIPLE_OVERDUE;
    data['OTHER_CHARGES'] = this.OTHER_CHARGES;
    data['REMAIN_TOTAL'] = this.REMAIN_TOTAL;
    data['BALANCE_AMOUNT'] = this.BALANCE_AMOUNT;
    data['DISBURSEMENT_AMT'] = this.DISBURSEMENT_AMT;
    data['LAST_PAYMENT_DATE'] = this.LAST_PAYMENT_DATE;
    data['FIRST_DUE_DATE'] = this.FIRST_DUE_DATE;
    data['DEBT_SALE_DATE'] = this.DEBT_SALE_DATE;
    data['FIRST_DUE_DATE'] = this.FIRST_DUE_DATE;
    data['TOTAL_REPAYMENT'] = this.TOTAL_REPAYMENT;
    return data;
  }
}

class LmtmCompany {
  String? companyCode;
  String? makerDate;
  String? authStatus;
  String? companyName;
  String? description;
  String? tenantCode;
  int? modNo;
  String? recordStatus;
  String? checkerDate;
  var lmtbContracts;
  String? checkerId;
  int? id;
  String? aggId;
  var ftsValue;
  String? createDate;
  String? makerId;

  LmtmCompany(
      {this.companyCode,
      this.makerDate,
      this.authStatus,
      this.companyName,
      this.description,
      this.tenantCode,
      this.modNo,
      this.recordStatus,
      this.checkerDate,
      this.lmtbContracts,
      this.checkerId,
      this.id,
      this.aggId,
      this.ftsValue,
      this.createDate,
      this.makerId});

  LmtmCompany.fromJson(Map<String, dynamic> json) {
    companyCode = json['companyCode'];
    makerDate = json['makerDate'];
    authStatus = json['authStatus'];
    companyName = json['companyName'];
    description = json['description'];
    tenantCode = json['tenantCode'];
    modNo = json['modNo'];
    recordStatus = json['recordStatus'];
    checkerDate = json['checkerDate'];
    lmtbContracts = json['lmtbContracts'];
    checkerId = json['checkerId'];
    id = json['id'];
    aggId = json['aggId'];
    ftsValue = json['ftsValue'];
    createDate = json['createDate'];
    makerId = json['makerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyCode'] = this.companyCode;
    data['makerDate'] = this.makerDate;
    data['authStatus'] = this.authStatus;
    data['companyName'] = this.companyName;
    data['description'] = this.description;
    data['tenantCode'] = this.tenantCode;
    data['modNo'] = this.modNo;
    data['recordStatus'] = this.recordStatus;
    data['checkerDate'] = this.checkerDate;
    data['lmtbContracts'] = this.lmtbContracts;
    data['checkerId'] = this.checkerId;
    data['id'] = this.id;
    data['aggId'] = this.aggId;
    data['ftsValue'] = this.ftsValue;
    data['createDate'] = this.createDate;
    data['makerId'] = this.makerId;
    return data;
  }
}
