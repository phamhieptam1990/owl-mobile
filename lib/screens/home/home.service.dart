import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/getit.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/models/deviceInfo.model.dart' as DEVICE;

import '../login/login.service.dart';

class HomeService {
  final _userInfoStore = getIt<UserInfoStore>();
  Future<Response> login(String username, String password) {
    var loginObject = {
      'password': password,
      'rememberMe': false,
      'username': username
    };
    return HttpHelper.post(LoginServiceUrl.LOGIN_SERVICE_PRODUCTION,
        body: loginObject, timeout: APP_CONFIG.QUERY_TIME_OUT, typeContent: 0);
  }

  Future<Response> getUserInfo() {
    return HttpHelper.get(LoginServiceUrl.PROFILE_INFO,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }

  Future<Response> getSupportTicketAggInfo() {
    return HttpHelper.get(CUSTOMER_REQUEST_SERVICE_URL.GET_TICKET_INFO,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }

  Future<Response> getTodayAggCalendarReport() {
    return HttpHelper.get(CALENDAR_REPORT_URL.TODAY_AGG_CALENDAR_REPORT,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }

  Future<Response> getCollectionContractStatusAgg() {
    DateTime firstDayCurrentMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
    firstDayCurrentMonth = firstDayCurrentMonth.subtract(Duration(
        hours: firstDayCurrentMonth.hour,
        minutes: firstDayCurrentMonth.minute,
        seconds: firstDayCurrentMonth.second,
        milliseconds: firstDayCurrentMonth.millisecond,
        microseconds: firstDayCurrentMonth.microsecond));

    DateTime lastDayCurrentMonth = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(Duration(days: 1));
    var empCode = '';
    empCode = _userInfoStore.user?.moreInfo?['empCode'] ?? '';
        var params = {
      'group': 'team',
      'empCode': empCode,
      'fromDate': firstDayCurrentMonth.millisecondsSinceEpoch,
      'toDate': lastDayCurrentMonth.millisecondsSinceEpoch
    };
    return HttpHelper.postJSON(FE_DASHBOARD_URL.GET_COLECTION_CONTRACT_STATUS,
        body: params,
        timeout: APP_CONFIG.QUERY_TIME_OUT,
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> getTodayAggCollectionReport() {
    return HttpHelper.get(CALENDAR_REPORT_URL.TODAY_AGG_COLLECTION_REPORT,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }


  Future<Response> getCheckInTodayReport(String empCode){
    var params = {"group":"team","empCode": empCode};
    return HttpHelper.post(FE_DASHBOARD_URL.GADGET_CHECKIN_TODAY,
        body: params,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }

  Future<Response> getCaseCheckInToday(String empCode){
    var params = {"group":"team","empCode": empCode};
    return HttpHelper.post(FE_DASHBOARD_URL.GADGET_CASE_CHECIN_TODAY,
        body: params,
        timeout: APP_CONFIG.QUERY_TIME_OUT);
  }

  Future<Response> createGPSLog(Position location, String titleLocation) async {
    DEVICE.DeviceInfo device = AppState.getDeviceInfo();

    var data = {
      "cmd": {
        "deviceId": device.imei,
        "coordinates": {
          "longitude": location.longitude.toString(),
          "latitude": location.latitude.toString(),
        },
        "trackDate": DateTime.now().millisecondsSinceEpoch,
        "action": "check-point",
        "address": titleLocation
      }
    };
    return HttpHelper.postJSON(MCR_FEA_URL.CREATE_GPS_LOG, body: data);
  }

  getLastFullName() {
    String fullName = _userInfoStore.user?.fullName ?? '';
    if (fullName.isNotEmpty) {
      if (fullName.contains(" ")) {
        return fullName.split(" ").last;
      }
      return fullName;
    }
      return '';
  }
}

class HomeConstant {
// Contract Details
// Other Checkin
// PTP - Promise To Pay
// Refuse to Pay
// Partial Payment
// Full Payment
}
