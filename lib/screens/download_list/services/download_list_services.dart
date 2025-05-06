import 'dart:io';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/screens/download_list/models/download_list_response.dart';
import 'package:athena/screens/recovery/constant.recovery.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/services/savefile.service.dart';

import '../../../utils/utils.dart';

class DownloadListServices {
  Future<DownloadListResponse?> getContactDocs(int currentPage,
      {int rowLength = 20, var filterModel}) async {
    if (!Utils.checkIsNotNull(filterModel)) {
      filterModel = {};
    }
    var formData = {
      "startRow": currentPage * rowLength + (currentPage == 0 ? 0 : 1),
      "endRow": (currentPage + 1) * rowLength,
      "filterModel": filterModel,
      "sortModel": []
    };

    final response = await HttpHelper.postJSON(
        MCR_JOB_SERVICES_URL.SEARCH_USER_JOBS,
        body: formData);
    if (Utils.checkIsNotNull(response)) {
      return DownloadListResponse?.fromJson(response.data);
    }
    return null;
  }

  Future getContactOneDocs(int currentPage,
      {int rowLength = 20, var filterModel}) async {
    if (!Utils.checkIsNotNull(filterModel)) {
      filterModel = {};
    }
    var formData = {
      "startRow": currentPage * rowLength + (currentPage == 0 ? 0 : 1),
      "endRow": (currentPage + 1) * rowLength,
      "filterModel": filterModel,
      "sortModel": []
    };

    return await HttpHelper.postJSON(MCR_JOB_SERVICES_URL.SEARCH_USER_JOBS,
        body: formData);
  }

  static Future<dynamic> downloadCheckinItemPath(filePath, fileName) async {
    String identifer = filePath;
    var response;
    response = await SaveFileService().getFileFromUrl(
      MCR_JOB_SERVICES_URL.DOWNLOAD_CHECKIN + identifer,
    );

    if (response != null && response.bodyBytes != null) {
      String ext = '';
      if (response.headers['content-type'].indexOf('pdf') > -1) {
        ext = '.pdf';
      } else if (response.headers['content-type'].indexOf('octet-stream') >
          -1) {
        ext = '.xlsx';
      }
      String name = fileName + "${DateTime.now().millisecondsSinceEpoch}" + ext;

      return await SaveFileService().handleDownloadOpenFile(
          Platform.isAndroid ? 'Athena Owl' : 'downloads',
          name,
          response?.bodyBytes,
          isStored: true);
    }

    return DownloadStatus.callFailed;
  }

  static Future<DownloadStatus> downloadCheckinItem(CheckinItem data) async {
    final filePath = data.jobContext?.filePath;
    if (filePath == null) {
      return DownloadStatus.callFailed;
    }
    var response;
    response = await SaveFileService().getFileFromUrl(
      MCR_JOB_SERVICES_URL.DOWNLOAD_CHECKIN + filePath,
    );

    if (response != null && response.bodyBytes != null) {
      String ext = '';
      if (response.headers['content-type'].indexOf('pdf') > -1) {
        ext = '.pdf';
      } else if (response.headers['content-type'].indexOf('octet-stream') >
          -1) {
        ext = '.xlsx';
      }
      final fileName = "${data.jobParamId ?? 'download'}$ext";
      return await SaveFileService().handleDownloadCheckin(
          Platform.isAndroid ? 'Athena Owl' : 'downloads',
          fileName,
          response?.bodyBytes,
          isStored: true);
    }

    return DownloadStatus.callFailed;
  }

  static Future<DownloadStatus> downloadVFList(CheckinItem data) async {
    try {
      final fileName = data.jobContext?.fileName;
      final pathByCurrentDate = data.jobContext?.pathByCurrentDate;

      if (fileName == null || pathByCurrentDate == null) {
        return DownloadStatus.callFailed;
      }
      final response = await SaveFileService().getDownLoadFile(
          '${IcollectConst.dowwnloadJobVF}fileName=$fileName&pathByCurrentDate=$pathByCurrentDate');

      // Fix 17: Add null check for response and bodyBytes
      if (response != null && response.bodyBytes != null) {
        return await SaveFileService().handleDownloadCheckin(
            Platform.isAndroid ? 'Athena Owl' : 'visitforms',
            fileName,
            response.bodyBytes,
            isStored: true);
      }
    } catch (e) {
      print('Error downloading VF List: $e');
    }
    return DownloadStatus.callFailed;
  }

  static Future<DownloadStatus> downloadTBKK(CheckinItem data) async {
    try {
      // Fix 19: Add null checks for jobContext properties
      final fileName = data.jobContext?.fileName;
      final pathByCurrentDate = data.jobContext?.pathByCurrentDate;

      if (fileName == null || pathByCurrentDate == null) {
        return DownloadStatus.callFailed;
      }

      final response = await SaveFileService().getDownLoadFile(
          '${IcollectConst.dowwnloadJobVF}fileName=$fileName&pathByCurrentDate=$pathByCurrentDate');

      // Fix 20: Add null check for response and bodyBytes
      if (response != null && response.bodyBytes != null) {
        return await SaveFileService().handleDownloadCheckin(
            Platform.isAndroid ? 'Athena Owl' : 'TBKKs',
            fileName,
            response.bodyBytes,
            isStored: true);
      }
    } catch (e) {
      // Fix 21: Add error logging
      print('Error in downloadTBKK: $e');
    }

    return DownloadStatus.callFailed;
  }

  Future<void> handleSaveExternal(String fileName, dynamic response) async {}
}
