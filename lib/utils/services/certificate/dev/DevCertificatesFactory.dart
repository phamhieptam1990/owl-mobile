import '../CertificatesFactory.dart';
import '../ICertificates.dart';

class DevCertificatesFactory with CertificatesFactory {

  @override
  ICertificates initCertXFile() {
    return ICertificates("assets/cert/dev/xfile.a4b.vn.cer");
  }

  @override
  ICertificates initCertA4b() {
    return ICertificates("assets/cert/dev/a4b.vn.cer");
  }

  @override
  ICertificates initCertFeCredit() {
    return ICertificates("assets/cert/dev/fecredit.cer");
  }

}