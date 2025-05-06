// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

import 'package:athena/models/map/location.model.dart';

class CollectionDetailModel {
  int id;
  String fullName;
  String detail;
  String status;
  String assignee;
  String customerStatus;
  int lastUpdate;
  String phone;
  String fullAddress;
  Location location;
  CollectionDetailModel(
      this.id,
      this.fullName,
      this.detail,
      this.status,
      this.assignee,
      this.customerStatus,
      this.lastUpdate,
      this.phone,
      this.fullAddress,
      this.location);
}
