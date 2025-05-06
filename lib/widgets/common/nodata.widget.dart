import 'package:athena/common/config/fonts.dart';
import 'package:athena/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:athena/utils/utils.dart';

class NoDataWidget extends StatelessWidget {
  final VoidCallback? callback;
  const NoDataWidget({
    Key? key, 
    this.callback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 30.0),
        child: Center(
          child: InkWell(
            onTap: callback,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/empty-box.png",
                  width: 100.0,
                ),
                Text(
                  S.of(context).dataEmpty,
                  style: TextStyle(fontSize: AppFont.fontSize16),
                ),
                SizedBox(
                  height: 10,
                ),
                // InkWell(
                //     onTap: () async {
                //       // this.callback();
                //     },
                //     child: Text(
                //       S.of(context).tapToRefresh,
                //       style: TextStyle(
                //           fontSize: AppFont.fontSize20, color: AppColor.primary),
                //     )
                // )
              ],
            ),
          ),
        ));
  }
}
