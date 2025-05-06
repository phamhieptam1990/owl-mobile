import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import '../home.provider.dart';

class ActionInMonthWidget extends StatelessWidget {
  final homeProvider = getIt<HomeProvider>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
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
                  Text(S.of(context).actionInMonth,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                  // GestureDetector(
                  //     onTap: () {},
                  //     child: Text(
                  //       S.of(context).seeAll,
                  //       style: TextStyle(
                  //           color: Theme.of(context).primaryColor,
                  //           fontSize: AppFont.fontSize16),
                  //     )),
                  InkWell(
                      onTap: () {},
                      child: Text(
                        S.of(context).seeAll,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: AppFont.fontSize16),
                      )),
                ],
              ),
            ),
            Divider(color: AppColor.blackOpacity),
            ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).examine, textAlign: TextAlign.left),
                    Text(homeProvider.getExamineCustomer.toString(),
                        textAlign: TextAlign.right),
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Theme.of(context).primaryColor),
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
