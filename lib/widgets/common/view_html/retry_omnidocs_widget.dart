import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';

class RetryOmnidocsWidget extends StatefulWidget {
  final Function? onRetry;
  const RetryOmnidocsWidget({Key? key, this.onRetry}) : super(key: key);

  @override
  State<RetryOmnidocsWidget> createState() => _RetryOmnidocsWidgetState();
}

class _RetryOmnidocsWidgetState extends State<RetryOmnidocsWidget> {
  Timer? _timer;
  int _start = 15;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/retry_img.png",
              width: 100.0,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: AppColor.grey),
                  children: [
                    TextSpan(
                        text: 'Số lượng truy cập đang quá tải.\nVui lòng nhấn ',
                        style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.normal,
                            color: AppColor.grey)),
                    TextSpan(
                        text: 'Thử lại',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (_start == 0) {
                              widget.onRetry?.call();
                            }
                          },
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: _start != 0 ? AppColor.grey : AppColor.blue),
                        children: _start != 0 ? [] : []),
                    _start != 0
                        ? TextSpan(
                            text: ' sau ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                color: AppColor.grey),
                            children: [
                                TextSpan(
                                    text: '$_start',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.orange)),
                                TextSpan(
                                    text: ' giây!',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.normal,
                                        color: AppColor.grey)),
                              ])
                        : TextSpan(
                            text: '.',
                            style: TextStyle(
                                fontSize: 22,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: AppColor.grey),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
          ],
        ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
