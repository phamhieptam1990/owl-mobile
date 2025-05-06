class ContractBasicModel {
  int? interestoutstanding;
  int? id;
  int? tenure;
  var totalinstallmentamount;
  Props? props;
  var billedinstallment;
  String? contracttype;
  String? contractnumber;
  var totalpaidnoinstallments;
  String? accountno;
  var lmtbContract;
  var insuranceamount;
  var ftsValue;
  var totalpaidamount;
  var disbursaldate;
  var emi;
  var disbursaldealername;
  String? scheme;
  var lastpaymentamount;
  var description;
  var repaymentfee;
  String? tenantCode;
  var excessamounts;
  int? modNo;
  var totaloverdueamount;
  var assetcost;
  String? agreementdate;
  var balanceoutstanding;
  String? checkerDate;
  var rate;
  int? principleoutstanding;
  int? dpd;
  var applicationid;
  String? ftsStringValue;
  String? createDate;
  String? makerId;
  String? nextduedate;
  String? makerDate;
  String? product;
  int? overduefee;
  String? contractstatus;
  String? authStatus;
  var loanamount;
  int? overduepenalty;
  String? recordStatus;
  String? lastpaymentdate;
  var firstpaymentdate;
  int? contractId;
  var checkerId;

  ContractBasicModel(
      {this.interestoutstanding,
      this.id,
      this.tenure,
      this.totalinstallmentamount,
      this.props,
      this.billedinstallment,
      this.contracttype,
      this.contractnumber,
      this.totalpaidnoinstallments,
      this.accountno,
      this.lmtbContract,
      this.insuranceamount,
      this.ftsValue,
      this.totalpaidamount,
      this.disbursaldate,
      this.emi,
      this.disbursaldealername,
      this.scheme,
      this.lastpaymentamount,
      this.description,
      this.repaymentfee,
      this.tenantCode,
      this.excessamounts,
      this.modNo,
      this.totaloverdueamount,
      this.assetcost,
      this.agreementdate,
      this.balanceoutstanding,
      this.checkerDate,
      this.rate,
      this.principleoutstanding,
      this.dpd,
      this.applicationid,
      this.ftsStringValue,
      this.createDate,
      this.makerId,
      this.nextduedate,
      this.makerDate,
      this.product,
      this.overduefee,
      this.contractstatus,
      this.authStatus,
      this.loanamount,
      this.overduepenalty,
      this.recordStatus,
      this.lastpaymentdate,
      this.firstpaymentdate,
      this.contractId,
      this.checkerId});

  ContractBasicModel.fromJson(Map<String, dynamic> json) {
    interestoutstanding = json['interestoutstanding'];
    id = json['id'];
    tenure = json['tenure'];
    totalinstallmentamount = json['totalinstallmentamount'];
    props = json['props'] != null ? new Props.fromJson(json['props']) : null;
    billedinstallment = json['billedinstallment'];
    contracttype = json['contracttype'];
    contractnumber = json['contractnumber'];
    totalpaidnoinstallments = json['totalpaidnoinstallments'];
    accountno = json['accountno'];
    lmtbContract = json['lmtbContract'];
    insuranceamount = json['insuranceamount'];
    ftsValue = json['ftsValue'];
    totalpaidamount = json['totalpaidamount'];
    disbursaldate = json['disbursaldate'];
    emi = json['emi'];
    disbursaldealername = json['disbursaldealername'];
    scheme = json['scheme'];
    lastpaymentamount = json['lastpaymentamount'];
    description = json['description'];
    repaymentfee = json['repaymentfee'];
    tenantCode = json['tenantCode'];
    excessamounts = json['excessamounts'];
    modNo = json['modNo'];
    totaloverdueamount = json['totaloverdueamount'];
    assetcost = json['assetcost'];
    agreementdate = json['agreementdate'];
    balanceoutstanding = json['balanceoutstanding'];
    checkerDate = json['checkerDate'];
    rate = json['rate'];
    principleoutstanding = json['principleoutstanding'];
    dpd = json['dpd'];
    applicationid = json['applicationid'];
    ftsStringValue = json['ftsStringValue'];
    createDate = json['createDate'];
    makerId = json['makerId'];
    nextduedate = json['nextduedate'];
    makerDate = json['makerDate'];
    product = json['product'];
    overduefee = json['overduefee'];
    contractstatus = json['contractstatus'];
    authStatus = json['authStatus'];
    loanamount = json['loanamount'];
    overduepenalty = json['overduepenalty'];
    recordStatus = json['recordStatus'];
    lastpaymentdate = json['lastpaymentdate'];
    firstpaymentdate = json['firstpaymentdate'];
    contractId = json['contractId'];
    checkerId = json['checkerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['interestoutstanding'] = this.interestoutstanding;
    data['id'] = this.id;
    data['tenure'] = this.tenure;
    data['totalinstallmentamount'] = this.totalinstallmentamount;
    data['props'] = this.props?.toJson();
      data['billedinstallment'] = this.billedinstallment;
    data['contracttype'] = this.contracttype;
    data['contractnumber'] = this.contractnumber;
    data['totalpaidnoinstallments'] = this.totalpaidnoinstallments;
    data['accountno'] = this.accountno;
    data['lmtbContract'] = this.lmtbContract;
    data['insuranceamount'] = this.insuranceamount;
    data['ftsValue'] = this.ftsValue;
    data['totalpaidamount'] = this.totalpaidamount;
    data['disbursaldate'] = this.disbursaldate;
    data['emi'] = this.emi;
    data['disbursaldealername'] = this.disbursaldealername;
    data['scheme'] = this.scheme;
    data['lastpaymentamount'] = this.lastpaymentamount;
    data['description'] = this.description;
    data['repaymentfee'] = this.repaymentfee;
    data['tenantCode'] = this.tenantCode;
    data['excessamounts'] = this.excessamounts;
    data['modNo'] = this.modNo;
    data['totaloverdueamount'] = this.totaloverdueamount;
    data['assetcost'] = this.assetcost;
    data['agreementdate'] = this.agreementdate;
    data['balanceoutstanding'] = this.balanceoutstanding;
    data['checkerDate'] = this.checkerDate;
    data['rate'] = this.rate;
    data['principleoutstanding'] = this.principleoutstanding;
    data['dpd'] = this.dpd;
    data['applicationid'] = this.applicationid;
    data['ftsStringValue'] = this.ftsStringValue;
    data['createDate'] = this.createDate;
    data['makerId'] = this.makerId;
    data['nextduedate'] = this.nextduedate;
    data['makerDate'] = this.makerDate;
    data['product'] = this.product;
    data['overduefee'] = this.overduefee;
    data['contractstatus'] = this.contractstatus;
    data['authStatus'] = this.authStatus;
    data['loanamount'] = this.loanamount;
    data['overduepenalty'] = this.overduepenalty;
    data['recordStatus'] = this.recordStatus;
    data['lastpaymentdate'] = this.lastpaymentdate;
    data['firstpaymentdate'] = this.firstpaymentdate;
    data['contractId'] = this.contractId;
    data['checkerId'] = this.checkerId;
    return data;
  }
}

class Props {
  String? cOLOR;
  double? pRICE;
  String? pRODUCT;
  var cDLDESC;
  String? bIKENAME;
  String? bIKETYPE;
  String? eNGINENO;
  String? mRCNUMBER;
  String? mRCSTATUS;
  String? pRODUCTGROUP;
  String? cUSTMEMOLINE;
  String? lASTACTIONFV;
  var lASTACTIONSKIP;
  String? lASTACTIONPHONE;
  String? FIRST_DUEDATE;
  Props(
      {this.cOLOR,
      this.pRICE,
      this.pRODUCT,
      this.cDLDESC,
      this.bIKENAME,
      this.bIKETYPE,
      this.eNGINENO,
      this.mRCNUMBER,
      this.mRCSTATUS,
      this.pRODUCTGROUP,
      this.cUSTMEMOLINE,
      this.lASTACTIONFV,
      this.lASTACTIONSKIP,
      this.FIRST_DUEDATE,
      this.lASTACTIONPHONE});

  Props.fromJson(Map<String, dynamic> json) {
    cOLOR = json['COLOR'];
    pRICE = json['PRICE'];
    pRODUCT = json['PRODUCT'];
    cDLDESC = json['CDL_DESC'];
    bIKENAME = json['BIKE_NAME'];
    bIKETYPE = json['BIKE_TYPE'];
    eNGINENO = json['ENGINE_NO'];
    mRCNUMBER = json['MRC_NUMBER'];
    mRCSTATUS = json['MRC_STATUS'];
    pRODUCTGROUP = json['PRODUCT_GROUP'];
    cUSTMEMOLINE = json['CUST_MEMO_LINE'];
    lASTACTIONFV = json['LAST_ACTION_FV'];
    lASTACTIONSKIP = json['LAST_ACTION_SKIP'];
    lASTACTIONPHONE = json['LAST_ACTION_PHONE'];
    FIRST_DUEDATE = json['FIRST_DUEDATE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['COLOR'] = this.cOLOR;
    data['PRICE'] = this.pRICE;
    data['PRODUCT'] = this.pRODUCT;
    data['CDL_DESC'] = this.cDLDESC;
    data['BIKE_NAME'] = this.bIKENAME;
    data['BIKE_TYPE'] = this.bIKETYPE;
    data['ENGINE_NO'] = this.eNGINENO;
    data['MRC_NUMBER'] = this.mRCNUMBER;
    data['MRC_STATUS'] = this.mRCSTATUS;
    data['PRODUCT_GROUP'] = this.pRODUCTGROUP;
    data['CUST_MEMO_LINE'] = this.cUSTMEMOLINE;
    data['LAST_ACTION_FV'] = this.lASTACTIONFV;
    data['LAST_ACTION_SKIP'] = this.lASTACTIONSKIP;
    data['LAST_ACTION_PHONE'] = this.lASTACTIONPHONE;
    data['FIRST_DUEDATE'] = this.FIRST_DUEDATE;
    return data;
  }
}
