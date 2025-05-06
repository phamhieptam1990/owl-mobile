class LoanTypeTicketModel {
  String? fieldTypeValue;
  String? fieldTypeName;
  String? fieldTypeCode;
  String? recordStatus;
  String? makerId;
  String? authStatus;
  int? id;
  String? description;
  LoanTypeTicketModel(
      {this.fieldTypeValue,
      this.fieldTypeName,
      this.fieldTypeCode,
      this.authStatus,
      this.makerId,
      this.id,
      this.description,
      this.recordStatus});

  Map toJson() => {
        'fieldTypeValue': fieldTypeValue,
        'fieldTypeName': fieldTypeName,
        'fieldTypeCode': fieldTypeCode,
        'makerId': makerId,
        'id': id,
        'recordStatus': recordStatus,
        'description': description,
      };
  factory LoanTypeTicketModel.fromJson(
      Map<String, dynamic> loanTypeTicketModel) {
    return LoanTypeTicketModel(
      fieldTypeValue: loanTypeTicketModel['fieldTypeValue'].toString(),
      fieldTypeCode: loanTypeTicketModel['fieldTypeCode'].toString(),
      fieldTypeName: loanTypeTicketModel['fieldTypeName'].toString(),
      makerId: loanTypeTicketModel['makerId'].toString(),
      id: loanTypeTicketModel['id'],
      recordStatus: loanTypeTicketModel['recordStatus'].toString(),
      description: loanTypeTicketModel['description'].toString(),
    );
  }
}
