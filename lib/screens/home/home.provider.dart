import 'package:athena/models/dashboard/number-dashboard.dart';
import 'package:flutter/widgets.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/screens/home/widgets/chart/target-line-chart.dart';

class HomeProvider with ChangeNotifier {
  TargetDashboardModel collectedAmountDashboardModel = new TargetDashboardModel(
      current: 0, target: 0, percentage: 0, color: AppColor.primary , title: '');
  TargetDashboardModel get getCollectedAmountDashboardModel =>
      collectedAmountDashboardModel;

  set setCollectedAmountDashboardModel(
          TargetDashboardModel collectedAmountDashboardModel) =>
      this.collectedAmountDashboardModel = collectedAmountDashboardModel;

  TargetDashboardModel collectFullCasesDashboardModel =
      new TargetDashboardModel(
          current: 0, target: 0, percentage: 0, color: AppColor.primary, title: '');
  TargetDashboardModel get getCollectFullCasesDashboardModel =>
      collectFullCasesDashboardModel;

  set setCollectFullCasesDashboardModel(
          TargetDashboardModel collectFullCasesDashboardModel) =>
      this.collectFullCasesDashboardModel = collectFullCasesDashboardModel;

  TargetDashboardModel checkInDashboardModel = new TargetDashboardModel(
      current: 0, target: 0, percentage: 0, color: AppColor.primary , title: '');
  TargetDashboardModel get getCheckInDashboardModel => checkInDashboardModel;

  set setCheckInDashboardModel(TargetDashboardModel checkInDashboardModel) =>
      this.checkInDashboardModel = checkInDashboardModel;

  NumberDashboardModel collectionModel = new NumberDashboardModel();
  NumberDashboardModel get getCollectionModel => collectionModel;
  set setcollectionModel(NumberDashboardModel collectionModel) =>
      this.collectionModel = collectionModel;

  NumberDashboardModel calendarModel= new NumberDashboardModel() ;
  NumberDashboardModel get getcalendarModel => calendarModel;
  set setcalendarModel(NumberDashboardModel calendarModel) =>
      this.calendarModel = calendarModel;

  int countPlanned = 0;
  int get getCountPlanned => countPlanned;

  bool isLogined = false;
  bool get getIsLogined => isLogined;

  set setIsLogined(bool isLogined) => this.isLogined = isLogined;

  bool unread = false;
  bool get aActive => unread;

  int proposeCalendar = 0;
  int doneActionCalendar = 0;

  int paidCases = 0;
  int unpaidCases = 0;

  int countBacklog = 0;

  // dashboard plan
  int planDone = 0;
  int get getPlanDone => planDone;

  void setPlanDone(int planDone) {
    this.planDone = planDone;
  }

  // dashboard plan
  int planUnDone = 0;
  int get getPlanUnDone => planUnDone;

  void setPlanUnDone(int planUnDone) {
    this.planUnDone = planUnDone;
  }

  // dashboard plan
  int planCancel = 0;
  int get getPlanCancel => planCancel;

  void setPlanCancel(int planCancel) {
    this.planCancel = planCancel;
  }

  // supportRequire
  int createByMeSup = 0;
  int get getCreateByMeSup => createByMeSup;

  void setCreateByMeSup(int createByMeSup) {
    this.createByMeSup = createByMeSup;
  }

  int toDaySup = 0;
  int get getToDaySup => toDaySup;

  void setToDaySup(int toDaySup) {
    this.toDaySup = toDaySup;
  }

  int weekSup = 0;
  int get getWeekSup => weekSup;

  void setWeekSup(int weekSup) {
    this.weekSup = weekSup;
  }

  int day30Sup = 0;
  int get getDay30Sup => day30Sup;

  void setDay30Sup(int day30Sup) {
    this.day30Sup = day30Sup;
  }

  //Khung giờ tải visitForm

  List<int>? timeVisitForm;

  // customer complain
  int examineCustomer = 0;
  int get getExamineCustomer => examineCustomer;

  set setExamineCustomer(int examineCustomer) =>
      {this.examineCustomer = examineCustomer};

  // target

  int achievedPercent = 0;
  int get getAchievedPercent => achievedPercent;

  set setAchievedPercent(int achievedPercent) =>
      this.achievedPercent = achievedPercent;

  var appDataConfig;
  HomeProvider(){
    timeVisitForm = [];
  }

  int getProposeCalendar() {
    return proposeCalendar;
  }

  int getDoneActionCalendar() {
    return doneActionCalendar;
  }

  int getPaiCases() {
    return paidCases;
  }

  int getUnpaidCases() {
    return unpaidCases;
  }

  void setProposeCalendar(int _proposeCalendar) {
    this.proposeCalendar = _proposeCalendar;
    notifyListeners();
  }

  void setDoneActionCalendar(int _doneActionCalendar) {
    this.doneActionCalendar = _doneActionCalendar;
    notifyListeners();
  }

  void setPaiCases(int _paidCases) {
    this.paidCases = _paidCases;
    notifyListeners();
  }

  void setCountBacklog(int _countBacklog) {
    this.countBacklog = _countBacklog;
  }

  void setUnpaidCases(int _unpaidCases) {
    this.unpaidCases = _unpaidCases;
    notifyListeners();
  }

  void setCountPlanned(int _countPlanned) {
    this.countPlanned = _countPlanned;
  }

  int totalCase = 0;
  int checkInCase = 0;

  void clearData() {
    proposeCalendar = 0;
    doneActionCalendar = 0;
    checkInCase = 0;
    totalCase = 0;
    paidCases = 0;
    unpaidCases = 0;

    // supportRequire
    createByMeSup = 0;
    toDaySup = 0;
    weekSup = 0;
    day30Sup = 0;
    isLogined = false;
    // customer complain
    examineCustomer = 0;
    // target
    achievedPercent = 0;
    countBacklog = 0;
    countPlanned = 0;
    appDataConfig = null;
  }
}
