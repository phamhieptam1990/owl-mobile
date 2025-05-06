import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';

ButtonState stateButtonOnlyText = ButtonState.idle;

// ignore: must_be_immutable
class LoadingButtonWidget extends StatefulWidget {
  final Function callbackOK;
  String title = '';
  final double height;
  LoadingButtonWidget(
      {Key? key, required this.callbackOK, required this.title, required this.height})
      : super(key: key);
  @override
  _LoadingButtonWidgetState createState() => _LoadingButtonWidgetState();
}

class _LoadingButtonWidgetState extends State<LoadingButtonWidget>
    with AfterLayoutMixin {
  Widget buildCustomButton() {
    if (widget.title == '') {
    widget.title = S.of(context).update;
  }
    var progressTextButton = ProgressButton(
        height: widget.height ?? 53,
        stateWidgets: {
          ButtonState.idle: Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          ButtonState.loading: Text(
            "Loading",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          ButtonState.fail: Text(
            "Fail",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          ButtonState.success: Text(
            "Success",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          )
        },
        stateColors: {
          ButtonState.idle: Theme.of(context).primaryColor,
          ButtonState.loading: AppColor.blue,
          ButtonState.fail: Colors.red.shade300,
          ButtonState.success: Colors.green.shade400,
        },
        onPressed: onPressedCustomButton,
        state: stateButtonOnlyText,
        padding: EdgeInsets.all(8.0));
    return progressTextButton;
  }

  void onPressedCustomButton() async {
    if (stateButtonOnlyText == ButtonState.loading) {
      return;
    }
    await widget.callbackOK();
  }

  @override
  Widget build(BuildContext context) {
    return buildCustomButton();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    stateButtonOnlyText = ButtonState.idle;
  }

  @override
  void dispose() {
    stateButtonOnlyText = ButtonState.idle;
    super.dispose();
  }
}
