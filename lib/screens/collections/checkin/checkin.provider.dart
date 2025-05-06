import 'package:flutter/widgets.dart';
import 'package:athena/models/tickets/ticket.model.dart';

class CheckInProvider with ChangeNotifier {
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

  String filter = '';
  String get getFilter => filter;

  set setFilter(String filter) => this.filter = filter;

  List<TicketModel> lstTicket = [];
  List get getLstTicket => lstTicket;

  set setLstTicket(List<TicketModel> lstTicket) =>
      {this.lstTicket = lstTicket, notifyListeners()};

  var checkIn;
  var durations;
  var position = {
    'latitude': 0.0,
    'longitude': 0.0,
    'accuracy': 0.0,
    'address': ''
  };
  bool isLoading = true;
  void clearData() {
    this.totalLength = 0;
    this.currentPage = 1;
    this.keyword = '';
    this.filter = '';
    this.lstTicket = [];
    this.checkIn = null;
    this.durations = null;
    this.position = {
      'latitude': 0,
      'longitude': 0,
      'accuracy': 0,
      'address': ''
    };
    this.isLoading = true;
  }
}
