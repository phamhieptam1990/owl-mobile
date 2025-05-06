class ContractPayscheModel {
  var emi;
  String? endDate;
  var description;
  int? repaymentfee;
  String? tenantCode;
  int? principal;
  var modNo;
  int? interest;
  var checkerDate;
  int? id;
  int? installmentno;
  var ftsStringValue;
  var installmentamount;
  var makerId;
  String? createDate;
  var openingprincipal;
  String? makerDate;
  String? authStatus;
  String? recordStatus;
  int? closingprincipal;
  String? duedate;
  int? contractId;
  var checkerId;
  String? paymentPeriod;
  var ftsValue;

  ContractPayscheModel(
      {this.emi,
      this.endDate,
      this.description,
      this.repaymentfee,
      this.tenantCode,
      this.principal,
      this.modNo,
      this.interest,
      this.checkerDate,
      this.id,
      this.installmentno,
      this.ftsStringValue,
      this.installmentamount,
      this.makerId,
      this.createDate,
      this.openingprincipal,
      this.makerDate,
      this.authStatus,
      this.recordStatus,
      this.closingprincipal,
      this.duedate,
      this.contractId,
      this.checkerId,
      this.paymentPeriod,
      this.ftsValue});

  ContractPayscheModel.fromJson(Map<String, dynamic> json) {
    emi = json['emi'];
    endDate = json['endDate'];
    description = json['description'];
    repaymentfee = json['repaymentfee'];
    tenantCode = json['tenantCode'];
    principal = json['principal'];
    modNo = json['modNo'];
    interest = json['interest'];
    checkerDate = json['checkerDate'];
    id = json['id'];
    installmentno = json['installmentno'];
    ftsStringValue = json['ftsStringValue'];
    installmentamount = json['installmentamount'];
    makerId = json['makerId'];
    createDate = json['createDate'];
    openingprincipal = json['openingprincipal'];
    makerDate = json['makerDate'];
    authStatus = json['authStatus'];
    recordStatus = json['recordStatus'];
    closingprincipal = json['closingprincipal'];
    duedate = json['duedate'];
    contractId = json['contractId'];
    checkerId = json['checkerId'];
    paymentPeriod = json['paymentPeriod'];
    ftsValue = json['ftsValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emi'] = this.emi;
    data['endDate'] = this.endDate;
    data['description'] = this.description;
    data['repaymentfee'] = this.repaymentfee;
    data['tenantCode'] = this.tenantCode;
    data['principal'] = this.principal;
    data['modNo'] = this.modNo;
    data['interest'] = this.interest;
    data['checkerDate'] = this.checkerDate;
    data['id'] = this.id;
    data['installmentno'] = this.installmentno;
    data['ftsStringValue'] = this.ftsStringValue;
    data['installmentamount'] = this.installmentamount;
    data['makerId'] = this.makerId;
    data['createDate'] = this.createDate;
    data['openingprincipal'] = this.openingprincipal;
    data['makerDate'] = this.makerDate;
    data['authStatus'] = this.authStatus;
    data['recordStatus'] = this.recordStatus;
    data['closingprincipal'] = this.closingprincipal;
    data['duedate'] = this.duedate;
    data['contractId'] = this.contractId;
    data['checkerId'] = this.checkerId;
    data['paymentPeriod'] = this.paymentPeriod;
    data['ftsValue'] = this.ftsValue;
    return data;
  }
}
