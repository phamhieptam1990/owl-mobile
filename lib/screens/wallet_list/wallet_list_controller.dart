import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/models/events.dart';
import 'package:athena/utils/log/crashlystic_services.dart';
import 'package:athena/widgets/app_loading_widget.dart';

import '../../models/wallet_list/all_by_emp_code_response.dart';
import '../../models/wallet_list/link_payment_ewallet_response.dart';
import '../../models/wallet_list/query_link_payment_ewallet_response.dart';
import '../../models/wallet_list/unlink_smp_response.dart';
import '../../utils/navigation/navigation.service.dart';
import '../../widgets/common/common.dart';
import 'wallet_services.dart';

class WalletListController extends GetxController {
  AllByEmpCodeResponse? allByEmpCodeResponse = AllByEmpCodeResponse(data: [], status: -1);

  bool isLoading = false;

  // WalletListController._();

  // static final WalletListController _instance = WalletListController._();
  // static WalletListController get instance => _instance;

  // factory WalletListController() {
  //   return _instance;
  // }

  WalletListResult resultLoaded = WalletListResult.initialize;

  bool _hasLaunching = false;

  static  AllByEmpCodeData? currentLinkingData;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getAllByEmpCode();
    onAppSwith();

    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getAllByEmpCode({bool isLoading = true}) async {
    try {
      if (isLoading) {
        resultLoaded = WalletListResult.loading;
        update();
      }

      final response = await WalletLinkingServices.getAllByEmpCode();
      if (response == null) {
        resultLoaded = WalletListResult.failed;
        update();
        return;
      }
      
      allByEmpCodeResponse = AllByEmpCodeResponse.fromJson(response.data);
    if ((allByEmpCodeResponse?.data?.isNotEmpty ?? false) &&
          allByEmpCodeResponse?.status == 0) {
        resultLoaded = WalletListResult.successed;
      } else {
        resultLoaded = WalletListResult.failed;
      }
      this.isLoading = false;
      update();
    } catch (msg) {
      CrashlysticServices.instance.log(msg.toString());
      resultLoaded = WalletListResult.failed;
      update();
    }
  }

  void linkSMP(AllByEmpCodeData data) async {
    try {
      AppLoading.show();
      final response = await WalletLinkingServices.linkPaymentEwalletSMP(data);
      if(response != null && response.data != null){
      final responseData = LinkPaymentEwalletResponse?.fromJson(response.data);

        showFailed(title: '${responseData.data?.errorMessage}');
          getAllByEmpCode(isLoading: false);
      }
      AppLoading.dismiss();
    } catch (_) {
      showFailed(title: 'Đã có lỗi xảy ra!');
      await getAllByEmpCode(isLoading: false);
      AppLoading.dismiss();
    }
  }

  void unLinkPopup(AllByEmpCodeData data) {
    WidgetCommon.generateDialogOKCancelGet('Bạn có chắc muốn hủy liên kết ?',
        callbackOK: () async {
      await _unlinkSMP(data);
    });
  }

  Future<void> _unlinkSMP(AllByEmpCodeData data) async {
    try {
      AppLoading.show();
      final response = await WalletLinkingServices.unLinkSMP(data);
      final responseData = UnlinkSmpResponse.fromJson(response?.data);
      await getAllByEmpCode(isLoading: false);
      AppLoading.dismiss();
      showFailed(title: '${responseData.data.errorMessage}');
        } catch (msg) {
      CrashlysticServices.instance.log(msg.toString());
      AppLoading.dismiss();
    }
  }

  Future<void> updateStatusLinking(AllByEmpCodeData data,
      {bool isUpdateLauching = false}) async {
    try {
      AppLoading.show();
      final response = await WalletLinkingServices.updateStatusLinking(data);
      getAllByEmpCode(isLoading: false);
      if (response != null && response.statusCode! == 200) {
        QueryLinkPaymentEwalletResponse _response =
            QueryLinkPaymentEwalletResponse.fromJson(response?.data);
        String _msg = _response.data.errorMessage ?? '';
        if (_msg.isNotEmpty ?? false) {
          showFailed(title: _msg);
        } else {
          showSucess();
        }
      } else {
        showFailed();
      }
      AppLoading.dismiss();
    } catch (msg) {
      CrashlysticServices.instance.log(msg.toString());
      AppLoading.dismiss();
    }
  }

  Future<void> onAppSwith() async {
    eventBus.on<QueryStatusLinkingSMP>().listen(
      (_) async {
        await getAllByEmpCode(isLoading: false);
      },
    );
    // }
  }

  Future<void> onResumeApp() async {
    await getAllByEmpCode(isLoading: false);
  }

  Future<void> opUpdate(QueryStatusLinkingSMP event) async {
    // Future.delayed(Duration(milliseconds: 500), () async {
    //   AppLoading.show();
    //   isLoading = true;
    //   final response =
    //       await WalletLinkingServices.updateStatusLinking(currentLinkingData);

    //   final statusLinkingResponse =
    //       QueryLinkPaymentEwalletResponse.fromJson(response.data);
    //   if (statusLinkingResponse.data.status == 'S') {
    //     showSucess(title: 'Liên kết thành công');
    //   } else {
    //     showFailed(title: 'Liên kết thất bại');
    //   }
    //   await getAllByEmpCode(isLoading: false);
    //   AppLoading.dismiss();
    // });
  }

  void showFailed({String title = 'Làm mới thất bại!'}) {
    // final snackbar = new SnackBar(
    //   content: new Text(title ?? ''),
    //   duration: Duration(seconds: 2),
    //   backgroundColor: Colors.redAccent,
    // );
    // ScaffoldMessenger.of(
    //   NavigationService.instance.navigationKey.currentContext,
    // ).showSnackBar(snackbar);
  }

  void showSucess({String title = 'Làm mới thành công'}) {
    // final snackbar = new SnackBar(
    //   content: new Text(title ?? ''),
    //   duration: Duration(seconds: 2),
    //   backgroundColor: AppColor.primary,
    // );
    // ScaffoldMessenger.of(
    //   NavigationService.instance.navigationKey.currentContext,
    // ).showSnackBar(snackbar);
  }
}

enum WalletListResult { initialize, loading, failed, successed }
