import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/screens/home/home.provider.dart';

class CustomerComplaintWidget extends StatelessWidget {
  final homeProvider = getIt<HomeProvider>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
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
                  Text(S.of(context).customerComplain,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text(homeProvider.getPaiCases().toString(),
                      style: TextStyle(
                          fontSize: AppFont.fontSize50,
                          color: AppColor.blackOpacity)),
                  Text(S.of(context).today,
                      style: TextStyle(fontSize: AppFont.fontSize16)),
                ]),
                Container(
                    height: 70,
                    child: VerticalDivider(color: AppColor.blackOpacity)),
                Column(children: [
                  Text(homeProvider.getUnpaidCases().toString(),
                      style: TextStyle(
                          fontSize: AppFont.fontSize50,
                          color: AppColor.blackOpacity)),
                  Text("< 1 " + S.of(context).week,
                      style: TextStyle(fontSize: AppFont.fontSize16)),
                ]),
                Container(
                    height: 70,
                    child: VerticalDivider(color: AppColor.blackOpacity)),
                Column(children: [
                  Text(homeProvider.getUnpaidCases().toString(),
                      style: TextStyle(
                          fontSize: AppFont.fontSize50,
                          color: AppColor.blackOpacity)),
                  Text("> 1 " + S.of(context).week,
                      style: TextStyle(fontSize: AppFont.fontSize16)),
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
