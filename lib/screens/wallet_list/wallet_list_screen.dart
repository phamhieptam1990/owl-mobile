import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athena/generated/l10n.dart';

import '../../widgets/common/appbar.dart';
import 'wallet_list_controller.dart';
import 'widgets/wallet_fake_loading.dart';
import 'widgets/wallet_item_widget.dart';
import 'widgets/wallet_list_failed.dart';

class WalletListScreen extends StatefulWidget {
  const WalletListScreen({Key? key}) : super(key: key);

  @override
  _WalletListScreenState createState() => _WalletListScreenState();
}

class _WalletListScreenState extends State<WalletListScreen>
    with WidgetsBindingObserver {
   WalletListController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = Get.put(WalletListController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommon(
        title: S.of(context).moneySources,
        lstWidget: const [],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    //   return GetBuilder<WalletListController>(
    //   init: _controller,
    //   builder: (controller) {
    //     if (controller.resultLoaded == WalletListResult.loading ||
    //         controller.resultLoaded == WalletListResult.initialize) {
    //       return const WalletFakeLoadingWidget();
    //     }
    //     if (controller.resultLoaded == WalletListResult.failed) {
    //       return WalletListFailed(
    //           onRefresh: () => controller.getAllByEmpCode());
    //     }

    //     // Check if allByEmpCodeResponse or data are null
    //     if (controller.allByEmpCodeResponse?.data == null) {
    //       return Center(child: Text(S.of(context).noDataFound));
    //     }

    //     return RefreshIndicator(
    //       onRefresh: () async {
    //         await controller.getAllByEmpCode();
    //       },
    //       child: controller.allByEmpCodeResponse.data.isEmpty
    //         ? Center(child: Text(S.of(context).noDataFound))
    //         : ListView.builder(
    //             itemCount: controller.allByEmpCodeResponse.data.length,
    //             itemBuilder: ((context, index) => WalletItemWidget(
    //                 data: controller.allByEmpCodeResponse.data[index])),
    //           ),
    //     );
    //   },
    // );
    return Container();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        _controller?.onResumeApp();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  void onResumedApp() {
    _controller?.onResumeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

enum WalletStatus { linked, processing, unlink }
