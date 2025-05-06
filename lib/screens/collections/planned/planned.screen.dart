import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:athena/screens/vietmap/vietmap.provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/employee/employee.model.dart';
import 'package:athena/models/generate_job_response.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/calendar/canlendar.service.dart';
import 'package:athena/screens/collections/collection/widget/leadingTitle.widget.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/login/login.service.dart';
import 'package:athena/screens/recovery/constant.recovery.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/services/customer/customer.service.dart';
import 'package:athena/utils/services/employee/employee.provider.dart';
import 'package:athena/utils/services/employee/employee.service.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../../getit.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/collections/collection/collections.provider.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:athena/widgets/common/common.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../download_list/services/download_list_services.dart';

class PlannedScreen extends StatefulWidget {
  PlannedScreen({Key? key}) : super(key: key);
  @override
  _PlannedScreenState createState() => _PlannedScreenState();
}

class _PlannedScreenState extends State<PlannedScreen>
    with TickerProviderStateMixin, AfterLayoutMixin {
  final calendarService = new CalendarService();
  final scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'planned');
  final _collectionProvider = getIt<CollectionProvider>();
  final _collecitonService = new CollectionService();
  final _employeeService = new EmployeeService();
  final _employeeProvider = getIt<EmployeeProvider>();
  final scrollDirection = Axis.vertical;
  final _customerService = new CustomerService();
  final _mapProvider = getIt<VietMapProvider>();
  final _collectionService = new CollectionService();
  final _homeProvider = getIt<HomeProvider>();
  SaveFileService _saveFileService = new SaveFileService();
  bool openCheckBox = false;
  int records = 0;
  bool isCheckAll = true;

  AutoScrollController? controller;
  Map<DateTime, List> eventsCalendar = {};
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  DateTime? selectedDate;
  bool isFirstEnter = true;
  bool _enablePullUp = true;

  //
  DateTime _focusedDay = DateTime.now();
  DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 6, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 6, DateTime.now().day);

  CalendarFormat _calendarFormat = CalendarFormat.week;

  void _onRefresh() async {
    try {
      _collectionProvider.currentPage = 1;
      _collectionProvider.lstTicket = [];
      _collectionProvider.totalLength = 0;
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
      final Response response = await this
          ._collecitonService
          .getPagingPlannedDate(_collectionProvider.getCurrentPage,
              date: selectedDate);

      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData2Level(response);
        if (Utils.checkIsNotNull(lstData)) {
          if (lstData.length < APP_CONFIG.LIMIT_QUERY) {
            _enablePullUp = false;
          } else {
            _collectionProvider.setCurrentPage =
                _collectionProvider.getCurrentPage + 1;
          }
          for (var data in lstData) {
            _employeeProvider
                .checkAddEmployee(new EmployeeModel(empCode: data['assignee']));
            _collectionProvider.getLstTicket.add(TicketModel.fromJson(data));
          }
          String empCodes = _employeeProvider.handleRequestEmployee();
          if (empCodes.length > 0) {
            final Response empRes =
                await _employeeService.getEmployees(empCodes);
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
        }
      }
    } catch (e) {
    } finally {
      setState(() {
        if (isFirstEnter) {
          isFirstEnter = false;
        }
      });
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

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    _collectionProvider.clearData();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    _collectionProvider.clearData();
  }

  Future<void> _onDaySelected(DateTime day, DateTime focusedDay) async {
    selectedDate = day;
    this._collectionProvider.currentPage = 1;
    this._collectionProvider.totalLength = 0;
    this._collectionProvider.lstTicket = [];
    this.isFirstEnter = true;
    _focusedDay = focusedDay;
    setState(() {});
    await handleFetchData();
  }

  Widget _buildTableCalendar(BuildContext context) {
    return TableCalendar(
      firstDay: kFirstDay,
      lastDay: kLastDay,
      locale: 'vi_VN',
      focusedDay: _focusedDay,
      // events: eventsCalendar,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {
        CalendarFormat.month: '1/2 Tháng',
        CalendarFormat.week: 'Tháng',
        CalendarFormat.twoWeeks: 'Tuần',
      },
      calendarFormat: _calendarFormat,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor, shape: BoxShape.circle),
        todayDecoration: BoxDecoration(
            color: Colors.deepOrange[200], shape: BoxShape.circle),
        markerDecoration: BoxDecoration(
            color: Colors.deepOrange[200], shape: BoxShape.circle),
        outsideDaysVisible: false,
      ),
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(selectedDate, day);
      },
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle()
            .copyWith(color: Color.fromARGB(255, 23, 18, 18), fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) async {
        if (openCheckBox) {
          await openConfirmCheckBox(context,
              callBack: () => _onDaySelected(selectedDay, focusedDay));
        } else {
          _onDaySelected(selectedDay, focusedDay);
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
    );
  }

  String buildTitleTextBuiler(DateTime date, var locale, BuildContext context) {
    return (S.of(context).month) +
        " " +
        date.month.toString() +
        " " +
        S.of(context).year +
        " " +
        date.year.toString();
  }

  Widget _buildEventList() {
    if (_collectionProvider.getLstTicket.length == 0) {
      return NoDataWidget();
    }
    return SmartRefresher(
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
        scrollDirection: scrollDirection,
        controller: controller,
        shrinkWrap: true,
        itemBuilder: (c, i) => buildItemListView(i),
        itemCount: _collectionProvider.getLstTicket.length,
      ),
    );
  }

  Widget buildItemListView(int i) {
    TicketModel detail = _collectionProvider.getLstTicket[i];
    return Column(children: [
      Card(
          child: Column(children: [
        InkWell(
          onTap: () {
            if (openCheckBox) {
              detail.isChecked = !(detail.isChecked ?? false);
              addToDownload(detail);
              setState(() {});
              return;
            }
            Utils.submitLocation(action: 'view-details-contract');
            Utils.pushName(context, RouteList.COLLECTION_DETAIL_SCREEN,
                params: _collectionProvider.getLstTicket[i]);
          },
          onLongPress: () {
            if (_checkToday(selectedDate!) ?? false) {
              setState(() {
                openCheckBox = !openCheckBox;
              });
            }
          },
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0), // Fix 5: Add const
            leading: openCheckBox
                ? Checkbox(
                    // Fix 6: Handle null value in isChecked
                    value: detail.isChecked ?? false,
                    onChanged: (bool? newValue) {
                      // Fix 7: Make newValue nullable
                      // Fix 8: Use null-safe assignment
                      detail.isChecked = !(detail.isChecked ?? false);
                      addToDownload(detail);
                      setState(() {});
                    },
                  )
                : CircleAvatar(
                    // Fix 9: Safe access to issueName with null check
                    child: Text(
                        (detail.issueName?.isNotEmpty ?? false)
                            ? detail.issueName![0]
                            : '',
                        style: const TextStyle(
                            color: AppColor.white)), // Fix 10: Add const
                    backgroundColor: _collecitonService.isRecordNew(
                        // Fix 11: Handle potential null in date conversions
                        Utils.converLongToDate(
                            Utils.convertTimeStampToDateEnhance(
                                    detail.createDate ?? '') ??
                                0),
                        Utils.converLongToDate(
                            Utils.convertTimeStampToDateEnhance(
                                    detail.assignedDate ?? '') ??
                                0),
                        context,
                        detail),
                  ),
            // title: Text(
            //   _collectionProvider.getLstTicket[i].issueName,
            //   style: TextStyle(fontWeight: FontWeight.w500),
            // ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _collectionProvider.getLstTicket[i].issueName!,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    this
                        ._collectionService
                        .buildLateCall(_collectionProvider.getLstTicket[i]),
                    SizedBox(
                      width: 7,
                    ),
                    Visibility(
                      visible: openCheckBox == false,
                      child: InkWell(
                        onTap: () => _onTapShareFile(
                            _collectionProvider.getLstTicket[i]),
                        child: Icon(
                          Icons.ios_share,
                          size: 26,
                          color: AppColor.appBar.withOpacity(0.8),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            subtitle: LeadingTitle(detail: _collectionProvider.getLstTicket[i]),
            // trailing: IconButton(
            //     onPressed: () async =>
            //         {buildActionSheet(_collectionProvider.getLstTicket[i])},
            //     icon: Icon(Icons.expand_more,
            //         color: Theme.of(context).primaryColor))
          ),
        ),
      ]))
    ]);
  }

  Future<bool> _checkTimeSystime(TicketModel data) async {
    try {
      Response response = await LoginService().getTimeSys();
      if (response.data != null) {
        var dateTimeSystemInt = response.data['data'];
        if (Utils.checkIsNotNull(dateTimeSystemInt)) {
          DateTime? dateTimeSystem = Utils.converLongToDate(
              Utils.convertTimeStampToDateEnhance(dateTimeSystemInt ?? '') ??
                  0);
          String? stringDateSys = Utils.getTimeFromDate(
              Utils.convertTimeStampToDateEnhance(dateTimeSystemInt));
          var minutes =
              Utils.diffInDaysGetMinues(DateTime.now(), dateTimeSystem);
          if (minutes > 2 || minutes < -2) {
            WidgetCommon.generateDialogOK(
              context,
              title: 'Thời gian trên thiết bị không hợp lệ!',
              content: 'Thời gian hệ thống: ' + '\n' + stringDateSys.toString(),
            );
            return false;
          }

          int timeStart;
          int timeEnd;

          try {
            timeStart = _homeProvider.timeVisitForm![0];
            timeEnd = _homeProvider.timeVisitForm![1];
          } catch (_) {
            timeStart = 8;
            timeEnd = 21;
          }

          if (dateTimeSystem.hour < timeStart ||
              dateTimeSystem.hour >= timeEnd) {
            WidgetCommon.generateDialogOK(
              context,
              title: 'Thông báo',
              content:
                  'Visit form chỉ được tải từ 0$timeStart:00 đến $timeEnd:00 hàng ngày',
            );
            return false;
          }
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _checkTimeSystimeDownloadList() async {
    try {
      Response response = await LoginService().getTimeSys();
      if (response.data != null) {
        var dateTimeSystemInt = response.data['data'];
        if (Utils.checkIsNotNull(dateTimeSystemInt)) {
          DateTime? dateTimeSystem = Utils.converLongToDate(
              Utils.convertTimeStampToDateEnhance(dateTimeSystemInt ?? '') ??
                  0);
          String? stringDateSys = Utils.getTimeFromDate(
              Utils.convertTimeStampToDateEnhance(dateTimeSystemInt));
          var minutes =
              Utils.diffInDaysGetMinues(DateTime.now(), dateTimeSystem);
          if (minutes > 2 || minutes < -2) {
            WidgetCommon.generateDialogOK(
              context,
              title: 'Thời gian trên thiết bị không hợp lệ!',
              content: 'Thời gian hệ thống: ' + '\n' + stringDateSys.toString(),
            );
            return false;
          }

          int timeStart;
          int timeEnd;

          try {
            timeStart = _homeProvider.timeVisitForm![0];
            timeEnd = _homeProvider.timeVisitForm![1];
          } catch (_) {
            timeStart = 8;
            timeEnd = 21;
          }

          if (dateTimeSystem.hour < timeStart ||
              dateTimeSystem.hour >= timeEnd) {
            WidgetCommon.generateDialogOK(
              context,
              title: 'Thông báo',
              content:
                  'Visit form chỉ được tải từ 0$timeStart:00 đến $timeEnd:00 hàng ngày',
            );
            return false;
          }
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void onDownload(path, fileName) async {
    WidgetCommon.showLoading(dismissOnTap: false);

    try {
      final status =
          await DownloadListServices.downloadCheckinItemPath(path, fileName);

      if (status['status'] == DownloadStatus.successed) {
        WidgetCommon.dismissLoading();
        await WidgetCommon.generateDialogOKCancelGet("Bạn muốn mở file?",
            callbackOK: () {
          try {
            OpenFilex.open(status['filePathAndName']);
          } catch (e) {
            WidgetCommon.showSnackbarErrorGet('Mở file thất bại!');
          }
        }, callbackCancel: () {});
        WidgetCommon.showSnackbar(
          _scaffoldKey,
          'Tải về thành công, Vui lòng kiểm tra trong thư mục ' +
              (Platform.isAndroid ? '/Download/Athena/' : 'downloads'),
          backgroundColor: AppColor.appBar,
        );
      }
      if (status['status'] == DownloadStatus.saveFileFailed) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(
            _scaffoldKey, 'Đã có lỗi xảy ra trong quá trình lưu file!');
      }
      if (status == DownloadStatus.callFailed) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(
            _scaffoldKey, 'Đã có lỗi xảy ra, vui lòng liên hệ phòng IT!');
      }
      if (status['status'] == DownloadStatus.noPerrmission) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(_scaffoldKey,
            'Vui lòng cung cấp quyền lưu trữ để thực hiện tính năng này');
      }
    } catch (_) {
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(
          _scaffoldKey, 'Đã có lỗi xảy ra, vui lòng liên hệ phòng IT!');
    }
  }

  void _onTapShareFile(TicketModel data) async {
    WidgetCommon.showLoading(dismissOnTap: false);
    final timeCorect = await _checkTimeSystime(data);
    if (!timeCorect) {
      WidgetCommon.dismissLoading();
      return;
    }
    String templateCode = '';
    if (data.feType == ActionPhone.LOAN) {
      templateCode = "LOAN_VF";
    } else if (data.feType == ActionPhone.CARD ||
        data.feType == ActionPhone.CRC) {
      templateCode = "CARD_VF";
    }
    try {
      var params = {
        "type": "VF",
        "params": [
          {
            "templateCode": templateCode,
            "params": {
              "customerId": data.customerId,
              "contractId": data.contractId
            }
          }
        ]
      };
      final response = await _saveFileService.postTequestDownLoadFile(
          IcollectConst.generateReportVisitForm, params);
      final generateJobResponse =
          GenerateJobResponse.fromJson(jsonDecode(response?.body ??''));
      if (generateJobResponse.status == 0) {
        await Future.delayed(Duration(seconds: 5));

        final filterModel = {
          "jobExecutionId": {
            "type": "equals",
            "filter": generateJobResponse.data?.jobExecutionId,
            // "filter": "mcrisgdbrp#f7f54e60-1647-4c11-b678-9b2b1db93cb5",
            "filterType": "text"
          }
        };
        var dataZip = await DownloadListServices()
            .getContactDocs(0, rowLength: 1, filterModel: filterModel);
        if (Utils.checkIsNotNull(dataZip?.data?.checkinItems) &&
            Utils.isArray(dataZip?.data?.checkinItems)) {
          final checkInItem = dataZip?.data?.checkinItems![0];
          if (Utils.checkIsNotNull(checkInItem?.jobContext?.filePath)) {
            // dowblload file
            onDownload(checkInItem?.jobContext?.filePath, checkInItem?.jobName);
          }
          // if (dataZip == null) {
          //   WidgetCommon.dismissLoading();

          //   WidgetCommon.generateDialogOKGet(
          //       content:
          //           'Quá trình xuất file đang được hệ thống xử lý. Vui lòng kiểm tra trạng thái file ${generateJobResponse?.data?.fileName} tại mục (Cấu Hình -> Danh sách tải về)',
          //       textBtnClose: 'Đã hiểu', callback: () {
          //     Utils.navigateToReplacement(
          //         context, RouteList.DOWNLOAD_LIST_SCREEN);
          //   });
          //   return;
          // }
          // }
          // if (Utils.checkIsNotNull(dataZip)) {
          //   String fileName = generateJobResponse?.data?.fileName ?? 'unknow.zip';
          //   if (dataZip != null && dataZip.bodyBytes != null) {
          //     final status = await SaveFileService().handleDownloadCheckin(
          //         Platform.isAndroid ? 'Athena Owl' : 'visitforms',
          //         fileName,
          //         dataZip?.bodyBytes,
          //         isStored: true);
          //     if (status == DownloadStatus.successed) {
          //       WidgetCommon.dismissLoading();

          //       return WidgetCommon.showSnackbar(
          //         _scaffoldKey,
          //         'Tải về thành công, Vui lòng Kiểm tra trong thư mục ' +
          //             (Platform.isAndroid ? '/Download/iCollect' : 'visitForms') +
          //             '$fileName',
          //         backgroundColor: AppColor.appBar,
          //       );
          //     }
          //     if (status == DownloadStatus.saveFileFailed) {
          //       WidgetCommon.dismissLoading();

          //       return WidgetCommon.showSnackbar(
          //           _scaffoldKey, 'Đã có lỗi xảy ra trong quá trình lưu file!');
          //     }

          //     if (status == DownloadStatus.noPerrmission) {
          //       WidgetCommon.dismissLoading();

          //       return WidgetCommon.showSnackbar(_scaffoldKey,
          //           'Vui lòng cung cấp quyền lưu trữ để thực hiện tính năng này');
          //     }
        }
      }
      // }

      WidgetCommon.dismissLoading();
      // WidgetCommon.showSnackbar(_scaffoldKey,
      //     'Dữ liệu bị lỗi, vui lòng liên hệ nhóm hỗ trợ hệ thống!');
    } catch (_) {
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(_scaffoldKey,
          'Dữ liệu bị lỗi, vui lòng liên hệ nhóm hỗ trợ hệ thống!');
    }
  }

  Future<void> downloadCheckedList() async {
    WidgetCommon.showLoading(dismissOnTap: false);
    final timeCorect = await _checkTimeSystimeDownloadList();
    if (!timeCorect) {
      WidgetCommon.dismissLoading();
      // return;
    }

    try {
      if (_collectionProvider.getLstTicket.isNotEmpty ?? false) {
        List<Map<String, dynamic>> checkedList = _collectionProvider
            .getLstTicket
            .where((element) => element.isChecked ?? false)
            .map((e) {
          String templateCode = '';
          // if (e?.feType == ActionPhone.LOAN) {
          //   templateCode = "L_VF_01";
          // } else if (e?.feType == ActionPhone.CARD) {
          //   templateCode = "C_VF_01";
          // }
          if (e.feType == ActionPhone.LOAN) {
            templateCode = "LOAN_VF";
          } else if (e.feType == ActionPhone.CARD ||
              e.feType == ActionPhone.CRC) {
            templateCode = "CARD_VF";
          }
          return {
            "templateCode": templateCode,
            "params": {"customerId": e.customerId, "contractId": e.contractId}
          };
        }).toList();

        if ((checkedList.length ?? 0) > 10) {
          WidgetCommon.dismissLoading();

          return WidgetCommon.generateDialogOK(
            context,
            title: 'Thông báo',
            content:
                'Visitforms bị giới hạn chỉ được phép tải không quá 10 hợp đồng, Vui lòng điều chỉnh danh sách tải về!',
          );
        }
        var params = {"type": "VF", "params": checkedList};

        final response = await _saveFileService.postTequestDownLoadFile(
            IcollectConst.generateReportVisitFormList, params);
        final generateJobResponse = jsonDecode(response?.body ??'');

        if (generateJobResponse['status'] == 0 &&
            generateJobResponse['data'] != null) {
          WidgetCommon.dismissLoading();

          WidgetCommon.generateDialogOKGet(
              content:
                  'Quá trình xuất file đang được hệ thống xử lý. Vui lòng kiểm tra trạng thái file tại mục (Cấu Hình -> Danh sách tải về)',
              textBtnClose: 'Đã hiểu',
              callback: () {
                Utils.navigateToReplacement(
                    context, RouteList.DOWNLOAD_LIST_SCREEN);
              });
          return;
        }

        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(_scaffoldKey,
            'Dữ liệu bị lỗi, vui lòng liên hệ nhóm hỗ trợ hệ thống!');
      }
    } catch (_) {
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(_scaffoldKey,
          'Dữ liệu bị lỗi, vui lòng liên hệ nhóm hỗ trợ hệ thống!');
    }
  }

  buildActionSheet(TicketModel item) async {
    if (item.customerData == null) {
      // final Response resCustomer =
      //     await _customerService.getContactByAggId(item.customerId);
      final Response resCustomer =
          await _customerService.getContactByAggId(item?.aggId ?? '');
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
      var action = _collecitonService.actionPhone(item, result!, context);
      handleSmsCallLog(action, item, result);
    } else {
      _collecitonService.actionPhone(item, result!, context);
    }
  }

  handleSmsCallLog(action, ticketModel, type) async {}

  bool isClickGotoMap = false;

  Future<void> gotoMapPage(BuildContext context) async {
    try {
      if (isClickGotoMap) {
        return;
      }
      WidgetCommon.showLoading(status: 'Đang lấy thông tin vị trí');
      bool permission =
          await PermissionAppService.checkServiceEnabledLocation();
      if (permission) {
        isClickGotoMap = true;
        Position? position = await PermissionAppService.getCurrentPosition();
        if (position == null) {
          WidgetCommon.dismissLoading();
          return;
        }
        if (position.latitude == 0 && position.longitude == 0) {
          WidgetCommon.dismissLoading();
          return;
        }
        _mapProvider.setCenterPosition(
            new LatLng(position.latitude, position.longitude));
        isClickGotoMap = false;
        WidgetCommon.dismissLoading();
        this._mapProvider.typeSearch = MapConstant.PLANNED;
        // Utils.pushName(null, RouteList.MAP_SCREEN, params: selectedDate);
        if (APP_CONFIG.enableVietMap) {
          Utils.pushName(context, RouteList.VIETMAP_SCREEN,
              params: selectedDate);
        } else {}
        // Utils.pushName(null, RouteList.MAP_SCREEN, params: selectedDate);
        return;
      }
      WidgetCommon.dismissLoading();
    } catch (e) {
      isClickGotoMap = false;
      WidgetCommon.dismissLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
        title: _buildTitle(),
        actions: [
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
            visible: (_checkToday(selectedDate) ?? false) &&
                openCheckBox &&
                (_collectionProvider.checkedIsNotEmpty() ?? false),
            child: IconButton(
              icon: Icon(Icons.ios_share),
              onPressed: () async {
                await downloadCheckedList();
                resetList();
                setState(() {
                  openCheckBox = false;
                });
              },
            ),
          ),
          Visibility(
            child: IconButton(
              icon: Icon(Icons.map),
              onPressed: () async {
                if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                  await this.gotoMapPage(context);
                }
              },
            ),
            visible: !openCheckBox,
          ),
          Visibility(
            child: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () async {
                openConfirmCheckBox(context);
              },
            ),
            visible: openCheckBox,
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTableCalendar(context),
          const SizedBox(height: 6.0),
          (isFirstEnter == true)
              ? Container(
                  child: ShimmerCheckIn(),
                  height: AppState.getHeightDevice(context) - 300,
                  width: AppState.getWidthDevice(context),
                )
              : Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget _buildTitle() {
    if (openCheckBox) {
      return Text(records.toString() + ' dòng');
    } else {
      return Text('Kế hoạch');
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      selectedDate = DateTime.now();
      // this._collecitonService.checkPlannedDate().then((response) {
      //   if (Utils.checkRequestIsComplete(response)) {
      //     final data = Utils.handleRequestData(response);
      //     if (Utils.isArray(data)) {
      //       data.forEach((k, v) {
      //         final day = Utils.convertTimeStampToDate(k);
      //         eventsCalendar[day] = ['Event ' + day.second.toString()];
      //       });
      //       setState(() {});
      //     }
      //   }
      // });
      await handleFetchData();
    } catch (e) {
      print(e);
    }
  }

  /// Returns the difference (in full days) between the provided date and today.
  /// Yesterday : calculateDifference(date) == -1.
//Today : calculateDifference(date) == 0.
//Tomorrow : calculateDifference(date) == 1.
  bool? _checkToday(DateTime? date) {
    if(date == null){
      return false;
    }
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  Future<void> openConfirmCheckBox(BuildContext context,
      {Function? callBack}) async {
    WidgetCommon.generateDialogOKCancelGet('Bạn muốn hủy thao tác',
        callbackOK: () async {
          resetList();
          callBack?.call();
        },
        callbackCancel: () async => {});
  }

  void resetList() {
    openCheckBox = false;
    records = 0;
    setState(() {});
    for (TicketModel ticketModel in this._collectionProvider.getLstTicket) {
      ticketModel.isChecked = false;
    }
  }

  void addToDownload(TicketModel ticketModel) {
    if (ticketModel == null || !(ticketModel.isChecked ?? false)) {
      records -= 1;
    } else {
      records += 1;
    }
    if (records < 0) {
      records = 0;
    }
  }

  void actionCheckAllRecordCalendar() {
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
}
