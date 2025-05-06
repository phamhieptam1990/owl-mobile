import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/employee/employee.model.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/offline/ticket/ticket.offline.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/collections/collection/widget/leadingTitle.widget.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/screens/filter/collections/filter-collections.screen.dart';
import 'package:athena/screens/home/home.service.dart';
import 'package:athena/screens/home/widgets/record_location_popup.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/customer/customer.service.dart';
import 'package:athena/utils/services/employee/employee.provider.dart';
import 'package:athena/utils/services/employee/employee.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';

import '../../../getit.dart';
import '../../../utils/common/tracking_installing_device.dart';
import '../../../utils/global-store/user_info_store.dart';
import '../collections.service.dart';
import 'collections.provider.dart';

class CollectionScreen extends StatefulWidget {
  CollectionScreen({Key? key}) : super(key: key);
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen>
    with AfterLayoutMixin {
  final _collectionService = new CollectionService();
  final _employeeService = new EmployeeService();
  final _customerService = new CustomerService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'CollectionScreen');
  final _collectionProvider = getIt<CollectionProvider>();
  final _employeeProvider = getIt<EmployeeProvider>();
  final _filterCollection = getIt<FilterCollectionsProvider>();
  List<TicketModel> lstTicketModelTemp = [];
  bool _enablePullUp = true;
  bool isFirstEnter = true;
  String title = '';
  bool openCheckBox = false;
  bool isCheckAll = true;
  int records = 0;
  DateTime? _now;
  DateTime? _currentTime;
  bool isLoadingRecordTLLocation = false;
  final _userInfoStore = getIt<UserInfoStore>();
  @override
  initState() {
    super.initState();
    _now = DateTime.now();
    _employeeProvider.clearData();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (title.isEmpty) {
      final titlePage = ModalRoute.of(context)?.settings.arguments ?? '';
      if (Utils.checkIsNotNull(titlePage)) {
        title = titlePage.toString();
      }
    }
    if (_userInfoStore.checkRoles('UNIT_HEAD') ||
        _userInfoStore.checkRoles('TEAM_LEAD') ||
        _userInfoStore.checkRoles('ROLE_OWL_ADMIN') ||
        _userInfoStore.checkRoles('ROLE_OWL_ADMIN_AGENT') ||
        _userInfoStore.checkRoles('ROLE_OWL_SUPER_ADMIN')) {
      this._filterCollection.seftModel = SeftModel("TEAM", 1);
    } else {
      this._filterCollection.seftModel = SeftModel("SEFT", 0);
    }
    if (!Utils.checkIsNotNull(this._collectionProvider.filter)) {
      this._collectionProvider.filter = {};
    }

    // Kiểm tra và đảm bảo statusTicketModel?.id không null
    if (_filterCollection.statusTicketModel?.id != null) {
      this._collectionProvider.filter["actionGroupId"] = {
        "type": "IN",
        "values": [_filterCollection.statusTicketModel?.id],
        "filterType": FilterType.SET
      };
    } else {
      // Xử lý nếu id là null, có thể set một giá trị mặc định hoặc báo lỗi
      print("statusTicketModel.id is null");
    }
    await Future.delayed(Duration(milliseconds: 100));
    await handleFetchData();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    try {
      _collectionProvider.currentPage = 1;
      _collectionProvider.lstTicket = [];
      this.isFirstEnter = true;
      setState(() {});
      await handleFetchData();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  Future<void> handleFetchData() async {
    try {
      if (MyConnectivity.instance.isOffline) {
        final boxTicketOffline =
            await HiveDBService.openBox(HiveDBConstant.TICKET);
        if (HiveDBService.checkValuesInBoxesIsNotEmpty(boxTicketOffline)) {
          final boxTicketOfflineValues =
              HiveDBService.getValuesData(boxTicketOffline);
          int lengthBoxTicket = boxTicketOfflineValues.length;
          int limitQuery =
              (_collectionProvider.getCurrentPage - 1) * APP_CONFIG.LIMIT_QUERY;
          if (limitQuery < 0) {
            limitQuery = -(limitQuery);
          }
          if (limitQuery == 0) {
            if (lengthBoxTicket >= APP_CONFIG.LIMIT_QUERY) {
              lengthBoxTicket = APP_CONFIG.LIMIT_QUERY;
            }
          } else if (limitQuery > 0 && limitQuery < lengthBoxTicket) {
            lengthBoxTicket = limitQuery + APP_CONFIG.LIMIT_QUERY;
            if (lengthBoxTicket > boxTicketOfflineValues.length) {
              lengthBoxTicket = boxTicketOfflineValues.length;
            }
          }
          int index = limitQuery;
          for (; index < lengthBoxTicket; index++) {
            TicketOfflineModel ticketOffline = boxTicketOffline.getAt(index);
            if (Utils.checkIsNotNull(ticketOffline.assigneeData)) {
              EmployeeModel emp =
                  EmployeeModel.fromJson(ticketOffline.assigneeData.toJson());
              ticketOffline.assigneeData = emp;
            }

            _collectionProvider.getLstTicket
                .add(TicketModel.fromJson(ticketOffline.toJson()));
          }
          if (index < boxTicketOfflineValues.length) {
            _collectionProvider.setCurrentPage =
                _collectionProvider.getCurrentPage + 1;
          } else {
            _enablePullUp = false;
          }
        }
      } else {
        _enablePullUp = true;
        Response? response;
        if (this._collectionProvider.filterNew.priority == true) {
          response = await this._collectionService.getPagingPlanned(
              _collectionProvider.getCurrentPage,
              _collectionProvider.getKeyword,
              this._collectionProvider.filterNew.type);
          countPaging('PLANNED');
        } else {
          if (this._filterCollection.seftModel?.value == 1) {
            response = await this
                ._collectionService
                .getPagingListWithPermission(
                    _collectionProvider.getCurrentPage,
                    _collectionProvider.getKeyword,
                    this._filterCollection.employeeHierachyModel?.empCode ?? '')
                .catchError((error, stackTrace) {
              if (error is DioException) {
                TrackingInstallingDevice()
                    .writeErrorsPagingList(error.response);
              }
            });
            countPaging('PERMISSION');
          } else {
            response = await this
                ._collectionService
                .getPagingList(
                    _collectionProvider.getCurrentPage,
                    _collectionProvider.getKeyword,
                    _collectionProvider.getFilter)
                .catchError((error, stackTrace) {
              if (error is DioException) {
                TrackingInstallingDevice()
                    .writeErrorsPagingList(error.response);
              }
            });
            countPaging('PAGING');
          }
        }
        if (Utils.checkRequestIsComplete(response)) {
          var lstData = Utils.handleRequestData2Level(response);
          if (lstData.length < APP_CONFIG.LIMIT_QUERY) {
            _enablePullUp = false;
          } else {
            _collectionProvider.setCurrentPage =
                _collectionProvider.getCurrentPage + 1;
          }
          if (_collectionProvider.getLstTicket.isEmpty) {
            for (var data in lstData) {
              _employeeProvider.checkAddEmployee(
                  new EmployeeModel(empCode: data['assignee']));
              _collectionProvider.getLstTicket.add(TicketModel.fromJson(data));
            }
          } else {
            var data;
            for (int index = 0; index < lstData.length; index++) {
              data = lstData[index];
              _employeeProvider.checkAddEmployee(
                  new EmployeeModel(empCode: data['assignee']));
              if (index == 0) {
                if (data['aggId'] ==
                    _collectionProvider
                        .getLstTicket[
                            _collectionProvider.getLstTicket.length - 1]
                        .aggId) {
                  continue;
                }
              }
              _collectionProvider.getLstTicket.add(TicketModel.fromJson(data));
            }
          }
        }

        String empCodes = _employeeProvider.handleRequestEmployee();
        if (empCodes.length > 0) {
          final Response empRes = await _employeeService.getEmployees(empCodes);
          if (Utils.checkRequestIsComplete(empRes)) {
            _employeeProvider.addEmployeesTemp(empRes.data['data']);
          }
        }

        for (TicketModel ticket in _collectionProvider.getLstTicket) {
          if (ticket.assigneeData == null) {
            for (int index = 0;
                index < _employeeProvider.getLstEmployee.length;
                index++) {
              if (_employeeProvider.getLstEmployee[index].empCode ==
                  ticket.assignee) {
                ticket.assigneeData = _employeeProvider.getLstEmployee[index];
                break;
              }
            }
          }
        }

        HiveDBService.addCollections(this._collectionProvider.getLstTicket);
      }
    } catch (e) {
      print(e);
      // printLog(e);
    } finally {
      if (isFirstEnter == true) {
        isFirstEnter = false;
      }
      setState(() {});
    }
  }

  countPaging(String type) {
    if (type == 'PERMISSION') {
      this
          ._collectionService
          .countListWithPermission(
              _collectionProvider.getCurrentPage,
              _collectionProvider.getKeyword,
              this._filterCollection.employeeHierachyModel?.empCode ?? '')
          .then((responseCount) {
        handleDataCountPagingList(responseCount);
      });
    } else if (type == 'PAGING') {
      this
          ._collectionService
          .countPagingList(_collectionProvider.getCurrentPage,
              _collectionProvider.getKeyword, _collectionProvider.getFilter)
          .then((responseCount) {
        handleDataCountPagingList(responseCount);
      });
    } else if (type == 'PLANNED') {
      this
          ._collectionService
          .countPlanned(this._collectionProvider.filterNew.type ?? '')
          .then((responseCount) {
        handleDataCountPagingList(responseCount);
      });
    }
  }

  handleDataCountPagingList(Response responseCount) {
    if (Utils.checkRequestIsComplete(responseCount)) {
      var responseData = responseCount.data;
      if (Utils.checkIsNotNull(responseData)) {
        this._collectionProvider.totalLength = responseData['data'];
        if (!isFirstEnter) {
          setState(() {});
        }
      }
    }
  }

  void _onLoading() async {
    try {
      if (mounted) {
        await handleFetchData();
      }
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  Widget buildTitle(BuildContext contexti) {
    if (openCheckBox) {
      return Text(records.toString() + ' dòng');
    }
    return new InkWell(
      onTap: () async {
        await openSort();
      },
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: (title.isEmpty)
            ? Text(S.of(context).collections +
                ' (' +
                _collectionProvider.totalLength.toString() +
                ')')
            : new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(S.of(context).collections +
                      ' (' +
                      _collectionProvider.totalLength.toString() +
                      ')'),
                  Text(title,
                      style: TextStyle(fontSize: 12.0),
                      overflow: TextOverflow.ellipsis)
                ],
              ),
      ),
    );
  }

  Widget buildItemListView(int i) {
    TicketModel detail = _collectionProvider.getLstTicket[i];
    return Card(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          InkWell(
            onTap: () {
              if (openCheckBox) {
                detail.isChecked = !detail.isChecked!;
                addPlannedText(detail);
                setState(() {});
                return;
              }
              Utils.submitLocation(action: 'view-details-contract');
              Utils.pushName(context, RouteList.COLLECTION_DETAIL_SCREEN,
                  params: _collectionProvider.getLstTicket[i]);
            },
            onLongPress: () {
              setState(() {
                openCheckBox = !openCheckBox;
              });
            },
            child: ListTile(
              contentPadding:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 0.0),
              leading: openCheckBox
                  ? Checkbox(
                      value: detail.isChecked,
                      onChanged: (bool? newValue) {
                        detail.isChecked = !detail.isChecked!;
                        addPlannedText(detail);
                        setState(() {});
                      },
                    )
                  : CircleAvatar(
                      child: Text(
                          _collectionProvider.getLstTicket[i].issueName![0],
                          style: TextStyle(color: AppColor.white)),
                      // backgroundColor: _collectionService.isRecordNew(
                      //     Utils.converLongToDate(
                      //         Utils.convertTimeStampToDateEnhance(
                      //             detail?.createDate)),
                      //     Utils.converLongToDate(
                      //         Utils.convertTimeStampToDateEnhance(
                      //             detail?.assignedDate)),
                      //     context,
                      //     detail)),
                      backgroundColor:
                          _collectionService.isRecordItem(context, detail)),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _collectionProvider.getLstTicket[i].issueName ?? '',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  this
                      ._collectionService
                      .buildLateCall(_collectionProvider.getLstTicket[i]),
                ],
              ),
              subtitle:
                  LeadingTitle(detail: _collectionProvider.getLstTicket[i]),
            ),
          ),
        ]));
  }

  addPlannedText(TicketModel ticketModel) {
    if (!Utils.checkIsNotNull(ticketModel.isChecked)) {
      records -= 1;
    } else {
      records += 1;
    }
    if (records < 0) {
      records = 0;
    }
  }

  handleSmsCallLog(action, ticketModel, type) async {
    // var smsFrom = DateTime.now();
    // var callFrom = DateTime.now();
    // final result = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => CallSmsLog(
    //             type: type,
    //             action: action,
    //             smsFrom: smsFrom,
    //             callFrom: callFrom,
    //             ticketModel: ticketModel)));

    // if (result == true) {
    //   print(result);
    // }
  }

  Future<void> openSort() async {
    final lstSort = [
      SheetAction(
        label: _collectionService.buildSortText(
            _collectionProvider.sortModel!, 'Last Payment', context),
        key: SortCollections.LAST_PAYMENT_DATE,
      ),
      SheetAction(
        label: _collectionService.buildSortText(
            _collectionProvider.sortModel!, S.of(context).POS, context),
        key: SortCollections.POS,
      ),
      SheetAction(
        label: _collectionService.buildSortText(
            _collectionProvider.sortModel!, S.of(context).EMI, context),
        key: SortCollections.EMI,
      ),
      SheetAction(
        label: _collectionService.buildSortText(
            _collectionProvider.sortModel!, S.of(context).dueDate, context),
        key: SortCollections.DUEDATE,
      ),
      SheetAction(
        label: _collectionService.buildSortText(_collectionProvider.sortModel!,
            S.of(context).OverdueAmount, context),
        key: SortCollections.OVERDUE_AMOUNT,
      ),
      SheetAction(
        label: _collectionService.buildSortText(_collectionProvider.sortModel!,
            S.of(context).minAmountDue, context),
        key: SortCollections.MIN_AMOUNT_DUE,
      ),
      SheetAction(
          label: S.of(context).clear,
          key: ActionPhone.CANCEL,
          isDestructiveAction: true)
    ];
    final result =
        await showModalActionSheet<String>(context: context, actions: lstSort);
    if (Utils.checkIsNotNull(result)) {
      this.isFirstEnter = true;
      this._collectionProvider.setCurrentPage = 1;
      this._collectionProvider.lstTicket = [];
      setState(() {});
      if (result == ActionPhone.CANCEL) {
        _collectionProvider.sortModel = null;
        await handleFetchData();
        return;
      }
      if (Utils.checkIsNotNull(_collectionProvider.sortModel)) {
        if (_collectionProvider.sortModel?.title == result) {
          if (_collectionProvider.sortModel?.value == SortCollections.ASC) {
            // _collectionProvider.sortModel.value = SortCollections.DESC;
          } else if (_collectionProvider.sortModel?.value ==
              SortCollections.DESC) {
            // _collectionProvider.sortModel.value = SortCollections.ASC;
          }
          await handleFetchData();
          return;
        }
      }

      _collectionProvider.sortModel = new SortModel(result!,
          SortCollections.DESC, _collectionService.buildKeySort(result));

      await handleFetchData();
    }
  }

  buildActionSheet(TicketModel item) async {
    if (openCheckBox) {
      return;
    }
    if (item.customerData == null) {
      // final Response resCustomer =
      //     await _customerService.getContactByAggId(item.customerId);
      final Response resCustomer =
          await _customerService.getContactByAggId(item.aggId!);
      if (Utils.checkRequestIsComplete(resCustomer)) {
        item.customerData = resCustomer.data['data'];
      }
    }
    final result = await showModalActionSheet<String>(
      context: context,
      actions: [
        SheetAction(
          icon: Icons.call,
          label: S.of(context).call,
          key: ActionPhone.CALL,
        ),
        SheetAction(
          icon: Icons.sms,
          label: S.of(context).SMS,
          key: ActionPhone.SMS,
        ),
        SheetAction(
          icon: Icons.near_me,
          label: S.of(context).direction,
          key: ActionPhone.DIRECTION,
        ),
        SheetAction(
            icon: Icons.cancel,
            label: S.of(context).cancel,
            key: ActionPhone.CANCEL,
            isDestructiveAction: true),
      ],
    );
    if (result == ActionPhone.CALL || result == ActionPhone.SMS) {
      var action = _collectionService.actionPhone(item, result!, context);
      handleSmsCallLog(action, item, result);
    } else {
      _collectionService.actionPhone(item, result!, context);
    }
  }

  navigateAndDisplaySelection(BuildContext context) async {
    if (!OfflineService.isFeatureValid(FEATURE_APP.FILTER_SEARCH_COLLECTIONS)) {
      return;
    }
    final result = await NavigationService.instance.navigateToRoute(
      MaterialPageRoute(builder: (context) => FilterCollectionScreen()),
    );
    if (result != null) {
      this.isFirstEnter = true;
      this._collectionProvider.setCurrentPage = 1;
      this._collectionProvider.keyword = '';
      this._collectionProvider.filter = {};
      this._collectionProvider.lstTicket = [];
      title = '';
      setState(() {});
      String dateFrom = '';
      String dateTo = '';
      if (Utils.checkIsNotNull(_filterCollection.paidCaseModel)) {
        if (_filterCollection.paidCaseModel?.value != -1) {
          title = _filterCollection.paidCaseModel?.title ?? '';
        }
      }
      if (_filterCollection.addressCtr.text.isNotEmpty) {
        this._collectionProvider.filter["ftsValue"] = {
          "type": FilterType.CONTAINS,
          "filter": _filterCollection.addressCtr.text,
          "filterType": FilterType.TEXT
        };
      }
      if (_filterCollection.customerNameCtr.text.isNotEmpty) {
        this._collectionProvider.filter["issueName"] = {
          "type": FilterType.CONTAINS,
          "filter": _filterCollection.customerNameCtr.text,
          "filterType": FilterType.TEXT
        };
      }
      if (_filterCollection.bucketCtr.text.isNotEmpty) {
        this._collectionProvider.filter["periodBucket"] = {
          "type": FilterType.CONTAINS,
          "filter": _filterCollection.bucketCtr.text,
          "filterType": FilterType.TEXT
        };
      }
      if (_filterCollection.applicationCtr.text.isNotEmpty) {
        this._collectionProvider.filter["appId"] = {
          "type": FilterType.CONTAINS,
          "filter": _filterCollection.applicationCtr.text,
          "filterType": FilterType.TEXT
        };
      }
      if (_filterCollection.contractApplIdCtr.text.isNotEmpty) {
        this._collectionProvider.filter["applId"] = {
          "type": FilterType.CONTAINS,
          "filter": _filterCollection.contractApplIdCtr.text,
          "filterType": FilterType.TEXT
        };
      }
      if (_filterCollection.idCardNumberCtrl.text.isNotEmpty) {
        this._collectionProvider.filter["idCardNumber"] = {
          "type": FilterType.CONTAINS,
          "filter": _filterCollection.idCardNumberCtrl.text,
          "filterType": FilterType.TEXT
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.meetingDate)) {
        dateFrom = Utils.convertTimeToSearch(_filterCollection.meetingDate);
        dateTo = Utils.convertTimeToSearch(_filterCollection.meetingDate);
        this._collectionProvider.filter["lastEventDate"] = {
          "type": FilterType.IN_RANGE,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "filterType": FilterType.DATE
        };
      }

      if (Utils.checkIsNotNull(_filterCollection.paidCaseModel)) {
//hasLastPaymentInMonth

        if (_filterCollection.paidCaseModel?.value == 1) {
          this._collectionProvider.filter["nvcontract_status"] = {
            "type": FilterType.EQUALS,
            "filter": "PAID",
            "filterType": FilterType.TEXT
          };
        } else if (_filterCollection.paidCaseModel?.value == 0) {
          this._collectionProvider.filter["nvcontract_status"] = {
            "type": FilterType.EQUALS,
            "filter": "UNPAID",
            "filterType": FilterType.TEXT
          };
        }
      }
      if (Utils.checkIsNotNull(_filterCollection.lastUpdatedDate)) {
        dateFrom = Utils.convertTimeToSearch(_filterCollection.lastUpdatedDate);
        dateTo = Utils.convertTimeToSearch(_filterCollection.lastUpdatedDate);
        this._collectionProvider.filter["lastCheckinDate"] = {
          "type": FilterType.IN_RANGE,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "filterType": FilterType.DATE
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.createdDate)) {
        dateFrom = Utils.convertTimeToSearch(_filterCollection.createdDate);
        dateTo = Utils.convertTimeToSearch(_filterCollection.createdDate);

        this._collectionProvider.filter["createDate"] = {
          "type": FilterType.IN_RANGE,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "filterType": FilterType.DATE
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.assignDate)) {
        dateFrom = Utils.convertTimeToSearch(_filterCollection.assignDate);
        dateTo = Utils.convertTimeToSearch(_filterCollection.assignDate);
        this._collectionProvider.filter["assignedDate"] = {
          "type": FilterType.IN_RANGE,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "filterType": FilterType.DATE
        };
      }
      if (_filterCollection.checkInModel?.value == 1) {
        this._collectionProvider.filter["hasCheckinInMonth"] = {
          "type": FilterType.EQUALS,
          "filter": FilterType.TRUE,
          "filterType": "text"
        };
      } else if (_filterCollection.checkInModel?.value == 0) {
        this._collectionProvider.filter["hasCheckinInMonth"] = {
          "type": FilterType.EQUALS,
          "filter": FilterType.FALSE,
          "filterType": "text"
        };
      }
      if (_filterCollection.ptpModel?.value == 1) {
        this._collectionProvider.filter["actionGroupCode"] = {
          "type": FilterType.EQUALS,
          "filter": "PTP",
          "filterType": "text"
        };
      } else if (_filterCollection.ptpModel?.value == 0) {
        this._collectionProvider.filter["actionGroupCode"] = {
          "type": FilterType.NOT_EQUAL,
          "filter": "PTP",
          "filterType": "text"
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.statusTicketModel?.id)) {
        this._collectionProvider.filter["actionGroupId"] = {
          "type": "IN",
          "values": [_filterCollection.statusTicketModel?.id],
          "filterType": FilterType.SET
        };
      }
      if (Utils.checkIsNotNull(_filterCollection.contractTypeInfo?.code)) {
        this._collectionProvider.filter["ftsContractValue"] = {
          "type": FilterType.CONTAINS,
          "filter": _filterCollection.contractTypeInfo?.code,
          "filterType": FilterType.TEXT
        };
      }
      await handleFetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: buildTitle(context),
        actions: <Widget>[
          Visibility(
            child: IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () async {
                await navigateAndDisplaySelection(context);
              },
            ),
            visible: !openCheckBox,
          ),
          Visibility(
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Utils.pushName(context, RouteList.SEARCH_SCREEN);
              },
            ),
            visible: !openCheckBox,
          ),
          Visibility(
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                actionCheckAllRecordCalendar();
              },
            ),
            visible: openCheckBox,
          ),
          Visibility(
            child: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                await openConfirmCheckBox(context, 'A');
              },
            ),
            visible: openCheckBox,
          ),
          Visibility(
            child: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () async {
                await openConfirmCheckBox(context, 'C');
              },
            ),
            visible: openCheckBox,
          ),
        ],
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
      ),
      // floatingActionButton: FloatContainerHomeScreen(
      //   onRecordTLLocation: onRecordTLLocation,
      // ),
      body: Scrollbar(child: buildBodyView()),
    );
  }

  void onRecordTLLocation() async {
    showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      barrierDismissible: true,
      context: context,
      pageBuilder: (_, __, ___) {
        return RecordLocationPopup(
          title: 'Lưu địa điểm',
          onsubmit: (position, title) async {
            try {
              setState(() {
                isLoadingRecordTLLocation = true;
              });

              final response =
                  await HomeService().createGPSLog(position, title);

              if (response.data['status'] == 0) {
                WidgetCommon.showSnackbar(_scaffoldKey, 'Ghi nhận thành công',
                    backgroundColor: AppColor.blue);
              } else {
                WidgetCommon.showSnackbar(_scaffoldKey, 'Ghi nhận thất bại!');
              }
              setState(() {
                isLoadingRecordTLLocation = false;
              });
            } catch (_) {
              WidgetCommon.showSnackbar(
                  _scaffoldKey, S.of(context).update_failed);
              setState(() {
                isLoadingRecordTLLocation = false;
              });
            }
          },
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  Future<void> addItemToList() async {
    try {
      List<String> aggIds = [];
      for (TicketModel ticket in this._collectionProvider.getLstTicket) {
        if (Utils.checkIsNotNull(ticket.isChecked)) {
          if (ticket.isChecked!) {
            aggIds.add(ticket.aggId!);
          }
        }
      }
      if (aggIds.length == 0) {
        return;
      }
      this.isFirstEnter = true;
      setState(() {});
      // final response = await _collectionService.addPlannedDate(
      //     aggIds, _currentTime.millisecondsSinceEpoch);
      final response = await _collectionService.addPlannedDate(
          aggIds, _currentTime?.toIso8601String() ?? '');
      if (Utils.checkRequestIsComplete(response)) {
        var responseData = response.data;
        if (Utils.checkIsNotNull(responseData)) {
          if (responseData['status'] == 0) {
            resetList();
            WidgetCommon.showSnackbar(_scaffoldKey,
                'Hợp đồng đã đã được thêm vào Lịch làm việc thành công',
                backgroundColor: AppColor.primary);
            eventBus.fire(ReloadPlannedHomeScreen('true'));
            return;
          }
        }
      }
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).insertFailed);
    } catch (e) {
      this.isFirstEnter = false;
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).insertFailed);
    } finally {
      setState(() {
        this.isFirstEnter = false;
      });
    }
  }

  Future<void> openConfirmCheckBox(BuildContext context, String type) async {
    if (type == 'A') {
      openCalendar(isNextAction: true);
    } else if (type == 'C') {
      WidgetCommon.generateDialogOKCancelGet('Bạn muốn hủy thao tác',
          callbackOK: () async => {resetList()},
          callbackCancel: () async => {});
    }
  }

  void resetList() {
    openCheckBox = false;
    _currentTime = null;
    records = 0;
    isCheckAll = true;
    setState(() {});
    for (TicketModel ticketModel in this._collectionProvider.getLstTicket) {
      ticketModel.isChecked = false;
    }
  }

  Widget buildBodyView() {
    if (isFirstEnter) {
      return ShimmerCheckIn(
        height: 60.0,
        countLoop: 8,
      );
    }
    if (_collectionProvider.getLstTicket.length == 0) {
      return NoDataWidget();
    }
    return Stack(
      children: [
        SmartRefresher(
          enablePullDown: true,
          enablePullUp: _enablePullUp,
          footer: CustomFooter(
            builder: (context, status) {
              Widget body;
              if (status == LoadStatus.idle) {
                body = Text("pull up load");
              } else if (status == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (status == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (status == LoadStatus.canLoading) {
                body = Text("release to load more");
              } else {
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(), // new
            itemBuilder: (c, i) => buildItemListView(i),
            itemCount: _collectionProvider.getLstTicket.length,
          ),
        ),
        buildLoadingRecordLocation()
      ],
    );
  }

  Widget buildLoadingRecordLocation() {
    return isLoadingRecordTLLocation
        ? Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: new BorderRadius.circular(10.0)),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        S.of(context).loading,
                        style: new TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  openCalendar({bool isNextAction = false}) {
    DatePicker.showDatePicker(context,
        showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
      _currentTime = date;
      WidgetCommon.generateDialogOKCancelGet(
          'Bạn muốn thêm những hợp đồng này vào chức năng Kế hoạch?',
          callbackOK: () async => {await addItemToList()},
          callbackCancel: () {});
    }, minTime: _now, currentTime: _currentTime, locale: LocaleType.vi);
  }

  actionCheckAllRecordCalendar() {
    if (isCheckAll) {
      for (TicketModel ticketModel in this._collectionProvider.getLstTicket) {
        ticketModel.isChecked = true;
      }
      records = this._collectionProvider.getLstTicket.length;
    } else {
      for (TicketModel ticketModel in this._collectionProvider.getLstTicket) {
        ticketModel.isChecked = false;
      }
      records = 0;
    }
    isCheckAll = !isCheckAll;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _filterCollection.clearData();
    _collectionProvider.clearData();
    // _hiearchyProvider.clearData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
