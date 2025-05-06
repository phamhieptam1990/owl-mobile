class TicketEventModel {
  String? endDate;
  String? eventDate;
  String? startDate;
  double? latitude;
  double? longitude;
  String? ticketId;
  String? userId;
  String? name;
  String? fullAddress;
  int? id;

  TicketEventModel({
    this.endDate,
    this.eventDate,
    this.startDate,
    this.latitude,
    this.longitude,
    this.ticketId,
    this.userId,
    this.name,
    this.fullAddress,
    this.id,
  });

  Map<String, dynamic> toJson() => {
        'endDate': endDate,
        'eventDate': eventDate,
        'startDate': startDate,
        'latitude': latitude,
        'longitude': longitude,
        'ticketId': ticketId,
        'userId': userId,
        'name': name,
        'fullAddress': fullAddress,
        'id': id,
      };

  factory TicketEventModel.fromJson(Map<String, dynamic> ticketEventModel) {
    return TicketEventModel(
      endDate: ticketEventModel['endDate'],
      eventDate: ticketEventModel['eventDate'],
      startDate: ticketEventModel['startDate'],
      latitude: ticketEventModel['latitude'],
      longitude: ticketEventModel['longitude'],
      ticketId: ticketEventModel['ticketId']?.toString(),
      userId: ticketEventModel['userId']?.toString(),
      name: ticketEventModel['name']?.toString(),
      fullAddress: ticketEventModel['fullAddress']?.toString(),
      id: ticketEventModel['id'],
    );
  }

  // String toJson() => json.encode(toMap());

  // factory TicketEventModel.fromJson(String source) =>
  //     TicketEventModel.fromMap(json.decode(source));
}