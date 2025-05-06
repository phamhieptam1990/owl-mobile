import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/category/action_ticket.model.dart';
import 'package:athena/models/category/contact_by_ticket.model.dart';
import 'package:athena/models/category/loan_type_ticket.model.dart';
import 'package:athena/models/category/place_contact_ticket.model.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/checkin.provider.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/category/category.service.dart';
import 'package:provider/provider.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/utils/app_state.dart';
import '../collections.service.dart';

class CheckInScreen extends StatefulWidget {
  CheckInScreen({Key? key}) : super(key: key);
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> with AfterLayoutMixin {
  final _collectionService = new CollectionService();
  final _categoryService = new CategoryService();
  final _categoryProvider = new CategorySingeton();
  final _checkInProvider = getIt<CheckInProvider>();
  TicketModel? ticketModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formLoginKey = new GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    handleData();
  }

  void handleData() async {
    // ContactByTicket
    Response response = await _categoryService.getContactByTicket();
    var lstData;
    if (Utils.checkRequestIsComplete(response)) {
      lstData = response.data['data'];
      for (var data in lstData) {
        _categoryProvider.getLstContactByTicketM
            .add(ContactByTicketModel.fromJson(data));
      }
    }
    // // Action
    response = await _categoryService.getActionTicket();
    if (Utils.checkRequestIsComplete(response)) {
      lstData = response.data['data'];
      for (var data in lstData) {
        _categoryProvider.getLstActionModel
            .add(ActionTicketModel.fromJson(data));
      }
    }

    // // Loan type
    response = await _categoryService.getLoanTypeTicket();
    if (Utils.checkRequestIsComplete(response)) {
      lstData = response.data['data'];
      for (var data in lstData) {
        _categoryProvider.getLstLoanTypeTicketM
            .add(LoanTypeTicketModel.fromJson(data));
      }
    }

    response = await _categoryService.getTicketStatus();
    if (Utils.checkRequestIsComplete(response)) {
      lstData = response.data['data'];
      for (var data in lstData) {
        _categoryProvider.getLstStatusTicketModel
            .add(StatusTicketModel.fromJson(data));
      }
    }
    if (ticketModel != null) {
      _phoneController.text = _collectionService.getPhoneCustomer(ticketModel);
    }
    setState(() {});
  }

  Widget buildTitle(BuildContext context) {
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Text(S.of(context).checkIn)],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ticketModel = ModalRoute.of(context)?.settings.arguments as TicketModel?;
    return ChangeNotifierProvider<CheckInProvider>(
        create: (context) => _checkInProvider,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBarCommon(title: S.of(context).checkIn, lstWidget: []),
            body: Container(
              height: AppState.getHeightDevice(context),
              width: AppState.getWidthDevice(context),
              child: buildForm(),
            )));
  }

  Widget formImage() {
    return Container(
      height: 150.0,
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).document,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    child: Icon(Icons.camera),
                    onTap: () async {
                      // openCamera();
                    },
                  )
                  // FlatButton.icon(
                  //     label: Text(''),
                  //     onPressed: () async => {},
                  //     icon: Icon(Icons.camera))
                ],
              ),
            ),
            Divider(
              color: AppColor.blackOpacity,
            ),
          ],
        ),
      ),
      // )
    );
  }

  Widget formDetail() {
    return Card(
        margin: EdgeInsets.all(7.0),
        child: new Form(
            key: _formLoginKey,
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
                validator: (val) => Utils.isRequire(context, val ?? ''),
                keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (term) {},
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).position + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              DropdownButtonFormField<ContactByTicketModel>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: S.of(context).contactBy + " *",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                isExpanded: true,
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstContactByTicketM
                    .map((ContactByTicketModel value) {
                  return new DropdownMenuItem<ContactByTicketModel>(
                    value: value,
                    child: new Text(value?.modeName ?? ''),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              DropdownButtonFormField<ContactByTicketModel>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: S.of(context).contactWith + " *",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                isExpanded: true,
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstContactByTicketM
                    .map((ContactByTicketModel value) {
                  return new DropdownMenuItem<ContactByTicketModel>(
                    value: value,
                    child: new Text(value?.modeName ?? ''),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              DropdownButtonFormField<PlaceContactTicketModel>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: S.of(context).contactPlace + " *",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                isExpanded: true,
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstPlaceContactTicketModel
                    .map((PlaceContactTicketModel value) {
                  return new DropdownMenuItem<PlaceContactTicketModel>(
                    value: value,
                    child: new Text(value?.placeValue ?? ''),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).fullNamePayment + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              DropdownButtonFormField<PlaceContactTicketModel>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: S.of(context).moneyPaymentTake + " *",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                isExpanded: true,
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstPlaceContactTicketModel
                    .map((PlaceContactTicketModel value) {
                  return new DropdownMenuItem<PlaceContactTicketModel>(
                    value: value,
                    child: new Text(value?.placeName ?? ''),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).timeScheduleNext + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).note + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).customerPhone + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ])));
  }

  Widget buildForm() {
    return Column(children: [
      Container(
        child: Text(
          "Phan Văn A",
          style: new TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      ),
      Expanded(
        child: ListView(
          children: [formImage(), formDetail()],
        ),
      )
    ]);
    // return Column(children: [Text("ABC XYZ"), Expanded(child: formDetail())]);
  }

  @override
  void dispose() {
    super.dispose();
    _categoryProvider.clearData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
