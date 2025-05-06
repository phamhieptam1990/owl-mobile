import 'package:athena/common/config/app_config.dart';

/// enable network proxy
const debugNetworkProxy = false;
const kAppConfig = 'lib/config/config_vi.json';

/// some constants Local Key
const kLocalKey = {
  "userInfo": "userInfo",
  "shippingAddress": "shippingAddress",
  "recentSearches": "recentSearches",
  "wishlist": "wishlist",
  "home": "home",
  "cart": "cart"
};

/// Logging config
const kLOG_TAG = "[ICollect]";
const kLOG_ENABLE = true;
// ignore: camel_case_types
bool APP_OFFLINE = false;
bool IS_FULL_SCREEN = false;
printLog(dynamic data) {
  if (kLOG_ENABLE) {
    print("[${DateTime.now().toUtc()}]$kLOG_TAG${data.toString()}");
  }
}

/// check if the environment is web
const bool kIsWeb = identical(0, 0.0);

/// use eventbus for fluxbuilder
// EventBus eventBus = EventBus();

const ApiPageSize = 20;

/// Use for set default SMS Login
class ActionPhone {
  static const String SMS = 'SMS';
  static const String CALL = 'CALL';
  static const String DIRECTION = 'DIRECTION';
  static const String EMAIL = 'EMAIL';
  static const String CANCEL = 'CANCEL';
  static const String CHECK_ADDRESS = 'CHECK_ADDRESS';
  static const String CHECK_PAYMENT = 'CHECK_PAYMENT';
  static const String OMNI_DOCS = 'Omnidocs';
  static const String PTP = 'PTP';
  static const String C_OTHER = 'C-OTHER';
  static const String RTP = 'RTP';
  static const String PAY = 'PAY';
  static const String OTHER = 'OTHER';
  static const String CHECK_HISTORY_PAYMENT = 'CHECK_HISTORY_PAYMENT';
  static const String CHECK_HISTORY_PAYMENT_CARD = 'CHECK_HISTORY_PAYMENT_CARD';
  static const String CHECK_KALAPA_INFOMATION = 'CHECK_KALAPA_INFOMATION';
  static const String EARLY_TERMINATION = 'EARLY_TERMINATION';
  static const String DOWNLOAD_TBKK = 'DOWNLOAD_TBKK';
  static const String HISTORY_COMPLAIN = 'HISTORY_COMPLAIN';

  static const String SEE_SCHEDULE_PAYMENT_HISTORY =
      'SEE_SCHEDULE_PAYMENT_HISTORY';
  static const String CARD = "CARD";
  static const String CRC = "CRC";
  static const String LOAN = "LOAN";
  static const String LOANS = "LOANS";
  static const String VIEW_OMNI_DOCS = "VIEW_OMNI_DOCS";
  static const String CAMERA = "Camera";
  static const String SELFIE = "Selfie";
  static const String SURVEY = "SURVEY";
  static const String HISTORY_TRANSACTION_CARD = "HISTORY_TRANSACTION_CARD";
  static const String HISTORY_TRANSACTION_EWALLET =
      "HISTORY_TRANSACTION_EWALLET";
  static const String HISTORY_PROMISE_PAYMENT = "HISTORY_PROMISE_PAYMENT";
}

class CollectionTicket {
  static const CV = 'CV';
  static const RELATIVE = 'RELATIVE';
  static const REL = 'REL';
  static const CLIENT = 'CLIENT';
  static const OTHER = 'OTHER';
  static const CITY = 'CITY';
  static const PROVINCE = 'PROVINCE';
  static const WARD = 'WARD';
  static const DONE = 'DONE';
  static const UNDONE = 'UNDONE';
  static const ALL = 'ALL';
  static const CANCEL = 'CANCEL';
}

class SortCollections {
  static const String POS = 'POS';
  static const String EMI = 'EMI';
  static const String DUEDATE = 'Due date';
  static const String OVERDUE_AMOUNT = 'Amount overdue';
  static const String MIN_AMOUNT_DUE = 'Min amount due';
  static const String ASC = 'asc';
  static const String DESC = 'desc';
  //
  static const String COL_LAST_PAYMENT_DATE = 'lastPaymentDate';
  static const String COL_POS_ATM = 'posAmt';
  static const String COL_EMI = 'emi';
  static const String COL_CONTRACT_DUE_DAY = 'contractDueDay';
  static const String COL_AMOUNT_OVER_DUE = 'amountOverdue';
  static const String COL_MIN_AMOUNT_DUE = 'minAmountDue';

  static const String LAST_PAYMENT_DATE = 'LAST_PAYMENT_DATE';
}

class MapConstant {
  static const String HOME_SEARCH = 'HOME';
  static const String PLANNED = 'SEARCH';
}

