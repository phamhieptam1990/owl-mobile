class TrackingCallResponse {
  TrackingCallResponse({
    this.status,
    this.data,
  });

  int? status;
  TrackCallData? data;

  factory TrackingCallResponse.fromJson(Map<String, dynamic> json) =>
      TrackingCallResponse(
        status: json["status"],
        data: TrackCallData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class TrackCallData {
  TrackCallData({
    this.ticketId,
    this.message,
    this.code,
  });

  String? ticketId;
  String? message;
  String? code;

  factory TrackCallData.fromJson(Map<String, dynamic> json) => TrackCallData(
        ticketId: json["ticketId"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "ticketId": ticketId,
        "message": message,
        "code": code,
      };
}
