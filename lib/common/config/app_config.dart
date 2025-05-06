import 'package:athena/config/enviroment/enviroment_type.dart';
import 'package:athena/config/enviroment/environment.dart';
// ignore: camel_case_types

bool IS_PRODUCTION_APP =
    Environment.value?.environmentType == EnvironmentType.production;
bool IS_INSTALLED_BY_STORE = true;
// ignore: camel_case_types

class APP_CONFIG {
  // URL
  static String HOST_NAME_SERVICES = Environment.value.hostNameServices;
  static String HOST_NAME = Environment.value.hostName;
  static String HOST_NAME_VNG = Environment.value.hostNameVNG;
  static String HOST_NAME_API = Environment.value.hostNameApi;
  static String HOST_NAME_CHAT_API = Environment.value.hostChatApi;
  static const String TENANT_DOMAIN = 'ATHENA';
  static const String TENANT_CODE = 'BROTHER';
  static const String VYMO_FE_NOTIFY_LOAN = 'VYMO_FE_NOTIFY_LOAN';
  static const int LIMIT_QUERY = 10;
  static int TIME_OUT_MINUTES_APP = 15;
  static const int LIMIT_QUERY_50 = 50;
  static const int LIMIT_LOGIN_OFFLINE = 20;
  static const int QUERY_TIME_OUT = 50000;
  static const int FETCH_POSITION_TIME_OUT = 20;
  static const int COMMAND_TIME_OUT = 50000;
  static const int COMMAND_TIME_OUT_60 = 60000;
  static const int COMMAND_TIME_OUT_NEW = 30000;
  static const double COMMAND_TIME_OUT_D = 30000.0;
  static const double QUERY_TIME_OUT_D = 30000.0;
  static const int MAX_ELEMENT_IN_LIST = 1000;
  static const int MAX_QUERY_OFFLINE = 200;
  static const String APP_CODE = 'OWL';
  static const String APP_NAME_NEW = 'Athena Owl';
  static const String APP_NAME = 'Athena Owl';
  static const String COMPANY_CODE = 'A4B';
  static const String KEY_JWT = 'Bearer ';
  static const String AUTHORIZATION = 'Authorization';
  static const String FORGET_PASSWORD = '';
  static const String THEME = "theme";
  static const String LANGUAGE = "language";
  static const String VERSION_IOS = '1.00.90';
  static const String VERSION_ANDROID = '1.00.90';
  static const String VERSION_IOS_PROD = '1.00.90';
  static const String VERSION_ANDROID_PROD = '1.00.90';
  static String VERSION_ANDROID_HOT_FIX =
      IS_PRODUCTION_APP ? '1.00.90' : '1.00.90';
  static String VERSION_IOS_HOT_FIX = IS_PRODUCTION_APP ? '1.00.90' : '1.00.90';
  static const String ANDROID = 'ANDROID';
  static const String IOS = 'IOS';
  static const bool enableVietMap = true;
  static const String GOOGLE_MAP_KEY_UAT =
      'AIzaSyDJZ4fwpZUXspbNzTOWQ76fZ1qIsHuLMps';

  static const String VIETMAP_KEY_UAT =
      'd440b2c1c5314d1bab9bb069eee3e14103c361571bbc8045';

