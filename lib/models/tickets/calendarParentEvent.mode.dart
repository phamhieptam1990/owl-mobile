import 'package:athena/models/tickets/calendarEvent.model.dart';

class CalendarParentEventModel {
  String? eventDate;
  String? startDate;
  String? endDate;
  String? name;
  int? id;
  bool? isGroup;
  List<CalendarEventModel>? lstCalendarEventModel;
  CalendarParentEventModel(
      {this.eventDate,
      this.startDate,
      this.endDate,
      this.name,
      this.id,
      this.lstCalendarEventModel,
      this.isGroup});

  factory CalendarParentEventModel.fromJson(
      Map<String, dynamic> calendarEventModel) {
    return CalendarParentEventModel(
        eventDate: calendarEventModel['eventDate'],
        startDate: calendarEventModel['startDate'],
        endDate: calendarEventModel['endDate'],
        name: calendarEventModel['name'],
        id: calendarEventModel['id'],
        isGroup: calendarEventModel['isGroup'] ?? false,
        lstCalendarEventModel:
            calendarEventModel['lstCalendarEventModel'] ?? []);
  }
}
