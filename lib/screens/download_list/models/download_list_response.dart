// To parse this JSON data, do
//
//     final downloadListResponse = downloadListResponseFromJson(jsonString);

import 'dart:convert';

DownloadListResponse downloadListResponseFromJson(String str) =>
    DownloadListResponse.fromJson(json.decode(str));

String downloadListResponseToJson(DownloadListResponse data) =>
    json.encode(data.toJson());

class DownloadListResponse {
  DownloadListResponse({
    this.status,
    this.data,
  });

  final int? status;
  final DownloadListData? data;

  factory DownloadListResponse.fromJson(Map<String, dynamic> json) =>
      DownloadListResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : DownloadListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data?.toJson(),
      };
}

class DownloadListData {
  DownloadListData({
    this.checkinItems,
    this.lastRow,
    this.secondaryColumnFields,
  });

  final List<CheckinItem>? checkinItems;
  final int? lastRow;
  final List<dynamic>? secondaryColumnFields;

  factory DownloadListData.fromJson(Map<String, dynamic> json) =>
      DownloadListData(
        checkinItems: json["data"] == null
            ? null
            : List<CheckinItem>.from(
                json["data"].map((x) => CheckinItem.fromJson(x))),
        lastRow: json["lastRow"] == null ? null : json["lastRow"],
        secondaryColumnFields: json["secondaryColumnFields"] == null
            ? null
            : List<dynamic>.from(json["secondaryColumnFields"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": checkinItems == null
            ? null
            : List<dynamic>.from((checkinItems??[]).map((x) => x.toJson())),
        "lastRow": lastRow == null ? null : lastRow,
        "secondaryColumnFields": secondaryColumnFields == null
            ? null
            : List<dynamic>.from((secondaryColumnFields??[]).map((x) => x)),
      };
  DownloadListData copyWith({
    List<CheckinItem>? data,
    int? lastRow,
    List<dynamic>? secondaryColumnFields,
  }) =>
      DownloadListData(
        checkinItems: data ?? this.checkinItems,
        lastRow: lastRow ?? this.lastRow,
        secondaryColumnFields:
            secondaryColumnFields ?? this.secondaryColumnFields,
      );
}

class CheckinItem {
  CheckinItem(
      {this.jobExecutionId,
      this.jobInstanceId,
      this.createTime,
      this.startTime,
      this.endTime,
      this.status,
      this.exitCode,
      this.jobName,
      this.initiator,
      this.retryTimes,
      this.tenantCode,
      this.appCode,
      this.source,
      this.jobContext,
      this.jobDescription,
      this.jobParamId});

  final String? jobExecutionId;
  String? jobParamId;
  final String? jobInstanceId;
  final String? createTime;
  final String? startTime;
  final String? endTime;
  final String? status;
  final String? exitCode;
  final String? jobName;
  final String? initiator;
  final int? retryTimes;
  final String? tenantCode;
  final String? appCode;
  final String? source;
  final JobContext? jobContext;
  final String? jobDescription;

  factory CheckinItem.fromJson(Map<String, dynamic> json) => CheckinItem(
        jobExecutionId:
            json["jobExecutionId"] == null ? null : json["jobExecutionId"],
        jobInstanceId:
            json["jobInstanceId"] == null ? null : json["jobInstanceId"],
        createTime: json["createTime"] == null ? null : json["createTime"],
        startTime: json["startTime"] == null ? null : json["startTime"],
        endTime: json["endTime"] == null ? null : json["endTime"],
        status: json["status"] == null ? null : json["status"],
        exitCode: json["exitCode"] == null ? null : json["exitCode"],
        jobName: json["jobName"] == null ? null : json["jobName"],
        initiator: json["initiator"] == null ? null : json["initiator"],
        retryTimes: json["retryTimes"] == null ? null : json["retryTimes"],
        tenantCode: json["tenantCode"] == null ? null : json["tenantCode"],
        appCode: json["appCode"] == null ? null : json["appCode"],
        source: json["source"] == null ? null : json["source"],
        jobContext: json["jobContext"] == null
            ? null
            : JobContext.fromJson(json["jobContext"]),
        jobDescription:
            json["jobDescription"] == null ? null : json["jobDescription"],
            jobParamId:
            json["jobParamId"] == null ? null : json["jobParamId"],
      );

  Map<String, dynamic> toJson() => {
        "jobExecutionId": jobExecutionId == null ? null : jobExecutionId,
        "jobInstanceId": jobInstanceId == null ? null : jobInstanceId,
        "createTime": createTime == null ? null : createTime,
        "startTime": startTime == null ? null : startTime,
        "endTime": endTime == null ? null : endTime,
        "status": status == null ? null : status,
        "exitCode": exitCode == null ? null : exitCode,
        "jobName": jobName == null ? null : jobName,
        "initiator": initiator == null ? null : initiator,
        "retryTimes": retryTimes == null ? null : retryTimes,
        "tenantCode": tenantCode == null ? null : tenantCode,
        "appCode": appCode == null ? null : appCode,
        "source": source == null ? null : source,
        "jobContext": jobContext == null ? null : jobContext?.toJson(),
        "jobDescription": jobDescription == null ? null : jobDescription,
        "jobParamId": jobParamId == null ? null : jobParamId
      };
}

class JobContext {
  JobContext({this.filePath,this.path, this.fileName, this.pathByCurrentDate});

  final String? filePath;
  final String? path;
  final String? fileName;
  final String? pathByCurrentDate;
  factory JobContext.fromJson(Map<String, dynamic> json) => JobContext(
        filePath: json["filePath"] == null ? null : json["filePath"],
        path: json["path"] == null ? null : json["path"],
        fileName: json["fileName"] == null ? null : json["fileName"],
        pathByCurrentDate: json["pathByCurrentDate"] == null
            ? null
            : json["pathByCurrentDate"],
      );

  Map<String, dynamic> toJson() => {
        "filePath": filePath == null ? null : filePath,
        "path": path == null ? null : path
      };
}
