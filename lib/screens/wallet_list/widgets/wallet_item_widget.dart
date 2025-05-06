import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/constants/cache_image_manage_key.dart';
import '../../../common/constants/color.dart';
import '../../../models/wallet_list/all_by_emp_code_response.dart';
import '../wallet_list_controller.dart';

class WalletItemWidget extends StatelessWidget {
  final AllByEmpCodeData data;
  final String cacheKey;
  WalletItemWidget({Key? key, required this.data, required this.cacheKey}) : super(key: key);

  final parentController = Get.find<WalletListController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildIconWallet(_icPath(data.walletType),
                cacheKey: _icCacheKey(data.walletType)),
            _buildContent(context),
            _showAction(data)
          ],
        ),
      ),
    );
  }

  Expanded _buildContent(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.providerName ?? '',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  data.statusCodeString ?? '',
                  style: TextStyle(
                      color: _statusColor(),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500),
                )
                // Chip(
                //     padding: EdgeInsetsDirectional.zero,
                //     backgroundColor: _statusColor(),
                //     label: Text(
                //       data?.statusCodeString ?? '',
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 10,
                //           fontWeight: FontWeight.w500),
                //     )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildIconWallet(String url, {String cacheKey = ''}) {
    return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: url,
            cacheKey: cacheKey,
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
  }

  String _icPath(WalletType type) {
    switch (type) {
      case WalletType.smartPay:
        return CacheImageManage.smartpayImgUrl;
        break;
      case WalletType.momo:
        return 'assets/images/ic_momo.png';
        break;

      case WalletType.moca:
        return 'assets/images/ic_moca.png';
        break;

      default:
        return 'assets/images/ic_unknow.png';
    }
  }

  String _icCacheKey(WalletType type) {
    switch (type) {
      case WalletType.smartPay:
        return CacheImageManage.smartpayKey;
        break;
      case WalletType.momo:
        return 'assets/images/ic_momo.png';
        break;

      case WalletType.moca:
        return 'assets/images/ic_moca.png';
        break;

      default:
        return 'assets/images/ic_unknow.png';
    }
  }

  Widget _showAction(AllByEmpCodeData data) {
    switch (data.statusCodeLinked) {
      case StatusCodeLinked.success:
        return _unlink();
        break;
      case StatusCodeLinked.unlink:
        return _linkNow();
        break;

      case StatusCodeLinked.failed:
        return _linkNowAgain();
        break;
      case StatusCodeLinked.processing:
        return _linking();
        break;

      default:
        return _linkNow();
    }
  }

  Color _statusColor() {
    switch (data.statusCodeLinked) {
      case StatusCodeLinked.success:
        return AppColor.primary;
        break;
      case StatusCodeLinked.processing:
        return Colors.amber[700]!;
        break;

      case StatusCodeLinked.failed:
        return AppColor.greyCopyWith(opacity: .7);
        break;

      case StatusCodeLinked.unlink:
        return AppColor.greyCopyWith(opacity: .7);
        break;

      default:
        return AppColor.black.withOpacity(.3);
    }
  }

  Widget _unlink() {
    return InkWell(
      onTap: onUnlink,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Tooltip(
            message: 'Hủy liên kết',
            child: Chip(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              avatar: Icon(
                Icons.link_off,
                size: 18,
                color: Colors.white,
              ),
              backgroundColor: Colors.amber[700],
              label: Text(
                'Hủy liên kết',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )),
    );
  }

  Widget _linkNow() {
    return InkWell(
      onTap: () => onLink(),
      child: Chip(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        avatar: Icon(
          Icons.add_link_outlined,
          size: 18,
          color: Colors.white,
        ),
        backgroundColor: Colors.green[600],
        label: Text(
          'Liên kết ngay',
          style: TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _linkNowAgain() {
    return InkWell(
      onTap: () => onLink(),
      child: Chip(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        avatar: Icon(
          Icons.add_link_outlined,
          size: 20,
          color: Colors.white,
        ),
        backgroundColor: Colors.green[600],
        label: Text(
          'Liên kết ngay',
          style: TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _linking() {
    return Row(
      children: [
        InkWell(
          onTap: onLinking,
          child: Chip(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            backgroundColor: Colors.green[600],
            avatar: Icon(
              Icons.refresh_sharp,
              size: 18,
              color: Colors.white,
            ),
            label: Text(
              'Làm mới ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  void onLinking() => parentController.updateStatusLinking(data);

  void onLink() => parentController.linkSMP(data);

  void onUnlink() => parentController.unLinkPopup(data);
}
