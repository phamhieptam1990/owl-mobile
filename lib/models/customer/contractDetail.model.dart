class ContractDetailModel {
  var lastPaymentAmt;
  var customerTitle;
  String? contractDate;
  var lmtbContractAssets;
  int? noOfInstOverdue;
  var contractType;
  var installmentAmt;
  var idnumber;
  var disbursalchanel;
  var lmtmContractStatus;
  var lmtbContractReversals;
  String? appId;
  int? id;
  var lmtbContractBalances;
   LmtbScheme? lmtbScheme;
  var lmtbContractPaysches;
  var disbursalDate;
   Props? props;
  var firstName;
  int? companyId;
  var disbursalbranchcode;
  var amountOverdue;
  var lmtbContractBasics;
  var ftsValue;
  String? saleunitcode;
  String? cifCode;
  String? schemeCode;
  var lastName;
  int? nfuFlag;
  var city;
  String? contractNo;
  var lmtbTransactions;
  var lmtbContractGuarantors;
  var description;
  var delinquencyString;
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
  String? fullName;
  var lmtbIpatTransactions;
  var loanAmount;
  var lmtbPaymentSchedules;
  var lmtbContractForeclosures;
  String? recordStatus;
  int? originalPos;
  var checkerId;
  var collectedAmt;
  var middleName;
  String? aggId;
  String? contractCode;

  ContractDetailModel(
      {this.lastPaymentAmt,
      this.customerTitle,
      this.contractDate,
      this.lmtbContractAssets,
      this.noOfInstOverdue,
      this.contractType,
      this.installmentAmt,
      this.idnumber,
      this.disbursalchanel,
      this.lmtmContractStatus,
      this.lmtbContractReversals,
      this.appId,
      this.id,
      this.lmtbContractBalances,
      required this.lmtbScheme,
      this.lmtbContractPaysches,
      this.disbursalDate,
      required this.props,
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
      required this.lmtmCompany,
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

  ContractDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      lastPaymentAmt = json['lastPaymentAmt'];
      customerTitle = json['customerTitle'];
      contractDate = json['contractDate'];
      lmtbContractAssets = json['lmtbContractAssets'];
      noOfInstOverdue = json['noOfInstOverdue'];
      contractType = json['contractType'];
      installmentAmt = json['installmentAmt'];
      idnumber = json['idnumber'];
      disbursalchanel = json['disbursalchanel'];
      lmtmContractStatus = json['lmtmContractStatus'];
      lmtbContractReversals = json['lmtbContractReversals'];
      appId = json['appId'];
      id = json['id'];
      lmtbContractBalances = json['lmtbContractBalances'];
      lmtbScheme = json['lmtbScheme'] != null
          ? new LmtbScheme.fromJson(json['lmtbScheme'])
          : LmtbScheme();
      lmtbContractPaysches = json['lmtbContractPaysches'];
      disbursalDate = json['disbursalDate'];
      props = json['props'] != null ? new Props.fromJson(json['props']) : Props();
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
      lmtmCompany = json['lmtmCompany'] != null
          ? new LmtmCompany.fromJson(json['lmtmCompany'])
          : LmtmCompany();
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
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastPaymentAmt'] = this.lastPaymentAmt;
    data['customerTitle'] = this.customerTitle;
    data['contractDate'] = this.contractDate;
    data['lmtbContractAssets'] = this.lmtbContractAssets;
    data['noOfInstOverdue'] = this.noOfInstOverdue;
    data['contractType'] = this.contractType;
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
  String? mOB;
  double? tERM;
  double? sLTT;
  String? aPPID;
  var bUCKET;
  String? sCHEME;
  String? aPPLID;
  String? cCCODE;
  String? cCNAME;
  var dUEDAY;
  String? fCCODE;
  String? nEWINT;
  double? pENALTY;
  String? tYPEHD;
  var cCPHONE;
  double? eFFRATE;
  var fIELDUW;
  String? pOSTYPE;
  double? sOKYTT;
  String? dEALDATE;
  double? pAIDTERM;
  String? uNITCODE;
  var wAIVEINT;
  String? eSIGNFLAG;
  String? eSIGNTYPE;
  String? gROUPSLTT;
  String? gROUPUSER;
  double? nEWAMOUNT;
  double? tOTALPAID;
  String? xLTamTru;
  String? aGENCYNAME;
  double? iNSTALLMENT;
  double? lOANAMOUNT;
  String? nEWSEGMENT;
  String? nOTEDETAILS;
  var rEMOVEPHONE;
  String? cHECKINTPOS;
  String? fIRSTDUEDATE;
  String? lASTDUEDATE;
  String? nEXTDUEDATE;
  double? oTHERCHARGES;
  String? pRODUCTGROUP;
  double? aMOUNTOVERDUE;
  String? oLDCONTRACT1;
  String? oLDCONTRACT2;
  var oLDCONTRACT3;
  String? uNITCODEDESC;
  String? cHARGEOFFDATE;
  String? cHARGEOFFFLAG;
  String? dEBTSALEDATES;
  double? iNTERESTOVERDUE;
  double? sECURITYDEPOSIT;
  double? nOOFINSTOVERDUE;
  double? lASTDUEDAYPAYAMT;
  double? pRINCIPLEOUTSTANDING;
  String? resolved_cnt;
  var TO_COLLECT;
  var END_DATE;
  var NEXT_DUE_DATE;
  var DUE_DATE;
  var CASA;
  var PERIOD_BUCKET;
  var CHANNEL;
  var RISK_SEGMENT;
  var INTEREST_PRODUCT;
  var REMAIN_TOTAL;
  Props({
    this.mOB,
    this.tERM,
    this.sLTT,
    this.aPPID,
    this.bUCKET,
    this.sCHEME,
    this.aPPLID,
    this.cCCODE,
    this.cCNAME,
    this.dUEDAY,
    this.fCCODE,
    this.nEWINT,
    this.pENALTY,
    this.tYPEHD,
    this.cCPHONE,
    this.eFFRATE,
    this.fIELDUW,
    this.pOSTYPE,
    this.sOKYTT,
    this.dEALDATE,
    this.pAIDTERM,
    this.uNITCODE,
    this.wAIVEINT,
    this.eSIGNFLAG,
    this.eSIGNTYPE,
    this.gROUPSLTT,
    this.gROUPUSER,
    this.nEWAMOUNT,
    this.tOTALPAID,
    this.xLTamTru,
    this.aGENCYNAME,
    this.iNSTALLMENT,
    this.lOANAMOUNT,
    this.nEWSEGMENT,
    this.nOTEDETAILS,
    this.rEMOVEPHONE,
    this.cHECKINTPOS,
    this.fIRSTDUEDATE,
    this.lASTDUEDATE,
    this.nEXTDUEDATE,
    this.oTHERCHARGES,
    this.pRODUCTGROUP,
    this.aMOUNTOVERDUE,
    this.oLDCONTRACT1,
    this.oLDCONTRACT2,
    this.oLDCONTRACT3,
    this.uNITCODEDESC,
    this.cHARGEOFFDATE,
    this.cHARGEOFFFLAG,
    this.dEBTSALEDATES,
    this.iNTERESTOVERDUE,
    this.sECURITYDEPOSIT,
    this.nOOFINSTOVERDUE,
    this.lASTDUEDAYPAYAMT,
    this.resolved_cnt,
    this.pRINCIPLEOUTSTANDING,
    this.TO_COLLECT,
    this.END_DATE,
    this.NEXT_DUE_DATE,
    this.DUE_DATE,
    this.CASA,
    this.PERIOD_BUCKET,
    this.CHANNEL,
    this.RISK_SEGMENT,
    this.INTEREST_PRODUCT,
    this.REMAIN_TOTAL
  });

  Props.fromJson(Map<String, dynamic> json) {
    try {
      REMAIN_TOTAL = json['REMAIN_TOTAL'] ?? 0;
      CASA = json['CASA'];
      PERIOD_BUCKET = json['PERIOD_BUCKET'];
      CHANNEL = json['CHANNEL'];
      RISK_SEGMENT = json['RISK_SEGMENT'];
      INTEREST_PRODUCT = json['INTEREST_PRODUCT'];
      TO_COLLECT = json['TO_COLLECT'];
      END_DATE = json['END_DATE'];
      NEXT_DUE_DATE = json['NEXT_DUE_DATE'];
      DUE_DATE = json['DUE_DATE'];
      mOB = json['MOB'];
      resolved_cnt = json['resolved_cnt'];
      tERM = json['TERM'];
      sLTT = json['SL_TT'];
      aPPID = json['APP_ID'];
      bUCKET = json['BUCKET'];
      sCHEME = json['SCHEME'];
      aPPLID = json['APPL_ID'];
      cCCODE = json['CC_CODE'];
      cCNAME = json['CC_NAME'];
      dUEDAY = json['DUE_DAY'];
      fCCODE = json['FC_CODE'];
      nEWINT = json['NEW_INT'];
      pENALTY = json['PENALTY'];
      tYPEHD = json['TYPE_HD'];
      cCPHONE = json['CC_PHONE'];
      eFFRATE = json['EFF_RATE'];
      fIELDUW = json['FIELD_UW'];
      pOSTYPE = json['POS_TYPE'];
      sOKYTT = json['SO_KY_TT'];
      dEALDATE = json['DEAL_DATE'];
      pAIDTERM = json['PAID_TERM'];
      uNITCODE = json['UNIT_CODE'];
      wAIVEINT = json['WAIVE_INT'];
      eSIGNFLAG = json['ESIGN_FLAG'];
      eSIGNTYPE = json['ESIGN_TYPE'];
      gROUPSLTT = json['GROUP_SLTT'];
      gROUPUSER = json['GROUP_USER'];
      nEWAMOUNT = json['NEW_AMOUNT'];
      tOTALPAID = json['TOTAL_PAID'];
      xLTamTru = json['XL_Tam_Tru'];
      aGENCYNAME = json['AGENCY_NAME'];
      iNSTALLMENT = json['INSTALLMENT'];
      lOANAMOUNT = json['LOAN_AMOUNT'];
      nEWSEGMENT = json['NEW_SEGMENT'];
      nOTEDETAILS = json['NOTE_DETAILS'];
      rEMOVEPHONE = json['REMOVE_PHONE'];
      cHECKINTPOS = json['CHECK_INT_POS'];
      fIRSTDUEDATE = json['FIRST_DUEDATE'];
      lASTDUEDATE = json['LAST_DUE_DATE'];
      nEXTDUEDATE = json['NEXT_DUE_DATE'];
      oTHERCHARGES = json['OTHER_CHARGES'];
      pRODUCTGROUP = json['PRODUCT_GROUP'];
      aMOUNTOVERDUE = json['AMOUNT_OVERDUE'];
      oLDCONTRACT1 = json['OLD_CONTRACT_1'];
      oLDCONTRACT2 = json['OLD_CONTRACT_2'];
      oLDCONTRACT3 = json['OLD_CONTRACT_3'];
      uNITCODEDESC = json['UNIT_CODE_DESC'];
      cHARGEOFFDATE = json['CHARGE_OFF_DATE'];
      cHARGEOFFFLAG = json['CHARGE_OFF_FLAG'];
      dEBTSALEDATES = json['DEBT_SALE_DATES'];
      iNTERESTOVERDUE = json['INTEREST_OVERDUE'];
      sECURITYDEPOSIT = json['SECURITY_DEPOSIT'];
      nOOFINSTOVERDUE = json['NO_OF_INST_OVERDUE'];
      lASTDUEDAYPAYAMT = json['LAST_DUEDAY_PAY_AMT'];
      pRINCIPLEOUTSTANDING = json['PRINCIPLE_OUTSTANDING'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MOB'] = this.mOB;
    data['resolved_cnt'] = this.resolved_cnt;
    data['TERM'] = this.tERM;
    data['SL_TT'] = this.sLTT;
    data['APP_ID'] = this.aPPID;
    data['BUCKET'] = this.bUCKET;
    data['SCHEME'] = this.sCHEME;
    data['APPL_ID'] = this.aPPLID;
    data['CC_CODE'] = this.cCCODE;
    data['CC_NAME'] = this.cCNAME;
    data['DUE_DAY'] = this.dUEDAY;
    data['FC_CODE'] = this.fCCODE;
    data['NEW_INT'] = this.nEWINT;
    data['PENALTY'] = this.pENALTY;
    data['TYPE_HD'] = this.tYPEHD;
    data['CC_PHONE'] = this.cCPHONE;
    data['EFF_RATE'] = this.eFFRATE;
    data['FIELD_UW'] = this.fIELDUW;
    data['POS_TYPE'] = this.pOSTYPE;
    data['SO_KY_TT'] = this.sOKYTT;
    data['DEAL_DATE'] = this.dEALDATE;
    data['PAID_TERM'] = this.pAIDTERM;
    data['UNIT_CODE'] = this.uNITCODE;
    data['WAIVE_INT'] = this.wAIVEINT;
    data['ESIGN_FLAG'] = this.eSIGNFLAG;
    data['ESIGN_TYPE'] = this.eSIGNTYPE;
    data['GROUP_SLTT'] = this.gROUPSLTT;
    data['GROUP_USER'] = this.gROUPUSER;
    data['NEW_AMOUNT'] = this.nEWAMOUNT;
    data['TOTAL_PAID'] = this.tOTALPAID;
    data['XL_Tam_Tru'] = this.xLTamTru;
    data['AGENCY_NAME'] = this.aGENCYNAME;
    data['INSTALLMENT'] = this.iNSTALLMENT;
    data['LOAN_AMOUNT'] = this.lOANAMOUNT;
    data['NEW_SEGMENT'] = this.nEWSEGMENT;
    data['NOTE_DETAILS'] = this.nOTEDETAILS;
    data['REMOVE_PHONE'] = this.rEMOVEPHONE;
    data['CHECK_INT_POS'] = this.cHECKINTPOS;
    data['FIRST_DUEDATE'] = this.fIRSTDUEDATE;
    data['LAST_DUE_DATE'] = this.lASTDUEDATE;
    data['NEXT_DUE_DATE'] = this.nEXTDUEDATE;
    data['OTHER_CHARGES'] = this.oTHERCHARGES;
    data['PRODUCT_GROUP'] = this.pRODUCTGROUP;
    data['AMOUNT_OVERDUE'] = this.aMOUNTOVERDUE;
    data['OLD_CONTRACT_1'] = this.oLDCONTRACT1;
    data['OLD_CONTRACT_2'] = this.oLDCONTRACT2;
    data['OLD_CONTRACT_3'] = this.oLDCONTRACT3;
    data['UNIT_CODE_DESC'] = this.uNITCODEDESC;
    data['CHARGE_OFF_DATE'] = this.cHARGEOFFDATE;
    data['CHARGE_OFF_FLAG'] = this.cHARGEOFFFLAG;
    data['DEBT_SALE_DATES'] = this.dEBTSALEDATES;
    data['INTEREST_OVERDUE'] = this.iNTERESTOVERDUE;
    data['SECURITY_DEPOSIT'] = this.sECURITYDEPOSIT;
    data['NO_OF_INST_OVERDUE'] = this.nOOFINSTOVERDUE;
    data['LAST_DUEDAY_PAY_AMT'] = this.lASTDUEDAYPAYAMT;
    data['PRINCIPLE_OUTSTANDING'] = this.pRINCIPLEOUTSTANDING;
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
  dynamic lmtbContracts;
  String? checkerId;
  int? id;
  String? aggId;
  dynamic ftsValue;
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
