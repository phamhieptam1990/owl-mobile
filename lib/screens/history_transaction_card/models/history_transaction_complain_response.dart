import 'package:athena/screens/collections/collection/history_payment_card_response.dart';
import 'package:athena/utils/utils.dart';

class HistoryTransactionComplainResponse {
  HistoryTransactionComplainResponse({
    this.status,
    this.data,
  });

  final int? status;
  final HistoryTransactionComplainData? data;

  factory HistoryTransactionComplainResponse.fromJson(
          Map<String, dynamic> json) =>
      HistoryTransactionComplainResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : HistoryTransactionComplainData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data?.toJson(),
      };
}

class HistoryTransactionComplainData {
  HistoryTransactionComplainData({
    this.dataStatus,
    this.accountNumber,
    this.cardSecInfoType,
  });

  final String? dataStatus;
  final String? accountNumber;
  final CardSecInfoType? cardSecInfoType;

  factory HistoryTransactionComplainData.fromJson(Map<String, dynamic> json) =>
      HistoryTransactionComplainData(
        dataStatus: json["dataStatus"] == null ? null : json["dataStatus"],
        accountNumber:
            json["accountNumber"] == null ? null : json["accountNumber"],
        cardSecInfoType: json["cardSecInfoType"] == null
            ? null
            : CardSecInfoType.fromJson(json["cardSecInfoType"]),
      );

  Map<String, dynamic> toJson() => {
        "dataStatus": dataStatus == null ? null : dataStatus,
        "accountNumber": accountNumber == null ? null : accountNumber,
        "cardSecInfoType":
            cardSecInfoType == null ? null : cardSecInfoType?.toJson(),
      };
}

class CardSecInfoType {
  CardSecInfoType(
      {this.account,
      this.mainCard,
      this.statement,
      this.passDue,
      this.cardHistories,
      this.cardStatements,
      this.transactionList});

  final Account? account;
  final MainCard? mainCard;
  final CardBasicInfoTypeStatement? statement;
  final PassDue? passDue;
  final CardHistories? cardHistories;
  final CardStatements? cardStatements;
  final TransactionList? transactionList;

  factory CardSecInfoType.fromJson(Map<String, dynamic> json) =>
      CardSecInfoType(
        account:
            json["account"] == null ? null : Account.fromJson(json["account"]),
        mainCard: json["mainCard"] == null
            ? null
            : MainCard.fromJson(json["mainCard"]),
        statement: json["statement"] == null
            ? null
            : CardBasicInfoTypeStatement.fromJson(json["statement"]),
        passDue:
            json["passDUE"] == null ? null : PassDue.fromJson(json["passDUE"]),
        cardHistories: json["cardHistories"] == null
            ? null
            : CardHistories.fromJson(json["cardHistories"]),
        cardStatements: json["cardStatements"] == null
            ? null
            : CardStatements.fromJson(json["cardStatements"]),
        transactionList: json["transactions"] == null
            ? null
            : TransactionList.fromJson(json["transactions"]),
      );

  Map<String, dynamic> toJson() => {
        "account": account == null ? null : account?.toJson(),
        "mainCard": mainCard == null ? null : mainCard?.toJson(),
        "statement": statement == null ? null : statement?.toJson(),
        "passDUE": passDue == null ? null : passDue?.toJson(),
        "cardHistories": cardHistories == null ? null : cardHistories?.toJson(),
        "statements": cardStatements == null ? null : cardStatements?.toJson(),
      };
}

class Account {
  Account({
    this.product,
    this.customerSegment,
    this.status,
    this.insuranceFlag,
    this.contractNumber,
    this.accountNumber,
    this.securityAnswer,
    this.billingCycle,
    this.blockCode1,
    this.blockCode1Date,
    this.blockCode2,
    this.blockCode2Date,
    this.warningCode,
    this.otb,
    this.holdAmount,
    this.currentBalance,
    this.totalPaidAmount,
    this.cycleDue,
    this.limit,
    this.overLimitFlag,
    this.overLimitAmount,
    this.paymentDate,
    this.lastPaymentAmount,
    this.paymentDueDate,
    this.lastPurchaseDate,
    this.lastPurchaseAmount,
  });

