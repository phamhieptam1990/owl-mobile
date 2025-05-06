import 'package:dio/dio.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/models/tickets/calendarEvent.model.dart';
import 'package:athena/utils/http/http_helper.dart';
import 'package:athena/utils/utils.dart';

class CalendarService {
  Future<Response> getEventInfoByRangeDate(String startDate, String endDate) {
    String params = 'startDate=$startDate&endDate=$endDate';
    return HttpHelper.get(CALENDAR_EVENT_URL.EVENT_INFO_BY_RANGE_DATE + params);
  }

  buildSearchTime(DateTime dateTime, String type) {
    String date = dateTime.day.toString() +
        "/" +
        dateTime.month.toString() +
        "/" +
        dateTime.year.toString();
    String time = '00:00:00';
    if (type == 'end') {
      time = '23:59:00';
    }
    return date + " " + time;
      // return
  }

  buildTextComplete(CalendarEventModel calendar) {
    String text = '';
    if (calendar.done == true) {
      text = 'Đã hoàn thành vào lúc ' +
          Utils.convertTime(Utils.convertTimeStampToDateEnhance(calendar.endDate ?? '') ?? 0, timeFormat: 'HH:mm');
    }
    return text;
  }

  // {{mcrevent}}/services/eventService/getEventInfoByRangeDate?startDate=08/11/2020 00:00:00&endDate=20/11/2020 00:00:00
}
