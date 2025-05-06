import 'package:athena/models/customer/customer.model.dart';

class CustomerSingeton {
  List<CustomerModel> lstCustomer = [];
  List<CustomerModel> get getLstCustomer => lstCustomer;

  set setLstCustomer(List<CustomerModel> lstCustomer) => this.lstCustomer = lstCustomer;
  void clearData() {
    lstCustomer = [];
  }

  static final CustomerSingeton _customerSingeton =
      CustomerSingeton._internal();

  factory CustomerSingeton() {
    return _customerSingeton;
  }

  CustomerSingeton._internal();
}
