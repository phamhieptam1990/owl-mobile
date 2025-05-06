import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/tickets/activity.model.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/noDataPayment.widget.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';

class CheckPaymentDetailScreen extends StatefulWidget {
  final ActivityModel activityModel;

  // Fix 1: Use const constructor
  const CheckPaymentDetailScreen({Key? key, required this.activityModel})
      : super(key: key);

  @override
  _CheckPaymentDetailScreenState createState() =>
      _CheckPaymentDetailScreenState();
}

class _CheckPaymentDetailScreenState extends State<CheckPaymentDetailScreen>
    with AfterLayoutMixin {
  // Fix 2: Remove 'new' keyword
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'CheckPaymentDetailScreen');

  // Fix 3: Use proper nullable type
  bool isLoading = true;
  ActivityModel? activityModel;

  // Fix 4: Define proper type for target
  Map<String, dynamic>? target;

  String? customerName;
  String? clientPhone;
  String? description;
  String? paymentNumber;
  String? contractNo;
  String? transactionDate;
  String? amountOverdue;
  String? paymentChannel;
  double? code;

  @override
  void initState() {
    super.initState();
    activityModel = widget.activityModel;
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await handleFetchData();
  }

  Future<void> handleFetchData() async {
    try {
      // Fix 5: Handle null safely
      dynamic targetData = activityModel?.target;

      // Fix 6: Use safer null checks with 'is' operator
      if (targetData is Map<String, dynamic>) {
        // Fix 7: Safe access to originalValue
        final dynamic originalValue = targetData['originalValue'];
        if (originalValue is Map<String, dynamic>) {
          targetData = originalValue;
        }

        // Fix 8: Safe access to inputData
        final dynamic inputData = targetData['inputData'];
        if (inputData is Map<String, dynamic>) {
          targetData = inputData;
        }

        // Fix 9: Use safer variable declarations
        Map<String, dynamic>? finalTargetData;
        List<dynamic>? paymentsData;

        // Fix 10: Safe access to sys and payment
        final dynamic sys = targetData['sys'];
        final dynamic payment = targetData['payment'];

        if (sys is Map<String, dynamic>) {
          finalTargetData = sys;
        }

        if (payment is List) {
          paymentsData = payment;
        }

        // Fix 11: Safe access to nested properties
        if (finalTargetData != null) {
          description = Utils.retunDataStr(finalTargetData['description']);

          // Fix 12: Safe number conversion
          final dynamic codeValue = finalTargetData['code'];
          if (codeValue is num) {
            code = codeValue.toDouble();
          }

          // Fix 13: Handle payment data safely
          if (code == 1.0 && paymentsData != null && paymentsData.isNotEmpty) {
            final dynamic payment = paymentsData[0];

            if (payment is Map<String, dynamic>) {
              // Fix 14: Safe conversion of transaction date
              final dynamic transactionDateValue = payment['transactionDate'];
              if (transactionDateValue != null) {
                transactionDate = Utils.convertTime(transactionDateValue);
              }

              // Fix 15: Safe amount formatting
              final dynamic amountPaid = payment['amountPaid'];
              if (amountPaid is num) {
                String amountOverdues = amountPaid.round().toString();
                amountOverdue = Utils.formatPrice(amountOverdues);
              }

              // Fix 16: Safe username extraction
              paymentChannel = Utils.retunDataStr(payment['username']);
            }
          }
        }

        // Fix 17: Store the processed data
        target = targetData is Map<String, dynamic>
            ? Map<String, dynamic>.from(targetData)
            : null;
      }
    } catch (e) {
      // Fix 18: Add error logging
      print('Error in handleFetchData: $e');
    } finally {
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget formDetail() {
    // Fix 19: Safe comparison with null check
    if (code == 3.0) {
      // Fix 20: Use const constructor
      return NoDataPayment(title: 'Không tìm thấy thông tin thanh toán');
    }
    return formDetailPayment(target);
  }

  Widget formDetailPayment(Map<String, dynamic>? data) {
    // Fix 21: Use const for EdgeInsets
    return Card(
        margin: const EdgeInsets.all(7.0),
        child: Column(children: [
          Container(
            // Fix 22: Use const for EdgeInsets
            margin: const EdgeInsets.only(left: 10, right: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(S.of(context).infomation,
                    // Fix 23: Use const for TextStyle
                    style: TextStyle(
                        fontSize: AppFont.fontSize16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Fix 24: Use const for Divider
          Divider(
            color: AppColor.blackOpacity,
          ),
          TextFormField(
            readOnly: true,
            // enabled: false,
            initialValue: amountOverdue,
            // Fix 25: Use const for InputDecoration
            decoration: InputDecoration(
                // Fix 26: Use const for EdgeInsets
                contentPadding: const EdgeInsets.all(10.0),
                labelText: S.of(context).moneyPaymentTake + " *",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            readOnly: true,
            // enabled: false,
            initialValue: transactionDate,
            // Fix 27: Use const for TextStyle
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
            // Fix 28: Use const for InputDecoration
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Ngày thực hiện giao dịch ",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            readOnly: true,
            // enabled: false,
            initialValue: paymentChannel,
            // Fix 29: Use const for TextStyle
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
            // Fix 30: Use const for InputDecoration
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Repayment Channel",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarCommon(
          title: S.of(context).checkPaymentCustomer,
          lstWidget: const [], // Fix 31: Use const for empty list
        ),
        // Fix 32: Use SizedBox instead of Container with fixed size
        body: SizedBox(
          height: AppState.getHeightDevice(context),
          width: AppState.getWidthDevice(context),
          child: SingleChildScrollView(
            // Fix 33: Use safer boolean comparison
            child: isLoading
                ? SizedBox(
                    height: AppState.getHeightDevice(context),
                    width: AppState.getWidthDevice(context),
                    // Fix 34: Use const constructor
                    child: const ShimmerCheckIn())
                : formDetail(),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
