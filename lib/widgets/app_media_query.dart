import 'package:flutter/material.dart';

class AppMediaQuery extends StatelessWidget {
  const AppMediaQuery({required this.child, this.showBanner = false});
  final Widget child;
  final bool showBanner;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          child,
          showBanner
              ? Banner(
                  message: 'Uat',
                  color: Colors.red,
                  location: BannerLocation.topEnd,
                )
              : Container()
        ],
      ),
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
    );
  }
}
