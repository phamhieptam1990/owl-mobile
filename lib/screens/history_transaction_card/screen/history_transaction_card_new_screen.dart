import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/history_transaction_card/controller/history_transaction_card_controller.dart';
import 'package:athena/screens/history_transaction_card/widgets/history_transaction_item.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/nodata.widget.dart';

import '../widgets/filter_date_form.dart';

class HistoryTransactionCardNewScreen extends StatelessWidget {
  HistoryTransactionCardNewScreen({Key? key, required this.data})
      : super(key: key);
  final TicketModel data;

  @override
  Widget build(BuildContext context) {
    HistoryTransactionCardController controller = Get.put(
      HistoryTransactionCardController(data),
      tag: 'HistoryTransactionCardScreen',
    );
    final _scaffoldKey =
        GlobalKey<ScaffoldState>(debugLabel: 'HistoryTransactionCardScreen');

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white.withOpacity(.9),
      appBar: AppBarCommon(
        title: 'Lịch sử giao dịch thẻ',
        lstWidget: [
          GetBuilder<HistoryTransactionCardController>(
            builder: (_) {
              return Visibility(
                visible: controller.isShowFilter ?? false,
                child: IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () async {
                    showGeneralDialog(
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionDuration: Duration(milliseconds: 300),
                      barrierDismissible: true,
                      context: context,
                      pageBuilder: (_, __, ___) {
                        return InputDateForm(
                            title: 'Chọn thời gian lọc',
                            controller: controller,
                            currentFromDate: controller.fromDateInput,
                            currentToDate: controller.toDateInput,
                            onSelectedDate: (fromDate, toDate) =>
                                controller.onFilter(fromDate, toDate));
                      },
                      transitionBuilder: (_, anim, __, child) {
                        return SlideTransition(
                          position:
                              Tween(begin: Offset(0, 1), end: Offset(0, 0))
                                  .animate(anim),
                          child: child,
                        );
                      },
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchData();
        },
        child: GetBuilder<HistoryTransactionCardController>(
          init: controller,
          builder: (_) {
            if (controller.isLoading) {
              return ShimmerCheckIn();
            }
            // Fix 7: Add proper null checks for nested properties
          final hasStatements = controller
                        .data?.cardSecInfoType?.cardStatements?.cardStatement !=
                    null &&
                controller.data?.cardSecInfoType?.cardStatements?.cardStatement!
                        .isNotEmpty ==
                    true;

                    
            return hasStatements
                ? buildTransList(controller)
                : buildNodata(controller);
          },
        ),
      ),
    );
  }

  Widget buildNodata(HistoryTransactionCardController controller) {
    return NoDataWidget(
      callback: () => controller.fetchData(),
    );
  }

  Widget buildTransList(
    HistoryTransactionCardController controller,
  ) {
    return HistoryTransactionList(
        currentFilterString: controller.getCurrentFilter(),
        cardTransactions: controller.cardTransaction,
        rechargeTransactions: controller.rechargeTransaction);
  }

  Widget buildValue(String title, String value) {
    return Row(
      children: [
        Expanded(
            child: Text(
          '$title',
          style: TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
        )),
        Expanded(
            child: Text('$value',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal))),
      ],
    );
  }
}
