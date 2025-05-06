import 'package:flutter/material.dart';
import 'package:athena/widgets/common/container/boxDecoration.dart';

class MenuItem extends StatelessWidget {
  final ProfileMenu menu;
  final bool checkSwitch;
  MenuItem({required this.menu, this.checkSwitch = false});
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return InkWell(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Container(
            height: deviceSize.height * 0.09,
            decoration: CustomDecorations().baseDecoration(
                Color(0xFFD1DCFF), 20.0, 5.0, Colors.white, 20.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: menu.iconColor,
                        ),
                        child: Icon(
                          menu.icon,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              menu.title,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              menu.subTitle,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFFC4C5C9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Color(0xFFC4C5C9),
                  )
                ],
              ),
            ),
          ),
        ),
        onTap: menu.action);
  }
}

class ProfileMenu {
  String title;
  String subTitle;
  IconData icon;
  Color iconColor;
  dynamic action;
  ProfileMenu(
      {required this.icon, required this.title, required this.iconColor, required this.subTitle, required this.action});
}

const Color profile_info_background = Color(0xFF3775FD);
const Color profile_info_categories_background = Color(0xFFF6F5F8);
const Color profile_info_address = Color(0xFF8D7AEE);
const Color profile_info_privacy = Color(0xFFF369B7);
const Color profile_info_general = Color(0xFFFFC85B);
const Color profile_info_notification = Color(0xFF5DD1D3);
const Color profile_item_color = Color(0xFFC4C5C9);
