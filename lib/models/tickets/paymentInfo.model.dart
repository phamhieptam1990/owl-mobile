import '../../utils/utils.dart';

class PaymentInfoModel {
  String? description;
  String? transactionTypeName;
  String? transactionStatus;
  String? ipatCode;
  String? transactionDate;
  double? transactionAmount;
  String? ipatMakerDate;

  PaymentInfoModel(
      {this.description,
      this.transactionTypeName,
      this.transactionStatus,
      this.ipatCode,
      this.transactionDate,
      this.transactionAmount,
      this.ipatMakerDate});

  PaymentInfoModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    transactionTypeName = json['transactionTypeName'];
    transactionStatus = json['transactionStatus'];
    ipatCode = json['ipatCode'];
    transactionDate = json['transactionDate'];
    ipatMakerDate = json['ipatMakerDate'];
    transactionAmount = Utils.checkValueIsDouble(json['transactionAmount'])
        ? json['transactionAmount']
        : double.tryParse(json['transactionAmount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['transactionTypeName'] = this.transactionTypeName;
    data['transactionStatus'] = this.transactionStatus;
    data['ipatCode'] = this.ipatCode;
    data['transactionDate'] = this.transactionDate;
    data['transactionAmount'] = this.transactionAmount;
    data['ipatMakerDate'] = this.ipatMakerDate;
    return data;
  }
}
