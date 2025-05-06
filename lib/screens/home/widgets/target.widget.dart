import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/home/widgets/chart/target-line-chart.dart';
import '../../../getit.dart';
import '../home.provider.dart';

class TargetWidget extends StatelessWidget {
  final homeProvider = getIt<HomeProvider>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      child: Card(
          elevation: 10,
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(
                      left: 30, right: 30, top: 10, bottom: 0.0),
                  child: Text(S.of(context).target,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                )),
            Divider(color: AppColor.blackOpacity),
            Align(
                alignment: Alignment.center,
                child: Container(
                  child: TargetDashboardWidget(
                      info: homeProvider.getCollectedAmountDashboardModel),
                )),
            Align(
                alignment: Alignment.center,
                child: Container(
                  child: TargetDashboardWidget(
                      info: homeProvider.getCollectFullCasesDashboardModel),
                )),
            Align(
                alignment: Alignment.center,
                child: Container(
                  child: TargetDashboardWidget(
                      info: homeProvider.getCheckInDashboardModel),
                )),
          ])),
    );
  }
}
