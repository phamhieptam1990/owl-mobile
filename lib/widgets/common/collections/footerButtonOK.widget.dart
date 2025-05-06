import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';

class FooterButonOKWidget extends StatelessWidget {
  final Function callbackOK;
  FooterButonOKWidget({
    Key? key,
    required this.callbackOK,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: MaterialButton(
          onPressed: () async {
            callbackOK();
          },
          color: Theme.of(context).primaryColor,
          child: Text(
            S.of(context).update,
            style: TextStyle(color: AppColor.white),
          ),
        ))
      ],
    );
  }
}
