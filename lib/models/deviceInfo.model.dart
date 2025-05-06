class DeviceInfo {
  String? imei;
  String? model;
  String? typeOS;
  String? manufacter;
  String? deviceModel;
  String? version;
  DeviceInfo(
      {this.imei,
      this.model,
      this.typeOS,
      this.manufacter,
      this.deviceModel,
      this.version});
  Map toJson() => {
        'imei': imei,
        'typeOS': typeOS,
        'model': model,
        'manufacter': manufacter,
        'deviceModel': deviceModel,
        'version': version
      };
  factory DeviceInfo.fromJson(Map<String, dynamic> deviceInfo) {
    return DeviceInfo(
        imei: deviceInfo['imei'] as String,
        model: deviceInfo['model'] as String,
        typeOS: deviceInfo['typeOS'] as String,
        manufacter: deviceInfo['manufacter'] as String,
        deviceModel: deviceInfo['deviceModel'] as String,
        version: deviceInfo['version'] as String);
  }
}
