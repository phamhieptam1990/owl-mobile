import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/getit.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/utils.dart';

class CustomerRequestService {
  final _userInfoStore = getIt<UserInfoStore>();
  Future<Response> getDetail(String aggId) {
    String url = CUSTOMER_REQUEST_SERVICE_URL.GET_DETAIL + aggId;
    return HttpHelper.get(url,
        timeout: APP_CONFIG.COMMAND_TIME_OUT, typeContent: 0);
  }

  Future<Response> getPagingList(
      int currentPage, String keyword, String statusFiler) async {
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);
    String userName = '';
    userName = _userInfoStore.user?.username ?? '';
      var dataJson = 'request=' +
        Uri.encodeComponent('{"startRow":' +
            offsetCurrent.toString() +
            ',"endRow":' +
            (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1).toString() +
            ',"rowGroupCols":[],"valueCols":[],"pivotCols":[],"pivotMode":false,"groupKeys":[],"filterModel":{"issueClassCode":{"type":"equals","filter":"VYMO_FC_SUPPORT","filterType":"text"},"reporter":{"type":"equals","filter":"$userName","filterType":"text"}},"sortModel":[{"colId":"makerDate","sort":"desc"}]}');
    if (statusFiler != '') {
      dataJson = 'request=' +
          Uri.encodeComponent('{"startRow":' +
              offsetCurrent.toString() +
              ',"endRow":' +
              (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1).toString() +
              ',"rowGroupCols":[],"valueCols":[],"pivotCols":[],"pivotMode":false,"groupKeys":[],"filterModel":{"issueClassCode":{"type":"equals","filter":"VYMO_FC_SUPPORT","filterType":"text"},"reporter":{"type":"equals","filter":"$userName","filterType":"text"},$statusFiler},"sortModel":[{"colId":"makerDate","sort":"desc"}]}');
    }
    return HttpHelper.postForm(CUSTOMER_REQUEST_SERVICE_URL.PIVOT_PAGING,
        body: dataJson, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> getSchemaPivot(context) async {
    return HttpHelper.get(CUSTOMER_REQUEST_SERVICE_URL.GET_SCHEMAPIVOT,
        timeout: APP_CONFIG.COMMAND_TIME_OUT, typeContent: 0);
  }

  Future<Response> getSupportTicketCategories(context,
      {String supportType = 'Athena Owl'}) async {
    return HttpHelper.get(
        CUSTOMER_REQUEST_SERVICE_URL.GET_SUPPORTTICKETCATEGORIES +
            '?supportType=$supportType',
        timeout: APP_CONFIG.COMMAND_TIME_OUT,
        typeContent: 0);
  }

  Future<Response> getCategoriesConfigByIssueType(context) async {
    return HttpHelper.get(
        CUSTOMER_REQUEST_SERVICE_URL.GET_CATEGORIESCONFIGBYISSUETYPE +
            'issueType=VYMO_FC_SUPPORT',
        timeout: APP_CONFIG.COMMAND_TIME_OUT,
        typeContent: 0);
  }

  Future<Response> actionTicketEdit(
      context, dynamic dataFinal, aggId, dataFinalFormat) {
    for (var item in dataFinalFormat.keys) {
      if (dataFinalFormat[item] == "numeric") {
        dataFinal[item] = int.parse(Utils.repplaceCharacter(dataFinal[item]));
      } else if (dataFinalFormat[item] == "date") {
        dataFinal[item] = dataFinal[item].millisecondsSinceEpoch;
        // (dataFinal[item]);
      }
    }
    var properties = dataFinal;
    // issueName
    Map<dynamic, dynamic> inputData = {'newValue': properties};
    Map<dynamic, dynamic> dataJson = {
      'aggId': aggId,
      'ticketActionId': 6,
      'inputData': inputData,
    };

    return HttpHelper.postForm(CUSTOMER_REQUEST_SERVICE_URL.EXECUTE_ACTION,
        body: 'cmd=' + Uri.encodeComponent(jsonEncode(dataJson)),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM,
        timeout: 60000);
  }

  Future<Response> actionTicket(
      context, dynamic dataFinal, aggId, dataFinalFormat) {
    for (var item in dataFinalFormat.keys) {
      if (dataFinalFormat[item] == "numeric") {
        dataFinal[item] = int.parse(Utils.repplaceCharacter(dataFinal[item]));
      } else if (dataFinalFormat[item] == "date") {
        dataFinal[item] = dataFinal[item].millisecondsSinceEpoch;
        // (dataFinal[item]);
      }
    }
    var properties = dataFinal;
    // issueName
    Map<dynamic, dynamic> inputData = {'newValue': properties};
    Map<dynamic, dynamic> dataJson = {
      'aggId': aggId,
      'ticketActionId': 6,
      'inputData': inputData,
    };

    return HttpHelper.postForm(CUSTOMER_REQUEST_SERVICE_URL.EXECUTE_ACTION,
        body: 'cmd=' + Uri.encodeComponent(jsonEncode(dataJson)),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM,
        timeout: 60000);
  }

  Future<Response> createTicket(
      context, dynamic dataFinal, username, dataFinalFormat) {
    for (var item in dataFinalFormat.keys) {
      if (dataFinalFormat[item] == "numeric") {
        dataFinal[item] = int.parse(Utils.repplaceCharacter(dataFinal[item]));
      } else if (dataFinalFormat[item] == "date") {
        dataFinal[item] = dataFinal[item].millisecondsSinceEpoch;
        // (dataFinal[item]);
      }
    }
    var temp = json.encode(dataFinal);
    var properties = json.decode(temp);
    var issueName = dataFinal['issueName'];
    var categoryId = dataFinal['categoryId'];
    var subCategoryId = dataFinal['subCategoryId'];
    properties.remove('categoryId');
    properties.remove('subCategoryId');
    properties.remove('issueName');
    // issueName
    Map<dynamic, dynamic> dataJson = {
      'issueName': issueName,
      'issueClassCode': 'VYMO_FC_SUPPORT',
      'reporter': username,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'assignee': null,
      // groupCandidates: ["BUR#NULL/ROLE_VYMO_FECREDIT_CA"],
      'groupCandidates': ['CAT#' + dataFinal['categoryId'].toString()],
      'watchers': null,
      'dueDate': null,
      'priority': 50,
      'properties': properties
    };

    return HttpHelper.postForm(CUSTOMER_REQUEST_SERVICE_URL.SENT_REQUEST,
        body: 'cmd=' + Uri.encodeComponent(jsonEncode(dataJson)),
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM,
        timeout: 60000);
  }
}
