import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/notifications/notification.model.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:get/get.dart';
import '../../widgets/common/nodata.widget.dart';
import 'notification.controller.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel detail;
  NotificationDetailScreen(this.detail);

  @override
  Widget build(BuildContext context) {
    try {
      final notificationDetailController =
          Get.put(NotificationDetailController());
      notificationDetailController.parent = this.detail;
      String makerDate = Utils.convertTime(
          Utils.convertTimeStampToDateEnhance(detail.createdTime ?? '') ?? 0);
      return Scaffold(
          appBar: AppBarCommon(
            title: S.of(context).Noti_titleDetail,
            lstWidget: [],
          ),
          body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GetBuilder<NotificationDetailController>(
                    id: 'NotificationDetailScreen',
                    builder: (_) => Column(
                      children: <Widget>[
                        Utils.checkIsNotNull(
                                notificationDetailController.detail)
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 30.0,
                                      child: ListTile(
                                        title: Text(S.of(context).Noti_from +
                                            ': ' +
                                            (notificationDetailController
                                                .detail?.from ??'')),
                                      ),
                                    ),
                                    Container(
                                      height: 50.0,
                                      child: ListTile(
                                        title: Text(
                                            S.of(context).Noti_makerDate +
                                                ": " +
                                                makerDate),
                                      ),
                                    ),
                                    Divider(
                                      height: 5.0,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0,
                                            top: 16.0,
                                            bottom: 16.0,
                                            right: 16.0),
                                        child: HtmlWidget(
                                            notificationDetailController
                                                .detail?.title ??'',
                                            enableCaching: false,
                                            textStyle: TextStyle(
                                                fontSize: AppFont.fontSize16))),
                                    Visibility(
                                        visible: notificationDetailController
                                                .detail?.content?.length >
                                            0,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0,
                                                top: 16.0,
                                                bottom: 16.0,
                                                right: 16.0),
                                            child: !notificationDetailController
                                                    .isHTMLContent
                                                ? Text(notificationDetailController.detail?.content,
                                                    style: TextStyle(
                                                        fontSize:
                                                            AppFont.fontSize16))
                                                : HtmlWidget(
                                                    notificationDetailController
                                                        .detail?.content,
                                                    enableCaching: false,
                                                    onTapUrl: (url) async {
                                                    if (await canLaunchUrl(
                                                        Uri.parse(url))) {
                                                      await launchUrl(
                                                          Uri.parse(url));
                                                    } else {
                                                      await WidgetCommon
                                                          .showSnackbarErrorGet(
                                                              'Không thể mở trang');
                                                    }
                                                    return true;
                                                  },
                                                    textStyle:
                                                        TextStyle(fontSize: AppFont.fontSize16)))),
                                  ],
                                ),
                              )
                            : Center(child: WidgetCommon.buildCircleLoading())
                      ],
                    ),
                  ))));
    } catch (e) {
      print(e);
      return NoDataWidget();
    }
  }
}