  // static const String CHAT_API_KEY = 'skkzn9s9jcux';
  // static const String CHAT_API_KEY_PRODUCTION = 'skkzn9s9jcux';
  static const String GOOGLE_MAP_REGION = 'vn';
  static const String UAT_LINK_ANDROID =
      'https://mail.google.com/';
  static const String UAT_LINK_IOS =
      'https://mail.google.com/';
  static  String PRODUCTION_LINK_ANDROID =
      'https://d1brdqgr1h0b0q.cloudfront.net/owl/android.html';
  static const String PRODUCTION_LINK_IOS =
      'https://athena-public-assets.s3.ap-southeast-1.amazonaws.com/app/production/ios.html';
  static const String UAT_ANDROID_APPS =
      'https://athena-public-assets.s3.ap-southeast-1.amazonaws.com/app/android_uat.json?v=';
  static const String UAT_IOS_APPS =
      'https://athena-public-assets.s3.ap-southeast-1.amazonaws.com/app/ios_uat.json?v=';
  static const String USER_ADMIN = 'admin@icollect.com.vn';
  static const String TOKEN_ADMIN = '@Icollect2021%#@';
  static const String APP_STORE =
      'https://athena-public-assets.s3.ap-southeast-1.amazonaws.com/app/production/ios.html';
  static const String PLAY_STORE =
      'https://play.google.com/store/apps/details?id=com.fe.icollect';
  static String LINK_CHANGE_PASS = IS_PRODUCTION_APP
      ? 'https://cagent.a4b.vn/#/forgot-password'
      : 'https://cagent-uat.a4b.vn/#/forgot-password';
}

class SERVICE_URL {
  static Map<String, String> MCRKALAPA = {
    'KALAPA_SERVICES': APP_CONFIG.HOST_NAME +
        (!IS_PRODUCTION_APP
            ? 'api/mcrkalapa/services/feaKalapaService/getKalapaInfo'
            : 'mcrkalapa/services/feaKalapaService/getKalapaInfo'),
    'KALAPA_BUDGET_DASHBOARD': APP_CONFIG.HOST_NAME +
        (!IS_PRODUCTION_APP
            ? 'api/mcrkalapa/services/empBudgetServices/getCurrentBudget'
            : 'mcrkalapa/services/empBudgetServices/getCurrentBudget'),
    'KALAPA_DASHBOARD_FEE': APP_CONFIG.HOST_NAME +
        (!IS_PRODUCTION_APP
            ? 'api/mcrkalapa/services/serviceDef/getServiceByChannel'
            : 'mcrkalapa/services/serviceDef/getServiceByChannel'),
    'GET_LIST_COMMENT_TYPE': APP_CONFIG.HOST_NAME +
        (!IS_PRODUCTION_APP
            ? 'api/mcrkalapa/services/commentService/getListCommentType'
            : 'mcrkalapa/services/commentService/getListCommentType'),
    'GET_COMMENT_BY_CONTRACTID': APP_CONFIG.HOST_NAME +
        (!IS_PRODUCTION_APP
            ? 'api/mcrkalapa/services/commentService/getCommentByContractId?'
            : 'mcrkalapa/services/commentService/getCommentByContractId?'),
    'CREAT_COMMENT': APP_CONFIG.HOST_NAME +
        (!IS_PRODUCTION_APP
            ? 'api/mcrkalapa/services/commentService/create'
            : 'mcrkalapa/services/commentService/create'),
  };

  static Map<String, String> MCRSMP = {
    'GET_PAYMENT_METHODS': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/paymentInstanceService/getPaymentMethods',
    'LIST_PROVIDER_BY_METHOD_CODE': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/paymentInstanceService/getListProviderByMethodCode?methodCode=',
    'LINK_PAYMENT_EWALLET': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/paymentInstanceService/linkPaymentEwallet',
    'GET_ALL_BY_EMPT_CODE': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/fetbEwalletMappingService/getAllByEmpCode',
    'QUERY_LINK_PAYMENT_EWALLET': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/paymentInstanceService/queryLinkPaymentEwallet',
    'UNLINK_PAYMENT_EWALLET': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/paymentInstanceService/unlinkPaymentEwallet',
    'GET_OVERALL_BY_EMP_CODE': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/fetbEwalletMappingService/getOverallByEmpCode',
    'GET_OVERRLL_BY_EMP_CODE_WITH_BALANCE': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/paymentInstanceService/getOverallByEmpCodeWithBalance',
    'GET_WALLET_TRANSACTION': APP_CONFIG.HOST_NAME_SERVICES +
        'mcrticket/api/fetbEwalletPaymentTransService/getEwalletPaymentHistory',
  };
}