  // Fix 6: Make fields nullable and final
  final String? product;
  final String? customerSegment;
  final String? status;
  final String? insuranceFlag;
  final String? contractNumber;
  final String? accountNumber;
  final String? securityAnswer;
  final String? billingCycle;
  final String? blockCode1;
  final int? blockCode1Date;
  final String? blockCode2;
  final int? blockCode2Date;
  final String? warningCode;
  final dynamic otb;
  final dynamic holdAmount;
  final dynamic currentBalance;
  final dynamic totalPaidAmount;
  final dynamic cycleDue;
  final dynamic limit;
  final String? overLimitFlag;
  final dynamic overLimitAmount;
  final Date? paymentDate;
  final dynamic lastPaymentAmount;
  final dynamic paymentDueDate;
  final dynamic lastPurchaseDate;
  final dynamic lastPurchaseAmount;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        product: json["product"] == null ? null : json["product"],
        customerSegment:
            json["customerSegment"] == null ? null : json["customerSegment"],
        status: json["status"] == null ? null : json["status"],
        insuranceFlag:
            json["insuranceFlag"] == null ? null : json["insuranceFlag"],
        contractNumber:
            json["contractNumber"] == null ? null : json["contractNumber"],
        accountNumber:
            json["accountNumber"] == null ? null : json["accountNumber"],
        securityAnswer:
            json["securityAnswer"] == null ? null : json["securityAnswer"],
        billingCycle:
            json["billingCycle"] == null ? null : json["billingCycle"],
        blockCode1: json["blockCode1"] == null ? null : json["blockCode1"],
        blockCode1Date:
            json["blockCode1Date"] == null ? null : json["blockCode1Date"],
        blockCode2: json["blockCode2"] == null ? null : json["blockCode2"],
        blockCode2Date:
            json["blockCode2Date"] == null ? null : json["blockCode2Date"],
        warningCode: json["warningCode"] == null ? null : json["warningCode"],
        otb: json["otb"] == null ? null : json["otb"],
        holdAmount: json["holdAmount"] == null ? null : json["holdAmount"],
        currentBalance:
            json["currentBalance"] == null ? null : json["currentBalance"],
        totalPaidAmount:
            json["totalPaidAmount"] == null ? null : json["totalPaidAmount"],
        cycleDue: json["cycleDue"] == null ? null : json["cycleDue"],
        limit: json["limit"] == null ? null : json["limit"],
        overLimitFlag:
            json["overLimitFlag"] == null ? null : json["overLimitFlag"],
        overLimitAmount:
            json["overLimitAmount"] == null ? null : json["overLimitAmount"],
        paymentDate: json["paymentDate"] == null
            ? null
            : Date.fromJson(json["paymentDate"]),
        lastPaymentAmount: json["lastPaymentAmount"] == null
            ? null
            : json["lastPaymentAmount"],
        paymentDueDate:
            json["paymentDueDate"] == null ? null : json["paymentDueDate"],
        lastPurchaseDate:
            json["lastPurchaseDate"] == null ? null : json["lastPurchaseDate"],
        lastPurchaseAmount: json["lastPurchaseAmount"] == null
            ? null
            : json["lastPurchaseAmount"],
      );

  Map<String, dynamic> toJson() => {
        "product": product == null ? null : product,
        "customerSegment": customerSegment == null ? null : customerSegment,
        "status": status == null ? null : status,
        "insuranceFlag": insuranceFlag == null ? null : insuranceFlag,
        "contractNumber": contractNumber == null ? null : contractNumber,
        "accountNumber": accountNumber == null ? null : accountNumber,
        "securityAnswer": securityAnswer == null ? null : securityAnswer,
        "billingCycle": billingCycle == null ? null : billingCycle,
        "blockCode1": blockCode1 == null ? null : blockCode1,
        "blockCode1Date": blockCode1Date == null ? null : blockCode1Date,
        "blockCode2": blockCode2 == null ? null : blockCode2,
        "blockCode2Date": blockCode2Date == null ? null : blockCode2Date,
        "warningCode": warningCode == null ? null : warningCode,
        "otb": otb == null ? null : otb,
        "holdAmount": holdAmount == null ? null : holdAmount,
        "currentBalance": currentBalance == null ? null : currentBalance,
        "totalPaidAmount": totalPaidAmount == null ? null : totalPaidAmount,
        "cycleDue": cycleDue == null ? null : cycleDue,
        "limit": limit == null ? null : limit,
        "overLimitFlag": overLimitFlag == null ? null : overLimitFlag,
        "overLimitAmount": overLimitAmount == null ? null : overLimitAmount,
        "paymentDate": paymentDate == null ? null : paymentDate?.toJson(),
        "lastPaymentAmount":
            lastPaymentAmount == null ? null : lastPaymentAmount,
        "paymentDueDate": paymentDueDate == null ? null : paymentDueDate,
        "lastPurchaseDate": lastPurchaseDate == null ? null : lastPurchaseDate,
        "lastPurchaseAmount":
            lastPurchaseAmount == null ? null : lastPurchaseAmount,
      };
}

