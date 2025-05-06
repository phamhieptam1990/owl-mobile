import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/tickets/address.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/customerName.widget.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/noDataPayment.widget.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/widgets/common/call_sms_log/call_sms_log.dart';
import 'package:athena/widgets/common/common.dart';

class DetailActionFeatureScreen extends StatefulWidget {
  final String type;
  final TicketModel ticketModel;
  final String title;
  final dynamic target;

  const DetailActionFeatureScreen(
      {Key? key,
      required this.type,
      required this.ticketModel,
      required this.title,
      required this.target})
      : super(key: key);

  @override
  _DetailActionFeatureScreenState createState() =>
      _DetailActionFeatureScreenState();
}

class _DetailActionFeatureScreenState extends State<DetailActionFeatureScreen>
    with AfterLayoutMixin {
  bool isLoadData = true;
  bool isShowEarlyTerminationCard = false;
  List<AddressModel>? lstAddress;
  String message = '';
  var inputData;

  List<dynamic> lstPaymentHistory = [];
  List<dynamic> lstSchedulePaymentHistory = [];
  CollectionService _collectionService = new CollectionService();
  var paymentInfo;
  var kalapa;
  var earlyTermination;
  bool toDayIsDueDate = false;
  bool isShowAllKalapa = false;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'DetailActionFeatureScreen');

  Widget formDetailAddress() {
    if (!Utils.isArray(lstAddress) && isLoadData) {
      return NoDataPayment(title: 'Không tìm thấy địa chỉ khách hàng');
    }
    List<Widget> lstWidget = [];
    lstWidget.add(Container(
      margin: EdgeInsets.only(left: 10, right: 10.0, top: 10),
      child: Center(child: buildColumnTitleAddress()),
    ));
    for (AddressModel addressModel in lstAddress!) {
      lstWidget.add(
        Padding(
            padding: EdgeInsets.only(left: 7.0, right: 7.0),
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                elevation: 10,
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
                    title: Text(addressModel.officeAddress ?? ''),
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
                ]))),
      );
    }
    lstWidget.add(Container(height: 50.0));
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lstWidget);
  }

  Widget buildColumnTitleAddress() {
    return Column(
      children: [
        CustomerNameCheckInWidget(
            customerFullName: widget.ticketModel.fullName),
        Text('Appl ID (${APP_CONFIG.APP_NAME_NEW}) : ' +
            (widget.ticketModel.contractId ??'')),
        new SizedBox(height: 4.0),
      ],
    );
  }

  Widget buildLoadView() {
    if (Utils.checkIsNotNull(inputData)) {
      if (widget.type == ActionPhone.CHECK_ADDRESS) {
        var sys = inputData['sys'];
        if (Utils.checkIsNotNull(sys)) {
          if (sys['code'] == 1) {
            var addresses = inputData['addresses'];
            if (Utils.isArray(addresses)) {
              lstAddress = [];
              addresses = addresses['address'];
              for (var address in addresses) {
                lstAddress?.add(AddressModel.fromJson(address));
              }
              return formDetailAddress();
            }
          }
        }
      }
      if (widget.type == ActionPhone.CHECK_KALAPA_INFOMATION) {
        var sys = inputData['sys'];
        if (Utils.checkIsNotNull(sys)) {
          if (sys['code'] == 1) {
            if (Utils.checkIsNotNull(inputData['kalapa'])) {
              kalapa = inputData['kalapa'];
              if (Utils.checkIsNotNull(kalapa)) {
                kalapa.forEach((final String key, final value) {
                  if (Utils.checkIsNotNull(value)) {
                    isShowAllKalapa = true;
                  }
                });
              }
              return buildKalapaInfomation();
            }
          }
        }
      }
      if (widget.type == ActionPhone.EARLY_TERMINATION) {
        earlyTermination = inputData;
        if (Utils.checkIsNotNull(earlyTermination)) {
          final sysLoanBasicInfo = earlyTermination['sysLoanBasicInfo'];
          final sysForeclosureInfo = earlyTermination['sysForeclosureInfo'];
          if (Utils.checkIsNotNull(sysLoanBasicInfo) ||
              Utils.checkIsNotNull(sysForeclosureInfo)) {
            if (sysLoanBasicInfo['code'] == 3 ||
                sysForeclosureInfo['code'] == 3) {
              return NoDataWidget();
            }
          }
          toDayIsDueDate = earlyTermination['toDayIsDueDate'];
          if (widget.ticketModel.feType == ActionPhone.CARD) {
            isShowEarlyTerminationCard = true;
          }
          return buildEarlyTermination();
        }
      }
      if (widget.type == ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY) {
        if (Utils.checkIsNotNull(inputData['loanBasicInfo'])) {
          var repaymentSchedules =
              inputData['loanBasicInfo']['repaymentSchedules'];
          if (Utils.checkIsNotNull(repaymentSchedules)) {
            var repaymentSchedule = repaymentSchedules['repaymentSchedule'];
            if (Utils.checkIsNotNull(repaymentSchedule)) {
              if (Utils.isArray(repaymentSchedule)) {
                lstSchedulePaymentHistory = repaymentSchedule.reversed.toList();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildScheduleFormHistoryPayment(),
                );
              }
            }
          }
        }
      }
      if (widget.type == ActionPhone.CHECK_HISTORY_PAYMENT) {
        if (Utils.checkIsNotNull(inputData['loanSecInfo'])) {
          var paymentHistories = inputData['loanSecInfo']['paymentHistories'];
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildFormHistoryPayment(),
                );
              }
            }
          }
        }
      } else if (widget.type == ActionPhone.CHECK_HISTORY_PAYMENT_CARD) {
        if (Utils.checkIsNotNull(inputData['paymentInfo'])) {
          paymentInfo = inputData['paymentInfo'];
          return Card(
              margin: EdgeInsets.all(7.0),
              child: ListTile(
                title: buildTitleCard(),
              ));
        }
      }
    }
    return NoDataWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarCommon(
          title: widget.title,
          lstWidget: [],
        ),
        body: SingleChildScrollView(
            child: isLoadData
                ? Container(
                    height: AppState.getHeightDevice(context),
                    width: AppState.getWidthDevice(context),
                    child: ShimmerCheckIn(
                      height: 60.0,
                      countLoop: 8,
                    ))
                : buildLoadView()));
  }

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

  Widget buildTitleCard() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: Text(
            'Ngày tiền vào hệ thống: ' + Utils.convertTimeWithoutTime(now),
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
            'Ngày thanh toán: ' + Utils.convertTimeWithoutTime(now),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: AppFont.fontSize16),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: Text(
              'Số tiền thanh toán: ' +
                  (Utils.checkIsNotNull(paymentInfo['fullPaymentAmount'])
                      ? Utils.formatPrice(
                          paymentInfo['fullPaymentAmount'].round().toString())
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
              'Số Biên Nhận: ',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: AppFont.fontSize16),
            ))
      ],
    );
  }

  List<Widget> buildFormHistoryPayment() {
    List<Widget> lstWidget = [];
    lstWidget.add(Padding(
        padding: EdgeInsets.all(7.0),
        child: Center(
            child: Text("Mã hợp đồng " + widget.ticketModel.contractId!,
                style: TextStyle(fontSize: AppFont.fontSize16)))));
    for (int index = 0; index < lstPaymentHistory.length; index++) {
      lstWidget.add(formDetailPayment(index));
    }
    return lstWidget;
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
                      child: Column(mainAxisSize: MainAxisSize.min, children: <
                          Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 30, top: 20),
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
                        Visibility(
                          visible: Utils.checkIsNotNull(kalapa['facebookLink']),
                          child: InkWell(
                            child: TextFormField(
                              readOnly: true,
                              enabled: false,
                              minLines: 1,
                              initialValue: kalapa['facebookLink'],
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: "Facebook KH",
                                  suffixIcon: InkWell(
                                    child: Icon(Icons.arrow_forward_ios),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always),
                            ),
                            onTap: () async {
                              await handleOpenLinkFB(kalapa['facebookLink']);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
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
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        // await callMobile(kalapa['facebookFriendMobile1']);
                                      },
                                      child: Icon(Icons.call),
                                    ),
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
                                      suffixIcon: Icon(Icons.arrow_forward_ios),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ))),
                        SizedBox(
                          height: 4.0,
                        ),
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
                                  initialValue: kalapa['facebookFriendMobile2'],
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
                                      suffixIcon: Icon(Icons.arrow_forward_ios),
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
                                  initialValue: kalapa['facebookFriendMobile3'],
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: "SĐT bạn KH FB (3)",
                                      suffixIcon: Icon(Icons.call),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ))),
                        SizedBox(
                          height: 4.0,
                        ),
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
                                      suffixIcon: Icon(Icons.arrow_forward_ios),
                                      border: InputBorder.none,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                ))),
                        SizedBox(
                          height: 4.0,
                        )
                      ])),
                  padding: EdgeInsets.only(left: 7.0, right: 7.0),
                ),
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
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
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
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['socialCurrentAddress']),
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
                              )),
                        ]))),
                Padding(
                    padding: EdgeInsets.only(left: 7.0, right: 7.0),
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
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
                          Visibility(
                              visible: Utils.checkIsNotNull(
                                  kalapa['telcoNationalID2']),
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
                              )),
                          SizedBox(
                            height: 4.0,
                          ),
                          Visibility(
                              visible:
                                  Utils.checkIsNotNull(kalapa['telcoAddress']),
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
                              )),
                          SizedBox(
                            height: 4.0,
                          ),
                          Visibility(
                              visible:
                                  Utils.checkIsNotNull(kalapa['telcoSubType']),
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
                              )),
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
            child: Text("Mã hợp đồng " + widget.ticketModel.contractId!,
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
                    // contentPadding:
                    //     EdgeInsets.only(left: 0.0, bottom: 0, top: 0, right: 8.0),
                    title: buildTitleScheduleHistoryPayment(index)))),
      ));
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
              'Gốc: ' +
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
              'Lãi: ' +
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
              'Phí Thu Hộ: ' +
                  (Utils.checkIsNotNull(
                          lstSchedulePaymentHistory[index]['repaymentFee'])
                      ? Utils.formatPrice(lstSchedulePaymentHistory[index]
                              ['repaymentFee']
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
              'Số dư cuối kỳ: ' +
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

  Widget buildEarlyTermination() {
    if (isShowEarlyTerminationCard) {
      return Container(
          width: AppState.getWidthDevice(context),
          child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 7.0, bottom: 3.0, left: 15.0, right: 10.0),
                    child: Text(
                      'Đối với hợp đồng Thẻ vui lòng liên hệ bộ phận Support Admin hoặc Bộ Phận Chăm Sóc KH để được biết thông tin chính xác.',
                      style: TextStyle(fontSize: AppFont.fontSize16),
                    ),
                  )
                ],
              )));
    }
    return Container(
        width: AppState.getWidthDevice(context),
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 7.0, bottom: 3.0, left: 15.0),
                  child: Text(
                    'Dư nợ gốc: ' +
                        (Utils.checkIsNotNull(
                                earlyTermination['principleOutstanding'])
                            ? Utils.formatPrice(
                                earlyTermination['principleOutstanding']
                                    .round()
                                    .toString())
                            : ''),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: AppFont.fontSize16),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0),
                    child: Text(
                        'Lãi (Quá Hạn & Dự Thu): ' +
                            (Utils.checkIsNotNull(
                                    earlyTermination['interestBillUnBill'])
                                ? Utils.formatPrice(
                                    earlyTermination['interestBillUnBill']
                                        .round()
                                        .toString())
                                : ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: AppFont.fontSize16))),
                Padding(
                    padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0),
                    child: Text(
                      'Phí thanh lý : ' +
                          (Utils.checkIsNotNull(
                                  earlyTermination['prePaymentPenalty'])
                              ? Utils.formatPrice(
                                  earlyTermination['prePaymentPenalty']
                                      .round()
                                      .toString())
                              : ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: AppFont.fontSize16),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0),
                    child: Text(
                      'Phí thu hộ : ' +
                          (Utils.checkIsNotNull(earlyTermination['advice'])
                              ? Utils.formatPrice(
                                  earlyTermination['advice'].round().toString())
                              : ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: AppFont.fontSize16),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0),
                    child: Text(
                      'Lãi trả chậm: ' +
                          (Utils.checkIsNotNull(
                                  earlyTermination['penaltyInterestPayoff'])
                              ? Utils.formatPrice(
                                  earlyTermination['penaltyInterestPayoff']
                                      .round()
                                      .toString())
                              : ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: AppFont.fontSize16),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 3.0, bottom: 3.0, left: 15.0),
                    child: Text(
                      'Tổng tiền phải thanh toán : ' +
                          (Utils.checkIsNotNull(
                                  earlyTermination['totalReceivable'])
                              ? Utils.formatPrice(
                                  earlyTermination['totalReceivable']
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
                    padding: EdgeInsets.only(top: 3.0, bottom: 7.0, left: 15.0),
                    child: Text(
                      'Ngày đến hạn: ' +
                          _collectionService
                              .showDueDateEarlyTermination(earlyTermination),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: AppFont.fontSize16),
                    )),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                Visibility(
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 7.0, bottom: 3.0, left: 15.0),
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
                                    _collectionService
                                        .showDueDateEarlyTermination(
                                            earlyTermination),
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
                      padding:
                          EdgeInsets.only(top: 7.0, bottom: 3.0, left: 15.0),
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
            )));
  }

  Future<void> callMobile(phone) async {
    if (!Utils.checkIsNotNull(phone)) {
      WidgetCommon.showSnackbar(_scaffoldKey, 'Không có dữ liệu');
      return;
    }
    var smsFrom = DateTime.now();
    var callFrom = DateTime.now();
    TicketModel newTicket = new TicketModel();
    newTicket.aggId = widget.ticketModel.aggId;
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
                phone: '')));
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
  void afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 300));
    try {
      if (widget.target['originalValue'] != null) {
        if (widget.target['originalValue']['inputData'] != null) {
          inputData = widget.target['originalValue']['inputData'];
        }
      }
    } catch (e) {
    } finally {
      this.isLoadData = false;
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
