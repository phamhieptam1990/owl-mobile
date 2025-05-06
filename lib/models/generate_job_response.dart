class GenerateJobResponse {
  GenerateJobResponse({
    this.status,
    this.data,
  });

  final int? status;
  final GenerateJobData? data;

  factory GenerateJobResponse.fromJson(Map<String, dynamic> json) =>
      GenerateJobResponse(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : GenerateJobData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null ? null : data?.toJson(),
      };
}

class GenerateJobData {
  GenerateJobData({
    this.fileName,
    this.jobExecutionId,
    this.pathByCurrentDate,
  });

  final String? fileName;
  final String? jobExecutionId;
  final String? pathByCurrentDate;

  factory GenerateJobData.fromJson(Map<String, dynamic> json) =>
      GenerateJobData(
        fileName: json["fileName"] == null ? null : json["fileName"],
        jobExecutionId:
            json["jobExecutionId"] == null ? null : json["jobExecutionId"],
        pathByCurrentDate: json["pathByCurrentDate"] == null
            ? null
            : json["pathByCurrentDate"],
      );

  Map<String, dynamic> toJson() => {
        "fileName": fileName == null ? null : fileName,
        "jobExecutionId": jobExecutionId == null ? null : jobExecutionId,
        "pathByCurrentDate":
            pathByCurrentDate == null ? null : pathByCurrentDate,
      };
}
