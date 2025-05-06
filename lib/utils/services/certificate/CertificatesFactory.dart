
import 'dart:typed_data';

import 'ICertificates.dart';

abstract class CertificatesFactory {
  ICertificates initCertXFile();
  ICertificates initCertA4b();
  ICertificates initCertFeCredit();

  List<Uint8List> listCert = [];

  Future<void> initListCert() async {
    listCert.add(await initCertXFile().initialize());
    listCert.add(await initCertA4b().initialize());
    listCert.add(await initCertFeCredit().initialize());
  }
}