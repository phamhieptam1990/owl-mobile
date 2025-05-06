class CalendarEventModel {
  String? eventDate;
  String? startDate;
  String? endDate;
  String? name;
  int? id;
  String? description;
  bool? done;
  String? ticketId;
  String? customerCode;
  String? customerName;
  String? actionCode;
  String? actionGroupCode;
  String? makerDate;
  String? actionName;
  String? actionGroupName;
  bool? isGroup;
  CalendarEventModel(
      {this.eventDate,
      this.startDate,
      this.endDate,
      this.name,
      this.id,
      this.description,
      this.done,
      this.ticketId,
      this.customerCode,
      this.customerName,
      this.actionCode,
      this.actionGroupCode,
      this.makerDate,
      this.actionName,
      this.actionGroupName,
      this.isGroup});

  factory CalendarEventModel.fromJson(Map<String, dynamic> calendarEventModel) {
    return CalendarEventModel(
      eventDate: calendarEventModel['eventDate'],
      startDate: calendarEventModel['startDate'],
      endDate: calendarEventModel['endDate'],
      name: calendarEventModel['name'],
      id: calendarEventModel['id'],
      description: calendarEventModel['description'],
      done: calendarEventModel['done'],
      ticketId: calendarEventModel['ticketId'],
      customerCode: calendarEventModel['customerCode'],
      customerName: calendarEventModel['customerName'],
      actionCode: calendarEventModel['actionCode'],
      actionGroupCode: calendarEventModel['actionGroupCode'] ?? '',
      makerDate: calendarEventModel['makerDate'],
      actionName: calendarEventModel['actionName'] ?? '',
      actionGroupName: calendarEventModel['actionGroupName'] ?? '',
      isGroup: calendarEventModel['isGroup'] ?? false,
    );
  }
}