class MCR_CUSTOMER_SERVICE_URL {
  static String GET_EMPLOYEE_BY_EMPCODES = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrusprofile/api/employee/getEmployeeByEmpCodes';
  static String GET_KALAPA_INFO = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getCollectionContactKalapa?aggId=';
  static String GET_CONTACT_BY_AGGID = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getCollectionCustomerInfo?';
  static String GET_CONTRACT_BY_AGGID = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrcontract/api/contract/getCollectionContract?';
  static String GET_ADDRESS_LOCATIONS = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrcustomer/api/contact/getAddressLocations?';
        static String GET_ADDRESS_LOCATIONS_TYPE_ID = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrcustomer/api/contact/getAddressLocationsById?';
  static String GET_CONTACT_DOCS = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrcustomer/api/contact/getContactDocs?appId=';
  static String GET_TRANSACTION_CARD_LIST =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/card/getTransactionList';
  static String GET_CONTRACT_BY_AGGID_NEW = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getCollectionContract?';
  static String GET_CONTACT_BY_AGGID_NEW = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getCollectionCustomerInfo?aggId=';
  static String GET_CONTRACT_FORE_CLOSURE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getLmsContractForeclosureInfo?';
}

class MCR_CONTRACT_SERVICE_URL {
  static String GET_CONTRACT_BY_AGGID =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/getLmsContractInfo?';
  static String GET_BY_AGG_ID_BASIC = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getLmsContractBasicInfo?';
  static String GET_PIVOT_PAGING_LMSCONTRACT_PAYSCHE =
      APP_CONFIG.HOST_NAME_SERVICES +
          'mcrticket/api/atick/pivotPagingLmsContractPaysche';
}

class MCR_US_PROFILE_SERVICE_URL {
  static String GET_EMPLOYEE_BY_EMPCODES = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrusprofile/api/employee/getEmployeeByEmpCodes';
  static String SEARCH_EMPLOYEE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrusprofile/api/employee/quickSearch?';
  static String GET_LINE_MANAGER_RECURSIVE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrusprofile/api/employee/getlinemanagerRecursive';
}

class MCR_FEA_URL {
  static String GET_PCTM_PRODUCT_BY_CODE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/getPctmProductByCode?';
  static String GET_PCTM_CASE_TYPE_BY_CODE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/getPctmCaseTypeByCode?';
  static String GET_PCTM_CUSTOMER_TYPE_BY_CODE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/getPctmCustomerTypeByCode?';
  static String GET_PCTM_CATEGORY_BY_CODE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/getPctmCategoryByCode?';
  static String GET_PCTM_SUBCATEGORY_BY_CODE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/getPctmSubCategoryByCode?';
  static String GET_PCTM_SUBCATEGORY_ATT_BY_CODE =
      APP_CONFIG.HOST_NAME_SERVICES +
          'mcrfea/api/complaintService/getPctmSubCategoryAttByCode?';
  static String CREATE_COMPLAIN = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/createComplaint?';
  static String GET_MASTER_DATA = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/getComplaintMasterDataAll';
  static String PIVOT_PAGING = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/complaintPivotPaging';
  static String GET_DETAIL = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/complaintService/getPctbComplaintByAggId?aggId=';
  static String GET_CUSTOMER_MULTIPLE_ADDRESS = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/customerService/getCustomerMultipleAddress?cifNumber=';
  static String GET_APPIDS = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/customerService/getTicketAppIds?aggId=';
  static String GET_APPIDS_NEW = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/customerService/getTicketAppIds?aggId=';
  static String GET_CUSTOMER_MULTIPLE_ADDRESS_LOG =
      APP_CONFIG.HOST_NAME_SERVICES +
          'mcrticket/api/atick/getCustomerMultipleAddress?aggId=';
  static String GET_DOC_ID =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrfea/api/omnidocsService/getDocId?';
  static String GET_DOC_VIEW =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrfea/api/omnidocsService/getDocView?';
  static String NGO_DISCONNECTDBOAxis2 = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/omnidocsService/ngoDisConnectBDOAxis2?';
  static String GET_PAYMENT_CARD_INFO_LOG = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getCardPaymentInfo?aggId=';
  static String GET_LOAN_SEC_INFO_LOG = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getLoanSecInfo?aggId=';
  static String GET_LOAN_BASIC_INFO = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/loanInfoService/getLoanBasicInfo';
  static String GET_LOAN_BASIC_INFO_LOG = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getLoanBasicInfo?aggId=';
  static String GET_KALAPA_LOAN_INFO = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/vymoKalapaService/getKalapaLoanInfo';
  static String GET_KALAPA_LOAN_INFO_LOG = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getKalapaLoanInfo?aggId=';
  static String DOWNLOAD_DOCS =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrfea/api/omnidocs/downloadDoc?';
  static String EARLY_TERMINATION = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrcontract/api/lmsJdbc/getEarlyTermination?contractNo=';
  static String SEARCH_MAP =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrgcl/api/mapService/search';
  static String REVERSE_MAP =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrgcl/api/v3/map/reverse';
  static String CREATE_GPS_LOG = IS_PRODUCTION_APP
      ? APP_CONFIG.HOST_NAME_SERVICES +
          'mcrgcl/api/gpsService/createGpsLogForIcollect'
      : APP_CONFIG.HOST_NAME_SERVICES +
          'api/mcrgcl/api/gpsService/createGpsLogForIcollect';
  static String HISTORY_TRANSACTION_CARD = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/cardService/getCreditCardStatementCardSecInfo';
  static String DOWNLOAD_DOCS_CACHE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrfea/api/omnidocs/downloadDocWithCached?';
}

