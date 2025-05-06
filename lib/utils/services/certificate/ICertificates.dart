

import 'package:flutter/services.dart';

class ICertificates {
  String certName;

  ICertificates(this.certName);

  Future<Uint8List> initialize() async {
    ByteData data2 = await PlatformAssetBundle().load(certName);
    return data2.buffer.asUint8List();
  }
}