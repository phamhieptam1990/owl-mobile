import '../CertificatesFactory.dart';
import '../ICertificates.dart';

class ProdCertificatesFactory with CertificatesFactory {

  @override
  ICertificates initCertXFile() {
    return ICertificates("assets/cert/prod/xfile.a4b.vn.cer");
  }

  @override
  ICertificates initCertA4b() {
    return ICertificates("assets/cert/prod/a4b.vn.cer");
  }

  @override
  ICertificates initCertFeCredit() {
    return ICertificates("assets/cert/prod/fecredit.cer");
  }

}