class Date {
  Date({
    this.name,
    this.value,
    this.nil,
  });

  // Fix 7: Make fields nullable and final
  final String? name;
  final dynamic value;
  final bool? nil;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        name: json["name"] == null ? null : json["name"],
        value: json["value"] == null ? null : json["value"],
        nil: json["nil"] == null ? null : json["nil"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "value": value == null ? null : value,
        "nil": nil == null ? null : nil,
      };
}

class CardHistories {
  CardHistories({
    this.cardHistory,
  });

  final List<dynamic>? cardHistory;

  factory CardHistories.fromJson(Map<String, dynamic> json) => CardHistories(
        cardHistory: json["cardHistory"] == null
            ? null
            : List<dynamic>.from(json["cardHistory"].map((x) => x)),
      );

Map<String, dynamic> toJson() => {
        "cardHistory":
            cardHistory == null ? null : List<dynamic>.from(cardHistory!),
      };

}

class MainCard {
  MainCard({
    this.maskedCardNumber,
    this.plasticIndicator,
    this.productAssociation,
    this.activatedFlag,
  });

   // Fix 9: Make fields nullable and final
  final String? maskedCardNumber;
  final String? plasticIndicator;
  final String? productAssociation;
  final String? activatedFlag;

  factory MainCard.fromJson(Map<String, dynamic> json) => MainCard(
        maskedCardNumber:
            json["maskedCardNumber"] == null ? null : json["maskedCardNumber"],
        plasticIndicator:
            json["plasticIndicator"] == null ? null : json["plasticIndicator"],
        productAssociation: json["productAssociation"] == null
            ? null
            : json["productAssociation"],
        activatedFlag:
            json["activatedFlag"] == null ? null : json["activatedFlag"],
      );

  Map<String, dynamic> toJson() => {
        "maskedCardNumber": maskedCardNumber == null ? null : maskedCardNumber,
        "plasticIndicator": plasticIndicator == null ? null : plasticIndicator,
        "productAssociation":
            productAssociation == null ? null : productAssociation,
        "activatedFlag": activatedFlag == null ? null : activatedFlag,
      };
}

class PassDue {
  PassDue({
    this.dpd,
    this.currentBucket,
    this.totalAmountDue,
    this.totalCurrentDue,
    this.totalPastDue,
    this.minimumAmountDue,
    this.delinquencyString,
    this.lateFees,
  });

  final dynamic dpd;
  final dynamic currentBucket;
  final dynamic totalAmountDue;
  final dynamic totalCurrentDue;
  final dynamic totalPastDue;
  final dynamic minimumAmountDue;
  final String? delinquencyString;
  final dynamic lateFees;

  factory PassDue.fromJson(Map<String, dynamic> json) => PassDue(
        dpd: json["dpd"] == null ? null : json["dpd"],
        currentBucket:
            json["currentBucket"] == null ? null : json["currentBucket"],
        totalAmountDue:
            json["totalAmountDue"] == null ? null : json["totalAmountDue"],
        totalCurrentDue:
            json["totalCurrentDue"] == null ? null : json["totalCurrentDue"],
        totalPastDue:
            json["totalPastDue"] == null ? null : json["totalPastDue"],
        minimumAmountDue:
            json["minimumAmountDue"] == null ? null : json["minimumAmountDue"],
        delinquencyString: json["delinquencyString"] == null
            ? null
            : json["delinquencyString"],
        lateFees: json["lateFees"] == null ? null : json["lateFees"],
      );

  Map<String, dynamic> toJson() => {
        "dpd": dpd == null ? null : dpd,
        "currentBucket": currentBucket == null ? null : currentBucket,
        "totalAmountDue": totalAmountDue == null ? null : totalAmountDue,
        "totalCurrentDue": totalCurrentDue == null ? null : totalCurrentDue,
        "totalPastDue": totalPastDue == null ? null : totalPastDue,
        "minimumAmountDue": minimumAmountDue == null ? null : minimumAmountDue,
        "delinquencyString":
            delinquencyString == null ? null : delinquencyString,
        "lateFees": lateFees == null ? null : lateFees,
      };
}

