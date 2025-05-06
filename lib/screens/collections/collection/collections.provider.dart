import 'package:flutter/widgets.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/filter/collections/filter-collections.screen.dart';

class CollectionProvider with ChangeNotifier {
  int countNotificationUnread = 0;
  int get getCountNotificationUnread => countNotificationUnread;

  int currentPage = 1;
  int get getCurrentPage => currentPage;

  set setCurrentPage(int currentPage) => this.currentPage = currentPage;
  int totalLength = 0;
  int get getTotalLength => totalLength;

  set setTotalLength(int totalLength) => this.totalLength = totalLength;

  setCountNotificationUnread(int countNotificationUnread) {
    this.countNotificationUnread = countNotificationUnread;
    notifyListeners();
  }

  String keyword = '';
  String get getKeyword => keyword;

  set setKeyword(String keyword) => this.keyword = keyword;

  dynamic filter = null;
  dynamic get getFilter => filter;

  set setFilter(dynamic filter) => this.filter = filter;

  List<TicketModel> lstTicket = [];
  List<TicketModel> get getLstTicket => lstTicket;

  bool checkedIsNotEmpty() {
    for (var item in getLstTicket) {
      if (item.isChecked == true) {
        return true;
      }
    }
    return false;
  }

  set setLstTicket(List<TicketModel> lstTicket) =>
      {this.lstTicket = lstTicket, notifyListeners()};

  SortModel? sortModel = null;

  FilterNew filterNew = new FilterNew(false, '');
  void clearData() {
    this.totalLength = 0;
    this.currentPage = 1;
    this.keyword = '';
    this.filter = null;
    this.lstTicket = [];
    this.filterNew = new FilterNew(false, '');
    sortModel = null;
  }
}

class FilterNew {
  bool? priority;
  String? type;
  FilterNew(bool priority, String type) {
    this.priority = priority;
    this.type = type;
  }
}