// class OMNI_SERVICE_URL {
//   static String CONTRACT_PIVOT_PAGING =
//       APP_CONFIG.HOST_NAME_SERVICES + 'mcrcontract/api/object/pivotPaging';
//   static String CONTRACT_GET_DOC_GROUPED = APP_CONFIG.HOST_NAME_SERVICES +
//       'mcrcontract/api/doc/getObjWithDocsGroupedByDocType?objId=';
//   static String REQEUST_TOKEN_VNG =
//       APP_CONFIG.HOST_NAME + 'api/sta/auth/requestToken';
//   static String DOWNLOAD_FILE_VNG =
//       APP_CONFIG.HOST_NAME_VNG + 'pub/files/download';
// }

class XFILE_SERVICE_URL {
  static String PIVOT_PAGING =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/xfile/object/pivotPaging';
  static String CONTRACT_GET_DOC_GROUPED = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrowldms/api/xfile/doc/getObjWithDocsGroupedByDocType?objId=';
  static String REQEUST_TOKEN_VNG =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/xfile/auth/requestToken';
  static String DOWNLOAD_FILE_VNG =
      APP_CONFIG.HOST_NAME_VNG + 'pub/files/download';
}

class USER_SERVICE_URL {
  static String TIME_SYSTEM =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/getSystemDateTime';
  static String CHANGE_PROFILE_SERVICE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrsecmt/api/secmtRegisterApiService/updateProfile?';
  static String ATTRIBUTE_GET =
      APP_CONFIG.HOST_NAME_API + 'getAttributeValueOfUser?';
  static String ATTRIBUTE_SET =
      APP_CONFIG.HOST_NAME_API + 'setAttributeValueForUser?';
  static String GET_MENU =
      APP_CONFIG.HOST_NAME_API + 'menuByModule?module=home';
}

class CALENDAR_REPORT_URL {
  static String TODAY_AGG_CALENDAR_REPORT = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrisgdbrp/api/report/getTodayAggCalendarReport';
  static String TODAY_AGG_COLLECTION_REPORT = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrisgdbrp/api/report/getTodayAggCollectionReport';
  static String GET_TICKET =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrisgdbrp/api/atick/getTicket?';
  static String CHECK_IN = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrisgdbrp/api/atick/updateCheckinResult?';
  static String FETCH_DATA_OFFLINE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrisgdbrp/api/data/syncDataMyTask?';
}

