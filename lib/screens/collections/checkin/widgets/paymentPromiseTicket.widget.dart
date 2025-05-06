import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/category/action_ticket.model.dart';
import 'package:athena/models/category/contact_by_ticket.model.dart';
import 'package:athena/models/category/contact_person_ticket.model.dart';
import 'package:athena/models/category/loan_type_ticket.model.dart';
import 'package:athena/models/category/place_contact_ticket.model.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/checkin.provider.dart';
import 'package:athena/screens/collections/checkin/widgets/customerName.widget.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/formatter/numbericMoney.formater.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/category/category.service.dart';
import 'package:athena/utils/services/geolocation.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/loading-button.widget.dart';

import '../../collections.service.dart';
import '../calendar.screen.dart';

class PaymentTicketWidget extends StatefulWidget {
  final String title;
  final TicketModel ticket;
  final int actionGroupID;
  PaymentTicketWidget(
      {Key? key,
      required this.ticket,
      required this.title,
      required this.actionGroupID})
      : super(key: key);
  @override
  _PaymentTicketWidgetState createState() => _PaymentTicketWidgetState();
}

class _PaymentTicketWidgetState extends State<PaymentTicketWidget>
    with AfterLayoutMixin {
  final _collectionService = new CollectionService();
  final _categoryService = new CategoryService();
  final _mapService = new VietMapService();
  final _categoryProvider = new CategorySingeton();
  final _checkInProvider = getIt<CheckInProvider>();
  TicketModel? ticketModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formLoginKey = new GlobalKey<FormState>();

  ContactPersonTicketModel? _contactPersonTicketModel;
  ContactByTicketModel? _contactByTicketModel;
  PlaceContactTicketModel? _placeContactTicketModel;
  ActionTicketModel? _actionTicketModel;

  final TextEditingController _moneyController = new TextEditingController();
  final TextEditingController _noteController = new TextEditingController();
  final TextEditingController _timeScheduleController =
      new TextEditingController();
  final TextEditingController _paymentPerson = new TextEditingController();
  final String actionGroupName = 'Promise to Pay';
  String? contractId = '';
  String? employeeInfomation = '';
  bool isCatchEventCheckin = false;
  @override
  initState() {
    super.initState();
    ticketModel = widget.ticket;
    _contactByTicketModel =
        this._categoryProvider.setDefaultContactByTicketModel();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    handleData();
    getCurrentPosition();
    _timeScheduleController.text = S.of(context).select;
  }

  void getCurrentPosition() async {
    try {
      Position? position = await PermissionAppService.getCurrentPosition();
      if(position == null) {
        return;
      }
      String address = await this._mapService.getAddressFromLongLatVMap(
          position.latitude, position.longitude, context);

      if (address.isNotEmpty) {
        _checkInProvider.position = {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'accuracy': position.accuracy,
          'address': address
        };
      }
    } catch (e) {
    } finally {
      _checkInProvider.isLoading = false;
      setState(() {});
    }
  }

  void handleData() async {
    try {
      Response response = await _categoryService.getContactByTicket();
      var lstData;
      if (Utils.checkRequestIsComplete(response)) {
        lstData = response.data['data'];
        for (var data in lstData) {
          _categoryProvider.getLstContactByTicketM
              .add(ContactByTicketModel.fromJson(data));
        }
      }
      // Action
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

      // // Status ticket model
      response = await _categoryService.getTicketStatus();
      if (Utils.checkRequestIsComplete(response)) {
        lstData = response.data['data'];
        for (var data in lstData) {
          _categoryProvider.getLstStatusTicketModel
              .add(StatusTicketModel.fromJson(data));
        }
      }

      response = await _categoryService.getContactByPerson();
      if (Utils.checkRequestIsComplete(response)) {
        lstData = response.data['data'];
        for (var data in lstData) {
          _categoryProvider.getLstContactPersonTicketModel
              .add(ContactPersonTicketModel.fromJson(data));
        }
      }

      response = await _categoryService.getPlaceContact();
      if (Utils.checkRequestIsComplete(response)) {
        lstData = response.data['data'];
        for (var data in lstData) {
          _categoryProvider.getLstPlaceContactTicketModel
              .add(PlaceContactTicketModel.fromJson(data));
        }
      }
    } catch (e) {
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    ticketModel = ModalRoute.of(context)?.settings?.arguments as TicketModel;
    if (ticketModel != null) {
      contractId = ticketModel?.contractId!;
    }
    return ChangeNotifierProvider<CheckInProvider>(
        create: (context) => _checkInProvider,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBarCommon(title: widget.title, lstWidget: []),
            body: Container(
              height: AppState.getHeightDevice(context),
              width: AppState.getWidthDevice(context),
              child: buildForm(),
            ),
            bottomNavigationBar: LoadingButtonWidget(
              height: 53,
              title: S.of(context).checkIn,
              callbackOK: () async {
                submitForm(context);
              },
            )));
  }

  void submitForm(BuildContext context) async {
    if (isCatchEventCheckin) {
      return;
    }
    final form = _formLoginKey.currentState;
    final bool? fakePosition = _collectionService.checkPositionError(
    _checkInProvider?.position['latitude'] != null ? 
        double.tryParse(_checkInProvider?.position['latitude']?.toString()??'') ?? 0.0 : 0.0,
    _checkInProvider.position['longitude'] != null ? 
        double.tryParse(_checkInProvider?.position['longitude']?.toString()??'') ?? 0.0 : 0.0) ?? false;
   // Fix: Fix position access in checkPositionError call
    if (_checkInProvider.position['latitude'] != null && 
        _checkInProvider.position['longitude'] != null &&
        _checkInProvider.position['latitude'] == 0.0 &&
        _checkInProvider.position['longitude'] == 0.0 && 
        fakePosition != null && !fakePosition) {
      return;
    }
    FocusScope.of(context).requestFocus(new FocusNode());
    if (form!.validate()) {
      form.save();
      try {
        int money = -1;
        if (Utils.checkIsNotNull(_moneyController.text)) {
          money = int.parse(Utils.repplaceCharacter(_moneyController.text));
        }
        String _dateShedule =
            _collectionService.getDateSchedule(_checkInProvider.checkIn);
        String _timeSchedule =
            _collectionService.getTimeSchedule(_checkInProvider.checkIn);
        String _durationMins =
            _collectionService.getDurationMin(_checkInProvider.durations);

        var data = {
          "aggId": ticketModel?.aggId,
          "contactModeId": _contactByTicketModel?.id,
          "contactPlaceId": _placeContactTicketModel?.id,
          "contactPersonId": _contactPersonTicketModel?.id,
          "paymentAmount": money,
          "paymentBy": ticketModel?.fullName,
          "paymentUnit": "1",
          "clientPhone": ticketModel?.phone,
          "description": _noteController.text,
          "fieldActionId": widget.actionGroupID,
          "actionGroupName": actionGroupName,
          "actionAttributeId": widget.actionGroupID,
          "address": _checkInProvider.position['address'],
          "longitude": _checkInProvider.position['longitude'],
          "latitude": _checkInProvider.position['latitude'],
          "accuracy": _checkInProvider.position['accuracy'],
          "date": _dateShedule,
          "time": _timeSchedule,
          "durationInMins": _durationMins
        };
        if (money == -1) {
          data['paymentAmount'] = null;
        }
        if (MyConnectivity.instance.isOffline) {
          data["customerName"] = ticketModel?.issueName;
          data["actionName"] =
              _actionTicketModel?.fetmAction['actionValue'] ?? '';
          data['contractId'] = contractId;
          data['employeeInfomation'] = employeeInfomation;
          data['actionGroupCode'] = widget.actionGroupID;
          bool isCheckIn = await this._collectionService.checkInOffline(data);
          if (!isCheckIn) {
            return WidgetCommon.showSnackbar(
                _scaffoldKey, S.of(context).update_failed);
          }
          eventBus.fire(UpdateDetailCollectionOffline({
            'actionGroupName': data["actionGroupName"],
            'lastEventDate': DateTime.now().microsecondsSinceEpoch
          }));
          Utils.popPage(context);
          return;
        }

        stateButtonOnlyText = ButtonState.loading;
        setState(() {});
        this.isCatchEventCheckin = true;
        final Response res = await this._collectionService.checkIn(data);
        stateButtonOnlyText = ButtonState.idle;
        setState(() {});
        this.isCatchEventCheckin = false;
        if (Utils.checkRequestIsComplete(res)) {
          if (res.data['data'] == null) {
            // WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
            //     backgroundColor: AppColor.secondary);
            eventBus.fire(ReloadList('DETAIL_SCREEN'));
            eventBus.fire(ReloadHomeScreen('HOME_SCREEN'));
            Utils.popPage(context);
            GeoPositionBackgroundService geoPositionBackgroundService =
                new GeoPositionBackgroundService();
            geoPositionBackgroundService.getFirstPositionWhenInApp();
            return;
          }
        } else {
          Map<String, dynamic>? validations = Utils.getValidationResponse(res);
          if (Utils.checkIsNotNull(validations)) {
            var message = '';
            validations?.forEach((k, v) {
              if (v == ValidationConstant.INVALIDSTARTDATETIME) {
                message += ' ' + S.of(context).invalidStartDatetime + '\n';
              } else if (v == ValidationConstant.TICKET_NOTFOUND) {
                message += ' Ticket not found' + '\n';
              } else if (v == ValidationConstant.UNAUTHORIZED_TICKET) {
                message +=
                    'Contract ${ticketModel?.contractId ?? ''} was not assigned for you.' +
                        '\n';
              }
            });
            WidgetCommon.generateDialogOKGet(content: message);
            return;
          }
          WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
        }
      } catch (e) {
        this.isCatchEventCheckin = false;
        stateButtonOnlyText = ButtonState.idle;
        setState(() {});
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
      }
    }
  }

  Widget formDetail() {
    return Card(
        margin: EdgeInsets.all(7.0),
        child: new Form(
            key: _formLoginKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              // Form.of(primaryFocus.context).save();
            },
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
                enabled: false,
                maxLines: 2,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                initialValue: _checkInProvider?.position['address']?.toString() ?? '',
                // keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (term) {},
                // textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.location_on),
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
                value: _contactByTicketModel,
                validator: (val) => Utils.isRequireSelect(context, val),
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstContactByTicketM
                    .map((ContactByTicketModel value) {
                  return new DropdownMenuItem<ContactByTicketModel>(
                    value: value,
                    child: new Text(value.modeName ?? ''),
                  );
                }).toList(),
                onChanged: (_) {
                  _contactByTicketModel = _;
                },
              ),
              DropdownButtonFormField<ContactPersonTicketModel>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: S.of(context).contactWith + " *",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                isExpanded: true,
                validator: (val) => Utils.isRequireSelect(context, val),
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstContactPersonTicketModel
                    .map((ContactPersonTicketModel value) {
                  return new DropdownMenuItem<ContactPersonTicketModel>(
                    value: value,
                    child: new Text(value.personName ?? ''),
                  );
                }).toList(),
                onChanged: (_) async {
                  _contactPersonTicketModel = _;
                  selectPerson(_contactPersonTicketModel);
                },
              ),
              Visibility(
                visible: _contactPersonTicketModel?.id != null,
                child: DropdownButtonFormField<ActionTicketModel>(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: S.of(context).actionCode + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  value: _actionTicketModel,
                  isExpanded: true,
                  validator: (val) => Utils.isRequireSelect(context, val),
                  hint:
                      Text(S.of(context).select), // Not necessary for Option 1
                  items: _categoryProvider.getLstActionReason
                      .map((ActionTicketModel value) {
                    return new DropdownMenuItem<ActionTicketModel>(
                      value: value,
                      child: new Text(value.fetmAction['actionName'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (_) {
                    _actionTicketModel = _;
                  },
                ),
              ),
              DropdownButtonFormField<PlaceContactTicketModel>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: S.of(context).contactPlace + " *",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                isExpanded: true,
                validator: (val) => Utils.isRequireSelect(context, val),
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstPlaceContactTicketModel
                    .map((PlaceContactTicketModel value) {
                  return new DropdownMenuItem<PlaceContactTicketModel>(
                    value: value,
                    child: new Text(value?.placeName ?? ''),
                  );
                }).toList(),
                onChanged: (_) {
                  _placeContactTicketModel = _;
                  setState(() {});
                },
              ),
              Visibility(
                child: Text(
                    _collectionService.getAddressCustomer(
                        ticketModel?.customerData, _placeContactTicketModel),
                    style: TextStyle(color: AppColor.primary)),
                visible: _collectionService
                    .isSelectPlaceContact(_placeContactTicketModel),
              ),
              InkWell(
                onTap: () async {
                  Utils.hideKeyboard(context);
                  _navigateAndDisplaySelection(context);
                },
                child: TextFormField(
                  readOnly: true,
                  enabled: false,
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  enableInteractiveSelection: false,
                  controller: _timeScheduleController,
                  validator: (val) => Utils.isRequire(context, val ?? ''),
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_right),
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).timeScheduleNext + " *",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              TextFormField(
                controller: _moneyController,
                inputFormatters: [NumericMoneyTextFormatter()],
                keyboardType: TextInputType.number,
                enableInteractiveSelection: false,
                // validator: (val) => Utils.isRequire(context, val),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).moneyPromisePayment,
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                controller: _noteController,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).note + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 250.0),
                child: Container(),
              )
            ])));
  }

  Widget formDetailPayment() {
    return Card(
        margin: EdgeInsets.all(7.0),
        child: new Form(
            key: _formLoginKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              // Form.of(primaryFocus.context).save();
            },
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
                enabled: false,
                maxLines: 2,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                initialValue: _checkInProvider.position['address']?.toString() ?? '',
                // keyboardType: TextInputType.emailAddress,
                onFieldSubmitted: (term) {},
                // textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.location_on),
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
                validator: (val) => Utils.isRequireSelect(context, val),
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstContactByTicketM
                    .map((ContactByTicketModel value) {
                  return new DropdownMenuItem<ContactByTicketModel>(
                    value: value,
                    child: new Text(value.modeName ?? ''),
                  );
                }).toList(),
                onChanged: (_) {
                  _contactByTicketModel = _;
                },
              ),
              DropdownButtonFormField<ContactPersonTicketModel>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: S.of(context).contactWith + " *",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                isExpanded: true,
                validator: (val) => Utils.isRequireSelect(context, val),
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstContactPersonTicketModel
                    .map((ContactPersonTicketModel value) {
                  return new DropdownMenuItem<ContactPersonTicketModel>(
                    value: value,
                    child: new Text(value.personName ?? ''),
                  );
                }).toList(),
                onChanged: (_) async {
                  _contactPersonTicketModel = _;
                  selectPerson(_contactPersonTicketModel);
                },
              ),
              Visibility(
                visible: _contactPersonTicketModel?.id != null,
                child: DropdownButtonFormField<ActionTicketModel>(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: S.of(context).actionCode + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  value: _actionTicketModel,
                  isExpanded: true,
                  validator: (val) => Utils.isRequireSelect(context, val),
                  hint:
                      Text(S.of(context).select), // Not necessary for Option 1
                  items: _categoryProvider.getLstActionReason
                      .map((ActionTicketModel value) {
                    return new DropdownMenuItem<ActionTicketModel>(
                      value: value,
                      child: new Text(value.actionName ?? ''),
                    );
                  }).toList(),
                  onChanged: (_) {
                    _actionTicketModel = _;
                  },
                ),
              ),
              DropdownButtonFormField<PlaceContactTicketModel>(
                decoration: InputDecoration(
                  filled: true,
                  labelText: S.of(context).contactPlace + " *",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                isExpanded: true,
                validator: (val) => Utils.isRequireSelect(context, val),
                hint: Text(S.of(context).select), // Not necessary for Option 1
                items: _categoryProvider.getLstPlaceContactTicketModel
                    .map((PlaceContactTicketModel value) {
                  return new DropdownMenuItem<PlaceContactTicketModel>(
                    value: value,
                    child: new Text(value.placeName ?? ''),
                  );
                }).toList(),
                onChanged: (_) {
                  _placeContactTicketModel = _;
                },
              ),
              Visibility(
                child: Text(
                    _collectionService.getAddressCustomer(
                        ticketModel?.customerData, _placeContactTicketModel),
                    style: TextStyle(color: AppColor.primary)),
                visible: _collectionService
                    .isSelectPlaceContact(_placeContactTicketModel),
              ),
              TextFormField(
                validator: (val) => Utils.isRequire(context, val ?? ''),
                initialValue: _paymentPerson.text,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.location_on),
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).fullNamePayment + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              InkWell(
                onTap: () async {
                  Utils.hideKeyboard(context);
                  _navigateAndDisplaySelection(context);
                },
                child: TextFormField(
                  readOnly: true,
                  enabled: false,
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  controller: _timeScheduleController,
                  validator: (val) => Utils.isRequire(context, val ?? ''),
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_right),
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).timeScheduleNext + " *",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
              ),
              TextFormField(
                controller: _moneyController,
                inputFormatters: [NumericMoneyTextFormatter()],
                keyboardType: TextInputType.number,
                enableInteractiveSelection: false,
                // validator: (val) => Utils.isRequire(context, val),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).moneyPromisePayment,
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                controller: _noteController,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).note + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 250.0),
                child: Container(),
              )
            ])));
  }

  Widget buildForm() {
    final buildFormDetail =
        (widget.actionGroupID == 1) ? formDetail() : formDetailPayment();
    return (_checkInProvider.isLoading == true)
        ? ShimmerCheckIn()
        : Column(children: [
            CustomerNameCheckInWidget(customerFullName: ticketModel?.fullName),
            Expanded(
              // child: ListView(
              //   children: [buildFormDetail],
              // ),
              child: Column(
                children: [buildFormDetail],
              ),
            )
          ]);
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => CalendarTicketScreen()),
    // );

    final result = await NavigationService.instance.navigateToRoute(
        MaterialPageRoute(builder: (context) => CalendarTicketScreen()));

    if (result != null) {
      _timeScheduleController.text = result.toString();
    }
  }

  void selectPerson(ContactPersonTicketModel? contactPersonTicketModel) async {
    try {
      WidgetCommon.showLoading();
      Response response = await _categoryService.getActionGroupAndPlace(
          widget.actionGroupID, contactPersonTicketModel?.id ?? 0);
      var lstData;
      if (Utils.checkRequestIsComplete(response)) {
        lstData = response.data['data'];
        for (var data in lstData) {
          _categoryProvider.getLstActionReason
              .add(ActionTicketModel.fromJson(data));
        }
        // if (lstData.length == 1) {
        //   _actionTicketModel = ActionTicketModel.fromJson(lstData[0]);
        // }
      }
    } catch (e) {
    } finally {
      WidgetCommon.dismissLoading();
      setState(() {});
    }
    }

  @override
  void dispose() {
    super.dispose();
    // _categoryProvider.clearData();
    _checkInProvider.clearData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
