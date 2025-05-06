import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';

import '../../utils/storage/storage_helper.dart';
import 'app_progress_loading.dart';
import 'general.dart';

class AvatarImgNetwork extends StatelessWidget {
  AvatarImgNetwork({
    Key? key,
    required this.baseImgUrl,
    required this.identify,
    this.errorWidget,
    this.fit,
    this.isShowProgress = true,
    this.hasIdentifyer = true,
  }) : super(key: key);
  
  final String identify;
  final String baseImgUrl;
  final bool isShowProgress;
  final bool hasIdentifyer;
  final BoxFit? fit;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>?>(
      future: _initHttpHeader(),
      builder: (context, snapshot) {
        return Visibility(
          visible: snapshot.data != null &&
              (snapshot.connectionState != ConnectionState.none),
          child: CachedNetworkImage(
            imageUrl: getUrl(hasIdentifyer),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                isShowProgress
                    ? Container(
                        alignment: Alignment.center,
                        child: CircularPercentIndicator(
                          radius: 36,
                          percent: downloadProgress.progress ?? .25,
                          progressColor: AppColor.primary,
                          backgroundColor: Colors.grey.shade600,
                        ),
                      )
                    : const SizedBox(),
            httpHeaders: snapshot.data ?? {},
            fit: fit,
            errorWidget: errorWidget ?? _buildDefaultErrors,
            // cacheKey: identify,
          ),
        );
      },
    );
  }

  Future<Map<String, String>?> _initHttpHeader() async {
    final String _storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';

    if (_storageToken.isNotEmpty &&
        identify.isNotEmpty &&
        baseImgUrl.isNotEmpty) {
      return {
        'Authorization': 'Bearer $_storageToken'
      };
    }
    return null;
  }

  Widget _buildDefaultErrors(BuildContext context, String url, dynamic error) {
    return Container(child: const Icon(Icons.error));
  }

  String getUrl(bool hasIdentifier) {
    return baseImgUrl + (hasIdentifier ? 'identifer=' : '') + identify;
  }
}