class HttpHelperConstant {
  static const String METHOD_GET = 'GET';
  static const String METHOD_POST = 'POST';
  static const String ACCEPT_ALL = '*/*';
  static const String APPLICATION_JSON = 'application/json;charset=UTF-8';
  static const String TEXT_PLAIN = 'text/plain;charset=UTF-8';
  static const String APPLICATION_FORM_URLENCODED =
      'application/x-www-form-urlencoded;charset:UTF-8';
  static const int INPUT_TYPE_JSON = 0;
  static const int INPUT_TYPE_FORM = 1;
  static const int STATUS_REQUEST_OK = 0;
  static const int STATUS_REQUEST_200 = 200;
  static const int STATUS_REQUEST_FAILED = 1;
}

class FilterType {
  static const String EQUALS = 'equals';
  static const String NOT_EQUAL = 'notEqual';
  static const String TRUE = 'true';
  static const String FALSE = 'false';
  static const String DATE = 'date';
  static const String IN_RANGE = 'inRange';
  static const String SET = 'set';
  static const String TEXT = 'text';
  static const String CONTAINS = 'contains';
  static const String IS_NOT_NULL = 'isNotNull';
}

class AppStateConfigConstant {
  static const bool simulator = true;
  static const String IS_FIRST_ENTER = 'IS_FIRST_ENTER';
  static const String FULLNAME = 'FULLNAME';
  static const String USER_NAME = 'userName';
  static const String MENU_DATA = 'menuData';
  static const String USER_TOKEN = 'userToken';
  static const String LOGIN_TIME = 'loginTime';
  static const String COUNT_LOGIN_OFFLINE = 'countLoginOffline';
  static const String DEVICE_INFO = 'deviceInfo';
  static const String OS = 'os';
  static const String THEME = 'theme';
  static const String LANGUAGE = 'language';
  static const String JWT = 'jwt';
  static const String JWT_BK = 'jwt_bk';
  static const String TOKEN_FIREBASE = 'tokenFireBase';
  static const String SPLIT_CHARACTER_VYMO = 'nVymo_';
  static const int DEFAULT_TIME_CHECKIN = 70;
  static const String INIT_BACKGROUND_PERMISSION = 'INIT_BACKGROUND_PERMISSION';
  static const String PHONE = 'PHONE';
  static const String EMAIL = 'EMAIL';
  static const String SMS = 'SMS';
  static const String ADDRESS = 'ADDRESS';
  static const String EVENT_CHECKIN = 'UpdateCheckinResult';
  static const String CREATE_VYMO_CALENDAR = 'CreateVymoCalendarEvent';
  static const String EVENT_CUSTOMER_MULTIPLE_ADDRESS =
      'QueryCustomerMultipleAddress';
  static const String EVENT_QUERY_KALAPA_LOAN_INFO = 'QueryKalapaLoanInfo';
  static const String EVENT_QUERY_LOAN_BASIC_INFO = 'QueryLoanBasicInfo';
  static const String EVENT_QUERY_LOAN_SEC_INFO = 'QueryLoanSecInfo';
  static const String EVENT_QUERY_CARD_PAYMENT_INFO = 'QueryCardPaymentInfo';
  static const String CHECK_PAYMENT = "QueryVymoPaymentInfo";
  static const String ETL_CREATE_TICKET = "ETLCreateTicket";
  static const String RECORD_PLANNED_DATE = "RecordPlannedDate";
  static const String INCREASE = "increase";
  static const String DECREASE = "decrease";
  static const String CALL_LOG = "RecordUserCallLog";
  static const String SMS_LOG = "RecordUserSmsLog";
  static const String PLANNED_LOG = "GetLoanEarlyTermination";
  static const String EDIT_LOG = "FC_SUPPORT_NEED_MORE_INFO";
  static const String DATA_NOT_FOUND = "Data not found";
  static const String TICKET = "TICKET";
  static const String TIME_UPDATE_COLLECTION = 'TIME_UPDATE_COLLECTION';
  static const String USER_INFO = 'USER_INFO';
  static const String TENANT_CODE = 'TENANT_CODE';
  static const String FINGER_LOGIN = 'FINGER_LOGIN';
  static const String LOCATION_MANAGER = 'LOCATION_MANAGER';
  static const String REFUSE_TO_PAY = 'Refuse to Pay';
  static const String IS_STORE_AVATAR = 'IS_STORE_AVATAR';
  static const String PLACE_HOLDER_IMAGE = 'assets/images/place_holder.jpg';
  static const String AVATAR_FILE = '';
  static const String CHECK_VERSION = 'check_version';
  static const String SKIP_VERSION = 'skip_version';
    static const String LINK_ANDROID = 'link_android';
}

class NotificationConstant {
  static const FE_ICOLLECT_TOPIC = 'FE_ICOLLECT';
}

class FieldTicketConstant {
  static const String NO = 'NO';
  static const String OTHER = 'OTHER';
  static const String RTP = 'RTP';
  static const String PAY = 'PAY';
  static const String PTP = 'PTP';
  static const String C_RTP = 'C-RTP';
  static const String C_PAY = 'C-PAY';
  static const String C_PTP = 'C-PTP';
  static const String C_OTHER = 'C-OTHER';
  static const String OBT = 'OBT';
  static const String PAID = 'PAID';
  static const String OTHER_CALL = 'OTHER_CALL';
  static const String WFP = 'WFP';
}

