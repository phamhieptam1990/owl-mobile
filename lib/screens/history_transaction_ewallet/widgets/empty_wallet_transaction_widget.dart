import 'package:flutter/material.dart';

import '../../../common/config/fonts.dart';
import '../../../generated/l10n.dart';

class EmptyDataWidget extends StatelessWidget {
  final Function onRefresh;
  const EmptyDataWidget({Key? key, required this.onRefresh})
      : super(key: key);

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
        ],
      ),
    );
  }
}
