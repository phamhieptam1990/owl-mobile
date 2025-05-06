import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/screens/collections/detail/models/comment_by_contract_response.dart';
import 'package:athena/screens/collections/detail/models/comment_type_list_response.dart';

class RatingKalapaInfo extends StatefulWidget {
  final List<CommentTypeList> list;

  final String servicesName;
  final String title;
  final CommentByContractIdData commentByContractIdData;

  final Function(CommentTypeList, String) onSubmit;

  RatingKalapaInfo(
      {Key? key,
      required this.list,
      required this.commentByContractIdData,
      this.servicesName = 'Thông tin kênh:',
      required this.onSubmit,
      this.title = 'Đánh giá'})
      : super(key: key);

  @override
  _RatingKalapaInfoState createState() => _RatingKalapaInfoState();
}

class _RatingKalapaInfoState extends State<RatingKalapaInfo> {
  CommentTypeList? _currentData;
  TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _switchValue = false;

  @override
  void initState() {
    // _currentData = widget.list.firstWhere((element) =>
    //     element.id == widget.commentByContractIdData.cstbCommentType.id);
    // _textEditingController.text =
    //     widget.commentByContractIdData.description;
    setState(() {});
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x25606060),
                    offset: Offset(2, -4.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildHeader(),
                  SizedBox(
                    height: 20,
                  ),
                  buildEditSwith(),
                  SizedBox(
                    height: 10,
                  ),
                  // buildTitleServiceName(),
                  Column(
                    children: generateRatingItem(_enableEdit()),
                  ),
                  buildInputOtherType(_enableEdit()),
                  SizedBox(
                    height: 20,
                  ),
                  buildBottomButton(_enableEdit()),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasPreviousData =>
      widget.commentByContractIdData != null ? true : false;

  bool _enableEdit() {
    if (_hasPreviousData) {
      if (_switchValue) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Widget buildEditSwith() {
    return Visibility(
      visible: _hasPreviousData,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Tôi muốn cập nhật đánh giá:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
            CupertinoSwitch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputOtherType(bool enableEdit) {
    return Visibility(
      visible: _currentData?.otherFlg == 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: TextFormField(
              controller: _textEditingController,
              enabled: enableEdit,
              decoration: new InputDecoration(
                labelText: "Vui lòng nhập thêm thông tin *",
                fillColor: AppColor.appBar,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(16.0),
                  borderSide: new BorderSide(),
                ),
              ),
              keyboardType: TextInputType.multiline,
              validator: (value) => value?.isEmpty == true ? 'Nội dung bắt buộc' : null,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
              minLines: 2,
              maxLines: 4,
              textInputAction: TextInputAction.done),
        ),
      ),
    );
  }

  Widget buildTitleServiceName() {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.servicesName ?? '',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF5A5A5A),
              fontSize: 18,
              fontFamily: 'Roboto'),
        ),
      ),
    );
  }

  Widget buildBottomButton(bool enabelRating) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Đóng".toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            style: ButtonStyle(
                padding:
                    WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                backgroundColor:
                    WidgetStateProperty.all<Color>(Color(0xFFF2F2F2)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
          ),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ElevatedButton(
            onPressed: () {
              if (enabelRating == false) {
              } else {
                if (_currentData?.otherFlg == 1) {
                  final form = _formKey.currentState;
                  if (form != null && form.validate()) {
                    Navigator.of(context).pop();
                    widget.onSubmit(
                        _currentData!, _textEditingController.text);
                  }
                } else {
                  Navigator.of(context).pop();
                  widget.onSubmit
                      .call(_currentData!, _textEditingController.text);
                }
              }
            },
            child: Text("Cập nhật".toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            style: ButtonStyle(
                padding:
                    WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(
                    enabelRating == true ? AppColor.appBar : Colors.grey.shade600),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: AppColor.appBar)))),
          ),
        )),
      ],
    );
  }

  List<Widget> generateRatingItem(bool enableRating) {
    return widget.list
        .map(
          (e) => ListTile(
            onTap: () {
              if (enableRating) {
                if (_currentData != e) {
                  setState(() {
                    _currentData = e;
                    _textEditingController.text = '';
                  });
                }
              } else {
                return;
              }
            },
            title: Text(
              '${e.name ?? ''}',
              style: enableRating == true
                  ? (e.id == _currentData?.id
                      ? TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)
                      : TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.normal))
                  : (e.id == _currentData?.id
                      ? TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold)
                      : TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.normal)),
            ),
            leading: Radio<CommentTypeList>(
                activeColor: enableRating ? AppColor.appBar : Colors.grey[700],
                value: _currentData!,
                groupValue: e,
                toggleable: true,
                onChanged: (value) {
                  if (enableRating) {
                    if (_currentData != e) {
                      setState(() {
                        _currentData = e;
                        _textEditingController.text = '';
                      });
                    }
                  } else {
                    return;
                  }
                }),
          ),
        )
        .toList();
  }

  Container buildHeader() {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x25606060),
            offset: Offset(2, -4.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              widget.title ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A5A5A),
                  fontSize: 16,
                  fontFamily: 'Roboto'),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 9, right: 19),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset('assets/images/ic_close.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
