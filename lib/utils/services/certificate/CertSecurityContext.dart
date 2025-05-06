
import 'dart:io';
import 'dart:typed_data';

import '../../../config/enviroment/enviroment_type.dart';
import '../../../config/enviroment/environment.dart';
import 'CertificatesFactory.dart';
import 'dev/DevCertificatesFactory.dart';
import 'prod/ProdCertificatesFactory.dart';
import 'uat/UATCertificatesFactory.dart';

class CertSecurityContext {
  SecurityContext sc = SecurityContext();

  Future<void> addTrustedCertificatesBytes() async {
    CertificatesFactory certificatesFactory = getCertificatesFactory();
    await certificatesFactory.initListCert();

    for (Uint8List byteData in certificatesFactory.listCert) {
      sc.setTrustedCertificatesBytes(byteData);
        }
  }

  CertificatesFactory getCertificatesFactory() {
    switch(Environment.value.environmentType) {
      case EnvironmentType.uat: {
        return UATCertificatesFactory();
      }
      case EnvironmentType.production: {
        return ProdCertificatesFactory();
      }
      case EnvironmentType.dev: {
        return DevCertificatesFactory();
      }
    }
  }
}