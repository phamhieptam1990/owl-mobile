import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';

import '../../../common/config/fonts.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/nice_button_widget.dart';

class WalletListFailed extends StatelessWidget {
  final Function onRefresh;
  const WalletListFailed({Key? key, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh.call();
        Future.value();
      },
      child: ListView(
        children: [
          SizedBox(
            height: 80,
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/empty-box.png",
              width: 150.0,
              height: 150,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              S.of(context).dataEmpty,
              style: TextStyle(
                  fontSize: AppFont.fontSize16, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Column(
            children: [
              NiceButtons(
                stretch: false,
                borderRadius: 16,
                startColor: AppColor.primary.withOpacity(.5),
                endColor: AppColor.primary,
                borderColor: AppColor.primary.withOpacity(.2),
                gradientOrientation: GradientOrientation.Vertical,
                onTap: (finish) {
                  onRefresh.call();
                },
                child: Text(
                  'Tải lại',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
