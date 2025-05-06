import 'package:hive/hive.dart';
part 'notification.offlline.model.g.dart';

@HiveType(typeId: 5)
class NotificationOfflineModel {
  @HiveField(0)
  String? updatedTime;
  @HiveField(1)
  String? makerDate;
  @HiveField(2)
  int? unread;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String? createdTime;
  @HiveField(5)
  String? to;
  @HiveField(6)
  String? from;
  @HiveField(7)
  String? aggId;
  @HiveField(8)
  var object;

  NotificationOfflineModel({
    this.updatedTime,
    this.makerDate,
    this.unread,
    this.title,
    this.createdTime,
    this.to,
    this.from,
    this.aggId,
    this.object,
  });
}
