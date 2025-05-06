
import '../CertificatesFactory.dart';
import '../ICertificates.dart';

class UATCertificatesFactory with CertificatesFactory {

  @override
  ICertificates initCertXFile() {
    return ICertificates("assets/cert/uat/xfile.a4b.vn.cer");
  }

  @override
  ICertificates initCertA4b() {
    return ICertificates("assets/cert/uat/a4b.vn.cer");
  }

  @override
  ICertificates initCertFeCredit() {
    return ICertificates("assets/cert/uat/fecredit.cer");
  }

}