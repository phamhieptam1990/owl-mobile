import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/history_transaction_ewallet/widgets/history_transaction_ewallet_loading_widget.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/nodata.widget.dart';

import '../collection.controller.dart';
import 'models/debt_settlement_response.dart';

class DebtSettlementDetailsTab extends StatefulWidget {
  final TicketModel ticketModel;
  final CollectionDetailCaseController controller;
  const DebtSettlementDetailsTab(this.controller, {Key? key, required this.ticketModel})
      : super(key: key);

  @override
  State<DebtSettlementDetailsTab> createState() =>
      _DebtSettlementDetailsTabState();
}

class _DebtSettlementDetailsTabState extends State<DebtSettlementDetailsTab> {
  bool isLoading = false;
  DebtSettlementData? data;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
   
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          fetchData();
        },
        child: _buildBody());
  }

  Widget _buildBody() {
    if (isLoading) {
      return HistoryTransactionEWalletFakeLoadingWidget();
    }

    return data != null
        ? ListView(
            children: [
              _buildBox(
                  child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('Tiền gốc'),
                      _buildTitle('Tiền lãi'),
                      _buildTitle('Phí phạt'),
                      _buildTitle('Tổng tiền'),
                      _buildTitle('Tiền đã đóng tháng trước'),
                      _buildTitle('Tiền còn lại'),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrice(Utils.formatPrice(
                          data?.remainPrincipalCurr?.toString() ?? '0',
                          hasVND: true)),
                      _buildPrice(Utils.formatPrice(
                          data?.remainIntCurr?.toString() ?? '0',
                          hasVND: true)),
                      _buildPrice(Utils.formatPrice(data?.remainLpi?.toString() ?? '0',
                          hasVND: true)),
                      _buildPrice(Utils.formatPrice(
                          data?.totalDebtSettlement?.toString() ?? '0',
                          hasVND: true)),
                      _buildPrice(Utils.formatPrice(data?.paidAmt?.toString() ?? '0',
                          hasVND: true)),
                      _buildPrice(Utils.formatPrice(
                          data?.remainPaidAmt?.toString() ?? '0',
                          hasVND: true)),
                    ],
                  )),
                ],
              )),
              _buildBoxPaymentMethod(
                'Phương thức thanh toán 1',
                range: _range(data?.debt1Min, data?.debt1Max),
                getFirst: '\t ${data?.debt1Bonus1}',
                getSecond: '\t ${data?.debt1Bonus2}',
              ),
              _buildBoxPaymentMethod(
                'Phương thức thanh toán 2',
                range: _range(data?.debt2Min, data?.debt2Max),
                getFirst: '\t ${data?.debt2Bonus1}',
                getSecond: '\t ${data?.debt2Bonus2}',
              ),
              _buildBoxPaymentMethod(
                'Phương thức thanh toán 3',
                range: _range(data?.debt3Min, data?.debt3Max),
                getFirst: '\t ${data?.debt3Bonus1}',
                getSecond: '\t ${data?.debt3Bonus2}',
              ),
              _buildBoxPaymentMethod(
                'Phương thức thanh toán 4',
                range: _range(data?.debt4Min, data?.debt4Max),
                getFirst: '\t ${data?.debt4Bonus1}',
                getSecond: '\t ${data?.debt4Bonus2}',
              ),
              SizedBox(
                height: 20,
              )
            ],
          )
        : ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
            NoDataWidget(
              callback: () {
                fetchData();
              },
            ),
          ]);
  }

  Widget _buildBox({Widget? child}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 2),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey[350]?.withOpacity(.5),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: child,
      ),
    );
  }

  Widget _buildBoxPaymentMethod(
    String paymentMethodIndex, {
    String? range,
    String? getFirst,
    String? getSecond,
  }) {
    return _buildBox(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paymentMethodIndex ?? '',
          style: TextStyle(
              color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          'Số tiền thu (trong khoảng)',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          range ?? '',
          style: TextStyle(
              color: AppColor.red, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          'Bonus (% Collected AMT)',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        RichText(
          text: TextSpan(
            text: '+ Thu 1 lần:',
            style: TextStyle(color: Colors.black87, fontSize: 14),
            children: <TextSpan>[
              TextSpan(
                  text: getFirst ?? '',
                  style: TextStyle(
                      color: AppColor.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(
          height: 7,
        ),
        RichText(
          text: TextSpan(
            text: '+ Thu 2 lần:',
            style: TextStyle(color: Colors.black87, fontSize: 14),
            children: <TextSpan>[
              TextSpan(
                  text: getSecond ?? '',
                  style: TextStyle(
                      color: AppColor.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Text(
        title ?? '',
        style: TextStyle(color: Colors.black87, fontSize: 14),
      ),
    );
  }

  Widget _buildPrice(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: RichText(
        text: TextSpan(
          text: ':  ',
          style: TextStyle(color: Colors.black87, fontSize: 14),
          children: <TextSpan>[
            TextSpan(
                text: title ?? '',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  String _range(dynamic from, dynamic to) {
    try {
      int _from;
      int _to;
      if (from is double) {
        _from = from.round();
      } else {
        _from = from;
      }
      if (to is double) {
        _to = to.round();
      } else {
        _to = to;
      }

      return Utils.formatPriceDefault0(_from.toString()) +
          ' - ' +
          Utils.formatPriceDefault0(_to.toString());
    } catch (_) {
      return '';
    }
  }
}
