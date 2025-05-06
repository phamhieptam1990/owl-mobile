import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:get/get_connect/http/src/response/response.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:pit_sms_call_log/pit_sms_call_log.dart' as sms;
import 'package:athena/common/constants/general.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/generated/l10n.dart';

class CallSmsLog extends StatefulWidget {
  final DateTime callFrom;
  final DateTime smsFrom;
  final dynamic ticketModel;
  final String type;
  final String phone;
  final action;

  /// sms, call
  CallSmsLog(
      {Key? key,
      required this.action,
      required this.type,
      required this.callFrom,
      required this.smsFrom,
      required this.ticketModel,
      required this.phone})
      : super(key: key);
  @override
  _CallSmsLogState createState() => _CallSmsLogState();
}

class _CallSmsLogState extends State<CallSmsLog>
    with AfterLayoutMixin, WidgetsBindingObserver {
  int currentIndex = 0;
  DateTime callTo = DateTime.now();
  DateTime smsTo = DateTime.now();
  // Permission _permission;
  final _collectionService = new CollectionService();
  // PermissionStatus _permissionStatus = PermissionStatus.permanentlyDenied;
  bool isPop = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    this.isPop = false;
    super.dispose();
  }

  @override
  Future<dynamic> afterFirstLayout(BuildContext context) async {
    // widget.action();
    if (widget.phone.length > 0) {
      callPhone(widget.phone);
    } else {
      String phone = widget.ticketModel.customerData['cellPhone'] ??
          widget.ticketModel.customerData['homePhone'];
      callPhone(phone);
    }
  }

  callPhone(phone) async {
    FlutterPhoneDirectCaller.callNumber(phone);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (widget.type == ActionPhone.CALL) {
          if (isPop) {
            return;
          }
          isPop = true;
          if (widget.phone.length > 0) {
            getCallHistoryExt(widget.phone);
          } else {
            getCallHistory(widget.ticketModel);
          }
        }
        if (widget.type == ActionPhone.SMS) {
          Navigator.pop(context, false);
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        // Bạn có thể để trống hoặc log để theo dõi
        break;
    }
  }

  getCallHistory(item) async {
    try {
      String phone =
          item.customerData['cellPhone'] ?? item.customerData['homePhone'];
      callTo = DateTime.now();
      final Iterable<CallLogEntry> result = await CallLog.query(
          number: phone,
          dateFrom: widget.callFrom.millisecondsSinceEpoch,
          dateTo: callTo.millisecondsSinceEpoch);
      for (CallLogEntry entry in result) {
        final Response res = await this
            ._collectionService
            .recordUserCallLog(context, entry, widget.ticketModel.aggId, false);
        if (Utils.checkRequestIsComplete(res)) {
          Navigator.pop(context, true);
          return;
        }
      }
      Navigator.pop(context, false);
    } catch (e) {
      print(e);
      Navigator.pop(context, false);
    }
  }

  getCallHistoryExt(String phone) async {
    try {
      callTo = DateTime.now();
      final Iterable<CallLogEntry> result = await CallLog.query(
          number: phone,
          dateFrom: widget.callFrom.millisecondsSinceEpoch,
          dateTo: callTo.millisecondsSinceEpoch);
      for (CallLogEntry entry in result) {
        final Response res = await this
            ._collectionService
            .recordUserCallLog(context, entry, widget.ticketModel.aggId, false);
        if (Utils.checkRequestIsComplete(res)) {
          Navigator.pop(context, true);
          return;
        }
      }
      Navigator.pop(context, false);
    } catch (e) {
      Navigator.pop(context, false);
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await Permission.sms.status;
    if (status.isDenied) {
      final request = await Permission.sms.request();
      if (request.isGranted) {
        initPlatformState();
      }
    } else {
      initPlatformState();
    }
  }

  Future<void> initPlatformState() async {
    // smsTo = DateTime.now();
    // String phone = widget.ticketModel.customerData['cellPhone'] ??
    //     widget.ticketModel.customerData['homePhone'];
    // try {
    //   var reponsesmsList = await sms.PitSmsCallLog.getSmsLog(daysBefore: 1);
    //   for (sms.SmsLog entry in reponsesmsList) {
    //     if (entry.date <= smsTo.millisecondsSinceEpoch &&
    //         entry.date >= widget.smsFrom.millisecondsSinceEpoch &&
    //         entry.address == phone) {
    //       // sms.SmsLog item = entry;
    //       final Response response = await this
    //           ._collectionService
    //           .recordUserSmsLog(context, entry, widget.ticketModel.aggId);
    //       if (Utils.checkRequestIsComplete(response)) {
    //         Navigator.pop(context, true);
    //         return;
    //         // await getTicketHistory();
    //       }
    //     }
    //   }
    // } catch (e) {
    //   Navigator.pop(context, false);
    // }
    // Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   key: _scaffoldKeySub,
    //   appBar: AppBarCommon(
    //     title: "Log",
    //     lstWidget: [],
    //   ),
    //   body: Container(),
    // );
    // return Align(
    //   alignment: Alignment.bottomCenter,
    //   child: Container(
    //     height: 300,
    //     child: SizedBox.expand(child: FlutterLogo()),
    //     margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(40),
    //     ),
    //   ),
    // );
    return new Container(
      alignment: AlignmentDirectional.center,
      decoration: new BoxDecoration(
        color: Colors.white70,
      ),
      child: new Container(
        decoration: new BoxDecoration(
            color: Colors.blue[50],
            borderRadius: new BorderRadius.circular(10.0)),
        width: 300.0,
        height: 200.0,
        alignment: AlignmentDirectional.center,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: new SizedBox(
                height: 50.0,
                width: 50.0,
                child: new CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  value: null,
                  strokeWidth: 7.0,
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: new Center(
                child: new Text(
                  S.of(context).loading,
                  style: new TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
