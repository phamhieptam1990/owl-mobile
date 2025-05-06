import 'dart:convert';

import 'package:athena/screens/vietmap/vietmap.provider.dart';
import 'package:call_log/call_log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/category/action_attribute_ticket.model.dart';
import 'package:athena/models/category/action_ticket.model.dart';
import 'package:athena/models/category/contact_by_ticket.model.dart';
import 'package:athena/models/category/contact_person_ticket.model.dart';
import 'package:athena/models/category/locality.model.dart';
import 'package:athena/models/category/place_contact_ticket.model.dart';
import 'package:athena/models/deviceInfo.model.dart';
import 'package:athena/models/map/placemark.model.dart';
import 'package:athena/models/offline/action/checkin/checkin.offline.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/models/tickets/ticketEvent.model.dart';
import 'package:athena/screens/collections/collection/collections.provider.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/screens/filter/collections/filter-collections.screen.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';

import '../../common/constants/functionsScreen.dart';
import 'checkin/widgets/sawPosition.widget.dart';

class CollectionService {
  final _mapProvider = getIt<VietMapProvider>();
  final _collectionProvider = getIt<CollectionProvider>();
  final _filterCollection = getIt<FilterCollectionsProvider>();
  final _categoryProvider = new CategorySingeton();

  int count = 0;
  int currentPage = 0;
  bool checkGet = true;
  String keyword = '';

  Future<Response> buildSMSTemplate(double amoutInNumber, String contractCode,
      String mobilePhone, String aggId) async {
    final dataJson = {
      "aggId": aggId,
      "contractId": contractCode,
      "paymentAmount": amoutInNumber.round(),
      "to": mobilePhone
    };
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.SMS_TEMPLATE,
        body: dataJson, timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getPagingList(
      int currentPage, String keyword, var statusFiler) async {
    if (keyword == "Search query" || keyword == "") {
      keyword = '';
    }
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);
    var sort = this.buildSortModelJSON();
    var dataJson = {
      "startRow": offsetCurrent.toString(),
      "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1).toString(),
      "filterModel": {},
      "sortModel": [sort]
    };

    var newStatusFilter = Utils.buildFilterRecordStatus(statusFiler);
    if (Utils.checkIsNotNull(newStatusFilter)) {
      if (Utils.checkIsNotNull(sort)) {
        if (_collectionProvider.sortModel?.key ==
            SortCollections.COL_LAST_PAYMENT_DATE) {
          newStatusFilter["lastPaymentDate"] = {
            "type": FilterType.IS_NOT_NULL,
            "filter": "",
            "filterType": FilterType.TEXT
          };
        }
        dataJson = {
          "startRow": offsetCurrent.toString(),
          "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1).toString(),
          "filterModel": newStatusFilter,
          "sortModel": [sort]
        };
      } else {
        dataJson = {
          "startRow": offsetCurrent.toString(),
          "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1).toString(),
          "filterModel": newStatusFilter,
          "sortModel": [sort]
        };
      }
    } else {
      if (Utils.isArray(_filterCollection.aggids)) {
        dataJson['filterModel'] = {
          'aggId': {
            "type": "in",
            "values": _filterCollection.aggids,
            "filterType": "set"
          }
        };
      }
    }
    print(dataJson.toString());
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PIVOT_PAGING,
        body: dataJson, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  buildSortModelJSON() {
    var sort = {"colId": "createDate", "sort": "desc"};
    if (Utils.checkIsNotNull(_collectionProvider.sortModel)) {
      sort = {
        "colId": "${_collectionProvider.sortModel?.key.toString()}",
        "sort": "${_collectionProvider.sortModel?.value.toString()}"
      };
    }
    return sort;
  }

  Future<Response> countPagingList(
      int currentPage, String keyword, dynamic statusFiler) async {
    if (keyword == "Search query" || keyword == "") {
      keyword = '';
    }
    final sort = this.buildSortModelJSON();

    var dataJson = {
      "filterModel": {},
      "sortModel": [sort]
    };
    var newStatusFilter = Utils.buildFilterRecordStatus(statusFiler);
    if (Utils.checkIsNotNull(newStatusFilter)) {
      if (Utils.checkIsNotNull(sort)) {
        if (_collectionProvider.sortModel?.key ==
            SortCollections.COL_LAST_PAYMENT_DATE) {
          newStatusFilter["lastPaymentDate"] = {
            "type": FilterType.IS_NOT_NULL,
            "filter": "",
            "filterType": FilterType.TEXT
          };
        }
        dataJson = {
          "filterModel": newStatusFilter,
          "sortModel": [sort]
        };
      } else {
        dataJson = {
          "filterModel": newStatusFilter,
          "sortModel": [sort]
        };
      }
    } else {
      if (Utils.isArray(_filterCollection.aggids)) {
        dataJson['filterModel'] = {
          'aggId': {
            "type": "in",
            "values": _filterCollection.aggids,
            "filterType": "set"
          }
        };
      }
    }

    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PIVOT_COUNT,
        body: dataJson);
  }

  Future<Response> countPlannedDate(
      {DateTime? dateFrom, DateTime? dateTo}) async {
    // if (!Utils.checkIsNotNull(dateFrom)) {
    DateTime _selectedDayTemp = DateTime.now();

    String strDateTo = Utils.convertTimeToSearch(_selectedDayTemp);
    final statusFiler = {
      "plannedDate": {
        "type": "inRange",
        "dateFrom": strDateTo,
        "dateTo": strDateTo,
        "filterType": "date"
      },
      "recordStatus": {
        "type": "${FilterType.EQUALS}",
        "filter": "O",
        "filterType": "${FilterType.TEXT}"
      }
    };
    Map<String, dynamic> dataRequest = {
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": statusFiler,
      "sortModel": [
        {"colId": "createDate", "sort": "desc"}
      ]
    };
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PIVOT_COUNT,
        body: dataRequest, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> countDashboadPlan() async {
    return HttpHelper.get(MCR_TICKET_SERVICE_URL.COUNT_DASHBOARD_PLAN);
  }

  Future<Response> checkPlannedDate() async {
    DateTime dateFrom = DateTime.now();
    DateTime dateTo = DateTime.now();
    DateTime _selectedDayTemp = DateTime.now();
    int firstOfWeek = 7 - _selectedDayTemp.weekday;
    if (firstOfWeek > 0) {
      dateFrom = _selectedDayTemp.subtract(Duration(days: 7 - firstOfWeek - 1));
      dateTo = _selectedDayTemp.add(Duration(days: firstOfWeek));
    } else if (firstOfWeek == 0) {
      // Ngay hien tai la ngay cuoi tuan
      dateFrom = _selectedDayTemp.subtract(Duration(days: 7 - firstOfWeek - 1));
      dateTo = DateTime.now();
    } else {
      dateTo = _selectedDayTemp;
      dateTo = _selectedDayTemp.subtract(Duration(days: 7));
    }
    final strDateFrom = Utils.convertTimeToSearch(dateFrom) ?? '';
    final strDateTo = Utils.convertTimeToSearch(dateTo) ?? '';
    final statusFiler = {
      "plannedDate": {
        "type": "inRange",
        "dateFrom": strDateFrom,
        "dateTo": strDateTo,
        "filterType": "date"
      },
      "recordStatus": {
        "type": "${FilterType.EQUALS}",
        "filter": "O",
        "filterType": "${FilterType.TEXT}"
      }
    };
    Map<String, dynamic> dataRequest = {
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": statusFiler,
      "sortModel": [
        {"colId": "createDate", "sort": "desc"}
      ]
    };
    // var dataJson = 'request=' + Utils.encodeRequestJson(dataRequest);
    // return HttpHelper.postForm(MCR_TICKET_SERVICE_URL.COUNT_PAGING_PLANNED_DATE,
    //     body: dataJson, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
    //  var dataJson = 'request=' + Utils.encodeRequestJson(dataRequest);
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.COUNT_PAGING_PLANNED_DATE,
        body: dataRequest);
  }

