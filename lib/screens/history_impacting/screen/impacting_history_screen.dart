import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:athena/screens/history_impacting/widgets/promise_payment_item_widget.dart';
import 'package:athena/widgets/common/appbar.dart';

import '../../../models/tickets/ticket.model.dart';
import '../../history_transaction_ewallet/widgets/empty_wallet_transaction_widget.dart';
import '../../history_transaction_ewallet/widgets/history_transaction_ewallet_loading_widget.dart';
import '../controller/impacting_history_controller.dart';
import 'filtering_impacting_history_screen.dart';

class HistoryPromisePaymentScreen extends StatelessWidget {
  final TicketModel data;

  const HistoryPromisePaymentScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImpactingHistoryController _controller = Get.put(
      ImpactingHistoryController(data),
      tag: 'ImpactingHistoryController',
    );

    return GetBuilder<ImpactingHistoryController>(
        init: _controller,
        builder: ((controller) {
          return Scaffold(
              appBar: AppBarCommon(
                title: 'Lịch sử tác động',
                lstWidget: [
                  IconButton(
                    icon: const Icon(Icons.filter_alt),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FilteringImpactingHistoryScreen(
                            actionCodeList: controller.actionCodeList,
                            currentChossed: controller.currentChossed,
                            onSelected: (val) {
                              controller.currentChossed = val;
                              controller.onFilter();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: RefreshIndicator(
                  onRefresh: () async {
                    controller.onFilter();
                  },
                  child: buildBody(controller)));
        }));
  }

  Widget buildBody(ImpactingHistoryController controller) {
    if (controller.isLoading) {
      return HistoryTransactionEWalletFakeLoadingWidget();
    }
    if (controller.impactingHistorys.isEmpty) {
      return EmptyDataWidget(onRefresh: ()=>{});
    }

    return ListView.builder(
      itemCount: controller.impactingHistorys.length ?? 0,
      itemBuilder: ((context, index) => ImpactingItemWidget(
            index: index,
            data: controller.impactingHistorys[index],
            isLastItem: index == controller.impactingHistorys.length - 1,
          )),
    );
  }
}
