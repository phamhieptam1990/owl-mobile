import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/paymentTicket.widget.dart';
import '../../../generated/l10n.dart';

class PromiseToPaymentScreen extends StatefulWidget {
  PromiseToPaymentScreen({Key? key}) : super(key: key);
  @override
  _PromiseToPaymentScreenState createState() => _PromiseToPaymentScreenState();
}

class _PromiseToPaymentScreenState extends State<PromiseToPaymentScreen>
    with AfterLayoutMixin {
  TicketModel? ticketModel;
  int? actionGroupID;
  String? actionGroupCode;
  String? actionGroupName;
  bool? enableDefaultActiveTime;
  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    // ticketModel = ModalRoute.of(context).settings.arguments;
    // return PaymentTicketWidget(
    //   ticket: ticketModel,
    //   title: S.of(context).customerPromiseToPay,
    //   actionGroupID: 1,
    // );
    try {
      Map<String, dynamic>? params = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if(params == null) {
        return Container();
      }
      ticketModel = params['ticketModel'];
      actionGroupID = params['actionGroupId'];
      actionGroupCode = params['actionGroupCode'];
      actionGroupName = params['actionGroupName'];
      enableDefaultActiveTime = params['enableDefaultActiveTime'];
      return PaymentTicketWidget(
        ticket: ticketModel,
        title: S.of(context).customerPromiseToPay,
        // title: actionGroupName,
        actionGroupID: actionGroupID,
        actionGroupName: actionGroupName,
        actionGroupCode: actionGroupCode,
        enableDefaultActiveTime: enableDefaultActiveTime ?? true,
        isPromisePayment: true,
      );
    } catch (e) {
      return Container();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _categoryProvider.clearData();
    // _checkInProvider.clearData();
  }
}
