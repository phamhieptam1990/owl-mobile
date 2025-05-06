import 'package:athena/common/config/app_config.dart';

class RecoveryConstant {
  static String PIVOT_PAGING = IS_PRODUCTION_APP
      ? APP_CONFIG.HOST_NAME + 'mcrflexoffice/api/allocation/pivotPaging'
      : APP_CONFIG.HOST_NAME_API + 'mcrflexoffice/api/allocation/pivotPaging';
  static String PIVOT_COUNT = IS_PRODUCTION_APP
      ? APP_CONFIG.HOST_NAME_SERVICES +
          'mcrflexoffice/api/allocation/pivotCount'
      : APP_CONFIG.HOST_NAME_API + 'mcrflexoffice/api/allocation/pivotCount';
  static String GET_LIST_CATEGORY = IS_PRODUCTION_APP
      ? APP_CONFIG.HOST_NAME +
          'mcrflexoffice/api/reportTemplate/getListByCategory?'
      : APP_CONFIG.HOST_NAME_API +
          'mcrflexoffice/api/reportTemplate/getListByCategory?';
  static String DOWNLOAD_PDF = IS_PRODUCTION_APP
      ? APP_CONFIG.HOST_NAME + 'mcrflexoffice/api/report/generate'
      : APP_CONFIG.HOST_NAME_API + 'mcrflexoffice/api/report/generate';
  static String DOWNLOAD_ALL = IS_PRODUCTION_APP
      ? APP_CONFIG.HOST_NAME + 'mcrflexoffice/api/report/bulkGenerate?'
      : APP_CONFIG.HOST_NAME_API + 'mcrflexoffice/api/report/bulkGenerate?';
  static String RECOVERY_IH = 'RECOVERY_IH';
}

class IcollectConst {
  static String downloadPDF =
      APP_CONFIG.HOST_NAME + 'api/mcrflexoffice/api/report/generate?';
  static String downloadVisitFormList =
      APP_CONFIG.HOST_NAME + 'api/mcrflexoffice/api/report/bulkGenerateVF';
  //endpoint backup dowwnload multiple visitforms
  static String generateReportVisitForm = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrisgdbrp/api/flexoffice/generateVisitForm';
  static String generateReportVisitFormList = APP_CONFIG.HOST_NAME_SERVICES +
      'mcrisgdbrp/api/flexoffice/generateVisitFormList';
  static String dowwnloadJobVF = APP_CONFIG.HOST_NAME_SERVICES +
          'mcrflexoffice/api/resources/download?';
   static String GENERATE_REPORT_CHECKIN = APP_CONFIG.HOST_NAME_SERVICES +
          'mcrcrmrpt/api/reportData/generateReport';
}
