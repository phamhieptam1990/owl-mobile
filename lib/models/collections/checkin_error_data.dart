// To parse this JSON data, do
//
//     final errorData = errorDataFromJson(jsonString);

import 'dart:convert';

CheckinErrorData errorDataFromJson(String str) =>
    CheckinErrorData.fromJson(json.decode(str) as Map<String, dynamic>);

String errorDataToJson(CheckinErrorData data) => json.encode(data.toJson());

class CheckinErrorData {
  CheckinErrorData({
    this.errorMessage,
    this.errorCode,
    this.errorType,
  });

  final String? errorMessage;
  final String? errorCode;
  final String? errorType;

  CheckinErrorData copyWith({
    String? errorMessage,
    String? errorCode,
    String? errorType,
  }) =>
      CheckinErrorData(
        errorMessage: errorMessage ?? this.errorMessage,
        errorCode: errorCode ?? this.errorCode,
        errorType: errorType ?? this.errorType,
      );

  factory CheckinErrorData.fromJson(Map<String, dynamic> json) =>
      CheckinErrorData(
        errorMessage: json["errorMessage"],
        errorCode: json["errorCode"],
        errorType: json["errorType"],
      );

  Map<String, dynamic> toJson() => {
        "errorMessage": errorMessage,
        "errorCode": errorCode,
        "errorType": errorType,
      };
}