import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';

import '../../utils/storage/storage_helper.dart';
import 'app_progress_loading.dart';

class AppCacheImage extends StatefulWidget {
  const AppCacheImage({
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
  State<AppCacheImage> createState() => _AppCacheImageState();
}

class _AppCacheImageState extends State<AppCacheImage> {
  Map<String, String>? httpHeader;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100),
        () => setState(() => httpHeader = _initHttpHeader()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: httpHeader != null,
      child: CachedNetworkImage(
        imageUrl: getUrl(widget.hasIdentifyer),
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            widget.isShowProgress
                ? Container(
                    alignment: Alignment.center,
                    child: CircularPercentIndicator(
                      radius: 36,
                      percent: downloadProgress.progress ?? .25,
                      progressColor: AppColor.primary,
                      backgroundColor: Colors.grey[600] ?? Colors.grey,
                    ),
                  )
                : const SizedBox(),
        httpHeaders: _initHttpHeader() ?? {},
        fit: widget.fit,
        errorWidget: widget.errorWidget ?? _buildDefaultErrors,
        cacheKey: widget.identify,
      ),
    );
  }

  Map<String, String>? _initHttpHeader() {
    final String _storageToken = StorageHelper.getStorageToken();
    if (_storageToken.isNotEmpty && 
        widget.identify.isNotEmpty &&
        widget.baseImgUrl.isNotEmpty) {
      return {
        'Authorization': 'Bearer $_storageToken'
      };
    }
    return null;
  }

  Widget _buildDefaultErrors(BuildContext context, String _, dynamic __) {
    return Container(child: const Icon(Icons.error));
  }

  String getUrl(bool hasIdentifier) {
    return widget.baseImgUrl +
        (hasIdentifier ? 'identifier=' : '') +
        widget.identify;
  }
}