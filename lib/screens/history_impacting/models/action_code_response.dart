// To parse this JSON data, do
//
//     final actionCodeResponse = actionCodeResponseFromJson(jsonString);

import 'package:equatable/equatable.dart';

class ActionCodeResponse {
  ActionCodeResponse({
    this.status,
    this.data,
  });

  final int? status;
  final List<ActionCodeItem>? data;

  factory ActionCodeResponse.fromJson(Map<String, dynamic> json) =>
      ActionCodeResponse(
        status: json["status"],
        data: List<ActionCodeItem>.from(
            json["data"].map((x) => ActionCodeItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from((data??[]).map((x) => x.toJson())),
      };
}

class ActionCodeItem extends Equatable {
  ActionCodeItem({
    this.actionId,
    this.code,
    this.name,
  });

  final int? actionId;
  final String? code;
  final String? name;

  List<Object?> get props => [actionId, code, name];

  factory ActionCodeItem.fromJson(Map<String, dynamic> json) => ActionCodeItem(
        actionId: json["actionId"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "actionId": actionId,
        "code": code,
        "name": name,
      };
}
