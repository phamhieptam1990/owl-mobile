import 'package:athena/models/customer-request/Request.model.dart';

class CustomerRequestSingeton {
  int offset = 0;
  int currentPage = 1;
  String filter = '';
  Map<String, dynamic> filterData = {
    'dateFrom': null,
    'dateTo': null,
    'statusCode': ''
  };
  // CustomerRequestService _customerRequestService = new CustomerRequestService();
  List<RequestModel> lstRequestModel = [];
  List<RequestModel> get getLstRequestModel => lstRequestModel;
  set selstRequestModel(List<RequestModel> lstRequestModel) =>
      this.lstRequestModel = lstRequestModel;
  void clearData() {
    lstRequestModel = [];
    offset = 0;
    currentPage = 1;
    filterData = {'dateFrom': null, 'dateTo': null, 'statusCode': ''};
  }

  Future<void> initData() async {
    try {} catch (e) {
      print(e);
    }
  }

  static final CustomerRequestSingeton _customerSingeton =
      CustomerRequestSingeton._internal();

  factory CustomerRequestSingeton() {
    return _customerSingeton;
  }

  CustomerRequestSingeton._internal();
}
