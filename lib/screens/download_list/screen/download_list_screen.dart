import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/download_list/models/download_list_response.dart';
import 'package:athena/screens/download_list/services/download_list_controller.dart';
import 'package:athena/screens/download_list/services/download_list_services.dart';
import 'package:athena/screens/download_list/widgets/checkin_item_widget.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';

class DownloadListScreen extends StatefulWidget {
  DownloadListScreen({Key? key}) : super(key: key);

  @override
  _DownloadListScreenState createState() => _DownloadListScreenState();
}

class _DownloadListScreenState extends State<DownloadListScreen> {
  final DownloadListController downloadController =
      Get.put(DownloadListController());
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'downloadList');

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarCommon(
        title: 'Danh sách tải về',
        lstWidget: [],
      ),
      body: GetBuilder<DownloadListController>(
        init: downloadController,
        builder: (value) {
          if (value.isLoading) {
            return ShimmerCheckIn();
          }
          final checkinItems = value.data?.checkinItems;
          if (checkinItems == null || checkinItems.isEmpty) {
            return SmartRefresher(
                enablePullDown: true,
                onRefresh: _onRefresh,
                controller: _refreshController,
                child: NoDataWidget());
          }
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: value.enablePullUp,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            footer: CustomFooter(
              builder: (context, status) {
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
            child: ListView.separated(
                itemBuilder: (context, index) {
                    // Fix 14: Safe index access with bounds check
                    if (index >= checkinItems.length) {
                      return const SizedBox();
                    }
                    
                    return CheckinItemWidget(
                      value: checkinItems[index],
                      onTap: () => onDownload(checkinItems[index]),
                    );
                },
                separatorBuilder: (context, index) {
                  return Container();
                },
                itemCount: checkinItems.length),
          );
        },
      ),
    );
  }

  void _onRefresh() async {
    downloadController.currentPage = 0;
    downloadController.fetchData();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _onLoading() async {
    try {
      if (mounted) {
        await downloadController.onLoadmoreData();
      }
      _refreshController.loadComplete();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  void onDownload(CheckinItem data) async {
    WidgetCommon.showLoading(dismissOnTap: false);

    try {
      DownloadStatus status;
      if (data.jobName == 'GENERATE_VF_JOB') {
        status = await DownloadListServices.downloadVFList(data);
      } else if (data.jobName == 'GENERATE_TBKK_JOB') {
        status = await DownloadListServices.downloadTBKK(data);
      } else {
        status = await DownloadListServices.downloadCheckinItem(data);
      }

      if (status == DownloadStatus.successed) {
        WidgetCommon.dismissLoading();

        if (data.jobName == 'GENERATE_VF_JOB') {
          WidgetCommon.showSnackbar(
            _scaffoldKey,
            'Tải về thành công, Vui lòng kiểm tra trong thư mục ' +
                ((Platform.isAndroid ? '/Download/Athena' : 'visitForms')),
            backgroundColor: AppColor.appBar,
          );
          return;
        }

        if (data.jobName == 'GENERATE_TBKK_JOB') {
          WidgetCommon.showSnackbar(
            _scaffoldKey,
            'Tải về thành công, Vui lòng kiểm tra trong thư mục ' +
                ((Platform.isAndroid ? '/Download/Athena/' : 'TBKKs')),
            backgroundColor: AppColor.appBar,
          );
          return;
        }
        WidgetCommon.showSnackbar(
          _scaffoldKey,
          'Tải về thành công, Vui lòng kiểm tra trong thư mục ' +
              (Platform.isAndroid ? '/Download/Athena/' : 'downloads'),
          backgroundColor: AppColor.appBar,
        );
      }
      if (status == DownloadStatus.saveFileFailed) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(
            _scaffoldKey, 'Đã có lỗi xảy ra trong quá trình lưu file!');
      }
      if (status == DownloadStatus.callFailed) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(
            _scaffoldKey, 'Đã có lỗi xảy ra, vui lòng liên hệ phòng IT!');
      }
      if (status == DownloadStatus.noPerrmission) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(_scaffoldKey,
            'Vui lòng cung cấp quyền lưu trữ để thực hiện tính năng này');
      }
    } catch (_) {
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(
          _scaffoldKey, 'Đã có lỗi xảy ra, vui lòng liên hệ phòng IT!');
    }
  }
}
