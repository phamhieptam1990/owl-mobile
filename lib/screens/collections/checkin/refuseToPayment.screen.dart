import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/paymentRefuseTicket.widget.dart';
import '../../../generated/l10n.dart';

class RefuseToPaymentScreen extends StatefulWidget {
  RefuseToPaymentScreen({Key? key}) : super(key: key);
  @override
  _RefuseToPaymentScreenState createState() => _RefuseToPaymentScreenState();
}

class _RefuseToPaymentScreenState extends State<RefuseToPaymentScreen>
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
      final Map<String, dynamic>? params =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (params == null) {
        return Container();
      }
      ticketModel = params['ticketModel'] as TicketModel?;
      actionGroupID = params['actionGroupId'] as int?;
      actionGroupCode = params['actionGroupCode'] as String?;
      actionGroupName = params['actionGroupName'] as String?;
      if (ticketModel == null) {
        return Container();
      }
      return PaymentRefuseTicketWidget(
          ticket: ticketModel!,
          // title: actionGroupName,
          title: S.of(context).customerRefuseToPay,
          actionGroupID: actionGroupID,
          actionGroupName: actionGroupName,
          actionGroupCode: actionGroupCode);
    } catch (e) {
      return Container();
    }
    // ticketModel = ModalRoute.of(context).settings.arguments;
    // return PaymentRefuseTicketWidget(
    //     ticket: ticketModel, title: S.of(context).customerRefuseToPay);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
