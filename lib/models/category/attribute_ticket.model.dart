class AttributeTicketModel {
  String? attributeValue;
  String? attributeName;
  String? attributeCode;
  String? recordStatus;
  String? makerId;
  String? authStatus;
  int? id;
  String? description;
  AttributeTicketModel(
      {this.attributeName,
      this.attributeValue,
      this.attributeCode,
      this.id,
      this.description,
      this.recordStatus});

  Map toJson() => {
        'attributeName': attributeName,
        'attributeValue': attributeValue,
        'attributeCode': attributeCode,
        'id': id,
        'recordStatus': recordStatus,
        'description': description,
      };
  factory AttributeTicketModel.fromJson(
      Map<String, dynamic> attributeTicketModel) {
    return AttributeTicketModel(
      attributeName: attributeTicketModel['attributeName'].toString(),
      attributeCode: attributeTicketModel['attributeCode'].toString(),
      attributeValue: attributeTicketModel['attributeValue'].toString(),
      id: attributeTicketModel['id'],
      recordStatus: attributeTicketModel['recordStatus'].toString(),
      description: attributeTicketModel['description'].toString(),
    );
  }
}
