class BaseResponse<T> {
  final int status;
  final String? message;
  final T data;

  BaseResponse({
    required this.status,
    this.message,
    required this.data,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    BaseObject<T> target,
  ) {
    return BaseResponse(
      status: json['status'] as int,
      message: json['message'] as String?,
      data: target.fromJson(json['data']),
    );
  }
}

abstract class BaseObject<T> {
  T fromJson(dynamic json);
}