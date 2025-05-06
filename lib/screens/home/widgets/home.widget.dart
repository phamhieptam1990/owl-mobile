import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/home/home.provider.dart';

class HomeWidget extends StatelessWidget {
 final HomeProvider _homeProvider;
  HomeWidget(this._homeProvider);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).calendarToday,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                  // GestureDetector(
                  //     onTap: () {},
                  //     child: Text(
                  //       S.of(context).seeMap,
                  //       style: TextStyle(
                  //           color: Theme.of(context).primaryColor,
                  //           fontSize: AppFont.fontSize16),
                  //     )),
                  InkWell(
                      onTap: () {},
                      child: Text(
                        S.of(context).seeMap,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: AppFont.fontSize16),
                      )),
                ],
              ),
            ),
            Divider(
              color: AppColor.blackOpacity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text(_homeProvider.getProposeCalendar().toString(),
                      style: TextStyle(
                          fontSize: AppFont.fontSize50,
                          color: AppColor.blackOpacity)),
                  Text(S.of(context).propose,
                      style: TextStyle(fontSize: AppFont.fontSize16)),
                ]),
                Container(
                    height: 70,
                    child: VerticalDivider(color: AppColor.blackOpacity)),
                Column(children: [
                  Text(_homeProvider.getDoneActionCalendar().toString(),
                      style: TextStyle(
                          fontSize: AppFont.fontSize50,
                          color: AppColor.blackOpacity)),
                  Text(S.of(context).actionDone,
                      style: TextStyle(fontSize: AppFont.fontSize16)),
                ])
              ],
            ),
            Divider(
              color: AppColor.blackOpacity,
            ),
            SizedBox(height: 10.0),
            // Text(S.of(context).no_record_metting)
          ],
        ),
      ),
    );
  }
}
