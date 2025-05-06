import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/constants/color.dart';
import '../../../widgets/nice_button_widget.dart';
import '../controller/history_transaction_card_controller.dart';

class InputDateForm extends StatefulWidget {
  final String title;
  final HistoryTransactionCardController controller;
  final int currentFromDate;
  final int currentToDate;

  final Function(int fromDate, int toDate) onSelectedDate;

  final int? maxTimeInput;

  InputDateForm(
      {Key? key,
      this.title = '',
      required this.controller,
      required this.currentFromDate,
      required this.currentToDate,
      this.maxTimeInput,
      required this.onSelectedDate})
      : super(key: key);

  @override
  State<InputDateForm> createState() => _InputDateFormState();
}

class _InputDateFormState extends State<InputDateForm> {
  final globalScaffoldKey = GlobalKey<ScaffoldMessengerState>();

  //ngày thành lập FE
  final foundingDate = DateTime(2010, 11, 1);

  DateTime? currentFromDateTime;
  DateTime? currentToDateTime;
  bool isShowError = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      currentFromDateTime = _converTimeStampToDate(widget.currentFromDate);
      currentToDateTime = _converTimeStampToDate(widget.currentToDate);
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: Get.height * 40 / 100,
            width: double.infinity,
            child: Scaffold(
              key: globalScaffoldKey,
              backgroundColor: Colors.transparent,
              body: Container(
                decoration: _componentStyle(),
                child: Column(
                  children: [buildHeader(context), _buildBody(context)],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _componentStyle() {
    return BoxDecoration(
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
    );
  }

  Container buildHeader(BuildContext context) {
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
              widget.title,
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
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset('assets/images/ic_close.png'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, left: 30, right: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildFromDate(),
                    SizedBox(
                      height: 16,
                    ),
                    _buildToDate(),
                    SizedBox(
                      height: 20,
                    ),
                    _buildErr()
                  ]),
            ),
          ),
          _buildApplyBtn(),
          SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }

  NiceButtons _buildApplyBtn() {
    return !isShowError
        ? NiceButtons(
            stretch: false,
            borderRadius: 16,
            startColor: AppColor.primary.withOpacity(.5),
            endColor: AppColor.primary,
            borderColor: AppColor.primary.withOpacity(.2),
            gradientOrientation: GradientOrientation.Vertical,
            onTap: (_) =>
                onPopFilterDate(currentFromDateTime!, currentToDateTime!),
            child: Text(
              'Áp dụng',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          )
        : NiceButtons(
            stretch: false,
            borderRadius: 16,
            startColor: AppColor.grey.withOpacity(.5),
            endColor: AppColor.grey,
            borderColor: AppColor.grey.withOpacity(.2),
            gradientOrientation: GradientOrientation.Vertical,
            onTap: (finish) {
              // onRefresh?.call();
            },
            child: Text(
              'Áp dụng',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          );
  }

  Widget _buildErr() {
    return Visibility(
      visible: isShowError,
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 30,
          child: Text(
            'Ngày lọc không hợp lệ, vui lòng điều chỉnh lại!',
            style: TextStyle(
                color: AppColor.orange,
                fontSize: 15,
                fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }

  Row _buildToDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            'Đến ngày:',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.blackOpacity),
          ),
        ),
        Container(
          width: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 2,
                offset: Offset(1, 3), // Shadow position
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  currentTime: currentToDateTime,
                  minTime: foundingDate,
                  maxTime: widget.maxTimeInput != null ? 
                     DateTime.fromMillisecondsSinceEpoch(widget.maxTimeInput!) : // Fix 17: Add non-null assertion
                     DateTime.now(),                  onChanged: (date) {}, onConfirm: (date) {
                setState(() {
                  currentToDateTime =
                      DateTime(date.year, date.month, date.day);
                  _validatorPickingTime(currentFromDateTime!, currentToDateTime!);
                });
              }, locale: LocaleType.vi);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _converDateToString(currentToDateTime),
                    style: TextStyle(
                        color: AppColor.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.edit,
                    color: AppColor.blackOpacity,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildFromDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(
            'Từ ngày:',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.blackOpacity),
          ),
        ),
        Container(
          width: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 2,
                offset: Offset(1, 3), // Shadow position
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  currentTime: currentFromDateTime,
                  minTime: foundingDate,
                  maxTime: widget.maxTimeInput != null ? 
                     DateTime.fromMillisecondsSinceEpoch(widget.maxTimeInput!) : // Fix 17: Add non-null assertion
                     DateTime.now(),
                  onChanged: (date) {}, onConfirm: (date) {
                setState(() {
                  currentFromDateTime =
                      DateTime(date.year, date.month, date.day);
                });
                _validatorPickingTime(
                  currentFromDateTime!,
                  currentToDateTime!,
                );
              }, locale: LocaleType.vi);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    _converDateToString(currentFromDateTime),
                    style: TextStyle(
                        color: AppColor.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.edit,
                    color: AppColor.blackOpacity,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onPopFilterDate(DateTime fromDate, DateTime toDate) {
    bool _validator = _validatorPickingTime(fromDate, toDate);
    if (_validator) {
      Navigator.of(context).pop();
      widget.onSelectedDate.call(
          fromDate.millisecondsSinceEpoch, toDate.millisecondsSinceEpoch);
    }
  }

  bool _validatorPickingTime(DateTime fromDate, DateTime toDate) {
    bool _validatorPickingTime;
    if (fromDate.compareTo(toDate) != -1) {
    _validatorPickingTime = false;
  } else {
    _validatorPickingTime = true;
  }

    setState(() {
      isShowError = !_validatorPickingTime;
    });
    return _validatorPickingTime;
  }

  DateTime _converTimeStampToDate(int timeStamp) {
    return DateTime.fromMillisecondsSinceEpoch(
      timeStamp,
    );
      return DateTime.now();
  }

  String _converDateToString(DateTime? date) {
    try {
      if(date == null){
        return '';
      }
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);
      return formattedDate;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }
}

enum InputDateType { fromDate, toDate }
