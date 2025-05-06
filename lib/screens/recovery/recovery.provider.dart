import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/generate_job_response.dart';
import 'package:athena/models/recovery/recovery.model.dart';
import 'package:athena/screens/recovery/constant.recovery.dart';
import 'package:athena/screens/recovery/widget/viewPdf.widget.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';

class RecoveryProvider {
  List<RecoveryModel> lstRecovery = [];
  SaveFileService _saveFileService = new SaveFileService();
  int totalLength = 0;
  int currentPage = 0;
  String keyword = '';

  Future<Response> pivotPaging(int offsetCurrent, String keyword) {
    if (offsetCurrent > 0) {
      offsetCurrent = offsetCurrent + 1;
    }
    Map<String, dynamic> params = {
      "startRow": offsetCurrent,
      "endRow": offsetCurrent + APP_CONFIG.LIMIT_QUERY,
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": {
        "recordStatus": {"type": "equals", "filter": "O", "filterType": "text"}
      },
      "sortModel": [
        {"colId": "createDate", "sort": "desc"}
      ]
    };
    if (Utils.checkIsNotNull(keyword)) {
      params['filterModel'] = {
        "recordStatus": {"type": "equals", "filter": "O", "filterType": "text"},
        "ftsValue": {
          "type": "contains",
          "filter": keyword,
          "filterType": "text"
        }
      };
    }
    return HttpHelper.postJSON(RecoveryConstant.PIVOT_PAGING, body: params);
  }

  Future<Response> pivotCount(int offsetCurrent, String keyword) {
    Map<String, dynamic> params = {
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": {
        "recordStatus": {"type": "equals", "filter": "O", "filterType": "text"}
      },
      "sortModel": [
        {"colId": "assignToEmail", "sort": "desc"}
      ]
    };
    if (Utils.checkIsNotNull(keyword)) {
      params['filterModel'] = {
        "recordStatus": {"type": "equals", "filter": "O", "filterType": "text"},
        "ftsValue": {
          "type": "contains",
          "filter": keyword,
          "filterType": "text"
        }
      };
    }
    return HttpHelper.postJSON(RecoveryConstant.PIVOT_COUNT, body: params);
  }

  Future<Response> getListByCategory(String _category, String _subCategory) {
    final params = RecoveryConstant.GET_LIST_CATEGORY +
        'category=$_category&subCategory=$_subCategory';
    return HttpHelper.get(params);
  }

  Future<Response> downLoadPDF(String _templateCode, int _id) {
    var params = {
      "templateCode": _templateCode,
      "params": {"id": _id}
    };
    return HttpHelper.postJSON(RecoveryConstant.DOWNLOAD_PDF, body: params);
  }

  Future<void> buildActionSheet(RecoveryModel item, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      WidgetCommon.showLoading();
      dynamic response =
          await this.getListByCategory(RecoveryConstant.RECOVERY_IH, item.type ?? '');
      WidgetCommon.dismissLoading();
      if (Utils.checkIsNotNull(response)) {
        response = Utils.handleRequestData(response);
        if (Utils.isArray(response)) {
          List<SheetAction<String>> lstSheetAction = [];
          for (var res in response) {
            lstSheetAction.add(SheetAction(
                label: res['name'],
                key: res['code'],
                icon: Icons.picture_as_pdf));
          }
          for (var res in response) {
            lstSheetAction.add(SheetAction(
                label: 'Download ' + res['name'],
                key: 'Download ' + res['code'],
                icon: Icons.import_export));
          }
          // lstSheetAction.add(SheetAction(
          //     label: 'Download tất cả',
          //     key: 'Download tất cả',
          //     icon: Icons.import_export));
          final result = await showModalActionSheet<String>(
            context: context,
            actions: lstSheetAction,
          );
          if (Utils.checkIsNotNull(result)) {
            var params;
            String resultF = '';
            String strExtension = '';
            GenerateJobResponse? generateJob;
            var generateJobResponse;
           if (result != null && result!.indexOf('Download ') > -1) {

              WidgetCommon.showLoading();
              if (result == 'Download tất cả') {
                final arrCode = [];
                for (var res in response) {
                  arrCode.add(res['code']);
                }
                params = {
                  "templateCodes": arrCode,
                  "params": {"id": item.id}
                };
                generateJobResponse =
                    await _saveFileService.postTequestDownLoadFile(
                        RecoveryConstant.DOWNLOAD_ALL, params);
                generateJob = GenerateJobResponse.fromJson(
                    jsonDecode(generateJobResponse?.body));
              } else if (result.indexOf('Download ') > -1) {
                resultF = result.replaceAll('Download ', '');
                params = {
                  "templateCode": resultF,
                  "params": {"id": item.id}
                };
                strExtension = '.pdf';
                generateJobResponse =
                    await _saveFileService.postTequestDownLoadFile(
                        RecoveryConstant.DOWNLOAD_PDF, params);
                generateJob = GenerateJobResponse.fromJson(
                    jsonDecode(generateJobResponse?.body));
              }
              if (generateJob != null && generateJob?.status == 0) {
                var dataZip = await _saveFileService.getDownLoadFile(IcollectConst
                        .dowwnloadJobVF +
                    'fileName=${generateJob?.data?.fileName}&pathByCurrentDate=${generateJob?.data?.pathByCurrentDate}');
                if (dataZip == null) {
                  await Future.delayed(Duration(seconds: 10));
                  dataZip = await _saveFileService.getDownLoadFile(IcollectConst
                          .dowwnloadJobVF +
                      'fileName=${generateJob?.data?.fileName}&pathByCurrentDate=${generateJob?.data?.pathByCurrentDate}');

                  if (dataZip == null) {
                    WidgetCommon.dismissLoading();

                    WidgetCommon.generateDialogOKGet(
                        content:
                            'Quá trình xuất file đang được hệ thống xử lý. Vui lòng kiểm tra trạng thái file ${generateJob?.data?.fileName} tại mục (Cấu Hình -> Danh sách tải về)',
                        textBtnClose: 'Đã hiểu',
                        callback: () {
                          Utils.navigateToReplacement(
                              context, RouteList.DOWNLOAD_LIST_SCREEN);
                        });
                    return;
                  }
                }
                if (Utils.checkIsNotNull(dataZip)) {
                  String fileName = generateJob?.data?.fileName ?? 'unknow.zip';
                  if (dataZip != null && dataZip.bodyBytes != null) {
                    final status = await SaveFileService().downloadAndPrintFile(
                        Platform.isAndroid ? 'Athena Owl' : 'DKKs',
                        fileName,
                        dataZip?.bodyBytes,
                        prefixShare: 'Recovery_',
                        contractId: item.id.toString());
                    if (status == DownloadStatus.successed) {
                      WidgetCommon.dismissLoading();

                      return WidgetCommon.showSnackbar(
                          scaffoldKey,
                          'Tải về thành công, Vui lòng Kiểm tra trong thư mục ' +
                              (Platform.isAndroid
                                  ? '/Download/Athena/'
                                  : 'DKKs/') +
                              '$fileName',
                          backgroundColor: AppColor.appBar);
                    }
                    if (status == DownloadStatus.saveFileFailed) {
                      WidgetCommon.dismissLoading();

                      return WidgetCommon.showSnackbar(scaffoldKey,
                          'Đã có lỗi xảy ra trong quá trình lưu file!');
                    }

                    if (status == DownloadStatus.noPerrmission) {
                      WidgetCommon.dismissLoading();

                      return WidgetCommon.showSnackbar(scaffoldKey,
                          'Vui lòng cung cấp quyền lưu trữ để thực hiện tính năng này');
                    }
                  }
                }
              }

              WidgetCommon.dismissLoading();
              WidgetCommon.showSnackbar(scaffoldKey,
                  'Dữ liệu bị lỗi, vui lòng liên hệ nhóm hỗ trợ hệ thống!');
              return;
            }
            await NavigationService.instance.navigateToRoute(
              MaterialPageRoute(
                  builder: (context) => ViewPdfScreen(
                      templateCode: result ?? '', id: item.id ?? 0, name: result ?? '')),
            );
          }
        }
      }
    } catch (e) {
      WidgetCommon.dismissLoading();
    }
  }

  clearData() {
    currentPage = 0;
    totalLength = 0;
    keyword = '';
    lstRecovery = [];
  }

  Color isRecordNew(String type, BuildContext context) {
    if (type == ActionPhone.LOANS) {
      return Theme.of(context).primaryColor;
    }
    if (type == ActionPhone.CARD) {
      return AppColor.blue;
    }
    return Theme.of(context).primaryColor;
  }
}
