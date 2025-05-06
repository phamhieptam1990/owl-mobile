import 'package:after_layout/after_layout.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/customer-request/customer-request.provider.dart';

import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/footerButtonOKCANCEL.widget.dart';

class FilterrequestScreen extends StatefulWidget {
  FilterrequestScreen({Key? key}) : super(key: key);
  @override
  _FilterrequestScreenState createState() => _FilterrequestScreenState();
}

class _FilterrequestScreenState extends State<FilterrequestScreen>
    with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  dynamic format = new DateFormat('dd/MM/yyyy');
  final _customerRequestSingeton = new CustomerRequestSingeton();
  dynamic dataStatusCode = [];
  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    try {
      setState(() {
        dataStatusCode = tblStatus();
      });
    } catch (e) {
      setState(() {});
    }
  }

  tblStatus() {
    return [
      {'id': 'all', 'name': S.of(context).all},
      {'id': 'OPEN', 'name': S.of(context).STATUS_CODE_OPEN},
      {'id': 'IN_PROGRESS', 'name': S.of(context).STATUS_CODE_IN_PROGRESS},
      {'id': 'ASSIGNED', 'name': S.of(context).STATUS_CODE_ASSIGNED},
      // {
      //   'id': 'OPNEED_MORE_INFOEN',
      //   'name': S.of(context).STATUS_CODE_NEED_MORE_INFO
      // },
      {
        'id': 'NEED_MORE_INFO',
        'name': S.of(context).STATUS_CODE_NEED_MORE_INFO
      },
      {'id': 'REJECTED', 'name': S.of(context).STATUS_CODE_REJECTED},
      {'id': 'DONE', 'name': S.of(context).STATUS_CODE_DONE},
    ];
  }

  Widget buildScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        new Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: new DateTimeField(
              mode: DateTimeFieldPickerMode.date,
              value: _customerRequestSingeton.filterData['dateFrom'] as DateTime?,
              onChanged: (DateTime? date) {
               if (date != null) {
                  setState(() {
                    _customerRequestSingeton.filterData['dateTo'] = date;
                  });
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: S.of(context).createdDateFrom,
                  hintText: 'Select date',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
              // label: "Select date",
              // firstDate: DateTime(1900),
              // lastDate: DateTime(2020),
              dateFormat: format),
        ),
        Divider(
          height: 0.0,
          thickness: 1.0,
        ),
        new Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: new DateTimeField(
              mode: DateTimeFieldPickerMode.date,
              value: _customerRequestSingeton.filterData['dateTo'],
              onChanged: (DateTime? date) {
                setState(() {
                  _customerRequestSingeton.filterData['dateTo'] = date;
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: S.of(context).createdDateTo,
                  hintText: 'Select date',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
              // label: "Select date",
              // firstDate: DateTime(1900),
              // lastDate: DateTime(2020),
              dateFormat: format),
        ),
        Divider(
          height: 0.0,
          thickness: 1.0,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 250.0),
          child: Container(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        // resizeToAvoidBottomPadding: true,
        appBar: AppBarCommon(title: S.of(context).filter, lstWidget: []),
        body: SingleChildScrollView(
          child: buildScreen(),
          reverse: false,
        ),
        bottomNavigationBar: FooterButonOKCANCELWidget(callbackOK: () async {
          Navigator.pop(context, true);
        }, callbackCancel: () async {
          _customerRequestSingeton.clearData();
          setState(() {});
        }));
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

class CheckInModel {
  String title;
  int value;
  CheckInModel(this.title, this.value);
}

class PTPModel {
  String title;
  int value;
  PTPModel(this.title, this.value);
}

class PaidCaseModel {
  String title;
  int value;
  PaidCaseModel(this.title, this.value);
}
