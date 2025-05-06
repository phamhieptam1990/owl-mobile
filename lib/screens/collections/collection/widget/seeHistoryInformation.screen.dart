import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/customerName.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/services/customer/customer.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/noDataPayment.widget.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/widgets/common/loading-button.widget.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:athena/widgets/common/call_sms_log/call_sms_log.dart';
import 'package:athena/models/events.dart';

import '../history_payment_card_response.dart';

class SeeHistoryInfomationScreen extends StatefulWidget {
  SeeHistoryInfomationScreen({Key? key}) : super(key: key);
  @override
  _SeeHistoryInfomationScreenState createState() =>
      _SeeHistoryInfomationScreenState();
}

class _SeeHistoryInfomationScreenState extends State<SeeHistoryInfomationScreen>
    with AfterLayoutMixin {
  final collectionService = new CollectionService();
  final customerService = new CustomerService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'SeeHistoryInfomationScreen');

  TicketModel? ticketModelParams;
  bool isLoadComplete = false;
  List<dynamic> lstPaymentHistory = [];
  List<dynamic> lstSchedulePaymentHistory = [];
  CollectionService _collectionService = new CollectionService();
  HistoryPaymentCardData? paymentInfo;
  var kalapa;
  var earlyTermination;
  String title = '';
  String message = '';
  String type = '';
  int? code;
  bool isShowAllKalapa = false;
  bool toDayIsDueDate = false;
  bool isShowEarlyTerminationCard = false;
  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {}

  Widget formDetailPayment(int index) {
    return Card(
        child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: ListTile(
                dense: true,
                contentPadding:
                    EdgeInsets.only(left: 0.0, bottom: 0, top: 0, right: 8.0),
                title: buildTitle(index))));
  }

  Widget buildTitle(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: Text(
            'Ngày tiền vào hệ thống: ' +
                (Utils.checkIsNotNull(lstPaymentHistory[index]['bookingDate'])
                    ? Utils.convertTimeWithoutTime(
                        lstPaymentHistory[index]['bookingDate'])
                    : ''),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: AppFont.fontSize16,
                color: Theme.of(context).primaryColor),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
                'Ngày thanh toán: ' +
                    (Utils.checkIsNotNull(lstPaymentHistory[index]['valueDate'])
                        ? Utils.convertTimeWithoutTime(
                            lstPaymentHistory[index]['valueDate'])
                        : ''),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: AppFont.fontSize16))),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
              'Số tiền thanh toán: ' +
                  (Utils.checkIsNotNull(
                          lstPaymentHistory[index]['amountOfMoney'])
                      ? Utils.formatPrice(lstPaymentHistory[index]
                              ['amountOfMoney']
                          .round()
                          .toString())
                      : ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: AppFont.fontSize16,
                  color: Theme.of(context).primaryColor),
            )),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
              'Số Biên Nhận: ' +
                  (Utils.checkIsNotNull(
                          lstPaymentHistory[index]['receiptNumber'])
                      ? lstPaymentHistory[index]['receiptNumber']
                      : ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppFont.fontSize16),
            ))
      ],
    );
  }

  Widget formDetail() {
    if (code != 1) {
      return Center(child: NoDataPayment(title: 'Không tìm thấy thông tin'));
    }
    if (type == ActionPhone.CHECK_HISTORY_PAYMENT) {
      if (lstPaymentHistory.isEmpty) {
        return centerWidgetNoData();
      }
    } else if (type == ActionPhone.CHECK_HISTORY_PAYMENT_CARD) {
      if (!Utils.checkIsNotNull(paymentInfo)) {
        return centerWidgetNoData();
      }
    } else if (type == ActionPhone.CHECK_KALAPA_INFOMATION) {
      if (!Utils.checkIsNotNull(kalapa)) {
        return centerWidgetNoData();
      }
    } else if (type == ActionPhone.EARLY_TERMINATION) {
      if (!Utils.checkIsNotNull(earlyTermination)) {
        return centerWidgetNoData();
      }
    } else if (type == ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY) {
      if (lstSchedulePaymentHistory.isEmpty) {
        return centerWidgetNoData();
      }
    }
    if (type == ActionPhone.CHECK_HISTORY_PAYMENT ||
        type == ActionPhone.CHECK_HISTORY_PAYMENT_CARD ||
        type == ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY) {
      return handleBuildWidget();
    } else if (type == ActionPhone.CHECK_KALAPA_INFOMATION ||
        type == ActionPhone.EARLY_TERMINATION) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [handleBuildWidget()]);
    }
      return Center(child: NoDataPayment(title: 'Không tìm thấy thông tin'));
  }

  Widget handleBuildWidget() {
    if (type == ActionPhone.CHECK_HISTORY_PAYMENT) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildFormHistoryPayment(),
      );
    } else if (type == ActionPhone.CHECK_HISTORY_PAYMENT_CARD) {
      return Card(
          margin: EdgeInsets.all(14.0),
          child: Column(children: buildTitleCard()));
    } else if (type == ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildScheduleFormHistoryPayment(),
      );
    } else if (type == ActionPhone.CHECK_KALAPA_INFOMATION) {
      return Column(children: [buildKalapaInfomation()]);
    } else if (type == ActionPhone.EARLY_TERMINATION) {
      return Column(children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10.0, top: 10),
          child: Center(
            child: CustomerNameCheckInWidget(
                customerFullName: ticketModelParams?.fullName),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10.0, top: 0),
          child: Center(
            child: Text('App ID: ' + (ticketModelParams?.contractId?.toString() ?? '') )
          ),
        ),
        Container(
          width: AppState.getWidthDevice(context),
          child: Card(
              child: buildEarlyTermination(),
              elevation: 5,
              // shape: RoundedRectangleBorder(
              //   side: BorderSide(color: Colors.white70, width: 1),
              //   borderRadius: new BorderRadius.circular(30.0),
              // ),
              margin: EdgeInsets.all(7.0)),
        )
      ]);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
  if (ticketModelParams == null) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null && args is Map<String, dynamic>) {
        ticketModelParams = args['ticketModel'] as TicketModel?;
        title = args['title'] as String;
        type = args['type'] as String;
        message = args['message'] as String;
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarCommon(title: title, lstWidget: []),
      body: SingleChildScrollView(
        child: (isLoadComplete == true)
            ? formDetail()
            : Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                margin: EdgeInsets.all(7.0),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10.0, top: 10),
                    child: Center(
                      child: CustomerNameCheckInWidget(
                          customerFullName: ticketModelParams?.fullName),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10.0, top: 0),
                    child: Center(
                      child: Text(
                          'App ID: ${ticketModelParams?.contractId?.toString() ?? ''}'),
                    ),
                  ),
                  Divider(
                    color: AppColor.blackOpacity,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: 15.0, right: 10.0, bottom: 10.0),
                      child: Text(
                        message,
                        style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFont.fontSize18),
                      )),
                ])),
      ),
      bottomNavigationBar:
          (lstPaymentHistory.length == 0 && paymentInfo == null) &&
                  isLoadComplete == false
              ? LoadingButtonWidget(
                  height: 53,
                  callbackOK: () async {
                    handleAction();
                  },
                  title: S.of(context).update,
                )
              : Container(height: 1.0),
    );
  }

  Future<void> handleAction() async {
    try {
      stateButtonOnlyText = ButtonState.loading;
      setState(() {});
      Response? response;
      String aggId = ticketModelParams?.aggId ?? '';
      if (type == ActionPhone.CHECK_HISTORY_PAYMENT_CARD) {
        DateTime toDate = DateTime.now();
        DateTime fromDate = toDate.subtract(Duration(days: 3 * 365));
        response = await this.collectionService.getTransactionCardList(
            fromDate: fromDate.millisecondsSinceEpoch,
            toDate: toDate.millisecondsSinceEpoch,
            accountNumber: ticketModelParams?.contractId);
      } else if (type == ActionPhone.CHECK_HISTORY_PAYMENT) {
        response = await this.collectionService.getLoanSecInfo(aggId);
      } else if (type == ActionPhone.CHECK_KALAPA_INFOMATION) {
        response = await this.collectionService.getKalapaLoanInfo(aggId);
      } else if (type == ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY) {
        response = await this.collectionService.getLoanBasicInfo(aggId);
      } else if (type == ActionPhone.EARLY_TERMINATION) {
        // var contractId = ticketModelParams?.contractId ?? ticketModelParams?.issueCode;
        response = await this.collectionService.getEarlyTermination(aggId);
        code = 1;
      }

      stateButtonOnlyText = ButtonState.idle;
      setState(() {});
      if (Utils.checkRequestIsComplete(response!)) {
        var lstData = Utils.handleRequestData(response!);
        if (lstData == null) {
          WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
          return;
        }
        if (Utils.checkIsNotNull(lstData['sys'])) {
          code = lstData['sys']['code'];
        }
        if (type == ActionPhone.CHECK_HISTORY_PAYMENT) {
          if (Utils.checkIsNotNull(lstData['loanSecInfo'])) {
            var paymentHistories = lstData['loanSecInfo']['paymentHistories'];
            if (Utils.checkIsNotNull(paymentHistories)) {
              var paymentHistory = paymentHistories['paymentHistory'];
              if (Utils.checkIsNotNull(paymentHistory)) {
                if (Utils.isArray(paymentHistory)) {
                  int length = paymentHistory.length;
                  int index = length - 1;
                  while (index >= 0) {
                    if (Utils.checkIsNotNull(paymentHistory[index])) {
                      lstPaymentHistory.add(paymentHistory[index]);
                    }
                    index--;
                  }
                }
              }
            }
          }
        } else if (type == ActionPhone.CHECK_HISTORY_PAYMENT_CARD) {
          paymentInfo = HistoryPaymentCardData.fromJson(lstData);
          if (paymentInfo?.transactions?.transaction?.isNotEmpty ?? false) {
            code = 1;
          }
        } else if (type == ActionPhone.CHECK_KALAPA_INFOMATION) {
          if (Utils.checkIsNotNull(lstData['kalapa'])) {
            kalapa = lstData['kalapa'];
            if (Utils.checkIsNotNull(kalapa)) {
              kalapa.forEach((final String key, final value) {
                if (Utils.checkIsNotNull(value)) {
                  isShowAllKalapa = true;
                }
              });
            }
          }
        } else if (type == ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY) {
          if (Utils.checkIsNotNull(lstData['loanBasicInfo'])) {
            var repaymentSchedules =
                lstData['loanBasicInfo']['repaymentSchedules'];
            if (Utils.checkIsNotNull(repaymentSchedules)) {
              var repaymentSchedule = repaymentSchedules['repaymentSchedule'];
              if (Utils.checkIsNotNull(repaymentSchedule)) {
                if (Utils.isArray(repaymentSchedule)) {
                  lstSchedulePaymentHistory =
                      repaymentSchedule.reversed.toList();
                }
              }
            }
          }
        } else if (type == ActionPhone.EARLY_TERMINATION) {
          if (Utils.checkIsNotNull(lstData)) {
            earlyTermination = lstData;
            toDayIsDueDate = Utils.checkIsNotNull(earlyTermination['dueDate'])
                ? earlyTermination['dueDate']
                : false;
            if (ticketModelParams?.feType == ActionPhone.CARD) {
              isShowEarlyTerminationCard = true;
            }
            code = 1;
          } else {
            earlyTermination = null;
          }
        }
      }
      setState(() {
        isLoadComplete = true;
      });
      eventBus.fire(ReloadList(ActionPhone.CHECK_PAYMENT));
    } catch (e) {
      print(e);
      setState(() {
        isLoadComplete = true;
      });
      stateButtonOnlyText = ButtonState.idle;
    }
  }

  // List<Widget> buildTitleCard() {
  //   return paymentInfo.transactions.transaction.map((e) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 5),
  //           child: Card(
  //             child: Container(
  //               width: double.infinity,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
  //                     child: Text(
  //                       'Ngày tiền vào hệ thống: ' +
  //                           (Utils.checkIsNotNull(e.postingDate)
  //                               ? Utils.convertTimeWithoutTime(e.postingDate)
  //                               : ''),
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                           fontSize: AppFont.fontSize16,
  //                           color: Theme.of(context).primaryColor),
  //                     ),
  //                   ),
  //                   Padding(
  //                       padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
  //                       child: Text(
  //                           'Ngày thanh toán: ' +
  //                               (Utils.checkIsNotNull(e.settlementDate)
  //                                   ? Utils.convertTimeWithoutTime(
  //                                       e.settlementDate)
  //                                   : ''),
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: TextStyle(fontSize: AppFont.fontSize16))),
  //                   Padding(
  //                       padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
  //                       child: Text(
  //                         'Số tiền thanh toán: ' +
  //                             (Utils.checkIsNotNull(e.trnxamount)
  //                                 ? Utils.formatPrice(
  //                                     e.trnxamount.round().toString())
  //                                 : ''),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(
  //                             fontSize: AppFont.fontSize16,
  //                             color: Theme.of(context).primaryColor),
  //                       )),
  //                   Padding(
  //                       padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
  //                       child: Text(
  //                         'Số Biên Nhận: ' +
  //                             (Utils.checkIsNotNull(e.rrn) ? e.rrn : ''),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: TextStyle(fontSize: AppFont.fontSize16),
  //                       ))
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       }).toList() ??
  //       centerWidgetNoData();
  // }

  // Fix 1: Add proper null safety to buildTitleCard method
  List<Widget> buildTitleCard() {
    // Fix 2: Add null check for paymentInfo
    if (paymentInfo == null || paymentInfo?.transactions == null || paymentInfo?.transactions?.transaction == null) {
      return [centerWidgetNoData()];
    }
    
    // Fix 3: Use null-safe access to transaction
    final transactions = paymentInfo?.transactions?.transaction;
    if (transactions == null || transactions.isEmpty) {
      return [centerWidgetNoData()];
    }
    
    // Fix 4: Map with proper null safety
    return transactions.map((e) {
      // Fix 5: Add null check for each transaction
      if (e == null) {
        return const SizedBox.shrink(); // Skip null transactions
      }
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Card(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                  child: Text(
                    'Ngày tiền vào hệ thống: ' +
                        (Utils.checkIsNotNull(e.postingDate)
                            ? Utils.convertTimeWithoutTime(e.postingDate)
                            : ''),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: AppFont.fontSize16,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                    child: Text(
                        'Ngày thanh toán: ' +
                            (Utils.checkIsNotNull(e.settlementDate)
                                ? Utils.convertTimeWithoutTime(
                                    e.settlementDate)
                                : ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: AppFont.fontSize16))),
                Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                    child: Text(
                      'Số tiền thanh toán: ' +
                          (Utils.checkIsNotNull(e.trnxamount)
                              ? Utils.formatPrice(
                                  e.trnxamount.round().toString())
                              : ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          color: Theme.of(context).primaryColor),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0, right: 15.0),
                    child: Text(
                      'Số Biên Nhận: ' + (e?.rrn ?? '') ,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: AppFont.fontSize16),
                    ))
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> buildFormHistoryPayment() {
    List<Widget> lstWidget = [];
    lstWidget.add(Padding(
        padding: EdgeInsets.all(7.0),
        child: Center(
            child: Text(("Mã hợp đồng " + (ticketModelParams?.contractId?.toString() ?? '')),
                style: TextStyle(fontSize: AppFont.fontSize16)))));
    for (int index = 0; index < lstPaymentHistory.length; index++) {
      lstWidget.add(formDetailPayment(index));
    }
    return lstWidget;
  }

  Widget buildEarlyTermination() {
    if (isShowEarlyTerminationCard) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: 7.0, bottom: 3.0, left: 15.0, right: 10.0),
              child: Text(
                'Đối với hợp đồng Thẻ vui lòng liên hệ bộ phận Support Admin hoặc Bộ Phận Chăm Sóc KH để được biết thông tin chính xác.',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: AppFont.fontSize16),
              ),
            )
          ]);
    }
    return Padding(
        padding: EdgeInsets.only(top: 7.0, bottom: 7.0, left: 7.0, right: 7.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: 7.0, bottom: 3.0, left: 15.0),
            //   child: Text(
            //     'Dư nợ gốc: ' +
            //         (Utils.checkIsNotNull(earlyTermination['principleAmt'])
            //             ? Utils.formatPrice(
            //                 earlyTermination['principleAmt'].round().toString())
            //             : ''),
            //     maxLines: 2,
            //     overflow: TextOverflow.ellipsis,
            //     style: TextStyle(fontSize: AppFont.fontSize16),
            //   ),
            // ),
            Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 7.0, left: 15.0),
                child: Text(
                  'Thông tin',
                  style: TextStyle(
                      fontSize: AppFont.fontSize18,
                      fontWeight: FontWeight.bold),
                )),
            Divider(
              height: 2,
              thickness: 1,
            ),
           Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Tổng số tiền cần thanh toán: ',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: (Utils.checkIsNotNull(earlyTermination['props']) &&
                            Utils.checkIsNotNull(earlyTermination['props']["REMAIN_TOTAL"]))
                        ? Utils.formatPrice(
                                earlyTermination['props']["REMAIN_TOTAL"]?.round().toString() ?? '') +
                            " VNĐ"
                        : '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 3.0, bottom: 10.0, left: 15.0),
                child: Text(
                  'Ngày yêu cầu tất toán hợp đồng : ' +
                      Utils.convertTimeWithoutTimeNow(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: AppFont.fontSize16,
                      color: Theme.of(context).primaryColor),
                )),
            // Padding(
            //     padding: EdgeInsets.only(top: 3.0, bottom: 7.0, left: 15.0),
            //     child: Text(
            //       'Ngày đến hạn: ' +
            //           _collectionService
            //               .showDueDateEarlyTermination(earlyTermination),
            //       maxLines: 2,
            //       overflow: TextOverflow.ellipsis,
            //       style: TextStyle(fontSize: AppFont.fontSize16),
            //     )),
            Divider(
              height: 2,
              thickness: 1,
            ),
            Visibility(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
                  child: RichText(
                    text: TextSpan(
                        text:
                            'Lưu ý: Trong trường hợp khách hàng muốn thanh lý hợp đồng, FC vui lòng nộp tiền vào số tài khoản công ty, hoặc hướng dẫn KH nộp tiền chậm nhất vào lúc ',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: AppFont.fontSize16,
                            fontStyle: FontStyle.italic),
                        children: <TextSpan>[
                          TextSpan(
                            text: '11h59 ngày ' +
                                Utils.convertTimeWithoutTimeNow(),
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 18),
                          ),
                          TextSpan(
                              text:
                                  '. Sau thời gian này số tiền thanh lý sẽ hết hạn, khách hàng phải đóng thêm tiền để thanh lý.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: AppFont.fontSize16,
                                  fontStyle: FontStyle.italic)),
                        ]),
                  ),
                ),
                visible: !toDayIsDueDate),
            Visibility(
                child: Padding(
                  padding: EdgeInsets.only(top: 7.0, bottom: 3.0, left: 15.0),
                  child: Text(
                      'Lưu ý: Vui lòng truy vấn số tiền thanh lý vào ngày làm việc tiếp theo, hoặc liên hệ nhóm hành chính để biết thêm thông tin.',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: AppFont.fontSize16,
                          fontStyle: FontStyle.italic)),
                ),
                visible: toDayIsDueDate),
            SizedBox(height: 20)
          ],
        ));
  }

  Widget buildKalapaInfomation() {
    return isShowAllKalapa
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Padding(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: <
                                Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 30, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Facebook',
                                    style: TextStyle(
                                        fontSize: AppFont.fontSize16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Divider(
                            color: AppColor.blackOpacity,
                          ),
                          // InkWell(
                          //   child: TextFormField(
                          //     readOnly: true,
                          //     enabled: false,
                          //     minLines: 1,
                          //     initialValue: kalapa['facebookLink'],
                          //     decoration: InputDecoration(
                          //         contentPadding: EdgeInsets.all(10.0),
                          //         labelText: "Facebook KH",
                          //         suffixIcon: Icon(Icons.arrow_forward_ios),
                          //         floatingLabelBehavior:
                          //             FloatingLabelBehavior.always),
                          //   ),
                          //   onTap: () async {
                          //     await handleOpenLinkFB(kalapa['facebookLink']);
                          //   },
                          // ),
                          Visibility(
                              visible:
                                  Utils.checkIsNotNull(kalapa['facebookLink']),
                              child: InkWell(
                                child: TextFormField(
                                  readOnly: true,
                                  enabled: false,
                                  minLines: 1,
                                  initialValue: kalapa['facebookLink'],
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: "Facebook KH",
                                      suffixIcon: Icon(Icons.arrow_forward_ios),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ),
                                onTap: () async {
                                  await handleOpenLinkFB(
                                      kalapa['facebookLink']);
                                },
                              )),
                          SizedBox(
                            height: 4.0,
                          ),
                          // InkWell(
                          //   child: TextFormField(
                          //     readOnly: true,
                          //     enabled: false,
                          //     minLines: 1,
                          //     initialValue: kalapa['facebookFriendMobile1'],
                          //     decoration: InputDecoration(
                          //         contentPadding: EdgeInsets.all(10.0),
                          //         labelText: "SĐT bạn KH FB (1)",
                          //         suffixIcon: Icon(Icons.call),
                          //         floatingLabelBehavior:
                          //             FloatingLabelBehavior.always),
                          //   ),
                          //   onTap: () async {
                          //     await callMobile(kalapa['facebookFriendMobile1']);
                          //   },
                          // ),
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['facebookFriendMobile1']),
                              child: InkWell(
                                child: TextFormField(
                                  readOnly: true,
                                  enabled: false,
                                  minLines: 1,
                                  initialValue: kalapa['facebookFriendMobile1'],
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: "SĐT bạn KH FB (1)",
                                      suffixIcon: Icon(Icons.call),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ),
                                onTap: () async {
                                  await callMobile(
                                      kalapa['facebookFriendMobile1']);
                                },
                              )),
                          SizedBox(
                            height: 4.0,
                          ),
                          // InkWell(
                          //     onTap: () async {
                          //       await handleOpenLinkFB(kalapa['facebookFriendLink1']);
                          //     },
                          //     child: TextFormField(
                          //       readOnly: true,
                          //       enabled: false,
                          //       minLines: 1,
                          //       initialValue: kalapa['facebookFriendLink1'],
                          //       decoration: InputDecoration(
                          //           contentPadding: EdgeInsets.all(10.0),
                          //           labelText: "FB bạn KH (1)",
                          //           suffixIcon: Icon(Icons.arrow_forward_ios),
                          //           floatingLabelBehavior:
                          //               FloatingLabelBehavior.always),
                          //     )),
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['facebookFriendLink1']),
                              child: InkWell(
                                  onTap: () async {
                                    await handleOpenLinkFB(
                                        kalapa['facebookFriendLink1']);
                                  },
                                  child: TextFormField(
                                    readOnly: true,
                                    enabled: false,
                                    minLines: 1,
                                    initialValue: kalapa['facebookFriendLink1'],
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        labelText: "FB bạn KH (1)",
                                        suffixIcon:
                                            Icon(Icons.arrow_forward_ios),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                  ))),
                          SizedBox(
                            height: 4.0,
                          ),
                          // InkWell(
                          //     onTap: () async {
                          //       await callMobile(kalapa['facebookFriendMobile2']);
                          //     },
                          //     child: TextFormField(
                          //       readOnly: true,
                          //       enabled: false,
                          //       minLines: 1,
                          //       initialValue: kalapa['facebookFriendMobile2'],
                          //       decoration: InputDecoration(
                          //           contentPadding: EdgeInsets.all(10.0),
                          //           labelText: "SĐT bạn KH FB (2)",
                          //           suffixIcon: Icon(Icons.call),
                          //           floatingLabelBehavior:
                          //               FloatingLabelBehavior.always),
                          //     )),
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['facebookFriendMobile2']),
                              child: InkWell(
                                  onTap: () async {
                                    await callMobile(
                                        kalapa['facebookFriendMobile2']);
                                  },
                                  child: TextFormField(
                                    readOnly: true,
                                    enabled: false,
                                    minLines: 1,
                                    initialValue:
                                        kalapa['facebookFriendMobile2'],
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        labelText: "SĐT bạn KH FB (2)",
                                        suffixIcon: Icon(Icons.call),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                  ))),
                          SizedBox(
                            height: 4.0,
                          ),
                          // InkWell(
                          //     onTap: () async {
                          //       await handleOpenLinkFB(kalapa['facebookFriendLink2']);
                          //     },
                          //     child: TextFormField(
                          //       readOnly: true,
                          //       enabled: false,
                          //       minLines: 1,
                          //       initialValue: kalapa['facebookFriendLink2'],
                          //       decoration: InputDecoration(
                          //           contentPadding: EdgeInsets.all(10.0),
                          //           labelText: "FB bạn KH (2)",
                          //           suffixIcon: Icon(Icons.arrow_forward_ios),
                          //           floatingLabelBehavior:
                          //               FloatingLabelBehavior.always),
                          //     )),
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['facebookFriendLink2']),
                              child: InkWell(
                                  onTap: () async {
                                    await handleOpenLinkFB(
                                        kalapa['facebookFriendLink2']);
                                  },
                                  child: TextFormField(
                                    readOnly: true,
                                    enabled: false,
                                    minLines: 1,
                                    initialValue: kalapa['facebookFriendLink2'],
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        labelText: "FB bạn KH (2)",
                                        suffixIcon:
                                            Icon(Icons.arrow_forward_ios),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                  ))),
                          SizedBox(
                            height: 4.0,
                          ),
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['facebookFriendMobile3']),
                              child: InkWell(
                                  onTap: () async {
                                    await callMobile(
                                        kalapa['facebookFriendMobile3']);
                                  },
                                  child: TextFormField(
                                    readOnly: true,
                                    enabled: false,
                                    minLines: 1,
                                    initialValue:
                                        kalapa['facebookFriendMobile3'],
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        labelText: "SĐT bạn KH FB (3)",
                                        suffixIcon: Icon(Icons.call),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                  ))),
                          // InkWell(
                          //     onTap: () async {
                          //       await callMobile(kalapa['facebookFriendMobile3']);
                          //     },
                          //     child: TextFormField(
                          //       readOnly: true,
                          //       enabled: false,
                          //       minLines: 1,
                          //       initialValue: kalapa['facebookFriendMobile3'],
                          //       decoration: InputDecoration(
                          //           contentPadding: EdgeInsets.all(10.0),
                          //           labelText: "SĐT bạn KH FB (3)",
                          //           suffixIcon: Icon(Icons.call),
                          //           floatingLabelBehavior:
                          //               FloatingLabelBehavior.always),
                          //     )),
                          SizedBox(
                            height: 4.0,
                          ),
                          // InkWell(
                          //     onTap: () async {
                          //       await handleOpenLinkFB(kalapa['facebookFriendLink3']);
                          //     },
                          //     child: TextFormField(
                          //       readOnly: true,
                          //       enabled: false,
                          //       minLines: 1,
                          //       initialValue: kalapa['facebookFriendLink3'],
                          //       decoration: InputDecoration(
                          //           contentPadding: EdgeInsets.all(10.0),
                          //           labelText: "FB bạn KH (3)",
                          //           suffixIcon: Icon(Icons.arrow_forward_ios),
                          //           border: InputBorder.none,
                          //           floatingLabelBehavior:
                          //               FloatingLabelBehavior.always),
                          //     )),
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['facebookFriendLink3']),
                              child: InkWell(
                                  onTap: () async {
                                    await handleOpenLinkFB(
                                        kalapa['facebookFriendLink3']);
                                  },
                                  child: TextFormField(
                                    readOnly: true,
                                    enabled: false,
                                    minLines: 1,
                                    initialValue: kalapa['facebookFriendLink3'],
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        labelText: "FB bạn KH (3)",
                                        suffixIcon:
                                            Icon(Icons.arrow_forward_ios),
                                        border: InputBorder.none,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                  ))),
                          SizedBox(
                            height: 4.0,
                          )
                        ])),
                    padding: EdgeInsets.only(left: 7.0, right: 7.0)),
                Padding(
                    padding: EdgeInsets.only(left: 7.0, right: 7.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: <
                                Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 30, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Bảo hiểm y tế',
                                    style: TextStyle(
                                        fontSize: AppFont.fontSize16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Divider(
                            color: AppColor.blackOpacity,
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   enabled: false,
                          //   minLines: 1,
                          //   initialValue: kalapa['healthAddress'],
                          //   decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.all(10.0),
                          //       labelText: "Địa chỉ khách hàng",
                          //       floatingLabelBehavior: FloatingLabelBehavior.always),
                          // ),
                          Visibility(
                              visible:
                                  Utils.checkIsNotNull(kalapa['healthAddress']),
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                minLines: 1,
                                initialValue: kalapa['healthAddress'],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    labelText: "Địa chỉ khách hàng",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              )),
                          SizedBox(
                            height: 4.0,
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   enabled: false,
                          //   minLines: 1,
                          //   initialValue: kalapa['healthRepresentativeName'],
                          //   decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.all(10.0),
                          //       labelText: "Tên chủ hộ",
                          //       border: InputBorder.none,
                          //       floatingLabelBehavior: FloatingLabelBehavior.always),
                          // ),
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['healthRepresentativeName']),
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                minLines: 1,
                                initialValue:
                                    kalapa['healthRepresentativeName'],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    labelText: "Tên chủ hộ",
                                    border: InputBorder.none,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              )),
                          SizedBox(
                            height: 4.0,
                          ),
                        ]))),
                Padding(
                    padding: EdgeInsets.only(left: 7.0, right: 7.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: <
                                Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 30, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Bảo hiểm xã hội',
                                    style: TextStyle(
                                        fontSize: AppFont.fontSize16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Divider(
                            color: AppColor.blackOpacity,
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   enabled: false,
                          //   minLines: 1,
                          //   initialValue: kalapa['socialMobile'],
                          //   decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.all(10.0),
                          //       labelText: "Số điện thoại KH",
                          //       floatingLabelBehavior: FloatingLabelBehavior.always),
                          // ),
                          Visibility(
                              visible:
                                  Utils.checkIsNotNull(kalapa['socialMobile']),
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                minLines: 1,
                                initialValue: kalapa['socialMobile'],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    labelText: "Số điện thoại KH",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              )),
                          SizedBox(
                            height: 4.0,
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   enabled: false,
                          //   minLines: 1,
                          //   initialValue: kalapa['socialCurrentAddress'],
                          //   decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.all(10.0),
                          //       labelText: "Địa chỉ",
                          //       border: InputBorder.none,
                          //       floatingLabelBehavior: FloatingLabelBehavior.always),
                          // ),
                          Visibility(
                            child: TextFormField(
                              readOnly: true,
                              enabled: false,
                              minLines: 1,
                              initialValue: kalapa['socialCurrentAddress'],
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: "Địa chỉ",
                                  border: InputBorder.none,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always),
                            ),
                            visible: Utils.checkIsNotNull(
                                kalapa['socialCurrentAddress']),
                          )
                        ]))),
                Padding(
                    padding: EdgeInsets.only(left: 7.0, right: 7.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        elevation: 5,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: <
                                Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 30, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Thông tin viễn thông',
                                    style: TextStyle(
                                        fontSize: AppFont.fontSize16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Divider(
                            color: AppColor.blackOpacity,
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   enabled: false,
                          //   minLines: 1,
                          //   initialValue: kalapa['telcoNationalID'],
                          //   decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.all(10.0),
                          //       labelText: "CMND (1)",
                          //       floatingLabelBehavior: FloatingLabelBehavior.always),
                          // ),
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['telcoNationalID']),
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                minLines: 1,
                                initialValue: kalapa['telcoNationalID'],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    labelText: "CMND (1)",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              )),
                          SizedBox(
                            height: 4.0,
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   enabled: false,
                          //   minLines: 1,
                          //   initialValue: kalapa['telcoNationalID2'],
                          //   decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.all(10.0),
                          //       labelText: "CMND (2)",
                          //       floatingLabelBehavior: FloatingLabelBehavior.always),
                          // ),
                          Visibility(
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                minLines: 1,
                                initialValue: kalapa['telcoNationalID2'],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    labelText: "CMND (2)",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              ),
                              visible: Utils.checkIsNotNull(
                                  kalapa['telcoNationalID2'])),
                          SizedBox(
                            height: 4.0,
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   enabled: false,
                          //   minLines: 1,
                          //   initialValue: kalapa['telcoAddress'],
                          //   decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.all(10.0),
                          //       labelText: "Địa chỉ khách hàng",
                          //       floatingLabelBehavior: FloatingLabelBehavior.always),
                          // ),
                          Visibility(
                            child: TextFormField(
                              readOnly: true,
                              enabled: false,
                              minLines: 1,
                              initialValue: kalapa['telcoAddress'],
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: "Địa chỉ khách hàng",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always),
                            ),
                            visible:
                                Utils.checkIsNotNull(kalapa['telcoAddress']),
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          // TextFormField(
                          //   readOnly: true,
                          //   enabled: false,
                          //   minLines: 1,
                          //   initialValue: kalapa['telcoSubType'],
                          //   decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.all(10.0),
                          //       labelText: "Loại thuê bao",
                          //       border: InputBorder.none,
                          //       floatingLabelBehavior: FloatingLabelBehavior.always),
                          // ),
                          Visibility(
                              child: TextFormField(
                                readOnly: true,
                                enabled: false,
                                minLines: 1,
                                initialValue: kalapa['telcoSubType'],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    labelText: "Loại thuê bao",
                                    border: InputBorder.none,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always),
                              ),
                              visible:
                                  Utils.checkIsNotNull(kalapa['telcoSubType']))
                        ])))
              ])
        : centerWidgetNoData(
            titleT: 'Hiện chưa có thêm thông tin gì của khách hàng này');
  }

  String retunData(var value) {
    if (Utils.checkIsNotNull(value)) {
      return value;
    }
    return '';
  }

  Widget centerWidgetNoData({String titleT = 'Không có dữ liệu'}) {
    return Center(child: NoDataPayment(title: titleT));
  }

  List<Widget> buildScheduleFormHistoryPayment() {
    List<Widget> lstWidget = [];
    lstWidget.add(Padding(
        padding: EdgeInsets.all(7.0),
        child: Center(
            child: Text(("Mã hợp đồng " + (ticketModelParams?.contractId?.toString() ?? '')),
                style: TextStyle(fontSize: AppFont.fontSize16)))));
    for (int index = 0; index < lstSchedulePaymentHistory.length; index++) {
      lstWidget.add(Padding(
          padding: EdgeInsets.only(left: 7.0, right: 7.0),
          child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: ListTile(
                      dense: true,
                      title: buildTitleScheduleHistoryPayment(index))))));
    }
    return lstWidget;
  }

  Widget buildTitleScheduleHistoryPayment(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: Text(
            'Ngày đến hạn: ' +
                (Utils.checkIsNotNull(
                        lstSchedulePaymentHistory[index]['dueDate'])
                    ? Utils.convertTimeWithoutTime(
                        lstSchedulePaymentHistory[index]['dueDate'])
                    : ''),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: AppFont.fontSize16,
                color: Theme.of(context).primaryColor),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
                'Số tiền góp: ' +
                    (Utils.checkIsNotNull(lstSchedulePaymentHistory[index]
                            ['installmentAmount'])
                        ? Utils.formatPrice(lstSchedulePaymentHistory[index]
                                ['installmentAmount']
                            .round()
                            .toString())
                        : ''),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: AppFont.fontSize16))),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
              'Gốc : ' +
                  (Utils.checkIsNotNull(
                          lstSchedulePaymentHistory[index]['principal'])
                      ? Utils.formatPrice(lstSchedulePaymentHistory[index]
                              ['principal']
                          .round()
                          .toString())
                      : ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: AppFont.fontSize16,
                  color: Theme.of(context).primaryColor),
            )),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
              'Lãi : ' +
                  (Utils.checkIsNotNull(
                          lstSchedulePaymentHistory[index]['interest'])
                      ? Utils.formatPrice(lstSchedulePaymentHistory[index]
                              ['interest']
                          .round()
                          .toString())
                      : ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppFont.fontSize16),
            )),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
              'Phí Thu Hộ : ' +
                  (Utils.checkIsNotNull(
                          lstSchedulePaymentHistory[index]['collectFee'])
                      ? Utils.formatPrice(lstSchedulePaymentHistory[index]
                              ['collectFee']
                          .round()
                          .toString())
                      : ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppFont.fontSize16),
            )),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
              'Số dư cuối kỳ : ' +
                  (Utils.checkIsNotNull(
                          lstSchedulePaymentHistory[index]['closingPrincipal'])
                      ? Utils.formatPrice(lstSchedulePaymentHistory[index]
                              ['closingPrincipal']
                          .round()
                          .toString())
                      : ''),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppFont.fontSize16),
            ))
      ],
    );
  }

  Future<void> callMobile(phone) async {
    if (!Utils.checkIsNotNull(phone)) {
      return WidgetCommon.showSnackbar(_scaffoldKey, 'Không có dữ liệu');
    }
    var smsFrom = DateTime.now();
    var callFrom = DateTime.now();
    TicketModel newTicket = new TicketModel();
    newTicket.aggId = this.ticketModelParams?.aggId;
    newTicket.customerData = {'cellPhone': phone, 'homePhone': phone};
    var action =
        _collectionService.actionPhone(newTicket, ActionPhone.CALL, context);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CallSmsLog(
                  type: ActionPhone.CALL,
                  action: action,
                  smsFrom: smsFrom,
                  callFrom: callFrom,
                  ticketModel: newTicket,
                  phone: '',
                )));
  }

  Future<void> handleOpenLinkFB(link) async {
    if (!Utils.checkIsNotNull(link)) {
      return WidgetCommon.showSnackbar(_scaffoldKey, 'Không có dữ liệu');
    }
    final fallbackUrl = Uri.parse('https://www.facebook.com/FECREDIT.VN/');

    try {
      String facebookId = '';
      if (link.indexOf('facebook.com') > -1) {
        facebookId =
            link.substring(link.indexOf('facebook.com/') + 13, link.length);
      }
      // String fbProtocolUrl = 'fb://page/id=' + facebookId;
      final fbProtocolUrl = Uri.parse('fb://profile/' + facebookId);
      bool launched = await UrlLauncher.launchUrl(fbProtocolUrl);
      if (!launched) {
        await UrlLauncher.launchUrl(fallbackUrl);
      }
    } catch (e) {
      await UrlLauncher.launchUrl(fallbackUrl);
    }
  }

  @override
  void dispose() {
    WidgetCommon.dismissLoading();
    stateButtonOnlyText = ButtonState.idle;
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
