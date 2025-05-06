import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/customer-request/list/customer-request-list.screen.dart';
import 'package:athena/utils/utils.dart';
import '../../../getit.dart';
import '../home.provider.dart';

class SupportWidget extends StatelessWidget {
  final homeProvider = getIt<HomeProvider>();
  final colorMain = Color(0xff0293ee);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, right: 30, top: 15, bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 30,
                  width: 150,
                  decoration: new BoxDecoration(
                    color: colorMain,
                    borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(50.0),
                        topRight: Radius.circular(50.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 15.0),
                    child: Text(S.of(context).supportRequire,
                        style: TextStyle(
                            color: AppColor.white,
                            fontSize: AppFont.fontSize18)),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Utils.pushName(context, RouteList.COLLECTION_SCREEN,
                          params: '');
                    },
                    child: Text(
                      S.of(context).seeAll + ' >',
                      style: TextStyle(
                          color: colorMain, fontSize: AppFont.fontSize18),
                    ))
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: 15.0, bottom: 0.0, left: 7.0, right: 7.0),
              child: Card(
                elevation: 10.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).createdByMe,
                                textAlign: TextAlign.left),
                            Text(homeProvider.getCreateByMeSup.toString(),
                                textAlign: TextAlign.right),
                          ],
                        ),
                        trailing:
                            Icon(Icons.keyboard_arrow_right, color: colorMain),
                        onTap: () {
                          pushPage(context, 0);
                        }),
                    Divider(
                      color: AppColor.blackOpacity,
                      indent: 20.0,
                      endIndent: 20.0,
                    ),
                    ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).today,
                                textAlign: TextAlign.left),
                            Text(homeProvider.getToDaySup.toString(),
                                textAlign: TextAlign.right),
                          ],
                        ),
                        trailing:
                            Icon(Icons.keyboard_arrow_right, color: colorMain),
                        onTap: () {
                          pushPage(context, 1);
                        }),
                    Divider(
                      color: AppColor.blackOpacity,
                      indent: 20.0,
                      endIndent: 20.0,
                    ),
                    ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("< 1 " + S.of(context).week,
                                textAlign: TextAlign.left),
                            Text(homeProvider.getWeekSup.toString(),
                                textAlign: TextAlign.right),
                          ],
                        ),
                        trailing:
                            Icon(Icons.keyboard_arrow_right, color: colorMain),
                        onTap: () {
                          pushPage(context, 2);
                        }),
                    Divider(
                      color: AppColor.blackOpacity,
                      indent: 20.0,
                      endIndent: 20.0,
                    ),
                    ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("30 " + S.of(context).day,
                                textAlign: TextAlign.left),
                            Text(homeProvider.getDay30Sup.toString(),
                                textAlign: TextAlign.right),
                          ],
                        ),
                        trailing:
                            Icon(Icons.keyboard_arrow_right, color: colorMain),
                        onTap: () {
                          pushPage(context, 3);
                        }),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void pushPage(context, statusFilter) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CustomerRequestListScreen(fillterStatus: statusFilter),
      ),
    );
  }
}
