import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';

abstract class BaseModel {
  Widget buildTitle(BuildContext context);
}

class DrowdownListBottomSheet extends StatefulWidget {
  final List<BaseModel>? values;
  final double? height;
  final String? title;
  final Function(BaseModel)? onSelected;
  DrowdownListBottomSheet(
      {Key?  key,
      required this.values,
      this.onSelected,
      this.title = '',
      this.height})
      : super(key: key);

  @override
  _DrowdownListBottomSheetState createState() =>
      _DrowdownListBottomSheetState();
}

class _DrowdownListBottomSheetState extends State<DrowdownListBottomSheet> {
  @override
  Widget build(BuildContext context) {
    double valueHeight = MediaQuery.of(context).size.height * 0.7;
    return  Container(
        height: widget.height ?? valueHeight,
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: AppColor.appBarOn,
              //   border: null, // tắt viền mờ
                // bật nền solid
                // backgroundColor: AppColor.primary,
                leading: InkWell(
                  child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                middle: Text(
                  widget.title ?? '',
                  style: TextStyle(color: Colors.black),
                )),
            child: SafeArea(
      child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 7),
                itemBuilder: (c, i) => buildEachItemListView(widget.values!, i),
                itemCount: widget?.values?.length ?? 0,
                separatorBuilder: (c, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        child: new Center(
                          child: new Container(
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    )))),
      
    );
  }

  Widget buildEachItemListView(List<BaseModel> lst, int index) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        widget.onSelected?.call(lst[index]);
      },
      contentPadding:
          EdgeInsets.only(left: 12.0, right: 8.0, top: 0.0, bottom: 0.0),
      title: lst[index].buildTitle(context),
    );
  }
}
