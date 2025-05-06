import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import '../../../generated/l10n.dart';
import 'widgets/paymentTicket.widget.dart';

class ParticalPaymentScreen extends StatefulWidget {
  ParticalPaymentScreen({Key? key}) : super(key: key);
  @override
  _ParticalPaymentScreenState createState() => _ParticalPaymentScreenState();
}

class _ParticalPaymentScreenState extends State<ParticalPaymentScreen>
    with AfterLayoutMixin {
  TicketModel? ticketModel;
  int? actionGroupID;
  String? actionGroupCode;
  String? actionGroupName;
  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    try {
      Map<String, dynamic>? params = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (params == null) {
        return Container();
      }
      ticketModel = params['ticketModel'];
      actionGroupID = params['actionGroupId'];
      actionGroupCode = params['actionGroupCode'];
      actionGroupName = params['actionGroupName'];
      return PaymentTicketWidget(
          ticket: ticketModel,
          // title: actionGroupName,
          title: S.of(context).customerPartialPayment,
          actionGroupID: actionGroupID,
          actionGroupName: actionGroupName,
          actionGroupCode: actionGroupCode);
    } catch (e) {
      return Container();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
