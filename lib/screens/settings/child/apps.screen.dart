import 'package:athena/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'browser.screen.dart';
import 'package:get/get.dart';
import '../setting.controller.dart';

class AppsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appsController = Get.put(AppsController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Ứng dụng - Chức năng'),
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
      ),
      body: SafeArea(
        child: Container(
            height: AppState.getHeightDevice(context),
            width: AppState.getWidthDevice(context),
            child: GetBuilder<AppsController>(
                id: 'AppsController',
                builder: (_) => ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: appsController.lstApps.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(appsController.lstApps[index].title),
                        contentPadding: EdgeInsets.all(8.0),
                        onTap: () async {
                          final token = await StorageHelper.getString(
                                  AppStateConfigConstant.JWT) ??
                              '';
                          String page =
                              appsController.lstApps[index].page ?? '';
                          final link =
                              appsController.lstApps[index].link + page + token;
                          // '?tokenAu=' +
                          // token;
                          await playWeb(
                              link, appsController.lstApps[index].title);
                        },
                      );
                    }))),
      ),
    );
  }

  Future<void> playWeb(link, title) async {
    Get.to(() => BrowserScreen(url: link, title: title));
  }

  Future<void> playPolicy(link, title, type) async {
    await this.playWeb(link, title);
  }
}