class ValidationConstant {
  static const String VALIDATERESULT = 'validateResult';
  static const String INVALIDSTARTDATETIME =
      'validation.ticket.vymo.invalidStartDatetime';
  static const String TICKET_NOTFOUND = 'validation.ticket.notFound';
  static const String UNAUTHORIZED_TICKET = 'validation.ticket.unauthorized';

//
  static const String EWALLET_PAYMENT_NOT_EXISTED =
      'validation.ticket.vymo.ewalletPaymentNotExisted';
  static const String EWALLET_PAYMENT_NOT_FOUND =
      'validation.ticket.vymo.ewalletPaymentNotFound';
  static const String EWALLET_PAYMENT_STATUS_NO_SUCCESS =
      'validation.ticket.vymo.ewalletPaymentStatusNotSuccess';
  static const String EWALLET_PAYMENT_AMOUNT_NOT_VALID =
      'validation.ticket.vymo.ewalletPaymentAmountNotValid';
  static const String EWALLET_PAYMENT_QUERY_BALANCE_NOT_SUCCESS =
      'validation.ticket.vymo.ewalletPaymentQueryBalanceNotSuccess';
  static const String EWALLET_PAYMENT_BALANCE_AMOUNT_NOT_VALID =
      'validation.ticket.vymo.ewalletPaymentBalanceAmountNotValid';

  static const String EWALLET_PAYMENT_ACCOUNT_NO_NOT_FOUND =
      'validation.ticket.vymo.ewalletPaymentAccountNoNotFound';

  static const String EWALLET_PAYMENT_ACCOUNT_NO_INVALID =
      'validation.ticket.vymo.ewalletPaymentAccountNoInvalid';
  static const String CHECKIN_OLD_DATA =
      'validation.ticket.vymo.checkinOldData';
}

class SurveyConstant {
  static const String LOAN =
      'https://icollect.surveysparrow.com/s/Loan-Contract/tt-ce8bca?';
  static const String CARD =
      'https://icollect.surveysparrow.com/s/Card-Contract/tt-ac057c1e55?';
}

class Roles {
  static const FCH = 'ROLE_VYMO_FECREDIT_FCH';
}

class MAP {
  static const String VIETMAP = 'vietmap';
  static const String GOOGLEMAP = 'googlemap';
  static const String ADDRESS = 'ADDRESS';
  static const String LATLONG = 'LATLONG';
}

class WalletValidateHelper {
  static final int minimumMoneyInput = 20000;
}

class ConitoConstant {
  static const String cognitoIdentityPoolId =
      'ap-southeast-1:40a4707f-0644-4476-90a0-49c09c2c7191';
  static const String cognitoUserPoolId = 'ap-southeast-1_RjTZaBe1q';
  static const String cognitoClientId = '3b6jh9ha592vnrnpf0ehts9nnm';
  static const String cognitoWebdomain =
      'owl-uat.auth.ap-southeast-1.amazoncognito.com';
  static const String cognitoUrlRedirect = 'athenahuntdev://';
  static const String cognitoUrlRedirectLogout = 'athenahuntdev://';
  static const String cognitoRegion = 'ap-southeast-1';
  static const String cognitoPoolUrl =
      'owl-uat.auth.ap-southeast-1.amazoncognito.com';
  static const String cognitoClientSecret =
      '1do1q3rdrod3rldvegjdi1t9rugttfth67thh823h6m9bh62kl3u';
  static String endpointUrl = APP_CONFIG.HOST_NAME;
}

class ConitoConstantProd {
  static const String cognitoIdentityPoolId =
      'ap-southeast-1:f893f7c2-b4fa-4896-8cfa-82406d033bbc';
  static const String cognitoUserPoolId = 'ap-southeast-1_FS57FbVX3';
  static const String cognitoClientId = '10iolucb6hefeo612pofv12rfm';
  static const String cognitoWebdomain =
      'cagent.auth.ap-southeast-1.amazoncognito.com';
  static const String cognitoUrlRedirect = 'athenahunt://';
  static const String cognitoUrlRedirectLogout = 'athenahunt://';
  static const String cognitoRegion = 'ap-southeast-1';
  static const String cognitoPoolUrl =
      'cagent.auth.ap-southeast-1.amazoncognito.com';
  static const String cognitoClientSecret =
      '1k5svmfm0t698388h67l188as67ct7unk8uu3256jj86kq5ef96t';
  static String endpointUrl = APP_CONFIG.HOST_NAME;
}

class TokenConstant {
  static const String ACCESS_TOKEN = 'ACCESSTOKEN';
  static const String versionWeb = 'versionWeb';

  static const String ID_TOKEN = 'IDTOKEN';
  static const String REFRESH_TOKEN = 'REFRESHTOKEN';
  static const String SERVER_TOKEN = 'SERVERTOKEN';
  static const String SIGN_DYNAMIC_LINK = 'SIGN_DYNAMIC_LINK';
}
