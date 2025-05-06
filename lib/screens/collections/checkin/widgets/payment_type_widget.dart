import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athena/common/constants/color.dart';

import '../../../../common/constants/cache_image_manage_key.dart';
import '../../../../models/wallet_list/overral_by_emp_code_with_balance.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/spinning_line_widget.dart';
import '../../../wallet_list/wallet_type_list_controller.dart';

class PaymentTypeWidget extends StatelessWidget {
  final OverallByEmpCodeWithBalanceData currentSelection;
  final Function(OverallByEmpCodeWithBalanceData) onSelection;
  final String title;
  final List payment;

  PaymentTypeWidget(
      {Key? key,
      required this.currentSelection,
      required this.title,
      required this.payment,
      required this.onSelection})
      : super(key: key);
  final globalScaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final _controller =
        Get.put<WalletTypeListController>(WalletTypeListController());
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GetBuilder<WalletTypeListController>(
            init: _controller,
            builder: (controller) => Container(
              height: Get.height * 60 / 100,
              width: double.infinity,
              child: Scaffold(
                key: globalScaffoldKey,
                backgroundColor: Colors.transparent,
                body: Container(
                  decoration: _componentStyle(),
                  child: Column(
                    children: [buildHeader(context), _buildBody(context)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _componentStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(20),
        topLeft: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x25606060),
          offset: Offset(2, -4.0),
          blurRadius: 2.0,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final _controller = Get.find<WalletTypeListController>();

    return GetBuilder<WalletTypeListController>(
      init: _controller,
      builder: (controller) {
        if (controller.resultLoaded == WalletTypeListResult.initialize ||
            controller.resultLoaded == WalletTypeListResult.loading) {
          return _buildLoading(context);
        }
        return Expanded(
            child: ListView.separated(
                itemBuilder: (contex, index) {
                  return _buildItem(_controller, index, contex, controller);
                },
                separatorBuilder: (_, __) => SizedBox(
                      height: 10,
                    ),
                itemCount: _controller.empCodeWithBalanceDatas.length ?? 0));
      },
    );
  }

  Expanded _buildLoading(BuildContext context) {
    return Expanded(
      child: Center(
        child: Align(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: SpinKitSpinningLines(
              color: AppColor.primary,
              duration: Duration(milliseconds: 2200),
            ),
          ),
        ),
      ),
    );
  }

  Opacity _buildItem(WalletTypeListController _controller, int index,
      BuildContext contex, WalletTypeListController controller) {
    return Opacity(
      opacity:
          _controller.empCodeWithBalanceDatas[index].enableFocus ? 1.0 : 0.6,
      child: InkWell(
        onTap: () => _onTapItem(contex, controller, index),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: AppColor.grey.withOpacity(.4),
                  offset: Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Container(
                child: Row(
                  children: [
                    _buildIcon(_controller.empCodeWithBalanceDatas[index]),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.empCodeWithBalanceDatas[index]
                                    .providerName ??
                                '',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          controller.empCodeWithBalanceDatas[index]
                                      .showBalance ??
                                  false
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, left: 0),
                                  child: Text(
                                    'Số dư: ' +
                                        Utils.formatPrice(
                                            controller
                                                    .empCodeWithBalanceDatas[
                                                        index]
                                                    .balance
                                                    .toString() ??
                                                '',
                                            hasVND: true),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[700]),
                                  ),
                                )
                              : SizedBox(),
                        ]),
                    Spacer(),
                    (currentSelection.providerCode ==
                            controller
                                .empCodeWithBalanceDatas[index].providerCode)
                        ? Icon(Icons.check, color: AppColor.primary)
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x25606060),
            offset: Offset(2, -4.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A5A5A),
                  fontSize: 16,
                  fontFamily: 'Roboto'),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 9, right: 19),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset('assets/images/ic_close.png'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildIcon(OverallByEmpCodeWithBalanceData data) {
    switch (data.getWalletType()) {
      case WalletType.smartPay:
        return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: CacheImageManage.smartpayImgUrl,
                cacheKey: CacheImageManage.smartpayKey,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Container(
                        margin: EdgeInsets.only(top: 60, bottom: 60),
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: AppColor.appBar)),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: AppColor.orange,
                  size: 30,
                ),
              ),
            ));

        break;
      default:
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset(_icPath(data.getWalletType())).image,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        );
    }
  }

  String _icPath(WalletType type) {
    switch (type) {
      case WalletType.smartPay:
        return 'assets/images/ic_smartpay.png';
        break;
      case WalletType.momo:
        return 'assets/images/ic_momo.png';
        break;

      case WalletType.moca:
        return 'assets/images/ic_moca.png';
        break;
      case WalletType.cash:
        return 'assets/images/ic_cash.png';
        break;

      default:
        return 'assets/images/ic_unknow.png';
    }
  }

  void _onTapItem(
      BuildContext context, WalletTypeListController controller, int index) {
    if (controller.empCodeWithBalanceDatas[index].enableFocus) {
      if (currentSelection.providerCode !=
          controller.empCodeWithBalanceDatas[index].providerCode) {
        Navigator.pop(context);
        onSelection.call(controller.empCodeWithBalanceDatas[index]);
      } else {
        Navigator.pop(context);
      }
    } else {
      if (!controller.isSnackbarActive) {
        final balance = controller.empCodeWithBalanceDatas[index].balance;
        
        controller.unAllowClick(
          balance == null
              ? 'Tài khoản chưa được xác thực.'
              : balance == 0
                  ? 'Tài khoản không đủ số dư.'
                  : '',
        );
      }
    }
  }
}

class PaymentTypeItem {
  PaymentType type;
  String balance;
  String title;

  PaymentTypeItem({
    required this.type,
    required this.title,
    required this.balance,
  });
}

enum PaymentType { smartpay, cash }
