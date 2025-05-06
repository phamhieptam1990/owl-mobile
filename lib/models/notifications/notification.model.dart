import 'package:athena/utils/utils.dart';

class NotificationModel {
  String? updatedTime;
  String? makerDate;
  int? unread;
  String? title;
  String? createdTime;
  String? to;
  String? from;
  String? aggId;
  var object;
  var content;
  NotificationModel(
      {this.updatedTime,
      this.makerDate,
      this.unread,
      this.title,
      this.createdTime,
      this.to,
      this.from,
      this.aggId,
      this.object,
      this.content});

  Map<String, dynamic> toJson() {
    return {
      'updatedTime': updatedTime,
      'makerDate': makerDate,
      'unread': unread,
      'title': title,
      'createdTime': createdTime,
      'to': to,
      'from': from,
      'aggId': aggId,
      'object': object,
      'content': content
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> notificationModel) {
    return NotificationModel(
        updatedTime: notificationModel['updatedTime'],
        makerDate: notificationModel['makerDate'],
        unread: notificationModel['unread'],
        title: notificationModel['title'],
        createdTime: notificationModel['createdTime'],
        to: notificationModel['to'],
        from: notificationModel['from'],
        aggId: notificationModel['aggId'],
        content: Utils.checkIsNotNull(notificationModel['content'])
            ? notificationModel['content']
            : '',
        object: notificationModel['object']);
  }
}