class NOTIFICATION_SERVICE_URL {
  static String GET_VERSION_APP = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrnotification/api/appAttb/getMobileVersionInfo';
  static String READ = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrnotification/api/notification/updateRead?';
  static String GET_COUNT_UNREAD = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrnotification/api/notification/countUnread';
  static String SAVE_UPDATE_DEVICE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrnotification/api/userDevice/save';
  static String DELETE_USER_DEVICE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrnotification/api/userDevice/delete?';
  static String GET_PAGING_LIST = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrnotification/api/notification/getPagingListSummary';
  static String GET_DETAIL_NOTIFICATION = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrnotification/api/notification/getByAggId?';
}

class MCR_GCL_URL {
  static String GET_LIST_GPS_USER_CURRENT = IS_PRODUCTION_APP
      ? APP_CONFIG.HOST_NAME +
          'mcrgcl/services/gpsService/getListGpsUserCurrent'
      : APP_CONFIG.HOST_NAME +
          'api/mcrgcl/services/gpsService/getListGpsUserCurrent';
}

class FE_DASHBOARD_URL {
  static String GADGET_CHECKIN_TODAY = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrcrmrpt/api/reportData/fefnGadCheckinInday';
  static String GADGET_CASE_CHECIN_TODAY = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrcrmrpt/api/reportData/fefnGadListCheckinInday';
  static String GET_COLECTION_CONTRACT_STATUS = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrisgdbrp/api/report/getCollectionContractStatusAgg';
  static String GET_DAILY_CHECK_STATUS = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrisgdbrp/api/report/getDailyCheckStatusAgg';
}

class CATEGORY_URL {
  static String TICKET_STATUS =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/actionGroup/getAll?';
  static String TICKET_ACTION =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/action/getAll';
  static String TICKET_ATTRIBUTE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/fetmActionAttributeService/getAll';
  static String TICKET_CONTACT_BY =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/contactMode/getAll';
  static String TICKET_PLACE_CONTACT =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/contactPlace/getAll';
  static String TICKET_LOAN_TYPE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/fetmFieldTypeService/getAll';
  static String TICKET_CONTACT_PERSON =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/contactPerson/getAll';
  static String ACTION_GROUP_AND_CONTACT_PLACE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/fieldAction/getByActionGroupAndContactPerson?';
  static String GET_FIELD_TYPE_BY_CODE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/actionGroup/getByFieldTypeCode?';
  static String GET_ALL_ACTION_GROUP =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/actionGroup/getAll';
  static String GET_ALL_CATEGORY_TICKET =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/category/getAll';
  static String GET_ALL_LOCALITY =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrcustomer/api/address/loadAllLocality';
}

class DMS_SERVICE_URL {
  static String UPLOAD_FILE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/resource/upload';
  static String UPLOAD_AVARTAR =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/avatar/upload?';
  static String DOWNLOAD_AVARTAR_FILE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/avatar/download?';
  static String GET_AVARTAR =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/avatar/userAvatar';
  static String UPLOAD_SELFIE_FILE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/selfie/upload?';
  static String DOWNLOAD_FILE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/resource/download?';
  static String DOWNLOAD_SELFIE_FILE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/selfie/download?';
  static String GET_FILE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrowldms/api/dmsService/getResources?';
  static String GET_FILE_64 = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrowldms/api/dmsService/getBase64Content?';
}

class CALENDAR_EVENT_URL {
  static String EVENT_INFO_BY_RANGE_DATE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrevent/api/event/getEventInfoByRangeDate?';
}

class MCR_JOB_SERVICES_URL {
  static String SEARCH_USER_JOBS =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrjob/api/job/searchUserJobs';
  static String DOWNLOAD_CHECKIN =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrisgdms/api/dms/download?identifier=';
}

