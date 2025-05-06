import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/widgets/common/common.dart';

// ignore: camel_case_types
class OfflineService {
  static Map<String, bool> FEATURE_OFFLINE = {
    'MAP': false,
    'CALL': false,
    'SMS': false,
    'CHECK_IN': true,
    'FILTER_SEARCH_COLLECTIONS': false,
    'CAMERA': false,
    'SEARCH_COLLECTIONS': false,
    'CUSTOMER_REQUEST': false,
    'CUSTOMER_COMPLAIN': false,
    'SUBMIT_CHECKIN_OFFLINE': false,
    'TRACKING': false,
  };

  static bool isFeatureValid(String feature) {
    if (MyConnectivity.instance.isOffline) {
      bool f = FEATURE_OFFLINE[feature] ?? false;
      if (f == false) {
        WidgetCommon.generateDialogOKGet(
            content: "Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại");
        return false;
      }
    }
    return true;
  }
}

// ignore: camel_case_types
class FEATURE_APP {
  static String MAP = 'MAP';
  static String CAMERA = 'CAMERA';
  static String CALL = 'CALL';
  static String SMS = 'SMS';
  static String CHECK_IN = 'CHECK_IN';
  static String FILTER_SEARCH_COLLECTIONS = 'FILTER_SEARCH_COLLECTIONS';
  static String SEARCH_COLLECTIONS = 'SEARCH_COLLECTIONS';
  static String CUSTOMER_REQUEST = 'CUSTOMER_REQUEST';
  static String CUSTOMER_COMPLAIN = 'CUSTOMER_COMPLAIN';
  static String SUBMIT_CHECKIN_OFFLINE = 'SUBMIT_CHECKIN_OFFLINE';
  // static String SMS = 'SMS';
}
