import 'package:dio/dio.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/utils/http/http_helper.dart';

class EmployeeService {
  Future<Response> getEmployees(String emps) {
    // return HttpHelper.postForm(
    //     MCR_CUSTOMER_SERVICE_URL.GET_EMPLOYEE_BY_EMPCODES,
    //     body: 'empCodes=["' + emps + '"]',
    //     typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
    return HttpHelper.get(
        MCR_CUSTOMER_SERVICE_URL.GET_EMPLOYEE_BY_EMPCODES + '?empCodes=["' + emps + '"]',
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }
}
