import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/events.dart';
import 'package:athena/screens/collections/checkin/widgets/customerName.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:dio/dio.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/loading-button.widget.dart';
import 'package:athena/widgets/common/collections/noDataPayment.widget.dart';
import 'package:athena/models/tickets/address.model.dart';
import 'package:athena/models/tickets/paymentInfo.model.dart';
import 'package:athena/common/config/app_config.dart';

class CheckPaymentScreen extends StatefulWidget {
  CheckPaymentScreen({Key? key}) : super(key: key);
  @override
  _CheckPaymentScreenState createState() => _CheckPaymentScreenState();
}

class _CheckPaymentScreenState extends State<CheckPaymentScreen>
    with AfterLayoutMixin {
  TicketModel? ticketModel;
  String type = '';
  String title = '';
  String message = '';
  bool isLoadAddress = false;
  bool isLoadPayment = false;
  List<AddressModel>? lstAddress;
  List<PaymentInfoModel>? lstPaymentInfo;
  final collectionService = new CollectionService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'checkPayment');
  @override
  initState() {
    super.initState();
  }

  Future<void> handleAction() async {
    try {
      if(ticketModel == null) {
        return;
      }
      stateButtonOnlyText = ButtonState.loading;
      setState(() {});
      Response? response;
      if (type == ActionPhone.CHECK_PAYMENT) {
        // String contractId = "20180420-0002150";
        response = await collectionService.getPayment(ticketModel?.contractId ??'');
      } else if (type == ActionPhone.CHECK_ADDRESS) {
        response =
            await collectionService.getCustomerMultipAddress(ticketModel?.aggId ??'');
      }
      stateButtonOnlyText = ButtonState.idle;
      if (response != null && Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData(response);
        if (lstData == null) {
          WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
          return;
        }
        eventBus.fire(ReloadList(ActionPhone.CHECK_PAYMENT));
        if (type == ActionPhone.CHECK_ADDRESS) {
          isLoadAddress = true;
          var sys = lstData['sys'];
          if (Utils.checkIsNotNull(sys)) {
            if (sys['code'] == 1) {
              var addresses = lstData['addresses'];
              if (Utils.isArray(addresses)) {
                lstAddress = [];
                addresses = addresses['address'];
                for (var address in addresses) {
                  lstAddress?.add(AddressModel.fromJson(address));
                }
              }
            }
          }
        } else if (type == ActionPhone.CHECK_PAYMENT) {
          isLoadPayment = true;
          if (Utils.isArray(lstData)) {
            lstPaymentInfo = [];
            for (var data in lstData) {
              lstPaymentInfo?.add(PaymentInfoModel.fromJson(data));
            }
          }
        } else {
          Utils.popPage(context);
        }
      }
      setState(() {});
    } catch (e) {
      stateButtonOnlyText = ButtonState.idle;
      setState(() {});
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {}

  Widget formDetail() {
    List<Widget> lstWidget = [];
    lstWidget.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10.0, top: 10),
      child: Center(child: buildColumnTitle()),
    ));

    if (isLoadAddress) {
      if (!Utils.isArray(lstAddress)) {
        return NoDataPayment(title: 'Không tìm thấy địa chỉ khách hàng');
      } else {
        for (AddressModel addressModel in lstAddress!) {
          lstWidget.add(Padding(
              padding: EdgeInsets.only(left: 7.0, right: 7.0),
              child: Card(
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 30, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Appl ID (PEGA): ' + addressModel.applId!,
                              style: TextStyle(
                                  fontSize: AppFont.fontSize16,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColor.blackOpacity,
                    ),
                    ListTile(
                      title: Text(addressModel.currentAddress ??''),
                      subtitle: Text("Địa Chỉ Tạm Trú"),
                      leading: Icon(Icons.home, color: AppColor.dashBoard1),
                    ),
                    Divider(
                      color: AppColor.blackOpacity,
                    ),
                    ListTile(
                      title: Text(addressModel.officeAddress ??''),
                      subtitle: Text("Địa chỉ Công Ty"),
                      leading: Icon(Icons.business, color: AppColor.dashBoard2),
                    ),
                    Divider(
                      color: AppColor.blackOpacity,
                    ),
                    ListTile(
                      title: Text(
                        addressModel.permanentAddress!,
                      ),
                      subtitle: Text("Địa Chỉ Thường Trú"),
                      leading: Icon(Icons.dns, color: AppColor.dashBoard3),
                    ),
                  ]))));
        }
      }
    }
    if (isLoadPayment) {
      if (!Utils.isArray(lstPaymentInfo)) {
        return NoDataPayment(title: 'Không tìm thấy thông tin thanh toán');
      } else {
        for (PaymentInfoModel paymentInfoModel in lstPaymentInfo!) {
          lstWidget.add(formDetailPaymentInfo(paymentInfoModel));
        }
      }
    }

    lstWidget.add(Container(height: 50.0));
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lstWidget);
  }

  @override
  Widget build(BuildContext context) {
   if (ticketModel == null) {
      final route = ModalRoute.of(context);
      if (route != null && route.settings.arguments != null) {
        final args = route.settings.arguments;

        if (args is Map<String, dynamic>) {
          ticketModel = args['ticketModel'] as TicketModel?;
          title = args['title'] as String? ?? '';
          type = args['type'] as String? ?? '';
          message = args['message'] as String? ?? '';
        }
      }
    }
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarCommon(
          title: title,
          lstWidget: [],
        ),
        bottomNavigationBar:
            Utils.isArray(lstAddress) || Utils.isArray(lstPaymentInfo)
                ? Container(height: 1.0)
                : LoadingButtonWidget(
                    height: 53,
                    callbackOK: () async {
                      handleAction();
                    },
                    title: (type == 'CHECK_PAYMENT') ? '' : 'Xem địa chỉ',
                  ),
        body: Container(
            height: AppState.getHeightDevice(context),
            width: AppState.getWidthDevice(context),
            child: SingleChildScrollView(
                child: (isLoadAddress || isLoadPayment)
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
                            margin:
                                EdgeInsets.only(left: 10, right: 10.0, top: 10),
                            child: Center(child: buildColumnTitle()),
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
                        ])))));
  }

  Widget formDetailPaymentInfo(PaymentInfoModel paymentInfo) {
    return Card(
        margin: EdgeInsets.all(7.0),
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 30, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(S.of(context).infomation,
                    style: TextStyle(
                        fontSize: AppFont.fontSize16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Divider(
            color: AppColor.blackOpacity,
          ),
          TextFormField(
            readOnly: true,
            // enabled: false,
            initialValue:
                Utils.formatPriceDouble(paymentInfo.transactionAmount),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: S.of(context).moneyPaymentTake + " *",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            readOnly: true,
            // enabled: false,
            initialValue: Utils.getTimeFromDate(
                Utils.convertTimeStampToDateEnhance(
                    paymentInfo.ipatMakerDate)),
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Ngày thanh toán",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            readOnly: true,
            // enabled: false,
            initialValue: Utils.getTimeFromDate(
                Utils.convertTimeStampToDateEnhance(
                    paymentInfo.transactionDate)),
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Ngày cập nhật tiền vào hệ thống",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            readOnly: true,
            // enabled: false,
            initialValue: paymentInfo.ipatCode,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Số hóa đơn",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
           TextFormField(
            readOnly: true,
            // enabled: false,
            initialValue: paymentInfo.transactionStatus == 'A' ? 'Active' : 'Cancel',
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Trạng thái",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            readOnly: true,
            // enabled: false,
            maxLength: null,
            initialValue: paymentInfo.description,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Ghi chú",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          )
        ]));
  }

  Widget buildColumnTitle() {
    return Column(
      children: [
        CustomerNameCheckInWidget(customerFullName: ticketModel?.fullName),
        Text(
            'Appl ID (${APP_CONFIG.APP_NAME_NEW}) : ' + (ticketModel?.contractId ?? '')),
        new SizedBox(height: 4.0),
      ],
    );
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
