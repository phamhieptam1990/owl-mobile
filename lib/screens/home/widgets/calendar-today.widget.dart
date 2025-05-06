import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/utils.dart';
import '../../../getit.dart';
import '../home.provider.dart';

class CalendarTodayWidget extends StatelessWidget {
 final Function callback;
  final homeProvider = getIt<HomeProvider>();
  final colorMain = Color(0xff0293ee);
  CalendarTodayWidget({Key? key, required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 180,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, right: 30, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 150,
                  decoration: new BoxDecoration(
                    // color: Colors.green,
                    color: colorMain,
                    borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(50.0),
                        topRight: Radius.circular(50.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 15.0),
                    child: Text(S.of(context).calendarToday,
                        style: TextStyle(
                            color: AppColor.white,
                            fontSize: AppFont.fontSize18)),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                        await callback.call();
                      }
                    },
                    child: Text(
                      S.of(context).seeMap + ' >',
                      style: TextStyle(
                          // color: Theme.of(context).primaryColor,
                          color: colorMain,
                          fontSize: AppFont.fontSize18),
                    ))
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 15.0, bottom: 0.0, left: 7.0, right: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    // color: colorMain,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10.0,
                    child: InkWell(
                      onTap: () {
                        Utils.pushName(context, RouteList.CALENDAR_SCREEN);
                      },
                      child: Column(children: [
                        Text(homeProvider.getProposeCalendar().toString(),
                            style: TextStyle(
                                fontSize: AppFont.fontSize50,
                                color: AppColor.blackOpacity)),
                        Text(S.of(context).propose,
                            style: TextStyle(fontSize: AppFont.fontSize18)),
                      ]),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Card(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                        onTap: () {
                          Utils.pushName(context, RouteList.CALENDAR_SCREEN);
                        },
                        child: Column(children: [
                          Text(homeProvider.getDoneActionCalendar().toString(),
                              style: TextStyle(
                                  fontSize: AppFont.fontSize50,
                                  color: AppColor.blackOpacity)),
                          Text(S.of(context).actionDone,
                              style: TextStyle(fontSize: AppFont.fontSize18)),
                        ])),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
