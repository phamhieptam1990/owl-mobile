import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingModel {
  String appCode;
  String companyCode;
  GeoPoint coordinates;
  String deviceId;
  DateTime trackDate;
  // String ticketId;
  // String ticketCode;
  // String unitCode;
  // String userName;
  DateTime makerDate;
  String action;
  TrackingModel(
      this.appCode,
      this.companyCode,
      this.coordinates,
      this.deviceId,
      this.trackDate,
      // this.ticketId,
      // this.ticketCode,
      // this.unitCode,
      this.makerDate,
      this.action
      // this.userName
      );
}

class TrackingModelConstant {
  static const onPositionChange = 'onPositionChange';
  static const onHeartbeat = 'onHeartbeat';
  static const onMotionChange = 'onMotionChange';
  static const onTimer = 'onTimer';
  static const onLocation = 'onLocation';
  static const onActivityChange = 'onActivityChange';
  static const onProviderChange = 'onProviderChange';
  static const onConnectivityChange = 'onConnectivityChange';
  static const onLogin = 'onLogin';
  static const onCheckin = 'onCheckin';
}

