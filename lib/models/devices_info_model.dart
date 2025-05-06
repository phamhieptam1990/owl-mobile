class DeviceInfoModel {
  String? deviceName;
  String? systemName;
  double? systemVersion;
  String? imei;
  String? model;
  String? manufacturer;
  String? systemVersionStr;
  DeviceInfoModel(
      {this.deviceName,
      this.systemName,
      this.systemVersion,
      this.systemVersionStr,
      this.model,
      this.imei,
      this.manufacturer});
}
