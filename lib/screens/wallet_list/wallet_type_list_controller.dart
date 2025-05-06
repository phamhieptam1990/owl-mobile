import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/wallet_list/overral_by_emp_code_with_balance.dart';
import '../../utils/log/crashlystic_services.dart';
import '../../utils/navigation/navigation.service.dart';

class WalletTypeListController extends GetxController {
  WalletTypeListResult resultLoaded = WalletTypeListResult.initialize;
  bool isSnackbarActive = false;

  List<OverallByEmpCodeWithBalanceData> empCodeWithBalanceDatas = [
    OverallByEmpCodeWithBalanceData(
        providerCode: "CASH",
        providerName: 'Tiền mặt',
        tenantCode: 'FECREDIT',
        appCode: 'VYMO',
        methodCode: 'CASH',
        methodName: 'Tiền mặt'),
  ].obs;
  @override
  void onInit() {
    getOverallByEmpCodeWithBalance();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getOverallByEmpCodeWithBalance({bool isLoading = true}) async {
    try {
      if (isLoading) {
        resultLoaded = WalletTypeListResult.loading;
        update();
      }

      // final response =
      //     await WalletLinkingServices.getOverallByEmpCodeWithBalance();
      // final balanceResponse =
      //     OverallByEmpCodeWithBalanceResponse.fromJson(response?.data);

      // if ((balanceResponse?.data?.isNotEmpty ?? false) &&
      //     balanceResponse.status == 0) {
      //   empCodeWithBalanceDatas = balanceResponse?.data;
      //   resultLoaded = WalletTypeListResult.successed;
      // } else {
      //   resultLoaded = WalletTypeListResult.failed;
      // }
      resultLoaded = WalletTypeListResult.successed;
      isLoading = false;
      update();
    } catch (msg) {
      CrashlysticServices.instance.log(msg.toString());
      resultLoaded = WalletTypeListResult.failed;
      update();
    }
  }

  void unAllowClick([String title = '']) {
    isSnackbarActive = true;

    final snackbar = new SnackBar(
      content: new Text(title ?? 'Vui lòng liên kết ví để thực hiện.'),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.redAccent,
    );
    final context = NavigationService.instance.navigationKey.currentContext;
    if (context != null && isSnackbarActive) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbar)
          .closed
          .then((value) => isSnackbarActive = false);
    } else {
      // Reset flag if we couldn't show the snackbar
      isSnackbarActive = false;
    }
  }
}

enum WalletTypeListResult { initialize, loading, failed, successed }
