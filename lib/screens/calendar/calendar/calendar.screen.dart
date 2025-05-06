import 'package:athena/common/config/app_config.dart';
import 'package:athena/screens/vietmap/vietmap.provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/tickets/calendarEvent.model.dart';
import 'package:athena/models/tickets/calendarParentEvent.mode.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/calendar/calendar/calendar.provider.dart';
import 'package:athena/screens/calendar/canlendar.service.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/employee/employee.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import '../../../getit.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:after_layout/after_layout.dart';
import 'package:athena/widgets/common/common.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key? key}) : super(key: key);
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with
        TickerProviderStateMixin,
        AfterLayoutMixin,
        AutomaticKeepAliveClientMixin<CalendarScreen> {
  final calendarService = new CalendarService();
  final scrollController = new ScrollController();
  final collectionService = new CollectionService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'calendar');
  final calendarProvider = getIt<CalendarProvider>();
  final _mapProvider = getIt<VietMapProvider>();
  final _collecitonService = new CollectionService();

  final _employeeService = new EmployeeService();

  final scrollDirection = Axis.vertical;

  late final AutoScrollController controller;
  late final AnimationController _animationController;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  DateTime _focusedDay = DateTime.now();
  DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 6, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 6, DateTime.now().day);

  CalendarFormat _calendarFormat = CalendarFormat.week;

  void _onRefresh() async {
    await handleFetchData();
    _refreshController.refreshCompleted();
  }

  Future<void> handleFetchData() async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      calendarProvider.currentPage = 0;
      calendarProvider.lstCalendarEventModel = [];
      calendarProvider.lstCalendarParentEventModel = [];
      calendarProvider.eventsCalendar = {};
      DateTime startDate =
          Utils.converLongToDate(calendarProvider.getStartDate);
      final start = calendarService.buildSearchTime(startDate, 'start');

      final endDate = Utils.converLongToDate(calendarProvider.getEndDate);
      final end = calendarService.buildSearchTime(endDate, 'end');

      this.calendarProvider.initCalendarData(startDate, endDate);
      List<CalendarEventModel> lstChild = [];

      final Response response =
          await this.calendarService.getEventInfoByRangeDate(start, end);

      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData(response);
        if (lstData != null) {
          for (var data in lstData) {
            calendarProvider.getLstCalendarEventModel
                .add(CalendarEventModel.fromJson(data));
            lstChild.add(CalendarEventModel.fromJson(data));
          }
          calendarProvider.mergeListData(lstChild);
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        if (calendarProvider.isFirstEnter) {
          calendarProvider.isFirstEnter = false;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      calculateStartDateEndDate(DateTime.now());
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      controller = AutoScrollController(
          viewportBoundaryGetter: () =>
              Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
          axis: scrollDirection);
      _animationController.forward();
    } catch (e) {}
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    WidgetCommon.dismissLoading();
    super.dispose();
  }

  Future<void> _onDaySelected(DateTime day, DateTime focusedDay) async {
    DateTime endDate = Utils.converLongToDate(calendarProvider.getEndDate);
    DateTime startDate = Utils.converLongToDate(calendarProvider.startDate);

    if ((endDate.month == day.month &&
            endDate.day == day.day &&
            endDate.year == day.year) ||
        (startDate.month == day.month &&
            startDate.day == day.day &&
            startDate.year == day.year) ||
        (day.isBefore(endDate) && day.isAfter(startDate))) {
      await controller.scrollToIndex(day.weekday - 1,
          preferPosition: AutoScrollPosition.begin);
      controller.highlight(day.weekday - 1);
      return;
    }
    calculateStartDateEndDate(day);
    calendarProvider.currentPage = 1;
    calendarProvider.lstCalendarEventModel = [];
    calendarProvider.lstCalendarParentEventModel = [];

    await handleFetchData();
  }

  void calculateStartDateEndDate(DateTime _selectedDayTemp) {
    DateTime _selectedDay;
    DateTime _endSelectedDay;
    int firstOfWeek = 7 - _selectedDayTemp.weekday;
    if (firstOfWeek > 0) {
      _selectedDay =
          _selectedDayTemp.subtract(Duration(days: 7 - firstOfWeek - 1));
      _endSelectedDay = _selectedDayTemp.add(Duration(days: firstOfWeek));
    } else {
      _endSelectedDay = _selectedDayTemp;
      _selectedDay = _selectedDayTemp.subtract(Duration(days: 7));
    }
    calendarProvider.setStartDate = _selectedDay.millisecondsSinceEpoch;
    calendarProvider.setEndDate = _endSelectedDay.millisecondsSinceEpoch;
    this.calendarProvider.initCalendarData(_selectedDay, _endSelectedDay);
  }

  Widget _buildTableCalendar(BuildContext context) {
    return TableCalendar(
      lastDay: kLastDay,
      firstDay: kFirstDay,
      focusedDay: _focusedDay,
      locale: 'vi_VN',
      // events: calendarProvider.eventsCalendar,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableCalendarFormats: const {
        CalendarFormat.month: '1/2 Tháng',
        CalendarFormat.week: 'Tháng',
        CalendarFormat.twoWeeks: 'Tuần',
      },
      calendarStyle: CalendarStyle(
        selectedDecoration:
            BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        todayDecoration: BoxDecoration(
            color: Colors.deepOrange[200], shape: BoxShape.circle),
        markerDecoration: BoxDecoration(
            color: Colors.deepOrange[200], shape: BoxShape.circle),
        outsideDaysVisible: false,
      ),

      calendarFormat: _calendarFormat,
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
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
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? status) {
          Widget body;
          if (status == LoadStatus.idle) {
            body = const Text("pull up load");
          } else if (status == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (status == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (status == LoadStatus.canLoading) {
            body = const Text("release to load more");
          } else {
            body = const Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
        scrollDirection: scrollDirection,
        controller: controller,
        shrinkWrap: true,
        itemBuilder: (c, i) => buildItemListView(i),
        itemCount: calendarProvider.getLstCalendarParentEventModel.length,
      ),
    );
  }

  Widget buildItemListView(int index) {
    CalendarParentEventModel calendarEventParentModel =
        calendarProvider.getLstCalendarParentEventModel.elementAt(index);
    Widget container =
        calendarEventParentModel.lstCalendarEventModel?.isNotEmpty == true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildChildren(calendarEventParentModel))
            : buildContainerDateNoItem(calendarEventParentModel);
    return AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: container);
  }

  Widget buildContainerDateNoItem(CalendarParentEventModel parent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildContainerDate(parent),
        Center(
          child: Container(
            child: Text("Không có cuộc gặp",
                style: TextStyle(
                    fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          ),
        )
      ],
    );
  }

  Widget buildContainerDate(CalendarParentEventModel parent) {
    return Center(
        child: Container(
      width: 150.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.5),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Center(
        child: Text(
            Utils.convertTimeWithoutTime(
                Utils.convertTimeStampToDateEnhance(parent.startDate ?? '') ?? 0),
            style: TextStyle(
              fontSize: 14.0,
            )),
      ),
      padding: EdgeInsets.all(8.0),
    ));
  }

  List<Widget> buildChildren(CalendarParentEventModel parent) {
    List<Widget> lstWidgets = [];
    lstWidgets.add(buildContainerDate(parent));
    List<CalendarEventModel> lst = parent.lstCalendarEventModel ?? [];
    for (CalendarEventModel calendar in lst) {
      lstWidgets.add(buildInfoTicket(calendar));
    }
    return lstWidgets;
  }

  void handlePushPage(BuildContext context, CalendarEventModel calendar) async {
    try {
      if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
        WidgetCommon.showLoading();
        final Response response =
            await collectionService.getTicketDetail(calendar.ticketId ?? '');
        TicketModel ticketModelT;
        if (Utils.checkRequestIsComplete(response)) {
          if (response.data['data'] != null) {
            var data = response.data['data'];
            if (Utils.checkIsNotNull(data)) {
              ticketModelT = TicketModel.fromJson(data);
              String empCodes = ticketModelT.assignee ?? '';
              if (empCodes.length > 0) {
                final Response empRes =
                    await _employeeService.getEmployees(empCodes);
                if (Utils.checkRequestIsComplete(empRes) &&
                    empRes.data != null &&
                    Utils.isArray(empRes.data['data'])) {
                  if (ticketModelT.assigneeData == null) {
                    ticketModelT.assigneeData = empRes.data['data'][0];
                  }
                }
              }
              WidgetCommon.dismissLoading();
              return Utils.pushName(context, RouteList.COLLECTION_DETAIL_SCREEN,
                  params: ticketModelT);
            }
          }
        }
        WidgetCommon.dismissLoading();
      }
    } catch (e) {
      WidgetCommon.dismissLoading();
    }
  }

  Widget buildInfoTicket(CalendarEventModel calendar) {
    return Column(children: [
      Card(
          child: Column(children: [
        InkWell(
          onTap: () async {
            handlePushPage(context, calendar);
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: CircleAvatar(
              child: Text(calendar?.customerName?[0] ?? '',
                  style: TextStyle(color: AppColor.white)),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            // leading: Hero(
            //   tag: calendar.id,
            //   child: CircleAvatar(
            //     child: Text(calendar.customerName[0],
            //         style: TextStyle(color: AppColor.white)),
            //     backgroundColor: AppColor.primary,
            //   ),
            // ),
            title: Text(
              calendar?.customerName ?? '',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: _buildLeadingTile(calendar, context),
          ),
        )
      ]))
    ]);
  }

  Widget _buildLeadingTile(CalendarEventModel detail, BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new SizedBox(height: 4.0),
        Text(
          (detail.actionGroupCode != null)
              ? _collecitonService.convertActionGroupName(
                  detail.actionGroupCode ?? '', '', context)
              : '',
          style: TextStyle(fontSize: 12.0, color: Colors.black54),
        ),
        new SizedBox(height: 4.0),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 15.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.0),
              child: Text(Utils.convertTime(
                  Utils.convertTimeStampToDateEnhance(detail.eventDate ?? '') ?? 0)),
            )
          ],
        ),
        new SizedBox(height: 4.0),
        Visibility(
          visible: detail.done ?? false,
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 10.0,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(calendarService.buildTextComplete(detail)),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      super.build(context);
      return ChangeNotifierProvider<CalendarProvider>(
        create: (context) => calendarProvider,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBarCommon(lstWidget: [
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () async {
                if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                  await this.gotoMapPage(context);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Utils.pushName(context, RouteList.SEARCH_SCREEN);
              },
            ),
          ], title: S.of(context).calendar),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTableCalendar(context),
              const SizedBox(height: 6.0),
              (calendarProvider.isFirstEnter == true)
                  ? Expanded(
                      child: Container(
                        child: ShimmerCheckIn(),
                        width: AppState.getWidthDevice(context),
                      ),
                    )
                  : Expanded(child: _buildEventList()),
            ],
          ),
        ),
      );
    } catch (e) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarCommon(lstWidget: [], title: S.of(context).calendar),
        body: NoDataWidget(),
      );
    }
  }

  bool? isClickGotoMap;
  Future<void> gotoMapPage(BuildContext context) async {
    try {
      if (isClickGotoMap ?? true) {
        return;
      }
      WidgetCommon.showLoading(status: 'Đang lấy thông tin vị trí');
      bool permission =
          await PermissionAppService.checkServiceEnabledLocation();
      if (permission) {
        isClickGotoMap = true;
        Position? position = await PermissionAppService.getCurrentPosition();
        if(position == null) {
          WidgetCommon.dismissLoading();
          return;
        }
        _mapProvider.setCenterPosition(
            new LatLng(position.latitude, position.longitude));
        isClickGotoMap = false;
        WidgetCommon.dismissLoading();
        // Utils.pushName(null, RouteList.MAP_SCREEN);
        if (APP_CONFIG.enableVietMap) {
          Utils.pushName(context, RouteList.VIETMAP_SCREEN);
        } else {}
        // Utils.pushName(null, RouteList.MAP_SCREEN);
        return;
            }
      WidgetCommon.dismissLoading();
    } catch (e) {
      WidgetCommon.dismissLoading();
      isClickGotoMap = false;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (calendarProvider.isFirstEnter) {
      await handleFetchData();
    }
  }
}