class CardBasicInfoTypeStatement {
  CardBasicInfoTypeStatement({
    this.statemenBalance,
    this.lastStatementDate,
    this.nextStatementDate,
    this.lastStatementDueDate,
    this.lastStatementMpa,
  });

  final dynamic statemenBalance;
  final Date? lastStatementDate;
  final Date? nextStatementDate;
  final Date? lastStatementDueDate;
  final dynamic lastStatementMpa;

  factory CardBasicInfoTypeStatement.fromJson(Map<String, dynamic> json) =>
      CardBasicInfoTypeStatement(
        statemenBalance:
            json["statemenBalance"] == null ? null : json["statemenBalance"],
        lastStatementDate: json["lastStatementDate"] == null
            ? null
            : Date.fromJson(json["lastStatementDate"]),
        nextStatementDate: json["nextStatementDate"] == null
            ? null
            : Date.fromJson(json["nextStatementDate"]),
        lastStatementDueDate: json["lastStatementDueDate"] == null
            ? null
            : Date.fromJson(json["lastStatementDueDate"]),
        lastStatementMpa:
            json["lastStatementMPA"] == null ? null : json["lastStatementMPA"],
      );

  Map<String, dynamic> toJson() => {
        "statemenBalance": statemenBalance == null ? null : statemenBalance,
        "lastStatementDate":
            lastStatementDate == null ? null : lastStatementDate?.toJson(),
        "nextStatementDate":
            nextStatementDate == null ? null : nextStatementDate?.toJson(),
        "lastStatementDueDate":
            lastStatementDueDate == null ? null : lastStatementDueDate?.toJson(),
        "lastStatementMPA": lastStatementMpa == null ? null : lastStatementMpa,
      };
}

class CardStatements {
  CardStatements({
    this.cardStatement,
  });

  final List<CardStatementElement>? cardStatement;

  factory CardStatements.fromJson(Map<String, dynamic> json) => CardStatements(
        cardStatement: json["cardStatement"] == null
            ? null
            : List<CardStatementElement>.from(json["cardStatement"]
                .map((x) => CardStatementElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statement": cardStatement == null
            ? null
            : List<dynamic>.from(cardStatement!.map((x) => x.toJson())),
      };
}

class CardStatementElement {
  CardStatementElement({
    this.balanceForBeginningOfPeriod,
    this.balanceForEndOfPeriod,
    this.mpa,
    this.statementdate,
  });

  final int? balanceForBeginningOfPeriod;
  final int? balanceForEndOfPeriod;
  final int? mpa;
  final int? statementdate;
  List<Transaction> cardTransaction = [];
  List<Transaction> rechargeTransaction = [];
  bool isLoaded = false;
  bool isLoading = true;

  factory CardStatementElement.fromJson(Map<String, dynamic> json) =>
      CardStatementElement(
        balanceForBeginningOfPeriod: json["balanceForBeginningOfPeriod"] == null
            ? null
            : Utils.tryToParseInt(json["balanceForBeginningOfPeriod"]),
        balanceForEndOfPeriod: json["balanceForEndOfPeriod"] == null
            ? null
            : Utils.tryToParseInt(json["balanceForEndOfPeriod"]),
        mpa: json["mpa"] == null ? null : Utils.tryToParseInt(json["mpa"]),
        statementdate:
            json["statmentdate"] == null ? null : json["statmentdate"],
      );

  Map<String, dynamic> toJson() => {
        "balanceForBeginningOfPeriod": balanceForBeginningOfPeriod == null
            ? null
            : balanceForBeginningOfPeriod,
        "balanceForEndOfPeriod":
            balanceForEndOfPeriod == null ? null : balanceForEndOfPeriod,
        "mpa": mpa == null ? null : mpa,
        "statementdate": statementdate == null ? null : statementdate,
      };
}

class TransactionList {
  List<Transaction>? transaction;

  TransactionList({this.transaction});

  TransactionList.fromJson(Map<String, dynamic> json) {
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction?.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction'] = this.transaction?.map((v) => v.toJson()).toList();
      return data;
  }
}