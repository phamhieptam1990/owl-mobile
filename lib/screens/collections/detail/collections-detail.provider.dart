import 'package:flutter/widgets.dart';
import 'package:athena/models/tickets/activity.model.dart';
import 'package:athena/models/tickets/ticketEvent.model.dart';

class CollectionDetailProvider with ChangeNotifier {
  int countNotificationUnread = 0;
  List<ActivityModel> lstAcivityModel = [];
  List<ActivityModel> get getLstAcivityModel => lstAcivityModel;

  set setLstTicket(List<ActivityModel> lstAcivityModel) =>
      {this.lstAcivityModel = lstAcivityModel, notifyListeners()};
  int get getCountNotificationUnread => countNotificationUnread;

  setCountNotificationUnread(int countNotificationUnread) {
    this.countNotificationUnread = countNotificationUnread;
    notifyListeners();
  }

  TicketEventModel? ticketEvent;
  TicketEventModel? get getTicketEvent {
    if (ticketEvent == null) {
      return null;
      // throw Exception("TicketEvent chưa được khởi tạo!");
    }
    return ticketEvent!;
  }

  setTicketEvent(TicketEventModel _ticketEvent) {
    this.ticketEvent = _ticketEvent;
  }

  void clearData() {
    lstAcivityModel = [];
    ticketEvent = null;
  }
}
