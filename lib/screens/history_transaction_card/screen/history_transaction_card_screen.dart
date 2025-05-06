// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:toggle_list/toggle_list.dart';
// import 'package:athena/common/constants/color.dart';
// import 'package:athena/models/tickets/ticket.model.dart';
// import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
// import 'package:athena/screens/history_transaction_card/controller/history_transaction_card_controller.dart';
// import 'package:athena/screens/history_transaction_card/models/history_transaction_complain_response.dart';
// import 'package:athena/screens/history_transaction_card/widgets/history_transaction_item.dart';
// import 'package:athena/utils/utils.dart';
// import 'package:athena/widgets/common/appbar.dart';
// import 'package:athena/widgets/common/nodata.widget.dart';

// class HistoryTransactionCardScreen extends StatelessWidget {
//   HistoryTransactionCardScreen({Key key, @required this.data})
//       : super(key: key);
//   final TicketModel data;

//   @override
//   Widget build(BuildContext context) {
//     HistoryTransactionCardController controller = Get.put(
//       HistoryTransactionCardController(data?.contractId),
//       tag: 'HistoryTransactionCardScreen',
//     );
//     final _scaffoldKey =
//         GlobalKey<ScaffoldState>(debugLabel: 'HistoryTransactionCardScreen');

//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Colors.transparent,
//       appBar: AppBarCommon(
//         title: 'Lịch sử giao dịch thẻ',
//         lstWidget: [],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           controller.fetchData();
//         },
//         child: GetBuilder<HistoryTransactionCardController>(
//           init: controller,
//           builder: (_) {
//             if (controller?.isLoading ?? false) {
//               return ShimmerCheckIn();
//             }
//             if (controller?.data == null) {
//               return buildNodata(controller);
//             }
//             return controller?.data?.cardSecInfoType?.cardStatements
//                         ?.cardStatement?.isNotEmpty ??
//                     false
//                 ? ToggleList(
//                     toggleAnimationDuration: Duration(milliseconds: 150),
//                     innerPadding: EdgeInsets.only(left: 12, right: 12, top: 16),
//                     divider: Divider(
//                       color: AppColor.grey,
//                     ),
//                     children: controller
//                         ?.data?.cardSecInfoType?.cardStatements?.cardStatement
//                         ?.map((e) => buildItem(controller, e))
//                         ?.toList())
//                 : buildNodata(controller);
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildNodata(HistoryTransactionCardController controller) {
//     return RefreshIndicator(
//       child: Container(height: 800, child: NoDataWidget()),
//       onRefresh: () async {
//         await controller.fetchData();
//       },
//     );
//   }

//   ToggleListItem buildItem(
//       HistoryTransactionCardController controller,
//       CardStatementElement cardValue) {
//     return ToggleListItem(
//       onExpansionChanged: (index, isExpand) =>
//           onExpansionChanged(controller, index, isExpand, cardValue),
//       leading: Padding(
//         padding: EdgeInsets.all(10),
//         child: Icon(
//           Icons.sailing,
//           color: (cardValue?.cardTransaction?.isNotEmpty ?? false) ||
//                   (cardValue?.rechargeTransaction?.isNotEmpty ?? false)
//               ? AppColor.orange
//               : AppColor.grey,
//         ),
//       ),
//       title: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         child: Column(
//           children: [
//             buildValue(
//                 'Số dư đầu kỳ',
//                 Utils.formatPrice(
//                     cardValue?.balanceForBeginningOfPeriod?.toString())),
//             buildValue('Số dư cuối kỳ',
//                 Utils.formatPrice(
//                     cardValue?.balanceForEndOfPeriod?.toString())),
//             buildValue(
//                 'Số dư tối thiểu',
//                 Utils.formatPrice(cardValue?.mpa?.toString())),
//             buildValue('Ngày sao kê',
//                 Utils.convertTimeWithoutTime(cardValue?.statementdate)),
//           ],
//         ),
//       ),
//       content: HistoryTransactionList(value: cardValue),
//       headerDecoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//       ),
//       expandedHeaderDecoration: BoxDecoration(
//         color: AppColor.appBar.withOpacity(0.7),
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//     );
//   }

//   void onExpansionChanged(HistoryTransactionCardController controller,
//       int index, bool isExpaned, CardStatementElement value) async {
//     FocusManager.instance.primaryFocus?.unfocus();
//     if (isExpaned) {
//       if (value?.isLoaded == true) {
//         return;
//       } else {
//         controller.onExpand(index, value);
//       }
//     }
//   }

//   Widget buildValue(String title, String value) {
//     return Row(
//       children: [
//         Expanded(
//             child: Text(
//           '$title',
//           style: TextStyle(
//               color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
//         )),
//         Expanded(
//             child: Text('$value',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 14,
//                     fontWeight: FontWeight.normal))),
//       ],
//     );
//   }
// }
