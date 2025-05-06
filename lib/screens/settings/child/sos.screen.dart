import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';

class SOSScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarCommon(title: S.of(context).connection, lstWidget: []),
        body: Container(
            height: 140.0,
            width: AppState.getWidthDevice(context),
            child: Card(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    // WidgetCommon.openPage(
                    //     'https://fecredit.com.vn/vay-tien-mat/uu-dai-tien-mat/',
                    //     _scaffoldKey);
                    WidgetCommon.openWebBrowser(
                        'https://fecredit.com.vn/vay-tien-mat/uu-dai-tien-mat/');
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.money,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(S.of(context).calculateMoneyPayPerMonth),
                  ),
                ),
                Divider(
                  color: AppColor.blackOpacity,
                ),
                InkWell(
                  onTap: () async {
                    // WidgetCommon.openPage(
                    //     'https://sd.fecredit.com.vn/CAisd/SDM', _scaffoldKey);
                    WidgetCommon.openWebBrowser(
                        'https://sd.fecredit.com.vn/CAisd/SDM');
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.contacts,
                      color: AppColor.blue,
                    ),
                    title: Text(S.of(context).contactITToSuppoter),
                  ),
                ),
              ],
            ))));
  }
}
