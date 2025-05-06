import 'package:dio/dio.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/utils.dart';

class NotificationService {
  static int count = 0;
  // static int currentPage = 0;
  static bool checkGet = true;
  static String keyword = '';

  Future<Response> deleteUserDevice(String? uuid, String appCode) {
    var dataJson = {'appCode': appCode, 'uuid': uuid};
    return HttpHelper.postJSON(NOTIFICATION_SERVICE_URL.DELETE_USER_DEVICE,
        body: dataJson);
  }

  Future<Response> updateRead(String aggId, int unread) {
    var dataJson = {"aggId": aggId, "unread": unread};
    return HttpHelper.postJSON(NOTIFICATION_SERVICE_URL.READ,
        body: dataJson, timeout: 30000);
  }

  Future<Response> getPagingList(int currentPage, String keyword,
      {bool isUnread = false}) {
    if (keyword == "Search query" || isUnread == true) {
      keyword = "";
    }

    int lengthCurrent = APP_CONFIG.LIMIT_QUERY;
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);

    final filters = [
      {
        "field": "keyword",
        "value": keyword,
        "comparison": "eq",
        "type": "string"
      }
    ];
    if (isUnread) {
      filters.add({
        "field": "unread",
        "value": "1",
        "comparison": "eq",
        "type": "string"
      });
    }
    var dataJSON = {
      "startRow": offsetCurrent,
      "numOfRow": lengthCurrent,
      "filters": filters,
      "sortField": "",
      "sortDir": "DESC"
    };
    return HttpHelper.postJSON(NOTIFICATION_SERVICE_URL.GET_PAGING_LIST,
        body: dataJSON, timeout: APP_CONFIG.QUERY_TIME_OUT, typeContent: 1);
  }

  Future getDetailNotification(String aggId) async {
    // return HttpHelper.postForm(NOTIFICATION_SERVICE_URL.GET_DETAIL_NOTIFICATION,
    //     body: 'aggId=' + aggId,
    //     timeout: APP_CONFIG.QUERY_TIME_OUT,
    //     typeContent: 1);
    return HttpHelper.get(
        NOTIFICATION_SERVICE_URL.GET_DETAIL_NOTIFICATION + 'aggId=' + aggId,
        timeout: APP_CONFIG.QUERY_TIME_OUT,
        typeContent: 1);
    // try {
    //   final storageToken =
    //       await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';

    //   // final response = await HTTP.post(
    //   //     Uri.parse(
    //   //         SERVICE_URL.NOTIFICATION_SERVICE['GET_DETAIL_NOTIFICATION']),
    //   //     encoding: Encoding.getByName("UTF-8"),
    //   //     body: params,
    //   //     headers: {
    //   //       'Authorization': APP_CONFIG.KEY_JWT + '$storageToken',
    //   //       'Content-Type': 'application/x-www-form-urlencoded'
    //   //     });
    //   final response = await HTTP.get(
    //       Uri.parse(
    //           SERVICE_URL.NOTIFICATION_SERVICE['GET_DETAIL_NOTIFICATION'] +
    //               'aggId=' +
    //               aggId),
    //       headers: {
    //         'Authorization': APP_CONFIG.KEY_JWT + '$storageToken',
    //         'Content-Type': 'application/x-www-form-urlencoded'
    //       });
    //   if (response != null) {
    //     if (response.statusCode == 200 && response.contentLength > 0) {
    //       if (Utils.checkIsNotNull(response.body)) {
    //         var data = json.decode(response.body);
    //         if (data['status'] == 0 && Utils.checkIsNotNull(data['data'])) {
    //           return data['data'];
    //         }
    //       }
    //     }
    //   }
    //   return null;
    // } catch (e) {
    //   return null;
    // }
  }

  Future<Response> getCountUnread() {
    return HttpHelper.get(NOTIFICATION_SERVICE_URL.GET_COUNT_UNREAD,
        timeout: APP_CONFIG.QUERY_TIME_OUT, typeContent: 1);
  }
}
