import 'package:flutter/widgets.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/collections/detail.model.dart';
import 'package:athena/models/tickets/mapTicket.model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:athena/models/employee/employee.model.dart';
import 'package:athena/models/employee/employee.tracking.model.dart';
import 'package:athena/utils/utils.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class VietMapProvider with ChangeNotifier {
  LatLng? centerPosition;  // Mark as nullable
  String typeSearch = MapConstant.HOME_SEARCH;
  String keyword = '';
  int currentPage = 1;
  int countBacklog = 0;
  int dateFrom = DateTime.now().millisecondsSinceEpoch;
  int dateTo = DateTime.now().millisecondsSinceEpoch;
  int get getCurrentPage => currentPage;

  set setCurrentPage(int currentPage) => this.currentPage = currentPage;
  int totalLength = 0;
  int get getTotalLength => totalLength;

  set setTotalLength(int totalLength) => this.totalLength = totalLength;

  List<CollectionDetailModel> lstCollectionDetailModel = [];
  List get getLstCollectionDetailModel => lstCollectionDetailModel;

  set setLstCollectionDetailModel(List<CollectionDetailModel> lstCollectionDetailModel) =>
      this.lstCollectionDetailModel = lstCollectionDetailModel;

  List<MapTicketModel> lstTicketModel = [];
  List<MapTicketModel> get getLstTicketModel => lstTicketModel;

  set setLstTicketModel(List<MapTicketModel> lstTicketModel) =>
      this.lstTicketModel = lstTicketModel;

  List<EmployeeModel> lstEmployeeModel = [];
  List<EmployeeModel> get getListEmployeeModel => lstEmployeeModel;

  set setLstEmployeeModel(List<EmployeeModel> lstEmployeeModel) =>
      this.lstEmployeeModel = lstEmployeeModel;

  List<EmployeeTrackingModel> lstEmployeeTrackingModel = [];
  List<EmployeeTrackingModel> get getListEmployeeTrackingModel =>
      lstEmployeeTrackingModel;

  set setLstEmployeeTrackingModel(
          List<EmployeeTrackingModel> lstEmployeeTrackingModel) =>
      this.lstEmployeeTrackingModel = lstEmployeeTrackingModel;

  setCenterPosition(LatLng _centerPosition) {
    this.centerPosition = _centerPosition;
  }

  getCenterPosition() {
    return this.centerPosition;
  }

  setCountBacklog(int _countBacklog) {
    this.countBacklog = _countBacklog;
  }

  void addEmployeeTrackingModel(var data) {
    if (Utils.checkIsNotNull(data)) {
      lstEmployeeTrackingModel.add(EmployeeTrackingModel.fromJson(data));
    }
  }

  void addEmployeeModel(var data) {
    if (Utils.checkIsNotNull(data)) {
      lstEmployeeModel.add(EmployeeModel.fromJson(data));
    }
  }

  void clearData() {
    this.lstCollectionDetailModel = [];
    this.lstTicketModel = [];
    this.currentPage = 1;
    this.totalLength = 0;
    this.countBacklog = 0;
    this.lstEmployeeModel = [];
    this.lstEmployeeTrackingModel = [];
    centerPosition = null;
    typeSearch = MapConstant.HOME_SEARCH;
    dateFrom = DateTime.now().microsecondsSinceEpoch;
    dateTo = DateTime.now().microsecondsSinceEpoch;
  }
}
