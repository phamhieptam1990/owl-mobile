import 'package:flutter/widgets.dart';
import 'package:athena/models/tickets/calendarEvent.model.dart';
import 'package:athena/models/tickets/calendarParentEvent.mode.dart';
import 'package:athena/utils/utils.dart';

class CalendarProvider with ChangeNotifier {
  bool isFirstEnter = true;

  int startDate = 0;
  int get getStartDate => startDate;

  set setStartDate(int startDate) => this.startDate = startDate;

  int endDate = 0;
  int get getEndDate => endDate;

  set setEndDate(int endDate) => this.endDate = endDate;

  int currentPage = 1;
  int get getCurrentPage => currentPage;

  set setCurrentPage(int currentPage) => this.currentPage = currentPage;

  String keyword = "";
  String get getKeyword => keyword;

  set setKeyword(String keyword) => this.keyword = keyword;

  int countNotificationUnread = 0;
  int get getCountNotificationUnread => countNotificationUnread;

  setCountNotificationUnread(int countNotificationUnread) {
    this.countNotificationUnread = countNotificationUnread;
    notifyListeners();
  }

  List<CalendarEventModel> lstCalendarEventModel = [];
  List<CalendarEventModel> get getLstCalendarEventModel =>
      lstCalendarEventModel;

  List<CalendarParentEventModel> lstCalendarParentEventModel = [];
  List<CalendarParentEventModel> get getLstCalendarParentEventModel =>
      lstCalendarParentEventModel;

  set setLstCalendarParentEventModel(
          List<CalendarParentEventModel> lstCalendarParentEventModel) =>
      this.lstCalendarParentEventModel = lstCalendarParentEventModel;

  Map<DateTime, List> eventsCalendar = {};
  Map<DateTime, List> get getEventsCalendar => eventsCalendar;

  void clearData() {
    this.countNotificationUnread = 0;
    this.lstCalendarEventModel = [];
    this.lstCalendarParentEventModel = [];
    this.currentPage = 1;
    this.keyword = "";
    this.startDate = 0;
    this.endDate = 0;
    this.isFirstEnter = true;
    eventsCalendar = {};
  }

  initCalendarData(DateTime startDate, DateTime endDate) {
    CalendarParentEventModel date1 = new CalendarParentEventModel(
        startDate: startDate.toIso8601String(),
        isGroup: true,
        lstCalendarEventModel: []);
    CalendarParentEventModel date2 = new CalendarParentEventModel(
        startDate: startDate.add(Duration(days: 1)).toIso8601String(),
        isGroup: true,
        lstCalendarEventModel: []);
    CalendarParentEventModel date3 = new CalendarParentEventModel(
        startDate: startDate.add(Duration(days: 2)).toIso8601String(),
        isGroup: true,
        lstCalendarEventModel: []);
    CalendarParentEventModel date4 = new CalendarParentEventModel(
        startDate: startDate.add(Duration(days: 3)).toIso8601String(),
        isGroup: true,
        lstCalendarEventModel: []);
    CalendarParentEventModel date5 = new CalendarParentEventModel(
        startDate: startDate.add(Duration(days: 4)).toIso8601String(),
        isGroup: true,
        lstCalendarEventModel: []);
    CalendarParentEventModel date6 = new CalendarParentEventModel(
        startDate: startDate.add(Duration(days: 5)).toIso8601String(),
        isGroup: true,
        lstCalendarEventModel: []);
    CalendarParentEventModel date7 = new CalendarParentEventModel(
        startDate: startDate.add(Duration(days: 6)).toIso8601String(),
        isGroup: true,
        lstCalendarEventModel: []);

    lstCalendarParentEventModel.add(date1);
    lstCalendarParentEventModel.add(date2);
    lstCalendarParentEventModel.add(date3);
    lstCalendarParentEventModel.add(date4);
    lstCalendarParentEventModel.add(date5);
    lstCalendarParentEventModel.add(date6);
    lstCalendarParentEventModel.add(date7);
  }

  mergeListData(List<CalendarEventModel> lstChild) {
    // DateTime dtParent;
    // DateTime dtChild;
    // int indexParent = 0;
    // CalendarParentEventModel parent;
    for (CalendarEventModel child in lstChild) {
      final String childStartDate = child.startDate ?? '';
      final dtChild = Utils.converLongToDate(
          Utils.convertTimeStampToDateEnhance(childStartDate) ?? 0);
      for (int indexParent = 0;
          indexParent < this.lstCalendarParentEventModel.length;
          indexParent++) {
         final parent = lstCalendarParentEventModel[indexParent];
        final String parentStartDate = parent.startDate ?? '';
        final dtParent = Utils.converLongToDate(
            Utils.convertTimeStampToDateEnhance(parentStartDate) ?? 0);
            
        if (dtChild.day == dtParent.day &&
            dtChild.month == dtParent.month &&
            dtChild.year == dtParent.year) {
          parent.lstCalendarEventModel?.add(child);
          eventsCalendar[dtChild] = ['Event A'];
          break;
        }
      }
    }
    eventsCalendar.forEach((key, value) {});
  }
}