  Future<Response> getPagingPlannedDateNew(int currentPage,
      {DateTime? date}) async {
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);
    if (!Utils.checkIsNotNull(date)) {
      date = DateTime.now();
    }
    String dateFrom = Utils.convertTimeToSearch(date!);
    final statusFiler = {
      "milestoneDate": {
        "type": "inRange",
        "dateFrom": dateFrom,
        "dateTo": dateFrom,
        "filterType": "date"
      },
      "planIssueStatus": {
        "type": "equals",
        "filter": CollectionTicket.UNDONE,
        "filterType": "text"
      },
      "recordStatus": {
        "type": "${FilterType.EQUALS}",
        "filter": "O",
        "filterType": "${FilterType.TEXT}"
      }
    };
    Map<String, dynamic> dataRequest = {
      "startRow": offsetCurrent,
      "endRow": offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1,
      "filterModel": statusFiler,
      "sortModel": [
        {"colId": "createDate", "sort": "desc"}
      ]
    };
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PAGING_PLANNED,
        body: dataRequest, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> getPagingPlannedDate(int currentPage,
      {DateTime? date}) async {
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);
    if (!Utils.checkIsNotNull(date)) {
      date = DateTime.now();
    }
    String dateFrom = Utils.convertTimeToSearch(date!);
    final statusFiler = {
      "plannedDate": {
        "type": "inRange",
        "dateFrom": dateFrom,
        "dateTo": dateFrom,
        "filterType": "date"
      },
      "recordStatus": {
        "type": "${FilterType.EQUALS}",
        "filter": "O",
        "filterType": "${FilterType.TEXT}"
      }
    };
    Map<String, dynamic> dataRequest = {
      "startRow": offsetCurrent,
      "endRow": offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1,
      "filterModel": statusFiler,
      "sortModel": [
        {"colId": "createDate", "sort": "desc"}
      ]
    };
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PIVOT_PAGING,
        body: dataRequest, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> countBacklog() {
    int offsetCurrent = Utils.buildOffsetConfig(1);
    String dateFrom = Utils.convertTimeToSearch(DateTime.now());
    String dateTo =
        Utils.convertTimeToSearch(DateTime.now().add(Duration(days: 30)));
    final statusFiler = {
      "lastEventDate": {
        "type": "${FilterType.IN_RANGE}",
        "dateFrom": "$dateFrom",
        "dateTo": "$dateTo",
        "filterType": "${FilterType.DATE}"
      },
      "hasCheckinInMonth": {
        "type": "${FilterType.EQUALS}",
        "filter": "${FilterType.TRUE}",
        "filterType": "text"
      },
      "recordStatus": {
        "type": "${FilterType.EQUALS}",
        "filter": "O",
        "filterType": "${FilterType.TEXT}"
      }
    };
    Map<String, dynamic> dataRequest = {
      "startRow": offsetCurrent,
      "endRow": offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1,
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": statusFiler,
      "sortModel": [
        {"colId": "createDate", "sort": "desc"}
      ]
    };
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PIVOT_COUNT,
        body: dataRequest, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> countPlanned(String type) {
    int offsetCurrent = Utils.buildOffsetConfig(1);
    var statusFiler;
    if (type == CollectionTicket.ALL) {
      statusFiler = {
        // "recordStatus": {"type": "equals", "filter": "O", "filterType": "text"},
      };
    } else if (type == CollectionTicket.UNDONE) {
      statusFiler = {
        "planIssueStatus": {
          "type": "equals",
          "filter": type,
          "filterType": "text"
        },
        "recordStatus": {"type": "equals", "filter": "O", "filterType": "text"},
      };
    } else {
      statusFiler = {
        "planIssueStatus": {
          "type": "equals",
          "filter": type,
          "filterType": "text"
        },
      };
    }
    Map<String, dynamic> dataRequest = {
      "startRow": offsetCurrent,
      "endRow": offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1,
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": statusFiler,
    };
    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.COUNT_PLANNED,
        body: dataRequest, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  convertStatusPland(status) {
    if (status == CollectionTicket.DONE) {
      return 1;
    } else if (status == CollectionTicket.UNDONE) {
      return 3;
    } else if (status == CollectionTicket.CANCEL) {
      return 2;
    } else if (status == CollectionTicket.ALL) {
      return 0;
    }
    return 0;
  }

  Future<Response> getPagingPlanned(
      int currentPage, String keyword, String? typeFilter) async {
    if (keyword == "Search query" || keyword == "") {
      keyword = '';
    }
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);
    var statusFiler;
    if (typeFilter == CollectionTicket.ALL) {
      statusFiler = {
        // "recordStatus": {"type": "equals", "filter": "O", "filterType": "text"},
      };
    } else if (typeFilter == CollectionTicket.UNDONE) {
      statusFiler = {
        "planIssueStatus": {
          "type": "equals",
          "filter": typeFilter,
          "filterType": "text"
        },
        "recordStatus": {"type": "equals", "filter": "O", "filterType": "text"},
      };
    } else {
      statusFiler = {
        "planIssueStatus": {
          "type": "equals",
          "filter": typeFilter,
          "filterType": "text"
        },
      };
    }

    Map<String, dynamic> dataJSON = {
      "startRow": offsetCurrent,
      "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1),
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": statusFiler
    };

    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.PAGING_PLANNED,
        body: dataJSON, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> getPagingListWithPermission(
      int currentPage, String keyword, String statusFiler) async {
    if (keyword == "Search query" || keyword == "") {
      keyword = '';
    }
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);
    final sort = this.buildSortModelJSON();
    Map<String, dynamic> dataJSON;
    dynamic filterModel = this.buildFilterPagingPermission(statusFiler);

    if (Utils.checkIsNotNull(sort)) {
      dataJSON = {
        "startRow": offsetCurrent,
        "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1),
        "rowGroupCols": [],
        "valueCols": [],
        "pivotCols": [],
        "pivotMode": false,
        "groupKeys": [],
        "filterModel": filterModel,
        "sortModel": [sort]
      };
    } else {
      dataJSON = {
        "startRow": offsetCurrent,
        "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1),
        "rowGroupCols": [],
        "valueCols": [],
        "pivotCols": [],
        "pivotMode": false,
        "groupKeys": [],
        "filterModel": filterModel,
      };
    }
    print(dataJSON.toString());
    return HttpHelper.postJSON(
        MCR_TICKET_SERVICE_URL.PIVOT_PAGING_WITH_PERMISSION_CHECKING,
        body: dataJSON,
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  buildFilterPagingPermission(String statusFiler) {
    String dateFrom = '';
    String dateTo = '';
    Map<String, Object> filterModel = {
      "recordStatus": {
        "type": "${FilterType.EQUALS}",
        "filter": "O",
        "filterType": "${FilterType.TEXT}"
      }
    };
    try {
      if (Utils.checkIsNotNull(statusFiler)) {
        filterModel["assignee"] = {
          "type": "equals",
          "filter": "$statusFiler",
          "filterType": "text"
        };
      }
      if (_filterCollection.addressCtr.text.isNotEmpty) {
        filterModel['ftsValue'] = {
          "type": "${FilterType.CONTAINS}",
          "filter": "${_filterCollection.addressCtr.text}",
          "filterType": "${FilterType.TEXT}"
        };
      }
      if (_filterCollection.customerNameCtr.text.isNotEmpty) {
        filterModel['issueName'] = {
          "type": "${FilterType.CONTAINS}",
          "filter": "${_filterCollection.customerNameCtr.text}",
          "filterType": "${FilterType.TEXT}"
        };
      }
      if (_filterCollection.applicationCtr.text.isNotEmpty) {
        filterModel['appId'] = {
          "type": "${FilterType.CONTAINS}",
          "filter": "${_filterCollection.applicationCtr.text}",
          "filterType": "${FilterType.TEXT}"
        };
      }
      if (_filterCollection.contractApplIdCtr.text.isNotEmpty) {
        filterModel['applId'] = {
          "type": "${FilterType.CONTAINS}",
          "filter": "${_filterCollection.contractApplIdCtr.text}",
          "filterType": "${FilterType.TEXT}"
        };
      }
      if (_filterCollection.idCardNumberCtrl.text.isNotEmpty) {
        filterModel['idCardNumber'] = {
          "type": "${FilterType.CONTAINS}",
          "filter": "${_filterCollection.idCardNumberCtrl.text}",
          "filterType": "${FilterType.TEXT}"
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.meetingDate)) {
        dateFrom = Utils.convertTimeToSearch(_filterCollection.meetingDate!);
        dateTo = Utils.convertTimeToSearch(_filterCollection.meetingDate!);
        filterModel['lastEventDate'] = {
          "type": "${FilterType.IN_RANGE}",
          "dateFrom": "$dateFrom",
          "dateTo": "$dateTo",
          "filterType": "${FilterType.DATE}"
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.paidCaseModel)) {
        if (_filterCollection.paidCaseModel?.value == 1) {
          filterModel['nvcontract_status'] = {
            "type": "${FilterType.EQUALS}",
            "filter": "PAID",
            "filterType": "${FilterType.TEXT}"
          };
        } else if (_filterCollection.paidCaseModel?.value == 0) {
          filterModel['nvcontract_status'] = {
            "type": "${FilterType.EQUALS}",
            "filter": "UNPAID",
            "filterType": "${FilterType.TEXT}"
          };
        }
      }
      if (Utils.checkIsNotNull(_filterCollection.lastUpdatedDate)) {
        dateFrom =
            Utils.convertTimeToSearch(_filterCollection.lastUpdatedDate!);
        dateTo = Utils.convertTimeToSearch(_filterCollection.lastUpdatedDate!);
        filterModel['lastCheckinDate'] = {
          "type": "${FilterType.IN_RANGE}",
          "dateFrom": "$dateFrom",
          "dateTo": "$dateTo",
          "filterType": "${FilterType.DATE}"
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.createdDate)) {
        dateFrom = Utils.convertTimeToSearch(_filterCollection.createdDate!);
        dateTo = Utils.convertTimeToSearch(_filterCollection.createdDate!);
        filterModel['createDate'] = {
          "type": "${FilterType.IN_RANGE}",
          "dateFrom": "$dateFrom",
          "dateTo": "$dateTo",
          "filterType": "${FilterType.DATE}"
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.createdDate)) {
        dateFrom = Utils.convertTimeToSearch(_filterCollection.createdDate!);
        dateTo = Utils.convertTimeToSearch(_filterCollection.createdDate!);
        filterModel['assignedDate'] = {
          "type": "${FilterType.IN_RANGE}",
          "dateFrom": "$dateFrom",
          "dateTo": "$dateTo",
          "filterType": "${FilterType.DATE}"
        };
      }
      if (_filterCollection.checkInModel?.value == 1) {
        filterModel['hasCheckinInMonth'] = {
          "type": "${FilterType.EQUALS}",
          "filter": "${FilterType.TRUE}",
          "filterType": "text"
        };
      } else if (_filterCollection.checkInModel?.value == 0) {
        filterModel['hasCheckinInMonth'] = {
          "type": "${FilterType.EQUALS}",
          "filter": "${FilterType.FALSE}",
          "filterType": "text"
        };
      }
      if (_filterCollection.ptpModel?.value == 1) {
        filterModel['actionGroupCode'] = {
          "type": "${FilterType.EQUALS}",
          "filter": "PTP",
          "filterType": "text"
        };
      } else if (_filterCollection.ptpModel?.value == 0) {
        filterModel['actionGroupCode'] = {
          "type": "${FilterType.NOT_EQUAL} ",
          "filter": "PTP",
          "filterType": "text"
        };
      }
       if (_filterCollection.bucketCtr.text.isNotEmpty) {
        filterModel["periodBucket"] = {
          "type": FilterType.CONTAINS,
          "filter": _filterCollection.bucketCtr.text,
          "filterType": FilterType.TEXT
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.statusTicketModel)) {
        final actionGroupId = {
          "type": "IN",
          "values": [
            "${_filterCollection.statusTicketModel?.id.toString() ?? ''}"
          ],
          "filterType": "${FilterType.SET.toString()}",
        };
        filterModel['actionGroupId'] = actionGroupId;
      }
      // filterModel['actionGroupId']
      if (_filterCollection.aggids.length > 0) {
        filterModel['aggId'] = {
          "type": "in",
          "values": _filterCollection.aggids,
          "filterType": "${FilterType.SET.toString()}"
        };
      }
      return filterModel;
    } catch (e) {
      print(e);
      return filterModel;
    }
  }

  changeCallType(type) {
    if (type == CallType.incoming) {
      return 'incoming';
    } else if (type == CallType.outgoing) {
      return 'outgoing';
    } else if (type == CallType.missed) {
      return 'missed';
    } else if (type == CallType.voiceMail) {
      return 'voiceMail';
    } else if (type == CallType.rejected) {
      return 'rejected';
    } else if (type == CallType.blocked) {
      return 'blocked';
    } else if (type == CallType.answeredExternally) {
      return 'answeredExternally';
    }
    return 'unknown';
  }

  Future<Response> recordUserSmsLog(context, dataFinal, aggId) {
    Map<String, dynamic> dataJson = {
      'aggId': aggId,
      'address': dataFinal.address,
      'body': dataFinal.body,
      'date': dataFinal.date,
    };
    return HttpHelper.postJSON(CUSTOMER_REQUEST_SERVICE_URL.RECORD_USER_SMS_LOG,
        body: dataJson);
  }

  Future<Response> recordUserCallLog(context, dataFinal, aggId, isIOS) async {
    Map<String, dynamic> dataJson;
    if (isIOS) {
      dataJson = {
        'aggId': aggId,
        'duration': dataFinal['duration'],
        'formattedNumber': dataFinal['formattedNumber'],
        'number': dataFinal['number'],
        'timestamp': dataFinal['timestamp'],
        'callType': dataFinal['callType']
      };
    } else {
      dataJson = {
        'aggId': aggId,
        'duration': dataFinal['duration'],
        'formattedNumber': dataFinal['formattedNumber'],
        'number': dataFinal['number'],
        'timestamp': dataFinal['timestamp'],
        'callType': dataFinal['callType']
      };
    }
    return HttpHelper.postJSON(
        CUSTOMER_REQUEST_SERVICE_URL.RECORD_USER_CALL_LOG,
        body: dataJson);
  }

  Future<Response> countListWithPermission(
      int currentPage, String keyword, String statusFiler) async {
    if (keyword == "Search query" || keyword == "") {
      keyword = '';
    }
    int offsetCurrent = Utils.buildOffsetConfig(currentPage);
    final sort = this.buildSortModelJSON();
    final filterModel = this.buildFilterPagingPermission(statusFiler);
    // Map<String, dynamic> dataJSON;
    // if (Utils.checkIsNotNull(dataJSON)) {
    //   dataJSON = {
    //     "startRow": offsetCurrent,
    //     "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1),
    //     "rowGroupCols": [],
    //     "valueCols": [],
    //     "pivotCols": [],
    //     "pivotMode": false,
    //     "groupKeys": [],
    //     "filterModel": filterModel,
    //     "sortModel": [sort]
    //   };
    // } else {
    //   dataJSON = {
    //     "startRow": offsetCurrent,
    //     "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1),
    //     "rowGroupCols": [],
    //     "valueCols": [],
    //     "pivotCols": [],
    //     "pivotMode": false,
    //     "groupKeys": [],
    //     "filterModel": filterModel
    //   };
    // }
    Map<String, dynamic> dataJSON = {
      "startRow": offsetCurrent,
      "endRow": (offsetCurrent + APP_CONFIG.LIMIT_QUERY - 1),
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": filterModel
    };
    return HttpHelper.postJSON(
        MCR_TICKET_SERVICE_URL.PIVOT_COUNT_WITH_PERMISSION_CHECKING,
        body: dataJSON);
  }

  Future<Response> getEmployee(String keyword, String reportEmpCode,
      {int numOfResult = APP_CONFIG.LIMIT_QUERY}) {
    return HttpHelper.get(MCR_US_PROFILE_SERVICE_URL.SEARCH_EMPLOYEE +
        'keyword=' +
        Uri.decodeComponent(keyword) +
        '&reportEmpCode=' +
        reportEmpCode +
        '&numOfResult=' +
        numOfResult.toString());
  }

  Future<Response> getPayment(String aggId) {
    return HttpHelper.get(MCR_TICKET_SERVICE_URL.GET_PAYMENT + aggId);
  }

  Future<Response> getContractByAggid(String aggId) {
    return HttpHelper.get(
        MCR_CONTRACT_SERVICE_URL.GET_CONTRACT_BY_AGGID + 'aggId=' + aggId);
  }

  Future<Response> getTicketDetail(String aggId) {
    return HttpHelper.get(MCR_TICKET_SERVICE_URL.GET_TICKET + 'aggId=' + aggId,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getContractInfo(String aggId) {
    return HttpHelper.get(MCR_TICKET_SERVICE_URL.GET_CONTRACT_INFO + aggId,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getDoccumentOmniId(String appId) {
    return HttpHelper.get(MCR_FEA_URL.GET_DOC_ID + 'appId=' + appId,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  bool isTicketActionDetailExist(TicketEventModel? event) {
    return true;
  }

  Future<Response> getEventLastTicket(String ticketId) {
    return HttpHelper.get(
        MCR_TICKET_SERVICE_URL.EVENT_LASTED_BY_TICKET + ticketId,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON);
  }

  Future<Response> getLatestCustomerComplaints(String ticketId) {
    return HttpHelper.get(
        MCR_TICKET_SERVICE_URL.GET_LATEST_CUSTOMER_COMPLAINS + ticketId,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON);
  }

  Future<Response> getUrlServey() {
    return HttpHelper.get(MCR_TICKET_SERVICE_URL.GET_URL_SERVEY,
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON);
  }

  Future<Response> getLineMananer(String emptyCode) {
    return HttpHelper.get(
        MCR_US_PROFILE_SERVICE_URL.GET_LINE_MANAGER_RECURSIVE +
            '?empCode=$emptyCode',
        typeContent: HttpHelperConstant.INPUT_TYPE_JSON);
  }

  Future<Response> getAcititySteamTicket(
      String ticketAggId, int offset, String fromTime) {
    final dataJson =
        'ticketAggId=$ticketAggId&offset=${0}&limit=${50}&fromTime=$fromTime';
    return HttpHelper.get(MCR_TICKET_SERVICE_URL.ACTIVITY_STEAM + dataJson);
  }

  Color colorDisableAction(var action, BuildContext context,
      {String type = ''}) {
    try {
      if (action == null) {
        return AppColor.blackOpacity;
      }
      if (action.customerData == null) {
        return AppColor.blackOpacity;
      }
      if (type == AppStateConfigConstant.EMAIL) {
        String email = action.customerData['email'] ?? '';
        if (email == '') {
          return AppColor.blackOpacity;
        }
      }
      if (type == AppStateConfigConstant.PHONE) {
        String phone = action.customerData['cellPhone'] ??
            action.customerData['homePhone'] || action.cusMobilePhone;
        if (phone == '') {
          return AppColor.blackOpacity;
        }
      }
      return Theme.of(context).primaryColor;
    } catch (e) {
      return AppColor.blackOpacity;
    }
  }

  actionGoVietMapPositionTypeId(
      TicketModel item, String type, BuildContext context) async {
    try {
      if (type == ActionPhone.DIRECTION) {
        await WidgetCommon.showLoading();
        Position? position = await PermissionAppService.getCurrentPosition();
        if (position == null) {
          return;
        }
        if (position.latitude == 0 && position.longitude == 0) {
          return;
        }
        LatLng _centerPosition =
            new LatLng(position.latitude, position.longitude);
        _mapProvider.setCenterPosition(_centerPosition);
        await WidgetCommon.dismissLoading();

        if (APP_CONFIG.enableVietMap) {
          Utils.pushName(context, RouteList.VIETMAP_SCREEN_POSITION_TYPE_ID,
              params: item);
        } else {}
        // Utils.pushName(null, RouteList.MAP_SCREEN_POSITION, params: item);
      }
    } catch (e) {}
  }

  actionPhone(TicketModel item, String type, BuildContext context) async {
    try {
      if (type == ActionPhone.DIRECTION) {
        await WidgetCommon.showLoading();
        Position? position = await PermissionAppService.getCurrentPosition();
        if (position == null) {
          return;
        }
        if (position.latitude == 0 && position.longitude == 0) {
          return;
        }
        LatLng _centerPosition =
            new LatLng(position.latitude, position.longitude);
        _mapProvider.setCenterPosition(_centerPosition);
        await WidgetCommon.dismissLoading();

        if (APP_CONFIG.enableVietMap) {
          Utils.pushName(context, RouteList.VIETMAP_SCREEN_POSITION,
              params: item);
        } else {}
        // Utils.pushName(null, RouteList.MAP_SCREEN_POSITION, params: item);
      } else if (type == ActionPhone.EMAIL) {
        String email = item.customerData['email'] ?? '';
        if (email == '') {
          return WidgetCommon.generateDialogOKGet(
              content: S.of(context).customerNoEmail);
        }
        Utils.actionPhone(email, type);
      } else {
        String phone =
            item.customerData['cellPhone'] ?? item.customerData['homePhone'];
        var status;
        if (type == ActionPhone.CALL) {
          status = await Permission.phone.request();
        } else {
          status = await Permission.sms.request();
        }
        if (status == PermissionStatus.denied) {
          WidgetCommon.generateDialogOKGet(
              content: 'Vui lòng cấp quyền cho chức năng Call');
          return false;
        }
        if (phone == '') {
          WidgetCommon.generateDialogOKGet(
              content: S.of(context).customerNoPhone);
          return false;
        }
        Utils.actionPhone(phone, type);
        return true;
      }
    } catch (e) {}
  }

  callPhoneExt(String phone, String type, BuildContext context) async {
    try {
      var status;
      if (type == ActionPhone.CALL) {
        status = await Permission.phone.request();
      } else {
        status = await Permission.sms.request();
      }
      if (status == PermissionStatus.denied) {
        WidgetCommon.generateDialogOKGet(
            content: 'Vui lòng cấp quyền cho chức năng Call');
        return false;
      }
      if (phone == '') {
        WidgetCommon.generateDialogOKGet(
            content: S.of(context).customerNoPhone);
        return false;
      }
      Utils.actionPhone(phone, type);
      return true;
    } catch (e) {
      return false;
    }
  }

  convertActionGroupCode(
      String? actionGroupCode, String? actionGroupName, BuildContext context) {
    if (actionGroupName?.isNotEmpty ?? false) {
      return actionGroupName;
    }
    if (actionGroupCode == FieldTicketConstant.PTP ||
        actionGroupCode == FieldTicketConstant.C_PTP) {
      return S.of(context).customerPromiseToPay;
    } else if (actionGroupCode == FieldTicketConstant.RTP ||
        actionGroupCode == FieldTicketConstant.C_RTP) {
      return S.of(context).customerRefuseToPay;
    } else if (actionGroupCode == FieldTicketConstant.PAY ||
        actionGroupCode == FieldTicketConstant.C_PAY) {
      return S.of(context).customerPartialPayment;
    } else if (actionGroupCode == FieldTicketConstant.OTHER ||
        actionGroupCode == FieldTicketConstant.C_OTHER) {
      return S.of(context).otherCheckIn;
    }
    return '';
  }

  String convertActionGroupName(
      String actionGroupCode, String actionGroupName, BuildContext context) {
    // return actionGroupName;
    if (actionGroupName.isNotEmpty ?? false) {
      return actionGroupName;
    }
    if (actionGroupCode == FieldTicketConstant.PAY) {
      return S.of(context).customerPartialPayment;
    }
    if (actionGroupCode == FieldTicketConstant.C_PAY) {
      return S.of(context).customerPartialPaymentC;
    }
    if (actionGroupCode == FieldTicketConstant.PTP) {
      return S.of(context).customerPromiseToPay;
    }
    if (actionGroupCode == FieldTicketConstant.C_PTP) {
      return S.of(context).customerPromiseToPayC;
    }
    if (actionGroupCode == FieldTicketConstant.RTP) {
      return S.of(context).customerRefuseToPay;
    }
    if (actionGroupCode == FieldTicketConstant.C_RTP) {
      return S.of(context).customerRefuseToPayC;
    }
    if (actionGroupCode == FieldTicketConstant.OTHER) {
      return S.of(context).otherCheckIn;
    }
    if (actionGroupCode == FieldTicketConstant.C_OTHER) {
      return S.of(context).otherCheckInC;
    }

    return actionGroupCode;
  }

  convertStatusCode(String? statusCode, BuildContext context) {
    if (statusCode == TICKET_SERVICE_STATUS.CANCEL) {
      return TICKET_SERVICE_STATUS.CANCEL;
    }
    if (statusCode == TICKET_SERVICE_STATUS.REOPENED) {
      return TICKET_SERVICE_STATUS.REOPENED;
    }
    if (statusCode == TICKET_SERVICE_STATUS.OPEN) {
      return S.of(context).doNotUpdateStatus;
    }
    if (statusCode == TICKET_SERVICE_STATUS.INIT) {
      return S.of(context).ticketStatusINIT;
    }
    if (statusCode == TICKET_SERVICE_STATUS.IN_PROGRESS) {
      return S.of(context).ticketStatusINPROGRESS;
    }
    if (statusCode == TICKET_SERVICE_STATUS.STATUS_UPDATED) {
      return S.of(context).ticketStatusSTATUS_UPDATED;
    }
    if (statusCode == TICKET_SERVICE_STATUS.DONE) {
      return S.of(context).ticketStatusDONE;
    }
    return statusCode;

// Khởi tạo
// Đang xử lý
// Đã cập nhật trạng thái
// Hoàn tất
//     -1000    CANCEL    Cancel
// -2    REOPENED    Reopened
// -1    OPEN    Open
// 0    INIT    Init
// -50    IN_PROGRESS    In Progress
// -100    DONE    Done
// 1    STATUS_UPDATED    Status Updated
  }

  getAssisneeData(TicketModel? ticket) {
    try {
      if (ticket?.assigneeData != null) {
        // if (ticket.assigneeData?.fullName != null) {
        //   return ticket.assigneeData?.fullName;
        // }
        if (ticket?.assigneeData?.empCode != null) {
          return ticket?.assigneeData?.empCode;
        }
        if (Utils.checkIsNotNull(ticket?.assigneeData['fullName'])) {
          return ticket?.assigneeData['fullName'] ?? '';
        }
      }
      if (Utils.checkIsNotNull(ticket?.assignee)) {
        return ticket?.assignee;
      }
      return '';
    } catch (e) {
      return ticket?.assigneeData?.fullName ?? '';
    }
  }

  getCustomer(TicketModel ticket) {
    if (ticket.customerData == null) {
      return '';
    }
    return ticket.customerData['fullName'] ?? '';
  }

  getPhoneCustomer(TicketModel? ticket) {
    if (ticket == null || ticket.customerData == null) {
      return '';
    }
    return ticket.customerData['cellPhone'] ?? '';
  }

  String buildAddressFromLatLong(List<Placemark> placeMarks) {
    if (placeMarks.isEmpty) {
      return '';
    }
    String street = '';
    String ward = '';
    String district = '';
    String city = '';
    Placemark place;
    for (int i = 0; i < placeMarks.length; i++) {
      place = placeMarks[i];
      if (i == 0) {
        street = place.street ?? '';
        district = place.subAdministrativeArea ?? '';
        city = place.administrativeArea ?? '';
      } else if (i == 3) {
        ward = place.name ?? '';
      }
    }
    return street + ", " + ward + ", " + district + ", " + city;
  }

  Future<Response> checkIn(var data) async {
    try {
      var longitude = data['longitude'];
      var latitude = data['latitude'];
      if (longitude == null ||
          longitude == 0.0 ||
          latitude == null ||
          latitude == 0.0) {
        WidgetCommon.generateDialogOKGet(
            content: 'Vui lòng nhấn định vị để cập nhật vị trí');
        return data;
      }
      var aggId = data['aggId'].toString();
      var contactModeId = data['contactModeId'];
      var contactPersonId = data['contactPersonId'];
      var contactPlaceId = data['contactPlaceId'];
      var paymentAmount = data['paymentAmount'];
      var paymentBy = data['paymentBy'].toString();
      var paymentUnit = data['paymentUnit'];
      var clientPhone = data['clientPhone'] ?? "";
      var description = data['description'].toString();
      var fieldActionId = data['fieldActionId'];
      var actionAttributeId = data['actionAttributeId'];
      var address = data['address'].toString();
      var accuracy = data['accuracy'];
      var date = data['date'].toString();
      var time = data['time'].toString();
      var actionGroupName = data['actionGroupName'].toString();
      var durationInMins = data['durationInMins'] ?? null;
      var attachments = [];
      var extraInfo = data['extraInfo'] != null ? data['extraInfo'] : {};

      if (data['attachments'] != null) {
        if (Utils.isArray(data['attachments'])) {
          attachments = data['attachments'];
        }
      }
      var selfie;
      if (data['selfie'] != null) {
        if (Utils.isArray(data['selfie'])) {
          selfie = data['selfie'].join('###');
        }
      }
      var offlineInfo;
      var submitTime = DateTime.now().millisecondsSinceEpoch;
      if (data['offlineInfo'] != null) {
        offlineInfo = data['offlineInfo'];
        offlineInfo['submitTime'] = DateTime.now().millisecondsSinceEpoch;
      }
      var contactFullAddress = data['contactFullAddress'];
      var contactName = data['contactName'];
      var contactMobile = data['contactMobile'];
      var contactProvinceId = data['contactProvinceId'];
      var contactDistrictId = data['contactDistrictId'];
      var contactWardId = data['contactWardId'];
      var contactAddress = data['contactAddress'];
      String customerAttitude = data['customerAttitude'];
      String overdueReason = data['overdueReason'];
      String financialSituation = data['financialSituation'];
      String otherTrace = data['otherTrace'];
      String relativeIncome = data['relativeIncome'];
      String checkInTypeCode = data['checkInTypeCode'];
      String checkInTypeName = data['checkInTypeName'];
      DeviceInfo? deviceInfo = AppState.getDeviceInfo();
      if (!Utils.checkIsNotNull(deviceInfo)) {
        var deviceInfoTemp =
            await StorageHelper.getString(AppStateConfigConstant.DEVICE_INFO);
        deviceInfo =
            DeviceInfo.fromJson(Utils.decodeJSONToString(deviceInfoTemp));
        AppState.setDeviceInfo(deviceInfo);
      }
      String imei = await Utils().getImeiDevices();
      var eventInfo;
      if (Utils.checkIsNotNull(date) &&
          Utils.checkIsNotNull(date) &&
          Utils.checkIsNotNull(date)) {
        eventInfo = {
          "date": date,
          "time": time,
          "durationInMins": durationInMins
        };
      } else {
        eventInfo = null;
      }
      final params = {
        "aggId": aggId,
        "submitTime": submitTime,
        "offlineInfo": offlineInfo,
        "checkinResult": {
          "attachment": attachments,
          "selfie": selfie,
          "contactModeId": contactModeId,
          "contactName": contactName,
          "contactMobile": contactMobile,
          "contactProvinceId": contactProvinceId,
          "contactDistrictId": contactDistrictId,
          "contactWardId": contactWardId,
          "contactAddress": contactAddress,
          "contactFullAddress": contactFullAddress,
          "contactPersonId": contactPersonId,
          "contactPlaceId": contactPlaceId,
          "paymentAmount": paymentAmount,
          "paymentBy": paymentBy,
          "actionGroupName": actionGroupName,
          "paymentUnit": paymentUnit,
          "clientPhone": clientPhone,
          "description": description,
          "fieldActionId": fieldActionId,
          "imei": imei,
          "deviceModel": deviceInfo?.deviceModel,
          "actionAttributeId": actionAttributeId,
          "customerAttitude": customerAttitude,
          "overdueReason": overdueReason,
          "financialSituation": financialSituation,
          "otherTrace": otherTrace,
          "relativeIncome": relativeIncome,
          "checkInTypeCode": checkInTypeCode,
          "checkInTypeName": checkInTypeName,
          "fieldGeo": {
            "address": address,
            "longitude": longitude,
            "latitude": latitude,
            "accuracy": accuracy
          },
          "eventInfo": eventInfo,
        },
        'extraInfo': extraInfo
      };
      return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.CHECK_IN, body: params);
    } catch (e) {
      print(e);
      return data;
    }
  }

  Future<bool> checkInOffline(var data) async {
    try {
      data['offlineInfo'] = {
        "uuid": data['aggId'] +
            '-' +
            DateTime.now().microsecondsSinceEpoch.toString(),
        "dataTime": DateTime.now().millisecondsSinceEpoch,
      };
      // await addCheckInOfflineStorage(data);
      CheckInOfflineModel offlineModel = new CheckInOfflineModel.fromJson(data);
      await HiveDBService.addCheckInOffline(offlineModel);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future addCheckInOfflineStorage(var data) async {
    List<String>? lstDataCheckInOffline =
        await StorageHelper.getStringList(HiveDBConstant.CHECK_IN_OFFLINE);
    if (!Utils.checkIsNotNull(lstDataCheckInOffline)) {
      lstDataCheckInOffline = [];
      lstDataCheckInOffline.add(jsonEncode(data));
    } else {
      lstDataCheckInOffline?.add(jsonEncode(data));
    }
    await StorageHelper.setStringList(
        HiveDBConstant.CHECK_IN_OFFLINE, lstDataCheckInOffline ?? []);
  }

  Future removeDataCheckInOffline(int index) async {
    List<String>? lstDataCheckInOffline =
        await StorageHelper.getStringList(HiveDBConstant.CHECK_IN_OFFLINE);
    if (Utils.checkIsNotNull(lstDataCheckInOffline)) {
      lstDataCheckInOffline?.removeAt(index);
      await StorageHelper.setStringList(
          HiveDBConstant.CHECK_IN_OFFLINE, lstDataCheckInOffline ?? []);
    }
  }

  Future<bool> checkInRefuseOffline(var data) async {
    try {
      data['offlineInfo'] = {
        "uuid": data['aggId'] +
            '-' +
            DateTime.now().microsecondsSinceEpoch.toString(),
        "dataTime": DateTime.now().millisecondsSinceEpoch,
      };
      data['date'] = null;
      CheckInOfflineModel offlineModel = new CheckInOfflineModel.fromJson(data);
      await HiveDBService.addCheckInOffline(offlineModel);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<Response> checkInRefuse(var data) async {
    var longitude = data['longitude'];
    var latitude = data['latitude'];
    if (longitude == null ||
        longitude == 0.0 ||
        latitude == null ||
        latitude == 0.0) {
      WidgetCommon.showSnackbarErrorGet(
          'Vui lòng nhấn định vị để cập nhật vị trí');
      return data;
    }
    var aggId = data['aggId'].toString();
    var contactModeId = data['contactModeId'];
    var contactPersonId = data['contactPersonId'];
    var contactPlaceId = data['contactPlaceId'];
    var paymentAmount = data['paymentAmount'];
    var paymentBy = data['paymentBy'].toString();
    var paymentUnit = data['paymentUnit'];
    var clientPhone = data['clientPhone'] ?? "";
    var description = data['description'].toString();
    var fieldActionId = data['fieldActionId'];
    var actionAttributeId = data['actionAttributeId'];
    var address = data['address'].toString();

    var accuracy = data['accuracy'];
    var date;
    var actionGroupName = data['actionGroupName'].toString();
    var attachments = [];
    var extraInfo = data['extraInfo'] != null ? data['extraInfo'] : {};
    if (data['attachments'] != null) {
      if (Utils.isArray(data['attachments'])) {
        attachments = data['attachments'];
      }
    }
    var selfie;
    if (data['selfie'] != null) {
      if (Utils.isArray(data['selfie'])) {
        selfie = data['selfie'].join('###');
      }
    }
    var offlineInfo;
    var submitTime = DateTime.now().millisecondsSinceEpoch;
    if (data['offlineInfo'] != null) {
      offlineInfo = data['offlineInfo'];
      offlineInfo['submitTime'] = DateTime.now().millisecondsSinceEpoch;
    }
    var contactName = data['contactName'];
    var contactMobile = data['contactMobile'];
    var contactProvinceId = data['contactProvinceId'];
    var contactDistrictId = data['contactDistrictId'];
    var contactWardId = data['contactWardId'];
    var contactAddress = data['contactAddress'];
    var contactFullAddress = data['contactFullAddress'];
    String customerAttitude = data['customerAttitude'];
    String overdueReason = data['overdueReason'];
    String financialSituation = data['financialSituation'];
    String otherTrace = data['otherTrace'];
    String relativeIncome = data['relativeIncome'];
    String checkInTypeCode = data['checkInTypeCode'];
    String checkInTypeName = data['checkInTypeName'];
    DeviceInfo? deviceInfo = AppState.getDeviceInfo();
    if (!Utils.checkIsNotNull(deviceInfo)) {
      var deviceInfoTemp =
          await StorageHelper.getString(AppStateConfigConstant.DEVICE_INFO);
      deviceInfo =
          DeviceInfo.fromJson(Utils.decodeJSONToString(deviceInfoTemp));
      AppState.setDeviceInfo(deviceInfo);
    }
    String imei = await Utils().getImeiDevices();

    final params = {
      "aggId": aggId,
      "submitTime": submitTime,
      "offlineInfo": offlineInfo,
      "checkinResult": {
        "attachment": attachments,
        "selfie": selfie,
        "contactModeId": contactModeId,
        "contactName": contactName,
        "contactMobile": contactMobile,
        "contactProvinceId": contactProvinceId,
        "contactDistrictId": contactDistrictId,
        "contactWardId": contactWardId,
        "contactAddress": contactAddress,
        "contactFullAddress": contactFullAddress,
        "contactPersonId": contactPersonId,
        "contactPlaceId": contactPlaceId,
        "paymentAmount": paymentAmount,
        "paymentBy": paymentBy,
        "actionGroupName": actionGroupName,
        "paymentUnit": paymentUnit,
        "clientPhone": clientPhone,
        "description": description,
        "fieldActionId": fieldActionId,
        "actionAttributeId": actionAttributeId,
        "imei": imei,
        "deviceModel": deviceInfo?.deviceModel,
        "customerAttitude": customerAttitude,
        "overdueReason": overdueReason,
        "financialSituation": financialSituation,
        "otherTrace": otherTrace,
        "relativeIncome": relativeIncome,
        "checkInTypeCode": checkInTypeCode,
        "checkInTypeName": checkInTypeName,
        "fieldGeo": {
          "address": address,
          "longitude": longitude,
          "latitude": latitude,
          "accuracy": accuracy
        },
        "eventInfo": date,
        "subAttributeId": data['subAttributeId'],
        "subAttributeGroupId": data['subAttributeGroupId'],
        "currentIncomeAmount": data['currentIncomeAmount'],
        "loanAmount": data['loanAmount'],
        "lastIncomeAmount": data['lastIncomeAmount'],
      },
      'extraInfo': extraInfo
    };

    return HttpHelper.postJSON(MCR_TICKET_SERVICE_URL.CHECK_IN, body: params);
  }

  String getDateSchedule(DateTime checkIn) {
    return checkIn.year.toString() +
        "-" +
        checkIn.month.toString() +
        "-" +
        checkIn.day.toString();
  }

  String getTimeSchedule(DateTime checkIn) {
    return checkIn.hour.toString() + ":" + checkIn.minute.toString();
  }

  String getDurationMin(var durations) {
    if (durations == null) {
      return '';
    }
    return durations['value'].toString();
  }

  Color isRecordItem(BuildContext context, TicketModel ticket) {
    if (ticket.nvcontractStatus == 'PAID') {
      return AppColor.red;
    }
    return Theme.of(context).primaryColor;
  }

  Color isRecordNew(DateTime date1, DateTime date2, BuildContext context,
      TicketModel ticket) {
    if (Utils.checkIsNotNull(ticket.priorityLevel)) {
      int priorityLevel = ticket.priorityLevel!;
      if (priorityLevel == 3) {
        return AppColor.red;
      }
      if (priorityLevel == 2) {
        return AppColor.priorityLevel2;
      }
      if (priorityLevel == 1) {
        return AppColor.yellow;
      }
    }
    if (!Utils.checkIsNotNull(date1) || !Utils.checkIsNotNull(date2)) {
      return Theme.of(context).primaryColor;
    }
    if (Utils.compareDateStr(date1, date2) == true) {
      return AppColor.blue;
    }
    return Theme.of(context).primaryColor;
  }

  bool isSelectPlaceContact(PlaceContactTicketModel? placeContact) {
    if (placeContact?.placeName != '') {
      return true;
    }
    return false;
  }

  String getAddressCustomer(
      var customer, PlaceContactTicketModel? placeContact) {
    try {
      if (customer == null) {
        return '';
      }
      var addressType;
      final pltbAddresses = customer['pltbAddresses'];
      if (pltbAddresses == null) {
        return '';
      }
      if (Utils.isArray(pltbAddresses)) {
        for (var address in pltbAddresses) {
          addressType = address['addressType'];
          addressType = addressType['typeCode'];
          if (addressType == placeContact?.placeCode) {
            if (Utils.checkIsNotNull(address['formattedAddress'])) {
              if (address['formattedAddress'] == 'NULL') {
                return '';
              }
              return address['formattedAddress'];
            }
            return '';
          }
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<Response> getContractForeclosure(String contractAggId) {
    return HttpHelper.get(MCR_CUSTOMER_SERVICE_URL.GET_CONTRACT_FORE_CLOSURE +
        'aggId=' +
        contractAggId);
  }

  Future<Response> getContractByAggId(String contractNo) {
    return HttpHelper.get(MCR_CUSTOMER_SERVICE_URL.GET_CONTRACT_BY_AGGID +
        'contractNo=' +
        contractNo);
  }

  Future<Response> getContractByAggIdNew(String aggId) {
    return HttpHelper.get(
        MCR_CUSTOMER_SERVICE_URL.GET_CONTRACT_BY_AGGID_NEW + 'aggId=' + aggId);
  }

  Future<Response> getContractBasicByAggId(String aggId) {
    return HttpHelper.get(
        MCR_CONTRACT_SERVICE_URL.GET_BY_AGG_ID_BASIC + 'aggId=' + aggId);
  }

  Future<Response> contractPayschepivotPaging(aggId) {
    var formData = {
      "startRow": 0,
      "endRow": 80,
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": {
        "aggId": {"type": "equals", "filter": aggId, "filterType": "text"}
      },
      "sortModel": []
    };
    return HttpHelper.postJSON(
        MCR_CONTRACT_SERVICE_URL.GET_PIVOT_PAGING_LMSCONTRACT_PAYSCHE,
        body: formData);
  }

  Future<Response> getCustomerMultipAddress(String aggid) {
    return HttpHelper.get(MCR_FEA_URL.GET_CUSTOMER_MULTIPLE_ADDRESS_LOG + aggid,
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getAppIds(String aggid) {
    return HttpHelper.get(MCR_FEA_URL.GET_APPIDS_NEW + aggid,
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  String tokenNew = '';
  // Future<Response> getObjectByTicketAggId(String aggId) {
  //   final params = {
  //     "startRow": 0,
  //     "endRow": 1,
  //     "filterModel": {
  //       "code": {"type": "equals", "filterType": "text", "filter": aggId}
  //     },
  //     "sortModel": []
  //   };
  //   return HttpHelper.postJSON(OMNI_SERVICE_URL.CONTRACT_PIVOT_PAGING,
  //       body: params, timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  // }

  Future<Response> getObjectXfile(String contractNo) {
    final params = {
      "startRow": 0,
      "endRow": 1,
      "rowGroupCols": [],
      "valueCols": [],
      "pivotCols": [],
      "pivotMode": false,
      "groupKeys": [],
      "filterModel": {
        "code": {"type": "equals", "filterType": "text", "filter": contractNo}
      },
      "sortModel": []
    };

    return HttpHelper.postJSON(XFILE_SERVICE_URL.PIVOT_PAGING,
        body: params, timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getObjWithDocsGroupedByDocType(String aggId) {
    return HttpHelper.get(XFILE_SERVICE_URL.CONTRACT_GET_DOC_GROUPED + aggId,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getTokenVNG(var refCodes) {
    final params = {"refCodes": refCodes, "includePreviewDoc": true};

    // return HttpHelper.postJSONNew('https://athena-api.a4b.vn/api/sta/auth/requestToken',
    //     body: params, timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW, token: tokenNew);
    // 'https://athena-api.a4b.vn/api/sta/auth/requestToken'
    return HttpHelper.postJSON(XFILE_SERVICE_URL.REQEUST_TOKEN_VNG,
        body: params, timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getFileFromVNG(String identifer, String accessToken) {
    final params = {
      "identifer": identifer,
      "preview": true,
      "accessToken": accessToken,
      "appCode": APP_CONFIG.APP_CODE
    };

    // return HttpHelper.postJSONNew('https://idms-gw.a4b.vn/pub/files/download',
    //     body: params, timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW, token: tokenNew);
    return HttpHelper.postJSON(XFILE_SERVICE_URL.DOWNLOAD_FILE_VNG,
        body: params, timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getCustomerMultipAddressWithoutLog(String aggid) {
    return HttpHelper.get(MCR_FEA_URL.GET_CUSTOMER_MULTIPLE_ADDRESS + aggid,
        typeContent: HttpHelperConstant.INPUT_TYPE_FORM,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Widget buildLoadingLocation(bool isLoading, BuildContext context) {
    if (!isLoading) {
      if (MyConnectivity.instance.isOffline) {
        return Icon(Icons.location_on, color: Theme.of(context).primaryColor);
      }
      return Icon(Icons.location_on, color: Theme.of(context).primaryColor);
    }
    return WidgetCommon.buildCircleLoading(
        widthSB: 20.0, heightSB: 20.0, pWidth: 20.0);
  }

  Future<Response> fetchDataOffline(int limit) {
    return HttpHelper.get(
        CALENDAR_REPORT_URL.FETCH_DATA_OFFLINE + 'startRow=0&endRow=$limit',
        timeout: 120000);
  }

  Future<Response> getPaymentCardInfo(String aggID) {
    return HttpHelper.get(MCR_FEA_URL.GET_PAYMENT_CARD_INFO_LOG + aggID,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getLoanSecInfo(String aggID) {
    return HttpHelper.get(MCR_FEA_URL.GET_LOAN_SEC_INFO_LOG + aggID,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getLoanBasicInfo(String aggId) {
    return HttpHelper.get(MCR_FEA_URL.GET_LOAN_BASIC_INFO_LOG + aggId,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getEarlyTermination(String aggId) {
    // return HttpHelper.get(MCR_FEA_URL.EARLY_TERMINATION + contractNo,
    //     timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
    return HttpHelper.get(MCR_TICKET_SERVICE_URL.GET_CONTRACT_INFO + aggId,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> addPlannedDate(List<String> aggIds, String plannedDate) {
    Map<String, dynamic> dataJSON = {
      "aggIds": aggIds,
      "plannedDate": plannedDate
    };

    // return HttpHelper.postForm(MCR_TICKET_SERVICE_URL.CREATE_PLANNED_DATE,
    //     body: 'cmd=' + Utils.encodeRequestJson(dataJSON),
    //     typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
    return HttpHelper.post(MCR_TICKET_SERVICE_URL.CREATE_PLANNED_DATE,
        body: dataJSON, typeContent: HttpHelperConstant.INPUT_TYPE_FORM);
  }

  Future<Response> getKalapaLoanInfo(String aggId) {
    return HttpHelper.get(MCR_FEA_URL.GET_KALAPA_LOAN_INFO_LOG + aggId,
        timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  buildSortText(SortModel sortModel, String label, BuildContext context) {
    if (Utils.checkIsNotNull(sortModel)) {
      if (sortModel.title == label) {
        if (sortModel.value == SortCollections.DESC) {
          return label + ' ' + S.of(context).desc;
        } else if (sortModel.value == SortCollections.ASC) {
          return label + ' ' + S.of(context).asc;
        }
      }
    }
    return label;
  }

  buildKeySort(String key) {
    switch (key) {
      case SortCollections.LAST_PAYMENT_DATE:
        return SortCollections.COL_LAST_PAYMENT_DATE;
      case SortCollections.POS:
        return SortCollections.COL_POS_ATM;
      case SortCollections.EMI:
        return SortCollections.COL_EMI;
      case SortCollections.DUEDATE:
        return SortCollections.COL_CONTRACT_DUE_DAY;
      case SortCollections.OVERDUE_AMOUNT:
        return SortCollections.COL_AMOUNT_OVER_DUE;
      case SortCollections.MIN_AMOUNT_DUE:
        return SortCollections.COL_MIN_AMOUNT_DUE;
      default:
        return '';
    }
  }

  String showDueDateEarlyTermination(earlyTermination) {
    try {
      if (Utils.checkIsNotNull(earlyTermination)) {
        if (Utils.checkIsNotNull(earlyTermination['props']) &
            Utils.checkIsNotNull(earlyTermination['props']['START_DATE'])) {
          if (earlyTermination['props']['START_DATE'] is int) {
            return Utils.convertTimeWithoutTime(
                earlyTermination['props']['START_DATE']);
          }
          return Utils.convertTimeWithoutTime(Utils.convertTimeStampToDate(
              earlyTermination['props']['START_DATE']));
        }
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  bool checkShowCity(PlaceContactTicketModel? _placeContactTicketModel) {
    if (!Utils.checkIsNotNull(_placeContactTicketModel)) {
      return false;
    }
    if (_placeContactTicketModel?.placeCode == CollectionTicket.RELATIVE ||
        _placeContactTicketModel?.placeCode == CollectionTicket.REL ||
        _placeContactTicketModel?.placeCode == CollectionTicket.OTHER) {
      return true;
    }
    return false;
  }

  bool checkShowAddress(ContactByTicketModel contactByTicketModel,
      ContactPersonTicketModel? contactPersonTicketModel) {
    if (!Utils.checkIsNotNull(contactByTicketModel) ||
        !Utils.checkIsNotNull(contactPersonTicketModel)) {
      return false;
    }
    if (contactByTicketModel.modeCode == CollectionTicket.CV) {
      return true;
    }
    return false;
  }

  bool checkShowProvince(LocalityModel cityModel) {
    if (!Utils.checkIsNotNull(cityModel)) {
      return false;
    }
    return true;
  }

  bool checkShowWard(LocalityModel provinceModel, LocalityModel wardModel) {
    if (!Utils.checkIsNotNull(provinceModel)) {
      return false;
    }
    return true;
  }

  String builFullAddress(LocalityModel? cityModel, LocalityModel? provinceModel,
      LocalityModel? wardModel, String? addressFull) {
    String address = '';
    if (Utils.checkIsNotNull(addressFull)) {
      address += addressFull??'' + ', ';
    }
    if (Utils.checkIsNotNull(wardModel)) {
      address += wardModel?.name??'' + ', ';
    }
    if (Utils.checkIsNotNull(provinceModel)) {
      address += provinceModel?.name??'' + ', ';
    }
    if (Utils.checkIsNotNull(cityModel)) {
      address += cityModel?.name??'';
    }
    return address;
  }

  Future<Response> getLocationFromAddressTypeId(
      String codes, addressTypeId) async {
    var url = MCR_CUSTOMER_SERVICE_URL.GET_ADDRESS_LOCATIONS_TYPE_ID +
        'codes=' +
        codes +
        '&addressTypeId=' +
        addressTypeId.toString();
    return HttpHelper.get(
        MCR_CUSTOMER_SERVICE_URL.GET_ADDRESS_LOCATIONS_TYPE_ID +
            'codes=' +
            codes +
            '&addressTypeId=' +
            addressTypeId.toString());
  }

  Future<Response> getLocationFromAddress(String codes) async {
    return HttpHelper.get(
        MCR_CUSTOMER_SERVICE_URL.GET_ADDRESS_LOCATIONS + 'codes=' + codes);
  }

  Future<Response> getDocsId(String appId) async {
    return HttpHelper.get(MCR_CUSTOMER_SERVICE_URL.GET_CONTACT_DOCS + appId);
  }

  Future<Response> getContactDocs(String contractId) async {
    return HttpHelper.get(
        MCR_TICKET_SERVICE_URL.GET_BY_CONTRACT_IDHP + contractId);
  }

  Future openMapWhenCheckIn(
      BuildContext context, _scaffoldKey, dynamic position) async {
    if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
      if (Utils.checkIsNotNull(position)) {
        LatLng positionT =
            new LatLng(position['latitude'], position['longitude']);
        return await NavigationService.instance.navigateToRoute(
            MaterialPageRoute(
                builder: (context) => SawPositionCheckin(position: positionT)));
      }
      return WidgetCommon.showSnackbar(
          _scaffoldKey, 'Không tìm thấy tọa độ check in');
    }
  }

  Widget buildCustomerAttitude(TicketModel? ticket) {
    if (Utils.checkIsNotNull(ticket?.customerAttitude)) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: 4.0),
            Row(
              children: [
                Icon(
                  Icons.feedback_outlined,
                  size: 15.0,
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 6.0),
                //   child: Text('Thái độ khách hàng:' + ticket.customerAttitude),
                // ),
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Text(
                        'Thái độ khách hàng: ' +
                            (ticket?.customerAttitude ?? ''),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14.0, color: Colors.black54),
                        // style: TextStyle(fontSize: 12.0)
                      )),
                ),
              ],
            )
          ]);
    }
    return Container();
  }

  Widget buildManager(TicketModel? ticket) {
    if (Utils.checkIsNotNull(ticket?.managerCode)) {
      final managerText =
          (ticket?.managerCode ?? '') + ' ' + (ticket?.managerFullname ?? '');
      return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // new SizedBox(height: 4.0),
            Row(
              children: [
                Icon(
                  Icons.supervisor_account,
                  size: 15.0,
                ),
                Flexible(
                  child: Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Text(
                        managerText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      )),
                )
              ],
            )
          ]);
    }
    return Container();
  }

  Widget buildLateCall(TicketModel ticket) {
    if (Utils.checkIsNotNull(ticket.flagDeferment) ||
        Utils.checkIsNotNull(ticket.flagLatecall) ||
        Utils.checkIsNotNull(ticket.flagSummarize)) {
      return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // new SizedBox(height: 4.0),
            Row(
              children: [
                Visibility(
                    visible: ticket.flagSummarize == 1,
                    child: Padding(
                        padding: EdgeInsets.only(right: 7.0),
                        child: Icon(
                          Icons.tab,
                          size: 15.0,
                          color: AppColor.dashBoard1,
                        ))),
                Visibility(
                    visible: ticket.flagLatecall == 1,
                    child: Padding(
                        padding: EdgeInsets.only(right: 7.0),
                        child: Icon(
                          Icons.record_voice_over,
                          size: 15.0,
                          color: AppColor.dashBoard2,
                        ))),
                Visibility(
                    visible: ticket.flagDeferment == 1,
                    child: Icon(
                      Icons.done_all_rounded,
                      size: 15.0,
                      color: AppColor.dashBoard3,
                    )),
                Visibility(
                    visible: ticket.flagCash24 == 1,
                    child: Icon(
                      Icons.flag,
                      size: 28.0,
                      color: AppColor.orange,
                    )),
              ],
            ),
            // SizedBox(height: 4.0),
          ]);
    }
    return Container();
  }

  Widget buildCaseExpirationDate(TicketModel? ticket) {
    if (Utils.checkIsNotNull(ticket?.caseExpirationDate)) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: 4.0),
            Row(children: [
              Icon(
                Icons.event_busy,
                size: 15.0,
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 6.0),
              //   child: Text('Ngày hết hạn: ' +
              //       Utils.convertTimeWithoutTime(ticket.caseExpirationDate)),
              // ),
              Flexible(
                child: Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Text(
                      'Ngày hết hạn: ' +
                          Utils.returnData(ticket?.caseExpirationDate,
                              type: 'date'),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      // style: TextStyle(fontSize: 12.0)
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    )),
              ),
            ]),
          ]);
    }
    return Container();
  }

  Widget buildTextSummary(TicketModel ticket) {
    if (Utils.checkIsNotNull(ticket.flagSummarize)) {
      // return Text(
      //     'Yêu cầu khách hàng gọi đến hotline 1900-234-588 nhánh 9 để được hướng dẫn giãn nợ');
      if (ticket.flagSummarize == 1) {
        return Text.rich(TextSpan(
            text: 'Yêu cầu khách hàng gọi đến hotline ',
            children: <InlineSpan>[
              TextSpan(
                text: '1900-234-588 nhánh 9 ',
                style: TextStyle(
                    color: AppColor.primary, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'để được hướng dẫn giãn nợ',
              ),
            ]));
      }
    }
    return Container();
  }

  List<ActionAttributeTicketModel> getListSelectActionAttributeTicket(
      ActionTicketModel? _actionTicketModel,
      String actionGroupCode,
      String? actionCode,
      int? actionGroupID,
      String? tenantCode) {
    List<ActionAttributeTicketModel> lstActionAttributeTicketModel = [];
    try {
      ActionAttributeTicketModel? attributeTicketModelTemp;
      bool isAdd = true;
      for (ActionAttributeTicketModel attribute
          in _categoryProvider.lstActionAttributeTicketModel) {
        if (attribute.attributeValue == FieldTicketConstant.PAID) {
          attributeTicketModelTemp = attribute;
        }
        if (attribute.actionId == _actionTicketModel?.fetmAction['id'] &&
            attribute.actionGroupId == actionGroupID) {
          if (actionGroupCode == FieldTicketConstant.PAY ||
              actionGroupCode == FieldTicketConstant.C_PAY) {
            if (attribute.attributeValue == FieldTicketConstant.OBT &&
                tenantCode == 'BROTHER') {
              lstActionAttributeTicketModel.add(attribute);
              isAdd = false;
            } else if (tenantCode != 'BROTHER') {
              lstActionAttributeTicketModel.add(attribute);
              isAdd = false;
            }
          } else {
            lstActionAttributeTicketModel.add(attribute);
            isAdd = false;
          }
        }
      }
      if (Utils.checkIsNotNull(attributeTicketModelTemp) &&
          isAdd &&
          actionCode == FieldTicketConstant.WFP &&
          (actionGroupCode == FieldTicketConstant.C_OTHER ||
              actionGroupCode == FieldTicketConstant.OTHER)) {
        lstActionAttributeTicketModel.add(attributeTicketModelTemp!);
      }
    } catch (e) {}
    return lstActionAttributeTicketModel;
  }

  Future<Response> getCollectionContactKalapa(String aggId) {
    final url = MCR_CUSTOMER_SERVICE_URL.GET_KALAPA_INFO + aggId;
    return HttpHelper.get(url, timeout: APP_CONFIG.COMMAND_TIME_OUT_NEW);
  }

  Future<Response> getTransactionCardList(
      {int? fromDate, int? toDate, String? accountNumber, int transType = 2}) {
    var data = {
      "params": {
        "accountNumber": accountNumber,
        "fromDate": fromDate,
        "toDate": toDate,
        "transType": transType
      }
    };
    return HttpHelper.postJSON(
      MCR_CUSTOMER_SERVICE_URL.GET_TRANSACTION_CARD_LIST,
      body: data,
    );
  }

  Future<Response> getContractTypeInfoList() {
    return HttpHelper.get(
      MCR_TICKET_SERVICE_URL.GET_CONTRACT_TYPE_INFO_LIST,
    );
  }

  // Future<Response>? getRecoveryInfo(String contractType,
  //     {String? accountNumber, String? applId}) async {
  //   // if (contractType == ActionPhone.CARD) {
  //   //   if (accountNumber?.isEmpty ?? false) {
  //   //     return '';
  //   //   }
  //   //   return HttpHelper.postJSON(SERVICE_URL.MCROPS['GET_BY_ACCOUNT_NUMBER'] ??,
  //   //       body: {"accountNumber": accountNumber});
  //   // }
  //   // if (contractType == ActionPhone.LOAN) {
  //   //   if (applId?.isEmpty ?? false) {
  //   //     return null;
  //   //   }
  //   //   return HttpHelper.postJSON(SERVICE_URL.MCROPS['GET_ALL_BY_APP_ID'],
  //   //       body: {"applId": applId});
  //   // }
  //   // return null;
  //   return null;
  // }

  // Future<Response> getDebtSettlement(String appId) {
  //   // var body = {'applId': appId};
  //   // return HttpHelper.postJSON(
  //   //   SERVICE_URL.MCROPS['GET_CSADEBT_SETTLMENT_ELIGIBLE'],
  //   //   body: body,
  //   // );
  //   return null;
  // }

  // if longtitude and latitude is null or 0.0 return false
  bool? checkPositionError(double? latitude, double? longitude) {
    if (Utils.checkIsNotNull(latitude) && Utils.checkIsNotNull(longitude)) {
      if (latitude != 0.0 &&
          longitude != 0.0 &&
          latitude != 0 &&
          longitude != 0) {
        return true;
      }
    }
    WidgetCommon.showSnackbarErrorGet(
        'Vui lòng nhấn định vị để cập nhật vị trí');
    return false;
  }

  bool showSMSConfirmation(userInfoStore, tenantCode) {
    if (!userInfoStore.checkPerimission(ScreenPermission.SMS_CONFIRMATION) ||
        tenantCode == 'TNEX') {
      return false;
    }
    return true;
  }
}

class TICKET_SERVICE_STATUS {
  static const String CANCEL = "CANCEL";
  static const String REOPENED = "REOPENED";
  static const String OPEN = "OPEN";
  static const String INIT = "INIT";
  static const String IN_PROGRESS = "IN_PROGRESS";
  static const String STATUS_UPDATED = "STATUS_UPDATED";
  static const String DONE = "DONE";
}

class ADDRESS_TYPE_ID {
  static const int cusFullAddress = 4;
  static const int permanentAddress = 2;
  static const int companyAddress = 1;
}
