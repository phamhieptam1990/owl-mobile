import 'package:athena/widgets/common/common.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppBarCommon extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> lstWidget;
  final String? title;
  Color? backgroundColor;
  Color color;
  AppBarCommon(
      {Key? key,
      required this.lstWidget,
      this.title,
      this.backgroundColor,
      this.color = Colors.white
      // List<Widget> lstWidget,
      })
      : super(key: key);

  Widget buildTitle(BuildContext context) {
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              this.title ?? '',
              style: TextStyle(color: color),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
        key: key,
        title: buildTitle(context),
        backgroundColor: backgroundColor,
        actions: this.lstWidget);
  }

  @override
  Widget build(BuildContext context) {
    return buildAppBar(context);
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
