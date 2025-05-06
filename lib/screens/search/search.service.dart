import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/search/search.offline.model.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/utils.dart';

class SearchService {
  final _homeProvider = getIt<HomeProvider>();

  Future<Response> getPagingList(
      int currentPage, String keyword, String statusFiler) async {
    if (keyword == "Search query" || keyword == "") {
      keyword = '';
    }
    int lengthCurrent = APP_CONFIG.LIMIT_QUERY;
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);

    final request = {
      "startRow": offsetCurrent,
      "endRow": offsetCurrent + lengthCurrent - 1,
      "filterModel": {
        "ftsValue": {
          "type": "contains",
          "filter": keyword,
          "filterType": "text"
        },
        "recordStatus": {
          "type": "${FilterType.EQUALS}",
          "filter": "O",
          "filterType": "${FilterType.TEXT}"
        }
      },
      "sortModel": []
    };
    print(request.toString());
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PIVOT_PAGING,
        body: request);
  }

  Future<Response> getPagingListPermission(
      int currentPage, String keyword, String statusFiler) async {
    if (keyword == "Search query" || keyword == "") {
      keyword = '';
    }
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);

    Map<String, dynamic> dataJSON = {
      "startRow": offsetCurrent,
      "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1),
      "filterModel": {
        "ftsValue": {
          "type": "${FilterType.CONTAINS}",
          "filter": keyword,
          "filterType": "${FilterType.TEXT}"
        },
        "recordStatus": {
          "type": "${FilterType.EQUALS}",
          "filter": "O",
          "filterType": "${FilterType.TEXT}"
        },
        "assignee": {
          "type": "equals",
          "filter": statusFiler,
          "filterType": "text"
        }
      }
    };

    return HttpHelper.postJSON(
        MCR_TICKET_SERVICE_URL.PIVOT_PAGING_WITH_PERMISSION_CHECKING,
        body: dataJSON);
  }

  void onSaveSearchKeyword(String keyword) {
    if (keyword.isNotEmpty ?? false) {
      Box<SearchOfflineModel> searchHistoryBox =
          Hive.box<SearchOfflineModel>(HiveDBConstant.SEARCH_SCREEN);
      int indexAlreadyKeyword =
          getIndexAlreadyKeyword(keyword, searchHistoryBox.values.toList());

      if (indexAlreadyKeyword == -1) {
        searchHistoryBox.add(SearchOfflineModel(keyword: keyword));
      } else {
        // move index to first
        SearchOfflineModel? template =
            searchHistoryBox.getAt(indexAlreadyKeyword);
        if(template == null) return;
        searchHistoryBox.deleteAt(indexAlreadyKeyword);
        searchHistoryBox.add(template);
      }
    }
  }

  void removeSearchRecentIndex(int index) {
    Box<SearchOfflineModel> searchHistoryBox =
        Hive.box<SearchOfflineModel>(HiveDBConstant.SEARCH_SCREEN);
    searchHistoryBox.deleteAt(index);
  }

  void clearSearchHistory() {
    Box<SearchOfflineModel> searchHistoryBox =
        Hive.box<SearchOfflineModel>(HiveDBConstant.SEARCH_SCREEN);
    searchHistoryBox.clear();
  }

//Returns -1 if [element] is not found.
  int getIndexAlreadyKeyword(String keyword, List<SearchOfflineModel> list) {
    return list.indexWhere((e) => e.keyword == keyword);
  }
}