class CUSTOMER_REQUEST_SERVICE_URL {
  static String RECORD_USER_SMS_LOG =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/recordUserSmsLog?';
  static String RECORD_USER_CALL_LOG =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/recordUserCallLog?';
  static String GET_TICKET_INFO = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getSupportTicketAggInfo?';
  static String EXECUTE_ACTION =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/executeAction?';
  static String GET_DETAIL = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getSupportTicket?aggId=';
  static String PIVOT_PAGING = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/pivotPagingSupportTicket';
  static String SENT_REQUEST =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/create';
  static String GET_SCHEMAPIVOT =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/getSchemaPivot';
  static String GET_SUPPORTTICKETCATEGORIES = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/pctmCategoryService/getSupportTicketCategories';
  static String GET_CATEGORIESCONFIGBYISSUETYPE =
      APP_CONFIG.HOST_NAME_SERVICES +
          'mcrticket/api/pctmCategoryService/getCategoriesConfigByIssueType?';
}

class MCR_TICKET_SERVICE_URL {
  static String PIVOT_PAGING =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/pivotPagingMyTask';
  static String PIVOT_COUNT =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/pivotCountMyTask';
  static String PIVOT_PAGING_WITH_PERMISSION_CHECKING =
      APP_CONFIG.HOST_NAME_SERVICES +
          'mcrticket/api/atick/pivotPagingWithPermissionChecking?';
  static String PIVOT_COUNT_WITH_PERMISSION_CHECKING =
      APP_CONFIG.HOST_NAME_SERVICES +
          'mcrticket/api/atick/pivotCountWithPermissionChecking?';
  static String GET_TICKET =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/getTicket?';
  static String GET_CONTRACT_INFO = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getLmsContractInfo?aggId=';

  // static String GET_PAYMENT = APP_CONFIG.HOST_NAME_SERVICES +
  //     'mcrticket/api/atick/getPaymentInfo?aggId=';
  static String GET_PAYMENT = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrcontract/api/payment/repayment/getPaymentInfo?contractNumber=';
  static String CHECK_IN =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/updateCheckinResult';
  static String ACTIVITY_STEAM = APP_CONFIG.HOST_NAME_SERVICES +
      'activitystreams/api/ticket/getTicketActLog?';
  static String EVENT_LASTED_BY_TICKET = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getEventInfoLastedByTicketId?ticketId=';
  static String SMS_TEMPLATE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/getSnsTemplateContent';
  static String CREATE_PLANNED_DATE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/bulkRecordTicketsPlannedDate';
  static String COUNT_PAGING_PLANNED_DATE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/atick/atickAggByPlannedDate';
  static String COUNT_DASHBOARD_PLAN = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/planIssue/getCasesHasPriority';
  static String COUNT_PLANNED = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/planIssue/pivotCountMyPlanningIssue';
  static String PAGING_PLANNED = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/planIssue/pivotPagingMyPlanningIssue';
  static String GET_BY_CONTRACT_IDHP = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/contract/getByContractIdHP?contractId=';
  static String CALL_CLICK = IS_PRODUCTION_APP
      ? APP_CONFIG.HOST_NAME_SERVICES + 'mcrccs/services/callService/click2Call'
      : APP_CONFIG.HOST_NAME_SERVICES +
          'api/mcrccs/services/callService/click2Call';
  static String GET_URL_SERVEY = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrnotification/api/appAttb/getMobileVersionInfo';
  static String GET_LATEST_CUSTOMER_COMPLAINS = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/customercomplaints/getLatestCustomerComplaints?accountNumber=';
  static String CUSTOMER_COMPLAINS_PAGE = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/customercomplaints/pivotPaging';
  static String GET_CONTRACT_TYPE_INFO_LIST = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrticket/api/contract/getContractTypeInfoList';
  static String GET_IMPACTING_HISTORY =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/getPaymentHistory';
  static String GET_ACTION_CODE =
      APP_CONFIG.HOST_NAME_SERVICES + 'mcrticket/api/atick/getActionCode';
}
