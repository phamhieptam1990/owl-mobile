import 'package:after_layout/after_layout.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/notifications/notification.model.dart' as model;
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/notification/notification-detail.screen.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'notification.controller.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:athena/utils/app_state.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AfterLayoutMixin, AutomaticKeepAliveClientMixin<NotificationScreen> {
  final notificationController = Get.put(NotificationController());
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'NotificationScreen');

  bool unreadFilter = false;

  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (notificationController.notificationProvider.lstNoticationModel.length >
            0 &&
        !notificationController.notificationProvider.isFirstEnter) {
      return;
    }
    await notificationController.handleRequestData(isUnread: unreadFilter);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Future<void> _onRefresh() async {
    try {
      notificationController.notificationProvider.lstNoticationModel = [];
      notificationController.notificationProvider.currentPage = 1;
      notificationController.notificationProvider.isFirstEnter = true;
      notificationController.updateScreen();
      await this
          .notificationController
          .notificationProvider
          .getCountNotification();
      await this
          .notificationController
          .handleRequestData(isUnread: unreadFilter);
      _refreshController.refreshCompleted();
    } catch (e) {
    } finally {
      // setState(() {});
    }
  }

  void _onLoading() async {
    try {
      if (mounted) {
        await this
            .notificationController
            .handleRequestData(isUnread: unreadFilter);
      }
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  Widget buildTitle(BuildContext context) {
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(S.of(context).Notification +
                " (" +
                notificationController
                    .notificationProvider.countNotificationUnread
                    .toString() +
                ")"),
            Expanded(
              child: CheckboxListTile(
                title: Text(
                  "Chưa đọc",
                  style: TextStyle(
                      color: AppColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),

                value: unreadFilter,
                contentPadding: EdgeInsets.only(left: 10),
                onChanged: _onFilterChanged,
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            )
          ],
        ),
      ),
    );
  }

    void _onFilterChanged(bool? newValue) async {
    if (newValue == null) return;
    
    setState(() {
      unreadFilter = newValue;
    });

    notificationController.notificationProvider.lstNoticationModel = [];
    notificationController.notificationProvider.currentPage = 1;
    notificationController.notificationProvider.isFirstEnter = true;
    await notificationController.handleRequestData(isUnread: unreadFilter);
  }

  Widget buildItemListView(int index) {
    model.NotificationModel notif = notificationController
        .notificationProvider.lstNoticationModel
        .elementAt(index);
    return GetBuilder<NotificationController>(
        id: 'NotiticationItem',
        builder: (_) => Container(
                child: InkWell(
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                        Utils.checkIsNotNull(notif.from) ? notif.from![0] : "I",
                        style: TextStyle(color: AppColor.white)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  title: buildTitleList(notif),
                ),
              ),
              onTap: () {
                try {
                  if (notificationController
                          .notificationProvider.lstNoticationModel
                          .elementAt(index)
                          .unread ==
                      1) {
                    notificationController
                        .notificationProvider.lstNoticationModel
                        .elementAt(index)
                        .unread = 0;
                    if (notificationController
                            .notificationProvider.getCountNotificationUnread >
                        0) {
                      notificationController.notificationProvider
                          .setCountNotificationUnread(notificationController
                                  .notificationProvider
                                  .getCountNotificationUnread -
                              1);
                      eventBus.fire(ReloadNotification('ReloadNotification'));
                      FlutterAppBadge.count(notificationController
                          .notificationProvider.getCountNotificationUnread);
                      //  AwesomeNotifications()
                      //     .setGlobalBadgeCounter(notificationController
                      //     .notificationProvider.getCountNotificationUnread);
                    }
                    if (!MyConnectivity.instance.isOffline) {
                      this
                          .notificationController
                          .notificationService
                          .updateRead(notif.aggId ?? '', 0);
                    }
                    setState(() {});
                    notificationController.updateNotificationItem();
                  }
                  if (Utils.checkIsNotNull(notif.title)) {
                    Get.to(() => NotificationDetailScreen(notif));
                  }

                  // NavigationService.instance.navigateToRoute(MaterialPageRoute(
                  //   builder: (context) =>
                  //       NotificationDetailScreen(notificationDetail: notif),
                  // ));
                } catch (e) {
                  print(e);
                }
              },
            )));
  }

  Widget buildTitleList(model.NotificationModel notif) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Text(
                  notif.createdTime != null
                      ? Utils.convertTime(notif.createdTime as int )
                      : "",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: AppColor.blackOpacity06))),
          Padding(
              padding: EdgeInsets.all(0.0),
              child: Container(
                height: 40,
                child: Utils.checkIsNotNull(notif.title)
                    ? HtmlWidget(notif.title!,
                        textStyle: TextStyle(
                            fontWeight: (notif.unread == 1)
                                ? FontWeight.bold
                                : FontWeight.normal))
                    : Text(''),
              )),
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(notif.from ?? '',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: AppColor.blackOpacity06)))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: buildTitle(context),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Utils.pushName(context, RouteList.SEARCH_SCREEN);
              },
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 58, 184, 62),
                  Color.fromARGB(255, 38, 134, 45),
                  Color.fromARGB(255, 6, 51, 9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
        ),
        body: GetBuilder<NotificationController>(
            id: 'NotificationScreen',
            builder: (_) => Container(
                height: AppState.getHeightDevice(context),
                width: AppState.getWidthDevice(context),
                child: buildBodyView())));
  }

  Widget buildBodyView() {
    if (notificationController.notificationProvider.isFirstEnter) {
      return Container(
          height: AppState.getHeightDevice(context),
          width: AppState.getWidthDevice(context),
          child: ShimmerCheckIn());
    }
    if (notificationController.notificationProvider.lstNoticationModel.length ==
        0) {
      return NoDataWidget(
        callback: () async {
          await this._onRefresh();
        },
      );
    }
    return buildListView();
  }

  Widget buildListView() {
  return SmartRefresher(
    enablePullDown: true,
    enablePullUp: this.notificationController.enablePullUp,
    footer: CustomFooter(
      builder: (BuildContext context, LoadStatus? status) {
        Widget body;
        if (status == LoadStatus.idle) {
          body = Text("pull up load");
        } else if (status == LoadStatus.loading) {
          body = CupertinoActivityIndicator();
        } else if (status == LoadStatus.failed) {
          body = Text("Load Failed!Click retry!");
        } else if (status == LoadStatus.canLoading) {
          body = Text("release to load more");
        } else {
          body = Text("No more Data");
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    ),
    controller: _refreshController,
    onRefresh: _onRefresh,
    onLoading: _onLoading,
    child: ListView.builder(
      itemBuilder: (c, i) => buildItemListView(i),
      itemCount: notificationController
          .notificationProvider.lstNoticationModel.length,
    ),
  );
}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
