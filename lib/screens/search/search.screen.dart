import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/circle_button_widget.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/employee/employee.model.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/search/search.offline.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/collections/collection/widget/leadingTitle.widget.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/filter/collections/filter-collections.provider.dart';
import 'package:athena/screens/search/search.provider.dart';
import 'package:athena/screens/search/search.service.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/services/customer/customer.service.dart';
import 'package:athena/utils/services/employee/employee.provider.dart';
import 'package:athena/utils/services/employee/employee.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:get/get.dart' as GETX;
import 'dart:async';
import 'package:athena/utils/services/debouncer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _collectionService = new CollectionService();
  final _searchService = new SearchService();
  final _customerService = new CustomerService();
  final _searchProvider = getIt<SearchProvider>();
  final _employeeProvider = getIt<EmployeeProvider>();
  final _employeeService = new EmployeeService();
  final _mapService = new VietMapService();
  final _filterCollection = getIt<FilterCollectionsProvider>();
  TextEditingController _searchQueryController = new TextEditingController();
  bool _isSearching = false;
  bool _enablePullUp = true;
  bool isFirstEnter = true;
  bool openCheckBox = false;
  int records = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'CollectionScreen');
  DateTime? _currentTime;
  DateTime _now = DateTime.now();
  String title = '';
  ScrollController _scrollController = new ScrollController();

  // bool isDebounce = true;
  String lastKeywordSearch = '';
  final _debouncer = Debouncer(delay: Duration(milliseconds: 2000));
  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && (_scrollController.hasClients)) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    _searchProvider.clearData();
    _searchQueryController.removeListener(onSearchChanged);
    _searchQueryController.dispose();
    // Bỏ dispose refreshController
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 100));
    if (!mounted) return;
    fetchData();
    if (mounted) {
      setState(() {
        _refreshController.refreshCompleted();
      });
    }
  }

  void _onLoading() async {
    if (!mounted) return;
    await Future.delayed(Duration(seconds: 2));
    fetchData();
    if (mounted) {
      setState(() {
        _refreshController.loadComplete();
      });
    }
  }

  Widget _buildSearchField() {
    return new TextField(
        controller: _searchQueryController,
        textInputAction: TextInputAction.search,
        autofocus: false,
        style: TextStyle(color: AppColor.white),
        cursorColor: Colors.black54,
        decoration: InputDecoration(
            filled: true,
        fillColor: Colors.transparent, 
          hintText: "Tìm kiếm theo tên, email, số điện thoại hoặc địa chỉ",
          hintStyle: const TextStyle(color: Colors.white60),
          border: InputBorder.none,
          suffixIcon: _searchQueryController.text.isNotEmpty
              ? CircleIconButton(
                  size: 24,
                  onPressed: () {
                    setState(() {
                      _searchQueryController.clear();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                        }
                      });
                    });
                  },
                )
              : null,
        ),
        onSubmitted: updateSearchQuery,
      );
    
  }

  Future<void> updateSearchQuery(String newQuery,
      {bool hideKeyBoard = true}) async {
    if (hideKeyBoard) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
    if (Utils.checkIsNotNull(newQuery) || _isSearching) {
      if (_searchProvider.keyword == newQuery) {
        return;
      }
    }

    _searchProvider.setKeyword = newQuery;
    _searchProvider.currentPage = 1;
    setState(() {
      _searchProvider.lstTicket = [];
      _isSearching = true;
      _enablePullUp = true;
      if (isFirstEnter) {
        isFirstEnter = false;
      }
    });

    if (mounted) {
      setState(() {
        fetchData();
        _refreshController.loadComplete(); // Đánh dấu load xong
      });
    }
  }

  Future<void> fetchData() async {
    try {
      // Response? response;
      // response = await this._searchService.getPagingListPermission(
      //     _searchProvider.getCurrentPage,
      //     _searchProvider.getKeyword,
      //     this._filterCollection.employeeHierachyModel?.empCode ?? '');
        Response? response;
      if (this._filterCollection?.employeeHierachyModel != null) {
        response = await this._searchService.getPagingListPermission(
            _searchProvider.getCurrentPage,
            _searchProvider.getKeyword,
            this._filterCollection?.employeeHierachyModel?.empCode??'');
      } else {
        response = await this._searchService.getPagingList(
            _searchProvider.getCurrentPage,
            _searchProvider.getKeyword,
            _searchProvider.getFilter);
      }
          if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData2Level(response);
        if (lstData.length < APP_CONFIG.LIMIT_QUERY) {
          _enablePullUp = false;
        } else {
          _searchProvider.setCurrentPage = _searchProvider.getCurrentPage + 1;
        }

        if (_searchProvider.getLstTicket.isEmpty) {
          for (var data in lstData) {
            _employeeProvider
                .checkAddEmployee(new EmployeeModel(empCode: data['assignee']));
            _searchProvider.getLstTicket.add(TicketModel.fromJson(data));
          }
        } else {
          var data;
          for (int index = 0; index < lstData.length; index++) {
            data = lstData[index];
            _employeeProvider
                .checkAddEmployee(new EmployeeModel(empCode: data['assignee']));
            if (index == 0) {
              if (data['aggId'] ==
                  _searchProvider
                      .getLstTicket[_searchProvider.getLstTicket.length - 1]
                      .aggId) {
                continue;
              }
            }
            _searchProvider.getLstTicket.add(TicketModel.fromJson(data));
          }
        }

        String empCodes = _employeeProvider.handleRequestEmployee();
        if (empCodes.length > 0) {
          final Response empRes = await _employeeService.getEmployees(empCodes);
          if (Utils.checkRequestIsComplete(empRes)) {
            _employeeProvider.addEmployeesTemp(empRes.data['data']);
          }
        }

        for (TicketModel ticket in _searchProvider.getLstTicket) {
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
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        if (_isSearching) {
          _isSearching = false;
        }
      });
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget buildItemListView(int i) {
    TicketModel ticket = _searchProvider.getLstTicket[i];
    return Card(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          InkWell(
            onTap: () {
              if (openCheckBox) {
                ticket.isChecked = !ticket.isChecked!;
                addPlannedText(ticket);
                setState(() {});
                return;
              }
              _searchService.onSaveSearchKeyword(ticket.fullName ?? '');

              Utils.pushName(context, RouteList.COLLECTION_DETAIL_SCREEN,
                  params: _searchProvider.getLstTicket[i]);
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
                      value: ticket.isChecked,
                      onChanged: (bool? newValue) {
                        ticket.isChecked = !ticket.isChecked!;
                        addPlannedText(ticket);
                        setState(() {});
                      },
                    )
                  : CircleAvatar(
                      child: Text(
                           (_searchProvider.getLstTicket[i].issueName?.isNotEmpty ?? false)
                          ? _searchProvider.getLstTicket[i].issueName![0]
                          : '',
                          // _searchProvider.getLstTicket[i].issueName[0],
                          style: TextStyle(color: AppColor.white)),
                      backgroundColor:
                          _collectionService.isRecordItem(context, ticket)),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchProvider.getLstTicket[i].issueName!,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  this
                      ._collectionService
                      .buildLateCall(_searchProvider.getLstTicket[i]),
                ],
              ),
              subtitle: LeadingTitle(detail: _searchProvider.getLstTicket[i]),
            ),
          ),
        ]));
  }

  handleSmsCallLog(action, ticketModel, type) async {}
  addPlannedText(TicketModel ticketModel) {
    if (!ticketModel.isChecked!) {
      records -= 1;
    } else {
      records += 1;
    }
    if (records < 0) {
      records = 0;
    }
  }

  buildActionSheet(TicketModel item) async {
    if (item.customerData == null) {
      // final Response resCustomer =
      //     await _customerService.getContactByAggId(item.customerId);
      final Response resCustomer =
          await _customerService.getContactByAggId(item.aggId ?? '');
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
          icon: Icons.email,
          label: S.of(context).email,
          key: ActionPhone.EMAIL,
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
      var action = _collectionService.actionPhone(item, result ?? '', context);
      handleSmsCallLog(action, item, result);
    } else {
      if (!Utils.checkIsNotNull(item.cusFullAddress) ||
          item.cusFullAddress == 'null') {
        return WidgetCommon.generateDialogOKGet(
            content: 'Không tìm thấy địa chỉ.');
      }
      _mapService.openMapNative(item.cusFullAddress ?? '', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();
    return Scaffold(
      appBar: buildAppBar(),
      key: _scaffoldKey,
      body: Container(
        height: AppState.getHeightDevice(context),
        width: AppState.getWidthDevice(context),
        child: buildBodyView(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
        title: openCheckBox ? buildTitle(context) : _buildSearchField(),
        actions: <Widget>[
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
        ]);
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
    setState(() {});
    for (TicketModel ticketModel in this._searchProvider.getLstTicket) {
      ticketModel.isChecked = false;
    }
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

  Future<void> addItemToList() async {
    try {
      List<String> aggIds = [];
      for (TicketModel ticket in this._searchProvider.getLstTicket) {
        if (Utils.checkIsNotNull(ticket.isChecked)) {
          if (ticket.isChecked!) {
            aggIds.add(ticket.aggId ??'');
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
          aggIds, _currentTime?.toIso8601String() ??'' );
      if (Utils.checkRequestIsComplete(response)) {
        var responseData = response.data;
        if (Utils.checkIsNotNull(responseData)) {
          if (responseData['status'] == 0) {
            WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).insertFailed);
            resetList();
            WidgetCommon.showSnackbar(_scaffoldKey,
                'Hợp đồng đã đã được thêm vào Lịch làm việc thành công',
                backgroundColor: AppColor.primary);
            eventBus.fire(ReloadPlannedHomeScreen('true'));
            return;
          }
        }
      } else {
        this.isFirstEnter = false;
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).insertFailed);
        return;
      }
    } catch (e) {
      this.isFirstEnter = false;
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).insertFailed);
    } finally {
      setState(() {
        this.isFirstEnter = false;
      });
    }
  }

  Widget buildTitle(BuildContext context) {
    if (openCheckBox) {
      return Text(records.toString() + ' dòng');
    }
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: (title.isEmpty)
          ? Text(S.of(context).collections +
              ' (' +
              _searchProvider.totalLength.toString() +
              ')')
          : new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(S.of(context).collections +
                    ' (' +
                    _searchProvider.totalLength.toString() +
                    ')'),
                Text(title,
                    style: TextStyle(fontSize: 12.0),
                    overflow: TextOverflow.ellipsis)
              ],
            ),
    );
  }

  Future<void> handleSpeech() async {
   
  }

  Future<void> searchSpeechToText(String result) async {
    printLog("============= $result");

    if (result.isNotEmpty) {
      await PermissionAppService.stopSpeech();
      GETX.Get.back();
      _searchQueryController.text = result;
      await updateSearchQuery(result);
    }
  }

  Future<void> errorSpeech(String result) async {
   
  }

  Future<void> onSearchChanged() async {
    // String text = _searchQueryController.text.toString();
    // if (text.length <= 2) {
    //   return;
    // }
    _debouncer(() async {
      String text = _searchQueryController.text.toString();
      if (text.length <= 2) {
        return;
      }
      if (lastKeywordSearch != text) {
        lastKeywordSearch = text;
        await updateSearchQuery(text, hideKeyBoard: false);
      }
      // if (isDebounce) {
      //   await updateSearchQuery(text);
      //   isDebounce = false;
      // } else {
      //   isDebounce = true;
      // }
    });
  }

  Widget buildBodyView() {
    try {
      if (isFirstEnter) {
        return Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Column(children: [
                  Text(
                    'Vui lòng nhập nội dung cần tìm kiếm.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Tìm kiếm theo tên, email, số điện thoại hoặc địa chỉ',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ])),
            SizedBox(
              height: 10,
            ),
            Flexible(child: buildListSearchRecent())
          ],
        );
      }
      if (_isSearching) {
        return ShimmerCheckIn(
          height: 60.0,
          countLoop: 8,
        );
      }
      if (_searchProvider.getLstTicket.length == 0 &&
          (_searchQueryController.text.isNotEmpty ?? false)) {
        return NoDataWidget();
      }
      if (_searchQueryController.text.isEmpty ?? false) {
        return buildListSearchRecent();
      }
      return SmartRefresher(
        enablePullDown: false,
        enablePullUp: _enablePullUp,
        footer: CustomFooter(
          builder: ( context, status) {
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
        onLoading: () {
          if (mounted) {
            _onLoading();
          }
        },
        child: ListView.builder(
          itemBuilder: (c, i) => buildItemListView(i),
          itemCount: _searchProvider.getLstTicket.length ?? 0,
        ),
      );
    } catch (e) {
      return Container();
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget buildListSearchRecent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.search),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  'Lịch sử tìm kiếm gần đây',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ValueListenableBuilder(
                valueListenable:
                    Hive.box<SearchOfflineModel>(HiveDBConstant.SEARCH_SCREEN)
                        .listenable(),
                builder: (contex, Box<SearchOfflineModel> box, b) {
                  return Visibility(
                    visible: (box.length ?? 0) > 0,
                    child: InkWell(
                      onTap: () => _searchService.clearSearchHistory(),
                      child: Text(
                        'Xóa tất cả',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColor.appBar,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Flexible(
          child: ValueListenableBuilder(
            valueListenable:
                Hive.box<SearchOfflineModel>(HiveDBConstant.SEARCH_SCREEN)
                    .listenable(),
            builder:
                (BuildContext context, Box<SearchOfflineModel> box, widget) {
              if (box.values.isEmpty)
                return Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      color: Colors.grey[350]?.withOpacity(.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Lịch sử tìm kiếm trống',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );

              return ListView.separated(
                  reverse: true,
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    SearchOfflineModel item = box.getAt(index)!;

                    return ListTile(
                        leading: Icon(Icons.restore),
                        title: Text('${item.keyword}'),
                        onTap: () {
                          setState(() {
                            _searchQueryController.text = item.keyword!;
                          });
                        },
                        trailing: InkWell(
                          onTap: () =>
                              _searchService.removeSearchRecentIndex(index),
                          child: Icon(Icons.clear, size: 22),
                        ));
                  },
                  separatorBuilder: (context, index) => SizedBox(),
                  itemCount: box.length ?? 0);
            },
          ),
        )
      ],
    );
  }
}
