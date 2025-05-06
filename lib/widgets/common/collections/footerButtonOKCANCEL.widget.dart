import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/utils/utils.dart';

// ignore: must_be_immutable
class FooterButonOKCANCELWidget extends StatelessWidget {
  final Function callbackCancel;
  final Function callbackOK;
  String? titleOK;
  String? titleCancel;

  FooterButonOKCANCELWidget(
      {Key? key,
      required this.callbackCancel,
      required this.callbackOK,
      this.titleOK,
      this.titleCancel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (!Utils.checkIsNotNull(this.titleOK)) {
      this.titleOK = S.of(context).update;
    }
    if (!Utils.checkIsNotNull(this.titleCancel)) {
      this.titleCancel = S.of(context).cancel;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: MaterialButton(
          color: AppColor.blackOpacity,
          onPressed: () async {
            callbackCancel();
          },
          child: Text(
            this.titleCancel ?? '',
            style: TextStyle(color: AppColor.white),
          ),
        )),
        Expanded(
            child: MaterialButton(
          onPressed: () async {
            callbackOK();
          },
          color: Theme.of(context).primaryColor,
          child: Text(
            this.titleOK ?? '',
            style: TextStyle(color: AppColor.white),
          ),
        ))
      ],
    );
  }
}
