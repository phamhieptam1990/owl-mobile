import 'package:dio/dio.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/log/crashlystic_services.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:flutter/material.dart';

class DMSService {
  Future<Response> uploadFile(FormData formData) async {
    return HttpHelper.postForm(DMS_SERVICE_URL.UPLOAD_FILE,
        body: formData,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> uploadFileAvartar(FormData formData) async {
    return HttpHelper.postForm(DMS_SERVICE_URL.UPLOAD_AVARTAR,
        body: formData,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response?> uploadFileSelfie(
      {FormData? formData, bool isRetryAWSFailed = false, Map<String, dynamic>? jsonData}) async {
    try {
       if (!isRetryAWSFailed) {
        if (formData == null) {
          debugPrint('Warning: formData is null when isRetryAWSFailed is false');
          return null;
        }
        
        return await HttpHelper.postForm(
          DMS_SERVICE_URL.UPLOAD_SELFIE_FILE,
          body: formData,
          timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
          typeContent: HttpHelperConstant.INPUT_TYPE_FORM
        );
      } else {
        if (jsonData == null) {
          debugPrint('Warning: jsonData is null when isRetryAWSFailed is true');
          return null;
        }
        
        return await HttpHelper.post(
          DMS_SERVICE_URL.UPLOAD_SELFIE_FILE,
          body: jsonData,
          typeContent: HttpHelperConstant.INPUT_TYPE_JSON,
          timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2)
        );
      }
    } catch (e) {
      if (e is DioException) {
        return e.response?.statusCode == 403 ? e.response : null;
      }
      CrashlysticServices.instance.log(e?.toString() ?? '');
      return null;
    }
  }

  Future<Response> getResources(String refCodes) {
    String sObject = 'refCodes=["' + refCodes + '"]';
    return HttpHelper.postForm(DMS_SERVICE_URL.GET_FILE,
        body: sObject,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> getResourcesList(attachment) {
    String sObject = 'refCodes=' + attachment.toString();
    return HttpHelper.postForm(DMS_SERVICE_URL.GET_FILE,
        body: sObject,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> downloadFile64(String refCodes) {
    String sObject = 'identifier=' + refCodes;
    return HttpHelper.get(DMS_SERVICE_URL.GET_FILE_64 + sObject,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> downloadFile(String refCodes) {
    String sObject = 'identifier=' + refCodes;
    return HttpHelper.get(DMS_SERVICE_URL.DOWNLOAD_FILE + sObject,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> downloadSelfieFile(String refCodes) {
    String sObject = 'identifier=' + refCodes;
    return HttpHelper.get(DMS_SERVICE_URL.DOWNLOAD_SELFIE_FILE + sObject,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> downloadAvartarFile(String refCodes) {
    String sObject = 'identifier=' + refCodes;
    return HttpHelper.get(DMS_SERVICE_URL.DOWNLOAD_AVARTAR_FILE + sObject,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> downloadAvartarUserLogin() async {
    final userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    final url = DMS_SERVICE_URL.GET_AVARTAR + '?username=' + userName;
    return HttpHelper.get(url,
        timeout: (APP_CONFIG.COMMAND_TIME_OUT_60 * 2),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {}
  }
}
