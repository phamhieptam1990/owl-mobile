class EmployeeTrackingModel {
  String? actor;
  String? appCode;
  String? tenantCode;
  String? deviceId;
  int? makerDate;
  String? makerId;
  Coordinates? coordinates;
  int? trackDate;

  EmployeeTrackingModel({
    this.actor,
    this.appCode,
    this.tenantCode,
    this.deviceId,
    this.makerDate,
    this.makerId,
    this.coordinates,
    this.trackDate,
  });

  EmployeeTrackingModel.fromJson(Map<String, dynamic> json) {
    actor = json['actor'];
    appCode = json['appCode'];
    tenantCode = json['tenantCode'];
    deviceId = json['deviceId'];
    makerDate = json['makerDate'];
    makerId = json['makerId'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    trackDate = json['trackDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['actor'] = actor;
    data['appCode'] = appCode;
    data['tenantCode'] = tenantCode;
    data['deviceId'] = deviceId;
    data['makerDate'] = makerDate;
    data['makerId'] = makerId;
    if (coordinates != null) {
      data['coordinates'] = coordinates?.toJson();
    }
    data['trackDate'] = trackDate;
    return data;
  }
}

class Coordinates {
  String? longitude;
  String? latitude;

  Coordinates({
    this.longitude, 
    this.latitude,
  });

  Coordinates.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}