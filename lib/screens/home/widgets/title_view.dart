import 'package:flutter/material.dart';

import '../../../common/constants/color.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final VoidCallback? action;
  const TitleView(
      {Key? key, this.titleTxt = "", this.subTxt = "", required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                titleTxt,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: AppColor.black,
                ),
              ),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              onTap: action,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      subTxt,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: AppColor.primary),
                    ),
                    SizedBox(
                        height: 38,
                        width: 26,
                        child: Visibility(
                            child: Icon(
                              Icons.arrow_forward,
                              color: AppColor.primary,
                              size: 18,
                            ),
                            visible: subTxt != '')),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
