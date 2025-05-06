class HistoryPaymentCardResponse {
  HistoryPaymentCardResponse({
    this.status,
    this.data,
  });

  final int? status;
  final HistoryPaymentCardData? data;

  factory HistoryPaymentCardResponse.fromJson(Map<String, dynamic> json) =>
      HistoryPaymentCardResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : HistoryPaymentCardData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data?.toJson(),
      };
}

class HistoryPaymentCardData {
  HistoryPaymentCardData({
    this.dataStatus,
    this.accountNumber,
    this.transactions,
  });

  final String? dataStatus;
  final String? accountNumber;
  final Transactions? transactions;

  factory HistoryPaymentCardData.fromJson(Map<String, dynamic> json) =>
      HistoryPaymentCardData(
        dataStatus: json["dataStatus"] == null ? null : json["dataStatus"],
        accountNumber:
            json["accountNumber"] == null ? null : json["accountNumber"],
        transactions: json["transactions"] == null
            ? null
            : Transactions.fromJson(json["transactions"]),
      );

  Map<String, dynamic> toJson() => {
        "dataStatus": dataStatus == null ? null : dataStatus,
        "accountNumber": accountNumber == null ? null : accountNumber,
        "transactions": transactions == null ? null : transactions?.toJson(),
      };
}

class Transactions {
  Transactions({
    this.transaction,
  });

  final List<Transaction>? transaction;

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        transaction: json["transaction"] == null
            ? null
            : List<Transaction>.from(
                json["transaction"].map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "transaction": transaction == null
            ? null
            : List<dynamic>.from((transaction??[]).map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    this.description,
    this.creditDebitFlag,
    this.transactionType,
    this.status,
    this.transactionCode,
    this.fee,
    this.postingDate,
    this.settlementDate,
    this.plan,
    this.planType,
    this.mcc,
    this.rrn,
    this.authCode,
    this.merchantName,
    this.paymentFlag,
    this.isCashTrnx,
    this.isReversal,
    this.trnxcurrencyCode,
    this.trnxdateAndTime,
    this.trnxamount,
  });

  final String? description;
  final String? creditDebitFlag;
  final String? transactionType;
  final String? status;
  final String? transactionCode;
  final int? fee;
  final int? postingDate;
  final int? settlementDate;
  final String? plan;
  final String? planType;
  final String? mcc;
  final String? rrn;
  final String? authCode;
  final String? merchantName;
  final String? paymentFlag;
  final String? isCashTrnx;
  final bool? isReversal;
  final String? trnxcurrencyCode;
  final int? trnxdateAndTime;
  final  trnxamount;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        description: json["description"] == null ? null : json["description"],
        creditDebitFlag:
            json["creditDebitFlag"] == null ? null : json["creditDebitFlag"],
        transactionType:
            json["transactionType"] == null ? null : json["transactionType"],
        status: json["status"] == null ? null : json["status"],
        transactionCode:
            json["transactionCode"] == null ? null : json["transactionCode"],
        fee: json["fee"] == null ? null : tryToParseInt(json["fee"]),
        postingDate: json["postingDate"] == null ? null : json["postingDate"],
        settlementDate:
            json["settlementDate"] == null ? null : json["settlementDate"],
        plan: json["plan"] == null ? null : json["plan"],
        planType: json["planType"] == null ? null : json["planType"],
        mcc: json["mcc"] == null ? null : json["mcc"],
        rrn: json["rrn"] == null ? null : json["rrn"],
        authCode: json["authCode"] == null ? null : json["authCode"],
        merchantName:
            json["merchantName"] == null ? null : json["merchantName"],
        paymentFlag: json["paymentFlag"] == null ? null : json["paymentFlag"],
        isCashTrnx: json["isCashTRNX"] == null ? null : json["isCashTRNX"],
        isReversal: json["isReversal"] == null ? null : json["isReversal"],
        trnxcurrencyCode:
            json["trnxcurrencyCode"] == null ? null : json["trnxcurrencyCode"],
        trnxdateAndTime:
            json["trnxdateAndTime"] == null ? null : json["trnxdateAndTime"],
        trnxamount: json["trnxamount"] == null
            ? null
            : tryToParseInt(json["trnxamount"]),
      );

  Map<String, dynamic> toJson() => {
        "description": description == null ? null : description,
        "creditDebitFlag": creditDebitFlag == null ? null : creditDebitFlag,
        "transactionType": transactionType == null ? null : transactionType,
        "status": status == null ? null : status,
        "transactionCode": transactionCode == null ? null : transactionCode,
        "fee": fee == null ? null : fee,
        "postingDate": postingDate == null ? null : postingDate,
        "settlementDate": settlementDate == null ? null : settlementDate,
        "plan": plan == null ? null : plan,
        "planType": planType == null ? null : planType,
        "mcc": mcc == null ? null : mcc,
        "rrn": rrn == null ? null : rrn,
        "authCode": authCode == null ? null : authCode,
        "merchantName": merchantName == null ? null : merchantName,
        "paymentFlag": paymentFlag == null ? null : paymentFlag,
        "isCashTRNX": isCashTrnx == null ? null : isCashTrnx,
        "isReversal": isReversal == null ? null : isReversal,
        "trnxcurrencyCode": trnxcurrencyCode == null ? null : trnxcurrencyCode,
        "trnxdateAndTime": trnxdateAndTime == null ? null : trnxdateAndTime,
        "trnxamount": trnxamount == null ? null : trnxamount,
      };
}

int tryToParseInt(dynamic value) {
  try {
    return double.parse(value?.toString()??'').toInt();
  } catch (_) {
    print(_);
    return int.parse(value?.toString()??'');
  } finally {}
}
