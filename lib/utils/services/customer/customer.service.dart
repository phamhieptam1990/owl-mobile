import 'package:dio/dio.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/utils/http/http_helper.dart';

class CustomerService {
  Future<Response> getContactByAggId(String aggId) {
    return HttpHelper.get(
        MCR_CUSTOMER_SERVICE_URL.GET_CONTACT_BY_AGGID + 'aggId=' + aggId);
  }

  Future<Response> getContactByAggIdNew(String aggId) {
    return HttpHelper.get(
        MCR_CUSTOMER_SERVICE_URL.GET_CONTACT_BY_AGGID_NEW + aggId);
  }
}
