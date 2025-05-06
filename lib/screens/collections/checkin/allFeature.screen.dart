import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/instance_manager.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/functionsScreen.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/category/action_attribute_ticket.model.dart';
import 'package:athena/models/category/action_ticket.model.dart';
import 'package:athena/models/category/contact_by_ticket.model.dart';
import 'package:athena/models/category/contact_person_ticket.model.dart';
import 'package:athena/models/category/customer_attitude.model.dart';
import 'package:athena/models/category/field_actions.model.dart';
import 'package:athena/models/category/locality.model.dart';
import 'package:athena/models/category/place_contact_ticket.model.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/models/employee/employee.model.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/locality.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/formatter/numbericMoney.formater.dart';
import 'package:athena/utils/formatter/numberstrmoney.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/camera.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/utils/services/employee/employee.provider.dart';
import 'package:athena/utils/services/employee/employee.service.dart';
import 'package:athena/utils/services/geolocation.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/loading-button.widget.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../../../common/config/app_config.dart';
import '../../../models/category/action_sub_attribute_model.dart';
import '../../../models/collections/checkin_error_data.dart';
import '../../../models/offline/category/attribute_value_type.dart';
import '../../../models/wallet_list/ewallet_payment_info.dart';
import '../../../models/wallet_list/overral_by_emp_code_with_balance.dart';
import '../../../utils/common/tracking_installing_device.dart';
import '../../../utils/storage/storage_helper.dart';
import '../../wallet_list/wallet_type_list_controller.dart';
import '../collections.service.dart';
import 'calendar.screen.dart';
import 'checkin.provider.dart';
import 'widgets/dropdown_list_bottom_sheet.dart';
import 'widgets/image_sefie.dart';
import 'widgets/payment_type_widget.dart';
import 'widgets/shimmerCheckIn.widget.dart';

class CheckInAllFeatureScreen extends StatefulWidget {
  final TicketModel ticket;
  CheckInAllFeatureScreen({Key? key, required this.ticket}) : super(key: key);
  @override
  _CheckInAllFeatureScreenState createState() =>
      _CheckInAllFeatureScreenState();
}

class _CheckInAllFeatureScreenState extends State<CheckInAllFeatureScreen>
    with AfterLayoutMixin {
  TicketModel? ticketModel;
  final _collectionService = new CollectionService();
  final _employeeService = new EmployeeService();
  final _employeeProvider = getIt<EmployeeProvider>();
  final _mapService = new VietMapService();
  final _categoryProvider = new CategorySingeton();
  final _checkInProvider = getIt<CheckInProvider>();
  final _dmsService = new DMSService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'AllFeatureScreen');
  final _formLoginKey = new GlobalKey<FormState>();
  int actionGroupId = -1;
  int moneyNumber = -1;
  ContactPersonTicketModel? _contactPersonTicketModel;
  ContactByTicketModel? _contactByTicketModel;
  PlaceContactTicketModel? _placeContactTicketModel;
  ActionTicketModel? _actionTicketModel;
  StatusTicketModel? _statusTicketModel;
  List<StatusTicketModel>? lstStatusTicketModel = [];
  List<ContactPersonTicketModel>? lstContactPersonTicketModel = [];
  CustomerAttitudeModel? _customerAttitudeModel;
  // ActionTicketModel _reasonAction;
  List<ActionAttributeTicketModel>? lstActionAttributeTicketModel = [];
  ActionAttributeTicketModel? _actionAttributeTicketModel;
  bool isLoading = true;
  bool isLoadingLocation = true;
  bool deferment = false;
  final TextEditingController _moneyController = new TextEditingController();
  final TextEditingController _noteController = new TextEditingController();
  final TextEditingController _timeScheduleController =
      new TextEditingController();
  final TextEditingController _paymentPerson = new TextEditingController();
  final TextEditingController _clientPhone = new TextEditingController();
  final TextEditingController _smsContent = new TextEditingController();
  final TextEditingController _locationCtr = new TextEditingController();
  var _customerData;

  final GlobalKey<FormFieldState> _keyContactPerson =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyContactByTicketModel =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyPlaceContact =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyActionTicket =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyStatusTicket =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyActionReason =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyActionAttributeTicketModel =
      new GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _keyActionIncomeAttributeModel =
      new GlobalKey<FormFieldState>();

  String contractId = '';
  String employeeInfomation = '';

  LocalityModel? cityModel;
  LocalityModel? provinceModel;
  LocalityModel? wardModel;
  bool showCity = false;
  bool showProvince = false;
  bool showWard = false;
  bool showContactPlace = true;

  final TextEditingController _fullNameContacter = new TextEditingController();
  final TextEditingController _phoneContacter = new TextEditingController();
  final TextEditingController _addressContacter = new TextEditingController();
  final TextEditingController _cityController = new TextEditingController();
  final TextEditingController _provinceController = new TextEditingController();
  final TextEditingController _wardController = new TextEditingController();
  List<ContactByTicketModel> lstContactByTicketNew = [];
  List<FileLocal> listImage = [];
  List<FileLocal> lstImgSelfie = [];
  bool isCatchEventCheckin = false;
  final _userInfoStore = getIt<UserInfoStore>();

  //
  bool isChangedClientNumber = false;
  bool showSMSConfirmation = true;
  String tenantCode = '';
  //
  OverallByEmpCodeWithBalanceData? currentPaymentType;

  final _defaultPaymentType = OverallByEmpCodeWithBalanceData(
      providerCode: "CASH",
      providerName: 'Tiền mặt',
      tenantCode: 'FECREDIT',
      appCode: 'VYMO',
      methodCode: 'CASH',
      methodName: 'Tiền mặt');

//init tracking apps installed
  final _trackingAppsInstalled = TrackingInstallingDevice();

  final GlobalKey<FormFieldState> _keyActionSubAttributeModel =
      new GlobalKey<FormFieldState>();

  final TextEditingController _currentIncomeAmountController =
      TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _lastIncomeAmountController =
      TextEditingController();

  List<ActionSubAttributeModel> actionSubAttributeModels =
      <ActionSubAttributeModel>[];
  List<ActionSubAttributeModel> actionIncomeAtributeModels =
      <ActionSubAttributeModel>[];

  ActionSubAttributeModel? _actionSubAttributeModel = ActionSubAttributeModel();
  ActionSubAttributeModel? _actionIncomeAttributeModel =
      ActionSubAttributeModel();

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    _customerAttitudeModel = new CustomerAttitudeModel('Bình Thường', 1);
    ticketModel = widget.ticket;
    _contactByTicketModel =
        this._categoryProvider.setDefaultContactByTicketModel();
    for (StatusTicketModel status
        in _categoryProvider.getLstStatusTicketModel) {
      if ((status.actionGroupCode ?? '').indexOf("C-") > -1 &&
          widget.ticket.feType == ActionPhone.CARD) {
        lstStatusTicketModel?.add(status);
      } else if (widget.ticket.feType == ActionPhone.LOAN &&
          status.actionGroupCode?.indexOf("C-") == -1) {
        lstStatusTicketModel?.add(status);
      }
    }
    for (int i = 0; i < _categoryProvider.getLstContactByTicketM.length; i++) {
      if (_categoryProvider.getLstContactByTicketM[i].modeCode == 'FV') {
        lstContactByTicketNew.add(_categoryProvider.getLstContactByTicketM[i]);
        break;
      }
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    tenantCode =
        await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE) ??
            APP_CONFIG.COMPANY_CODE;
    await handleData();
    _timeScheduleController.text = S.of(context).select;
  }

  Future<void> getCurrentPosition(
      bool isCheckPermission, bool reloadPosition) async {
    try {
      if (!await PermissionAppService.detectAppMockLocation(
        context,
      )) return;
      if (!kDebugMode) {
        if (await PermissionAppService.isDeveloperMode()) return;
      }
      if (!isLoadingLocation) {
        setState(() {
          isLoadingLocation = true;
        });
      }
      bool permission = true;
      if (isCheckPermission) {
        permission = await PermissionAppService.checkServiceEnabledLocation();
      }
      if (permission) {
        Position? position;
        if (reloadPosition) {
          position = await PermissionAppService.getCurrentPosition();
        } else {
          position = await PermissionAppService.getLastKnowPosition();
        }
        String address = await this._mapService.getAddressFromLongLatVMap(
            position?.latitude ?? 0.0, position?.longitude ?? 0.0, context);
        if (address.isNotEmpty) {
          _checkInProvider.position = {
            'latitude': position?.latitude ?? 0.0,
            'longitude': position?.longitude ?? 0.0,
            'accuracy': position?.accuracy ?? 0.0,
            'address': address
          };
          _locationCtr.text = address;
        }
        //
        _trackingAppsInstalled.writeAppInstalled(recordType: 'checkin');
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  Future<void> handleData() async {
    try {
      await _categoryProvider.initAllCateogyData();
      _categoryProvider.initStatusAction();
      await _categoryProvider.initActionModel();
      _customerData = ticketModel?.customerData;
      _clientPhone.text = ticketModel?.cusMobilePhone ?? '';
      if (ticketModel?.assigneeData == null) {
        _employeeProvider
            .checkAddEmployee(new EmployeeModel(empCode: ticketModel?.assignee));
        String empCodes = _employeeProvider.handleRequestEmployee();
        if (empCodes.length > 0) {
          final Response empRes = await _employeeService.getEmployees(empCodes);
          if (Utils.checkRequestIsComplete(empRes)) {
            _employeeProvider.addEmployeesTemp(empRes.data['data']);
            ticketModel?.assigneeData =
                EmployeeModel.fromJson(empRes.data['data']);
          }
        }
        for (int index = 0;
            index < _employeeProvider.getLstEmployee.length;
            index++) {
          if (_employeeProvider.getLstEmployee[index].empCode ==
              ticketModel?.assignee) {
            ticketModel?.assigneeData = _employeeProvider.getLstEmployee[index];
            break;
          }
        }
      }
      if (!_collectionService.showSMSConfirmation(_userInfoStore, tenantCode)) {
        isChangedClientNumber = true;
        showSMSConfirmation = false;
        setState(() {});
      }
    } catch (e) {
    } finally {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        isLoading = false;
      });
    }
    await getCurrentPosition(false, false);
  }

  Widget buildTitle(BuildContext contexti) {
    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Cập nhật trạng thái"),
            Text(ticketModel?.issueName ?? '', style: TextStyle(fontSize: 12.0))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          title: buildTitle(context),
          actions: [
            IconButton(
                icon: Icon(Icons.location_on, color: Colors.white),
                onPressed: () async {
                  await getCurrentPosition(true, true);
                })
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 58, 184, 62),
                  Color.fromARGB(255, 38, 134, 45),
                  Color.fromARGB(255, 6, 51, 9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
        ),
        body: buildForm(),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: LoadingButtonWidget(
            height: 62,
            title: S.of(context).checkIn,
            callbackOK: () async {
              if (_statusTicketModel?.actionGroupCode! ==
                      FieldTicketConstant.RTP ||
                  _statusTicketModel?.actionGroupCode! ==
                      FieldTicketConstant.C_RTP) {
                submitFormRefuse(context).then((value) {
                  isCatchEventCheckin = false;
                  stateButtonOnlyText = ButtonState.idle;
                  setState(() {});
                });
              } else {
                submitForm(context).then((value) {
                  stateButtonOnlyText = ButtonState.loading;
                  isCatchEventCheckin = false;

                  setState(() {});
                });
              }
                        },
          ),
        ));
  }

  Future<void> submitForm(BuildContext context) async {
    if (isCatchEventCheckin || stateButtonOnlyText == ButtonState.loading) {
      return;
    }
    stateButtonOnlyText = ButtonState.loading;
    setState(() {});
    final tenantCode =
        await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE);
    if (!_collectionService.showSMSConfirmation(_userInfoStore, tenantCode)) {
      isChangedClientNumber = true;
    }
    this.isCatchEventCheckin = true;

    if (lstImgSelfie.isEmpty ?? false) {
      return WidgetCommon.showSnackbar(
          _scaffoldKey, 'Vui lòng bổ sung hình ảnh checkin');
    }
    if (!Utils.isCheckInTimeValid()) {
      return WidgetCommon.showSnackbar(
          _scaffoldKey, S.of(context).checkInTimeInvalid);
    }
    if (showCity) {
      
    }
    if (deferment) {
      if (_phoneContacter.text.length == 0) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey, 'Vui lòng nhập Số điện thoại người liên hệ');
      }
      if (!Utils.isPhoneValid(_phoneContacter.text)) {
        return WidgetCommon.showSnackbar(_scaffoldKey,
            'Số điện thoại phải có 10 chữ số và bắt đầu bằng số 0');
      }
    }

    String address = '';
    if (Utils.checkIsNotNull(_checkInProvider.position)) {
      address = _checkInProvider.position['address']?.toString() ?? '';
    }
    if (address.isEmpty || _locationCtr.text.toString().isEmpty) {
      return WidgetCommon.generateDialogOKGet(
          content: 'Vui lòng cấp quyền cho Athena Owl truy cập vị trí');
    }

    final form = _formLoginKey.currentState;
    FocusScope.of(context).requestFocus(new FocusNode());
    if (form!.validate()) {
      form?.save();
      if (_statusTicketModel?.actionGroupCode == FieldTicketConstant.PAY ||
          _statusTicketModel?.actionGroupCode == FieldTicketConstant.C_PAY) {
        if (_smsContent.text.length == 0 &&
            !isChangedClientNumber &&
            _userInfoStore
                .checkPerimission(ScreenPermission.SMS_CONFIRMATION)) {
          return WidgetCommon.showSnackbar(_scaffoldKey,
              S.of(context).pleaseChoose + 'xem nội dung tin nhắn');
        }
        if (currentPaymentType?.isWallet ?? false) {
          final _paymentInput =
              int.parse(Utils.repplaceCharacter(_moneyController.text));
          if (_paymentInput < WalletValidateHelper.minimumMoneyInput) {
            WidgetCommon.showSnackbar(_scaffoldKey,
                'Số tiền giao dịch dưới mức tối thiểu cho phép (20.000 VND)');
          }
        }
        if (MyConnectivity.instance.isOffline &&
            (currentPaymentType?.isWallet ?? false)) {
          return WidgetCommon.showSnackbar(
              _scaffoldKey, S.of(context).featureCantRunOffline);
        }
      }
      if ((lstActionAttributeTicketModel?.isNotEmpty ?? false) &&
          _actionAttributeTicketModel == null) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey,
            S.of(context).pleaseChoose +
                S.of(context).actionAttributeCode.toLowerCase());
      }
      try {
        int money = -1;
        if (Utils.checkIsNotNull(_moneyController.text)) {
          money = int.parse(Utils.repplaceCharacter(_moneyController.text));
        }
        if (_checkInProvider.checkIn == null) {
          return WidgetCommon.showSnackbar(
              _scaffoldKey, S.of(context).pleaseChoose + 'Thời Gian Tác động');
        }

        // String phone =
        //     Utils.checkIsNotNull(ticketModel.customerData['cellPhone'])
        //         ? ticketModel.customerData['cellPhone']
        //         : ticketModel.customerData['mobilePhone'];
        // if (phone.isEmpty &&
        //     (_statusTicketModel.actionGroupCode != FieldTicketConstant.PAY &&
        //         _statusTicketModel.actionGroupCode !=
        //             FieldTicketConstant.C_PAY)) {
        //   return WidgetCommon.generateDialogOKGet(
        //       content: 'Không tìm thấy thông tin khách hàng');
        // }
        String address = '';
        if (Utils.checkIsNotNull(_checkInProvider.position)) {
          address = _checkInProvider.position['address']?.toString() ?? '';
        }
        if (address.isEmpty || _locationCtr.text.toString().isEmpty) {
          return WidgetCommon.generateDialogOKGet(
              content: 'Không tìm thấy địa chỉ check in');
        }
        if (Utils.checkIsNotNull(_phoneContacter.text)) {
          if (!Utils.isPhoneValid(_phoneContacter.text)) {
            return WidgetCommon.showSnackbar(_scaffoldKey,
                'Số điện thoại phải có 10 chữ số và bắt đầu bằng số 0');
          }
        }
        if (!showCity) {
          cityModel = null;
          provinceModel = null;
          wardModel = null;
          _addressContacter.text = '';
        }
        if (_statusTicketModel?.actionGroupCode! == FieldTicketConstant.PAY ||
            _statusTicketModel?.actionGroupCode! == FieldTicketConstant.C_PAY) {
          _fullNameContacter.text = '';
          _phoneContacter.text = '';
        }
        String _dateShedule =
            _collectionService.getDateSchedule(_checkInProvider.checkIn);
        String _timeSchedule =
            _collectionService.getTimeSchedule(_checkInProvider.checkIn);
        String _durationMins =
            _collectionService.getDurationMin(_checkInProvider.durations);

        String _paymentName = (_statusTicketModel?.actionGroupCode! ==
                    FieldTicketConstant.PAY ||
                _statusTicketModel?.actionGroupCode == FieldTicketConstant.C_PAY)
            ? _paymentPerson.text
            : '';

        String clientPhone =
            ((_statusTicketModel?.actionGroupCode == FieldTicketConstant.PAY ||
                    _statusTicketModel?.actionGroupCode ==
                        FieldTicketConstant.C_PAY))
                ? _clientPhone.text
                : '';
        String actionGroupName = _statusTicketModel?.actionGroupName ?? '';

        List<String> attachments = [];
        if (listImage.isNotEmpty) {
          for (FileLocal img in listImage) {
            // attachments.add('"' + img.key + '"');
            attachments.add(img.key);
          }
        }
        List<String> selfies = [];
        if (lstImgSelfie.isNotEmpty) {
          for (FileLocal img in lstImgSelfie) {
            // selfies.add('"' + img.key + '"');
            selfies.add(img.key);
          }
        }
        var actionAttributeId;
        if (Utils.checkIsNotNull(_actionAttributeTicketModel)) {
          actionAttributeId = _actionAttributeTicketModel?.id;
        }
        if (!showContactPlace) {
          _placeContactTicketModel = PlaceContactTicketModel(id: 3);
        }
        final extraInfo = await Utils().getExtrainInfo();

        var data = {
          "aggId": ticketModel?.aggId,
          "contactModeId": _contactByTicketModel?.id,
          "contactPlaceId": _placeContactTicketModel?.id,
          "contactPersonId": _contactPersonTicketModel?.id,
          "paymentAmount": money,
          "paymentBy": _paymentName,
          "paymentUnit": 1,
          "clientPhone": clientPhone,
          "description": _noteController.text,
          "fieldActionId": _actionTicketModel?.id,
          "actionAttributeId": actionAttributeId,
          "address": _checkInProvider.position['address'],
          "longitude": _checkInProvider.position['longitude'],
          "latitude": _checkInProvider.position['latitude'],
          "accuracy": _checkInProvider.position['accuracy'],
          "date": _dateShedule,
          "time": _timeSchedule,
          "durationInMins": _durationMins,
          "actionGroupName": actionGroupName,
          "attachments": attachments,
          "selfie": selfies,
          "contactName": _fullNameContacter.text,
          "contactMobile": _phoneContacter.text,
          "contactProvinceId":
              Utils.checkIsNotNull(cityModel) ? cityModel?.id : null,
          "contactDistrictId":
              Utils.checkIsNotNull(provinceModel) ? provinceModel?.id : null,
          "contactWardId":
              Utils.checkIsNotNull(wardModel) ? wardModel?.id : null,
          "contactAddress": _addressContacter.text,
          "contactFullAddress": _collectionService.builFullAddress(
              cityModel, provinceModel, wardModel, _addressContacter.text),
          "customerAttitude": _customerAttitudeModel?.title,
          'extraInfo': extraInfo ?? {},
          'ewalletPaymentInfo': currentPaymentType == null
              ? null
              : EWalletPaymentInfo(
                      aggId: currentPaymentType?.aggId ?? '',
                      isEwalletPayment: currentPaymentType?.isWallet ?? false)
                  .toJson()
        };
        if (money == -1) {
          data['paymentAmount'] = null;
        }
        final checkApp = await PermissionAppService.checkAppInstalled(context);
        if (!checkApp) {
          this.isCatchEventCheckin = false;
          return;
        }
        if (MyConnectivity.instance.isOffline) {
          this.isCatchEventCheckin = true;
          data["customerName"] = ticketModel?.issueName;
          data["actionName"] =
              _actionTicketModel?.fetmAction['actionValue'] ?? '';
          data['contractId'] = contractId;
          data['employeeInfomation'] = employeeInfomation;
          data['actionGroupCode'] = _statusTicketModel?.actionGroupCode ?? '';
          bool isCheckIn = await this._collectionService.checkInOffline(data);
          if (!isCheckIn) {
            return WidgetCommon.showSnackbar(
                _scaffoldKey, S.of(context).update_failed);
          }
          Utils.popPage(context, result: {
            "actionGroupname": _statusTicketModel?.actionGroupName,
            "actionGroupCode": _statusTicketModel?.actionGroupCode
          });
          return;
        }
        if (!AppState.checkVersionCanSubmitRequest(context)) {
          return;
        }
        final bool checkIn = await AppState.checkTime(context, () {
          Utils.pushAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN);
        });
        if (!checkIn) {
          this.isCatchEventCheckin = false;
          return;
        }

         final fakeCheckIn = _collectionService.checkPositionError(
          (_checkInProvider.position['latitude'] as num).toDouble(),
          (_checkInProvider.position['longitude'] as num).toDouble());
          if (fakeCheckIn != null && !fakeCheckIn) {
            return;
          }

        final Response res = await this._collectionService.checkIn(data);
        // stateButtonOnlyText = ButtonState.idle;
        // setState(() {});
        this.isCatchEventCheckin = false;
        stateButtonOnlyText = ButtonState.idle;
        if (Utils.checkRequestIsComplete(res)) {
          if (res.data['data'] == null) {
            // final complaint = await createComplaint();
            // stateButtonOnlyText = ButtonState.idle;
            this.isCatchEventCheckin = false;
            Utils.popPage(context, result: {
              "actionGroupname": _statusTicketModel?.actionGroupName,
              "actionGroupCode": _statusTicketModel?.actionGroupCode
            });
            GeoPositionBackgroundService geoPositionBackgroundService =
                new GeoPositionBackgroundService();
            geoPositionBackgroundService.getFirstPositionWhenInApp();
            return;
            // setState(() {});
            // return;
          } else {
            try {
              final errorData = CheckinErrorData.fromJson(res.data['data']);
              if (errorData.errorType == 'question') {
                await WidgetCommon.generateDialogOKCancelGet(
                    errorData.errorMessage ?? 'Đã có lỗi xảy ra!',
                    callbackOK: () async {
                  //resubmit when fail with payment smart pay

                  setState(() {
                    currentPaymentType = _defaultPaymentType;
                  });
                  submitForm(context);
                });
              } else {
                WidgetCommon.showSnackbar(_scaffoldKey,
                    errorData.errorMessage ?? S.of(context).update_failed);
              }
              stateButtonOnlyText = ButtonState.idle;
              setState(() {});
              return;
            } catch (_) {
              WidgetCommon.showSnackbar(
                  _scaffoldKey, S.of(context).update_failed);
              stateButtonOnlyText = ButtonState.idle;
              setState(() {});
              return;
            }
          }
        } else {
          // stateButtonOnlyText = ButtonState.idle;
          setState(() {});
          Map<String, dynamic>? validations = Utils.getValidationResponse(res);
          if (Utils.checkIsNotNull(validations)) {
            var message = '';
            bool isShowConfirm = false;
            validations?.forEach((k, v) {
              if (v == ValidationConstant.INVALIDSTARTDATETIME) {
                message += ' ' + S.of(context).invalidStartDatetime + '\n';
              } else if (v == ValidationConstant.TICKET_NOTFOUND) {
                message += ' Ticket not found' + '\n';
              } else if (v == ValidationConstant.UNAUTHORIZED_TICKET) {
                message +=
                    'Contract ${ticketModel?.contractId} was not assigned for you.' +
                        '\n';
              } else if (v == ValidationConstant.CHECKIN_OLD_DATA) {
                isShowConfirm = true;

                message =
                    'Dữ liệu đã thay đổi vui lòng cập nhật lại dữ liệu mới nhất!';
              }
              //Intergrate payment
              else if (v == ValidationConstant.EWALLET_PAYMENT_NOT_EXISTED) {
                message += 'Thông tin thanh toán không hợp lệ!' + '\n';
              } else if (v == ValidationConstant.EWALLET_PAYMENT_NOT_FOUND) {
                message += 'Thông tin thanh toán không hợp lệ!' + '\n';
              } else if (v ==
                  ValidationConstant.EWALLET_PAYMENT_STATUS_NO_SUCCESS) {
                message += 'Tài khoản thanh toán chưa hợp lệ!' + '\n';
              } else if (v ==
                  ValidationConstant.EWALLET_PAYMENT_AMOUNT_NOT_VALID) {
                message += 'Số tiền thanh toán chưa hợp lệ!' + '\n';
              } else if (v ==
                  ValidationConstant
                      .EWALLET_PAYMENT_QUERY_BALANCE_NOT_SUCCESS) {
                message += 'Lỗi hệ thống!' + '\n';
              } else if (v ==
                  ValidationConstant.EWALLET_PAYMENT_BALANCE_AMOUNT_NOT_VALID) {
                message += 'Tài khoản không đủ số dư!' + '\n';
              } else if (v ==
                  ValidationConstant.EWALLET_PAYMENT_ACCOUNT_NO_NOT_FOUND) {
                message +=
                    'Giao dịch qua ví thất bại, vui lòng thử lại bằng tiền mặt!' +
                        '\n';
              } else if (v ==
                  ValidationConstant.EWALLET_PAYMENT_ACCOUNT_NO_INVALID) {
                message +=
                    'Giao dịch qua ví thất bại vì SĐT của FC không trùng khớp với SĐT liên kết ví, vui lòng thử lại bằng tiền mặt!' +
                        '\n';
              }
            });
            WidgetCommon.generateDialogOKGet(
              title: 'Cập nhật thất bại',
              callback: () async {
                Navigator.pop(context);
                await _categoryProvider.backgroundUpdateCategoryAll(
                    isClearData: true);
              },
              content: message,
            );
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

  Widget buildFormDetail() {
    // if (_statusTicketModel.id == 3) {
    if (_statusTicketModel?.actionGroupCode == FieldTicketConstant.PAY ||
        _statusTicketModel?.actionGroupCode == FieldTicketConstant.C_PAY) {
      return formDetailPayment();
    } else if ((_statusTicketModel?.actionGroupCode ==
                FieldTicketConstant.PTP ||
            _statusTicketModel?.actionGroupCode ==
                FieldTicketConstant.C_PTP) ||
        (_statusTicketModel?.actionGroupCode == FieldTicketConstant.OTHER ||
            _statusTicketModel?.actionGroupCode ==
                FieldTicketConstant.C_OTHER)) {
      return formDetail();
    } else if (_statusTicketModel?.actionGroupCode ==
            FieldTicketConstant.RTP ||
        _statusTicketModel?.actionGroupCode == FieldTicketConstant.C_RTP) {
      return formDetailRefuse();
    }
      return Container();
  }

  Future<void> submitFormRefuse(BuildContext context) async {
    if (isCatchEventCheckin || stateButtonOnlyText == ButtonState.loading) {
      return;
    }

    stateButtonOnlyText = ButtonState.loading;

    setState(() {});
    isCatchEventCheckin = true;
    // final checkApp = await PermissionAppService.checkAppInstalled(context);
    // if (!checkApp) {
    //   return;
    // }
    if (lstImgSelfie.isEmpty ?? false) {
      return WidgetCommon.showSnackbar(
          _scaffoldKey, 'Bạn chưa chụp hình checkin!');
    }
    if (!Utils.isCheckInTimeValid()) {
      return WidgetCommon.showSnackbar(
          _scaffoldKey, S.of(context).checkInTimeInvalid);
    }

    if (_formKey.currentState?.validate() == false) {
      return;
    }
    if (showCity) {
      
    }
    String address = '';
    if (Utils.checkIsNotNull(_checkInProvider.position)) {
      address = _checkInProvider.position['address']?.toString() ?? '';
    }
    if (address.isEmpty || _locationCtr.text.toString().isEmpty) {
      return WidgetCommon.generateDialogOKGet(
          content: 'Không tìm thấy địa chỉ check in');
    }

     final fakeCheckIn = _collectionService.checkPositionError(
          (_checkInProvider.position['latitude'] as num).toDouble(),
          (_checkInProvider.position['longitude'] as num).toDouble());
      if (fakeCheckIn != null && !fakeCheckIn) {
        return;
      }

    final form = _formLoginKey.currentState;
    FocusScope.of(context).requestFocus(new FocusNode());
    if (form!.validate()) {
      form.save();
      try {
        String address = '';
        if (Utils.checkIsNotNull(_checkInProvider.position)) {
          address = _checkInProvider.position['address']?.toString() ?? '';
        }
        if (address.isEmpty || _locationCtr.text.toString().isEmpty) {
          return WidgetCommon.generateDialogOKGet(
              content: 'Không tìm thấy địa chỉ check in');
        }
        if ((lstActionAttributeTicketModel?.isNotEmpty ?? false) &&
            _actionAttributeTicketModel == null) {
          return WidgetCommon.showSnackbar(
              _scaffoldKey,
              S.of(context).pleaseChoose +
                  S.of(context).actionAttributeCode.toLowerCase());
        }

        if (Utils.checkIsNotNull(_phoneContacter.text)) {
          if (!Utils.isPhoneValid(_phoneContacter.text)) {
            return WidgetCommon.showSnackbar(_scaffoldKey,
                'Số điện thoại người liên hệ không đúng định dạng');
          }
        }
        if (!showCity) {
          cityModel = null;
          provinceModel = null;
          wardModel = null;
          _addressContacter.text = '';
        }

        // int money = 0;
        List<String> attachments = [];
        if (listImage.isNotEmpty) {
          for (FileLocal img in listImage) {
            // attachments.add('"' + img.key + '"');
            attachments.add(img.key);
          }
        }
        List<String> selfies = [];
        if (lstImgSelfie.isNotEmpty) {
          for (FileLocal img in lstImgSelfie) {
            // selfies.add('"' + img.key + '"');
            selfies.add(img.key);
          }
        }
        var actionAttributeId;
        if (Utils.checkIsNotNull(_actionAttributeTicketModel)) {
          actionAttributeId = _actionAttributeTicketModel?.id;
        }
        if (!showContactPlace) {
          _placeContactTicketModel = PlaceContactTicketModel(id: 3);
        }
        final extraInfo = await Utils().getExtrainInfo();

        var data = {
          "aggId": ticketModel?.aggId,
          "contactModeId": _contactByTicketModel?.id,
          "contactPlaceId": _placeContactTicketModel?.id,
          "contactPersonId": _contactPersonTicketModel?.id,
          "paymentAmount": null,
          "paymentBy": "",
          "paymentUnit": null,
          "clientPhone": ticketModel?.cusMobilePhone,
          "description": _noteController.text,
          "fieldActionId": _actionTicketModel?.id,
          "actionAttributeId": actionAttributeId,
          "address": _checkInProvider.position['address'],
          "longitude": _checkInProvider.position['longitude'],
          "latitude": _checkInProvider.position['latitude'],
          "accuracy": _checkInProvider.position['accuracy'],
          "date": null,
          "time": null,
          "actionGroupName": _statusTicketModel?.actionGroupName,
          "durationInMins": null,
          "attachments": attachments,
          "selfie": selfies,
          "contactName": _fullNameContacter.text,
          "contactMobile": _phoneContacter.text,
          "contactProvinceId":
              Utils.checkIsNotNull(cityModel) ? cityModel?.id : null,
          "contactDistrictId":
              Utils.checkIsNotNull(provinceModel) ? cityModel?.id : null,
          "contactWardId":
              Utils.checkIsNotNull(wardModel) ? cityModel?.id : null,
          "contactAddress": _addressContacter.text,
          "contactFullAddress": _collectionService.builFullAddress(
              cityModel, provinceModel, wardModel, _addressContacter.text),
          "customerAttitude": _customerAttitudeModel?.title,
          'extraInfo': extraInfo ?? {},
          "subAttributeId": _actionSubAttributeModel?.id,
          "subAttributeGroupId": _actionIncomeAttributeModel?.id,
          "currentIncomeAmount": Utils.parseDoubleStringToInt(_currentIncomeAmountController.text),
          "loanAmount":
              Utils.parseDoubleStringToInt(_loanAmountController.text),
          "lastIncomeAmount":
              Utils.parseDoubleStringToInt(_lastIncomeAmountController.text)
        };
        final checkApp = await PermissionAppService.checkAppInstalled(context);
        if (!checkApp) {
          this.isCatchEventCheckin = false;
          return;
        }
        if (MyConnectivity.instance.isOffline) {
          this.isCatchEventCheckin = false;
          data["customerName"] = ticketModel?.issueName;
          data["actionName"] =
              _actionTicketModel?.fetmAction['actionValue'] ?? '';
          data['contractId'] = contractId;
          data['employeeInfomation'] = employeeInfomation;
          data['actionGroupCode'] = _statusTicketModel?.actionGroupCode;
          data['isRefusePayment'] = true;
          if (Utils.isArray(selfies)) {
            data['isRefusePayment'] = selfies.join('###');
          }
          bool isCheckIn = await this._collectionService.checkInOffline(data);
          if (!isCheckIn) {
            return WidgetCommon.showSnackbar(
                _scaffoldKey, S.of(context).update_failed);
          }
          Utils.popPage(context, result: {
            "actionGroupname": _statusTicketModel?.actionGroupName,
            "actionGroupCode": _statusTicketModel?.actionGroupCode
          });
          return;
        }
        if (!AppState.checkVersionCanSubmitRequest(context)) {
          return;
        }
        final bool checkIn = await AppState.checkTime(context, () {
          Utils.pushAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN);
        });
        if (!checkIn) {
          this.isCatchEventCheckin = false;
          return;
        }
        stateButtonOnlyText = ButtonState.loading;
        setState(() {});
        final Response res = await this._collectionService.checkInRefuse(data);
        stateButtonOnlyText = ButtonState.idle;
        setState(() {});
        this.isCatchEventCheckin = false;
        if (Utils.checkRequestIsComplete(res)) {
          if (res.data['data'] == null) {
            Utils.popPage(context, result: {
              "actionGroupname": _statusTicketModel?.actionGroupName,
              "actionGroupCode": _statusTicketModel?.actionGroupCode
            });
            GeoPositionBackgroundService geoPositionBackgroundService =
                new GeoPositionBackgroundService();
            geoPositionBackgroundService.getFirstPositionWhenInApp();
            return;
          }
        } else {
          Map<String, dynamic>? validations = Utils.getValidationResponse(res);
          if (Utils.checkIsNotNull(validations)) {
            var message = '';
            bool isShowConfirm = false;

            validations?.forEach((k, v) {
              if (v == ValidationConstant.INVALIDSTARTDATETIME) {
                message += ' ' + S.of(context).invalidStartDatetime + '\n';
              } else if (v == ValidationConstant.TICKET_NOTFOUND) {
                message += ' Ticket not found' + '\n';
              } else if (v == ValidationConstant.UNAUTHORIZED_TICKET) {
                message +=
                    'Contract ${ticketModel?.contractId} was not assigned for you.' +
                        '\n';
              } else if (v == ValidationConstant.CHECKIN_OLD_DATA) {
                isShowConfirm = true;

                message =
                    'Dữ liệu đã thay đổi vui lòng cập nhật lại dữ liệu mới nhất!';
              }
            });
            if (message.isEmpty) {
              message = S.of(context).update_failed;
            }
            WidgetCommon.generateDialogOKGet(
              title: 'Cập nhật thất bại',
              callback: () async {
                Navigator.pop(context);
                await _categoryProvider.backgroundUpdateCategoryAll(
                    isClearData: true);
              },
              content: message,
            );
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

  Widget selfieWidget() {
    return Card(
      // margin: EdgeInsets.all(7.0),
      margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0, top: 0.0),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 30, top: 0.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(S.of(context).selfie_check_in,
                  style: TextStyle(
                      fontSize: AppFont.fontSize16,
                      fontWeight: FontWeight.bold)),
              TextButton.icon(
                  onPressed: () async {
                    if (OfflineService.isFeatureValid(FEATURE_APP.CAMERA)) {
                      await takePictureSelfie();
                    }
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                  label:
                      Text("Chụp ảnh", style: TextStyle(color: Colors.black))),
            ],
          ),
        ),
        // Divider(
        //   color: AppColor.blackOpacity,
        // ),
        Visibility(
          child: Divider(
            color: AppColor.blackOpacity,
          ),
          visible: lstImgSelfie.isNotEmpty,
        ),
        (lstImgSelfie.isEmpty == true)
            ? Container()
            : ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.0, minHeight: 100.0),
                child: buildListImage(ActionPhone.SELFIE)),
      ]),
    );
  }

  Future<void> takePictureSelfie() async {
    try {
      if (lstImgSelfie.length >= 5) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey, "Chỉ được tải lên tối đa 5 tấm ảnh");
      }
      CameraService cameraService = new CameraService();
      var _image = await cameraService.forceSelfie();
      WidgetCommon.showLoading();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String pathImage = _image?.path ??'';
      if (pathImage.isNotEmpty) {
        final extensionFile = pathImage.split('.').last;
        final FormData formData = new FormData.fromMap({
          "cmd": Utils.encodeJSONToString({
            "fileName": fileName + "." + extensionFile,
            "extension": extensionFile
          }),
          "file": await MultipartFile.fromFile(pathImage, filename: fileName)
        });
        final response = await _dmsService.uploadFile(formData);
        if (response.statusCode == 403) {
          final imgBytes = File(pathImage).readAsBytesSync();
          final bytes = base64Encode(imgBytes);
          final Response<dynamic>? _retryResponse = await _dmsService
              .uploadFileSelfie(isRetryAWSFailed: true, jsonData: {
            "fileName": fileName + "." + extensionFile,
            "ticketAggId": ticketModel?.aggId,
            "base64Content": bytes ?? ''
          });
          WidgetCommon.dismissLoading();
          if (Utils.checkRequestIsComplete(_retryResponse!)) {
            if (_retryResponse.data['data'] != null) {
              String stringLabel = _retryResponse.data['data'].toString();
              lstImgSelfie.add(new FileLocal(stringLabel, "123", _image!));
              setState(() {});
              return;
            }
          }
        } else {
          WidgetCommon.dismissLoading();
          if (Utils.checkRequestIsComplete(response)) {
            if (response.data['data'] != null) {
              String stringLabel = response.data['data'].toString();
              lstImgSelfie.add(new FileLocal(stringLabel, "123", _image!));
              setState(() {});
              return;
            }
          }
        }
      }
          WidgetCommon.showSnackbar(_scaffoldKey,
          "Vui lòng thử tải ảnh lại, hoặc liên hệ quản trị viên để được hỗ trợ");
    } catch (e) {
      WidgetCommon.showSnackbar(_scaffoldKey,
          "Vui lòng thử tải ảnh lại, hoặc liên hệ quản trị viên để được hỗ trợ");
      WidgetCommon.dismissLoading();
    } finally {
      WidgetCommon.dismissLoading();
    }
  }

  Widget formDetailRefuse() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      // cameraWidget(),
      selfieWidget(),
      Card(
          margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0, top: 0.0),
          child: new Form(
              key: _formLoginKey,
              onChanged: () {},
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
                buildLocation(),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: false,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: _categoryProvider.getLstContactByTicketM,
                            title:
                                'Chọn ${S.of(context).contactBy.toLowerCase()}',
                            onSelected: (value) {
                              if (value is ContactByTicketModel) {
                                _contactByTicketModel = value;
                                if (value.modeCode == 'FC' ||
                                    value.modeName.toString().contains(
                                        'Gọi điện thoại cho khách hàng')) {
                                  showContactPlace = false;
                                } else {
                                  showContactPlace = true;
                                }
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<ContactByTicketModel>(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: S.of(context).contactBy + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        key: _keyContactByTicketModel,
                        value: _contactByTicketModel,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        validator: (val) => Utils.isRequireSelect(
                            context, _contactByTicketModel),
                        hint: (_contactByTicketModel?.modeName != null)
                            ? Text(
                                _contactByTicketModel?.modeName ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: false,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: lstContactPersonTicketModel,
                            title: 'Chọn người liên hệ',
                            onSelected: (value) {
                              if (value is ContactPersonTicketModel) {
                                _contactPersonTicketModel = value;
                                deferment = false;
                                selectPerson(_contactPersonTicketModel);
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<ContactPersonTicketModel>(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: S.of(context).contactWith + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        key: _keyContactPerson,
                        isExpanded: true,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        validator: (val) => Utils.isRequireSelect(
                            context, _contactPersonTicketModel),
                        hint: (_contactPersonTicketModel?.personName != null)
                            ? Text(
                                _contactPersonTicketModel?.personName ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) async {},
                      ),
                    )),
                buildWidgetContacter(AppStateConfigConstant.FULLNAME),
                buildWidgetContacter(AppStateConfigConstant.PHONE),
                buildCheckBoxDeferment(),
                Visibility(
                    visible: _contactPersonTicketModel?.id != null,
                    child: Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      child: InkWell(
                        onTap: () async {
                          await showBarModalBottomSheet(
                            expand: false,
                            context: context,
                            isDismissible: true,
                            bounce: true,
                            backgroundColor: AppColor.primary,
                            builder: (context) => DrowdownListBottomSheet(
                              values: _categoryProvider.getLstActionReason,
                              title:
                                  'Chọn ${S.of(context).actionCode.toLowerCase()}',
                              onSelected: (value) {
                                if (value is ActionTicketModel) {
                                  _actionTicketModel = value;
                                  selectActionAttributeTicket();
                                  setState(() {});
                                }
                              },
                            ),
                          );
                        },
                        child: DropdownButtonFormField<ActionTicketModel>(
                          decoration: InputDecoration(
                            filled: true,
                            labelText: S.of(context).actionCode + " *",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          key: _keyActionReason,
                          isExpanded: true,
                          isDense: false,
                          itemHeight: 50,
                          elevation: 1,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          validator: (val) => Utils.isRequireSelect(
                              context, _actionTicketModel),
                          hint: (_actionTicketModel?.fetmAction != null)
                              ? Text(
                                  _actionTicketModel
                                          ?.fetmAction['actionValue']?.toString() ??
                                      '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              : Text(S
                                  .of(context)
                                  .select), // Not necessary for Option 1
                          items: [],
                          onChanged: (_) {},
                        ),
                      ),
                    )),
                Visibility(
                  visible: (lstActionAttributeTicketModel?.length ?? 0) > 0,
                  child: Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      child: InkWell(
                        onTap: () async {
                          await showBarModalBottomSheet(
                            expand: false,
                            context: context,
                            isDismissible: true,
                            bounce: true,
                            backgroundColor: AppColor.primary,
                            builder: (context) => DrowdownListBottomSheet(
                              values: lstActionAttributeTicketModel,
                              title:
                                  'Chọn ${S.of(context).actionAttributeCode.toLowerCase()}',
                              onSelected: (value) {
                                if (value is ActionAttributeTicketModel) {
                                  setlectActionAttribute(value);
                                }
                              },
                            ),
                          );
                        },
                        child:
                            DropdownButtonFormField<ActionAttributeTicketModel>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: S.of(context).actionAttributeCode + " *",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          key: _keyActionAttributeTicketModel,
                          isExpanded: true,
                          isDense: false,
                          itemHeight: 50,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          elevation: 1,
                          validator: (val) => Utils.isRequireSelect(
                              context, _actionAttributeTicketModel),
                          hint: (_actionAttributeTicketModel != null)
                              ? Text(
                                  _actionAttributeTicketModel?.description ??
                                      '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              : Text(S.of(context).select),
                          items: [],
                          onChanged: (_) {},
                        ),
                      )),
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Visibility(
                          visible:
                              actionSubAttributeModels.isNotEmpty ?? false,
                          child: Listener(
                              onPointerDown: (_) =>
                                  FocusScope.of(context).unfocus(),
                              child: InkWell(
                                onTap: () async {
                                  await showBarModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    isDismissible: true,
                                    bounce: true,
                                    backgroundColor: AppColor.primary,
                                    builder: (context) =>
                                        DrowdownListBottomSheet(
                                      values: actionSubAttributeModels,
                                      title:
                                          'Chọn nguyên nhân cụ thể - thứ cấp',
                                      onSelected: (value) {
                                        if (value is ActionSubAttributeModel) {
                                          _actionSubAttributeModel = value;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  );
                                },
                                child: DropdownButtonFormField<
                                    ActionAttributeTicketModel>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText:
                                        'Nguyên nhân cụ thể - thứ cấp' + " *",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  key: _keyActionSubAttributeModel,
                                  isExpanded: true,
                                  isDense: false,
                                  iconEnabledColor: AppColor.appBar,
                                  iconDisabledColor: AppColor.appBar,
                                  itemHeight: 50,
                                  elevation: 1,
                                  validator: (val) =>
                                      actionSubAttributeModels.isNotEmpty ??
                                              false
                                          ? Utils.isRequireSelect(
                                              context, _actionSubAttributeModel)
                                          : null,
                                  hint: (_actionSubAttributeModel != null)
                                      ? Text(
                                          _actionSubAttributeModel
                                                  ?.description ??
                                              '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )
                                      : Text(S.of(context).select),
                                  items: [],
                                  onChanged: (_) {},
                                ),
                              )),
                        ),
                        Visibility(
                          visible:
                              _actionAttributeTicketModel?.attributeValue ==
                                  AttributeValueType.DIF,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              enableInteractiveSelection: false,
                              inputFormatters: [NumericMoneyTextFormatter()],
                              controller: _loanAmountController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: "Thu nhập lúc mở khoản vay *",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              _actionAttributeTicketModel?.attributeValue ==
                                  AttributeValueType.DIF,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              enableInteractiveSelection: false,
                              controller: _currentIncomeAmountController,
                              inputFormatters: [NumericMoneyTextFormatter()],
                              validator: (val) =>
                                  _actionAttributeTicketModel?.attributeValue ==
                                          AttributeValueType.DIF
                                      ? Utils.isRequire(context, val ?? '')
                                      : null,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: "Thu nhập hiện tại *",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              actionIncomeAtributeModels.isNotEmpty ?? false,
                          child: Listener(
                              onPointerDown: (_) =>
                                  FocusScope.of(context).unfocus(),
                              child: InkWell(
                                onTap: () async {
                                  await showBarModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    isDismissible: true,
                                    bounce: true,
                                    backgroundColor: AppColor.primary,
                                    builder: (context) =>
                                        DrowdownListBottomSheet(
                                      // height: 60,
                                      values: actionIncomeAtributeModels ?? [],
                                      title:
                                          'Nguồn thu nhập/nghề nghiệp hiện tại của khách hàng',
                                      onSelected: (value) {
                                        if (value is ActionSubAttributeModel) {
                                          _actionIncomeAttributeModel = value;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  );
                                },
                                child: DropdownButtonFormField<
                                    ActionAttributeTicketModel>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    labelText:
                                        'Nguồn thu nhập/nghề nghiệp hiện tại của khách hàng' +
                                            " *",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  key: _keyActionIncomeAttributeModel,
                                  isExpanded: true,
                                  isDense: false,
                                  iconEnabledColor: AppColor.appBar,
                                  iconDisabledColor: AppColor.appBar,
                                  itemHeight: 50,
                                  elevation: 1,
                                  validator: (val) => actionIncomeAtributeModels
                                              .isNotEmpty ??
                                          false
                                      ? Utils.isRequireSelect(
                                          context, _actionIncomeAttributeModel)
                                      : null,
                                  hint: (_actionIncomeAttributeModel != null)
                                      ? Text(
                                          _actionIncomeAttributeModel
                                                  ?.description ??
                                              '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )
                                      : Text(S.of(context).select),
                                  items: [],
                                  onChanged: (_) {},
                                ),
                              )),
                        ),
                        Visibility(
                          visible:
                              _actionAttributeTicketModel?.attributeValue ==
                                  AttributeValueType.RLP,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              enableInteractiveSelection: false,
                              inputFormatters: [NumericMoneyTextFormatter()],
                              controller: _lastIncomeAmountController,
                              validator: (val) =>
                                  _actionAttributeTicketModel?.attributeValue ==
                                          AttributeValueType.RLP
                                      ? Utils.isRequire(context, val ?? '')
                                      : null,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: "Số tiền KH nhận từ khoản vay *",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always),
                            ),
                          ),
                        ),
                      ],
                    )),
                Visibility(
                    visible: showContactPlace,
                    child: Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        child: InkWell(
                          onTap: () async {
                            await showBarModalBottomSheet(
                              expand: false,
                              context: context,
                              isDismissible: true,
                              bounce: true,
                              backgroundColor: AppColor.primary,
                              builder: (context) => DrowdownListBottomSheet(
                                values: _categoryProvider
                                    .getLstPlaceContactTicketModel,
                                title:
                                    'Chọn ${S.of(context).contactPlace.toLowerCase()}',
                                onSelected: (value) {
                                  if (value is PlaceContactTicketModel) {
                                    _placeContactTicketModel = value;
                                    setState(() {});
                                  }
                                },
                              ),
                            );
                          },
                          child:
                              DropdownButtonFormField<PlaceContactTicketModel>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: S.of(context).contactPlace + " *",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            key: _keyPlaceContact,
                            isExpanded: true,
                            iconEnabledColor: AppColor.appBar,
                            iconDisabledColor: AppColor.appBar,
                            validator: (val) => Utils.isRequireSelect(
                                context, _placeContactTicketModel),
                            hint: _placeContactTicketModel != null
                                ? Text(
                                    _placeContactTicketModel?.placeName ?? '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                : Text(S
                                    .of(context)
                                    .select), // Not necessary for Option 1
                            items: [],
                            onChanged: (_) {},
                          ),
                        ))),
                Visibility(
                  child: Padding(
                    child: Text(
                        _collectionService.getAddressCustomer(
                            _customerData, _placeContactTicketModel),
                        style: TextStyle(color: AppColor.primary)),
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  visible: _collectionService
                          .isSelectPlaceContact(_placeContactTicketModel) &&
                      showContactPlace,
                ),
                Visibility(
                  visible: showCity,
                  child: InkWell(
                    onTap: () async {
                      Utils.hideKeyboard(context);
                      _navigateAndDisplaySelectionLocality(
                          context, CollectionTicket.CITY);
                    },
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _cityController,
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.arrow_right),
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Tỉnh/Thành phố *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                  ),
                ),
                Visibility(
                    visible: showProvince,
                    child: InkWell(
                      onTap: () async {
                        Utils.hideKeyboard(context);
                        _navigateAndDisplaySelectionLocality(
                            context, CollectionTicket.PROVINCE);
                      },
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _provinceController,
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_right),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Quận/ Huyện/ Thị Xã *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    )),
                Visibility(
                    visible: showWard,
                    child: InkWell(
                      onTap: () async {
                        Utils.hideKeyboard(context);
                        _navigateAndDisplaySelectionLocality(
                            context, CollectionTicket.WARD);
                      },
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _wardController,
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_right),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Xã/ Phường/ Thị Trấn *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    )),
                Visibility(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _addressContacter,
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Địa chỉ *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    visible: showCity),
                TextFormField(
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 5,
                  controller: _noteController,
                  validator: (val) => Utils.isRequire(context, val ?? ''),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).note + " *",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: true,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: _categoryProvider.lstCustomerAttitudeModel,
                            title: 'Chọn thái độ khách hàng',
                            onSelected: (value) {
                              if (value is CustomerAttitudeModel) {
                                _customerAttitudeModel = value;
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<CustomerAttitudeModel>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Thái độ khách hàng *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        value: _customerAttitudeModel,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        validator: (val) => Utils.isRequireSelect(
                            context, _customerAttitudeModel),
                        hint: _customerAttitudeModel != null
                            ? Text(
                                _customerAttitudeModel?.title ?? '',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                Padding(
                  child: Container(),
                  padding: EdgeInsets.only(bottom: 50.0),
                )
              ])))
    ]);
  }

  void selectPerson(ContactPersonTicketModel? contactPersonTicketModel) async {
    try {
      WidgetCommon.showLoading();
      _categoryProvider.lstActionReason = [];
      lstActionAttributeTicketModel = [];
      _actionTicketModel = null;
      _actionAttributeTicketModel = null;
      WidgetCommon.resetGlobalFormFieldState(_keyActionTicket);
      WidgetCommon.resetGlobalFormFieldState(_keyActionReason);
      WidgetCommon.resetGlobalFormFieldState(_keyActionAttributeTicketModel);
      WidgetCommon.resetGlobalFormFieldState(_keyActionSubAttributeModel);
      _actionSubAttributeModel = null;
      WidgetCommon.resetGlobalFormFieldState(_keyActionIncomeAttributeModel);
      _actionIncomeAttributeModel = null;
      int? contactPersonId = contactPersonTicketModel?.id!;
      for (FieldActions data in _categoryProvider.getLstFieldActions) {
        if (data.contactPersonId == contactPersonId &&
            _statusTicketModel?.id == data.actionGroupId) {
          Map<dynamic, dynamic> abc = data.toJson();
          _categoryProvider.getLstActionReason
              .add(ActionTicketModel.fromJson(abc));
                }
      }

      if (contactPersonTicketModel?.personCode == CollectionTicket.CLIENT) {
        _fullNameContacter.text = ticketModel?.fullName! ?? '';
      } else {
        _fullNameContacter.text = '';
      }
      // if (_statusTicketModel.actionGroupCode != FieldTicketConstant.PAY ||
      //     _statusTicketModel.actionGroupCode != FieldTicketConstant.C_PAY)
      //   showContacter = _collectionService.checkShowAddress(
      //       _contactByTicketModel, contactPersonTicketModel);
      // if (showContacter) {
      //   if (contactPersonTicketModel.personCode == CollectionTicket.CLIENT) {
      //     _fullNameContacter.text = ticketModel.fullName;
      //   } else {
      //     _fullNameContacter.text = '';
      //   }
      // } else {
      //   showCity = false;
      //   showContacter = false;
      // }
    } catch (e) {
    } finally {
      setState(() {});
      await Future.delayed(Duration(milliseconds: 100));
      WidgetCommon.dismissLoading();
    }
    }

  Widget buildForm() {
    return (isLoading == true)
        ? ShimmerCheckIn()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: true,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: lstStatusTicketModel,
                            title: 'Trạng thái cập nhật',
                            onSelected: (value) {
                              if (value is StatusTicketModel) {
                                _statusTicketModel = value;
                                _categoryProvider.lstActionReason = [];
                                lstActionAttributeTicketModel = [];
                                _contactPersonTicketModel = null;
                                deferment = false;
                                _actionTicketModel = null;
                                _actionAttributeTicketModel = null;

                                lstContactPersonTicketModel = this
                                    ._categoryProvider
                                    .initDataListContactPerson(
                                        _statusTicketModel?.id);
                                WidgetCommon.resetGlobalFormFieldState(
                                    _keyContactPerson);
                                WidgetCommon.resetGlobalFormFieldState(
                                    _keyPlaceContact);
                                WidgetCommon.resetGlobalFormFieldState(
                                    _keyActionTicket);
                                WidgetCommon.resetGlobalFormFieldState(
                                    _keyActionReason);
                                WidgetCommon.resetGlobalFormFieldState(
                                    _keyActionAttributeTicketModel);
                                WidgetCommon.resetGlobalFormFieldState(
                                    _keyActionSubAttributeModel);
                                WidgetCommon.resetGlobalFormFieldState(
                                    _keyActionIncomeAttributeModel);
                                clearSubActionController();
                                _actionSubAttributeModel = null;
                                _actionIncomeAttributeModel = null;
                                showCity = false;
                                showProvince = false;
                                showWard = false;
                                cityModel = null;
                                wardModel = null;

                                provinceModel = null;
                                _cityController.text = '';
                                _wardController.text = '';
                                _provinceController.text = '';
                                _addressContacter.text = '';
                                _fullNameContacter.text = '';
                                _phoneContacter.text = '';
                                currentPaymentType = null;
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<StatusTicketModel>(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: 'Chọn trạng thái cập nhật *',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        key: _keyStatusTicket,
                        isExpanded: true,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        validator: (val) =>
                            Utils.isRequireSelect(context, _statusTicketModel),
                        hint: _statusTicketModel != null
                            ? _statusTicketModel?.buildTitle(context)
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                Expanded(
                  child: ListView(
                    children: [buildFormDetail()],
                  ),
                )
              ]);
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await NavigationService.instance.navigateToRoute(
        MaterialPageRoute(builder: (context) => CalendarTicketScreen()));
    if (result != null) {
      _timeScheduleController.text = result.toString();
    }
  }

  Widget formDetailPayment() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      // cameraWidget(),
      selfieWidget(),
      Card(
          margin: EdgeInsets.all(7.0),
          child: new Form(
              key: _formLoginKey,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
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
                buildLocation(),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: false,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: lstContactByTicketNew,
                            title:
                                'Chọn ${S.of(context).contactBy.toLowerCase()}',
                            onSelected: (value) {
                              if (value is ContactByTicketModel) {
                                _contactByTicketModel = value;
                                if (value.modeCode == 'FC' ||
                                    value.modeName.toString().contains(
                                        'Gọi điện thoại cho khách hàng')) {
                                  showContactPlace = false;
                                } else {
                                  showContactPlace = true;
                                }
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<ContactByTicketModel>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: S.of(context).contactBy + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        key: _keyContactByTicketModel,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        value: _contactByTicketModel,
                        validator: (val) => Utils.isRequireSelect(
                            context, _contactByTicketModel),
                        hint: (_contactByTicketModel?.modeName != null)
                            ? Text(
                                _contactByTicketModel?.modeName.toString() ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: false,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: lstContactPersonTicketModel,
                            title: 'Chọn người liên hệ',
                            onSelected: (value) {
                              if (value is ContactPersonTicketModel) {
                                _contactPersonTicketModel = value;
                                deferment = false;
                                selectPerson(_contactPersonTicketModel);
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<ContactPersonTicketModel>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: S.of(context).contactWith + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        key: _keyContactPerson,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        isExpanded: true,
                        validator: (val) => Utils.isRequireSelect(
                            context, _contactPersonTicketModel),
                        hint: (_contactPersonTicketModel?.personName != null)
                            ? Text(
                                _contactPersonTicketModel?.personName ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                // buildWidgetContacter(AppStateConfigConstant.FULLNAME),
                // buildWidgetContacter(AppStateConfigConstant.PHONE),
                Visibility(
                    visible: _categoryProvider.getLstActionReason.length > 0,
                    child: Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      child: InkWell(
                        onTap: () async {
                          await showBarModalBottomSheet(
                            expand: false,
                            context: context,
                            isDismissible: true,
                            bounce: true,
                            backgroundColor: AppColor.primary,
                            builder: (context) => DrowdownListBottomSheet(
                              values: _categoryProvider.getLstActionReason,
                              title:
                                  'Chọn ${S.of(context).actionCode.toLowerCase()}',
                              onSelected: (value) {
                                if (value is ActionTicketModel) {
                                  _actionTicketModel = value;
                                  selectActionAttributeTicket();
                                  setState(() {});
                                }
                              },
                            ),
                          );
                        },
                        child: DropdownButtonFormField<ActionTicketModel>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: S.of(context).actionCode + " *",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          // value: _actionTicketModel,
                          key: _keyActionTicket,
                          isExpanded: true,
                          isDense: false,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          itemHeight: 50,
                          elevation: 1,
                          validator: (val) => Utils.isRequireSelect(
                              context, _actionTicketModel),
                          hint: (_actionTicketModel?.fetmAction != null)
                              ? Text(
                                  _actionTicketModel
                                          ?.fetmAction['actionValue'] ??
                                      '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              : Text(S
                                  .of(context)
                                  .select), // Not necessary for Option 1
                          items: [],
                          onChanged: (_) {},
                        ),
                      ),
                    )),
                Visibility(
                  visible: (lstActionAttributeTicketModel?.length ?? 0) > 0,
                  child: Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      child: InkWell(
                        onTap: () async {
                          await showBarModalBottomSheet(
                            expand: false,
                            context: context,
                            isDismissible: true,
                            bounce: true,
                            backgroundColor: AppColor.primary,
                            builder: (context) => DrowdownListBottomSheet(
                              values: lstActionAttributeTicketModel,
                              title:
                                  'Chọn ${S.of(context).actionAttributeCode.toLowerCase()}',
                              onSelected: (value) {
                                if (value is ActionAttributeTicketModel) {
                                  _actionAttributeTicketModel = value;
                                  setState(() {});
                                }
                              },
                            ),
                          );
                        },
                        child:
                            DropdownButtonFormField<ActionAttributeTicketModel>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: S.of(context).actionAttributeCode + " *",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          key: _keyActionAttributeTicketModel,
                          isExpanded: true,
                          isDense: false,
                          itemHeight: 50,
                          elevation: 1,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          validator: (val) => Utils.isRequireSelect(
                              context, _actionAttributeTicketModel),
                          hint: (_actionAttributeTicketModel != null)
                              ? Text(
                                  _actionAttributeTicketModel?.description ??
                                      '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              : Text(S.of(context).select),
                          items: [],
                          onChanged: (_) {},
                        ),
                      )),
                ),
                Visibility(
                    visible: showContactPlace,
                    child: Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        child: InkWell(
                          onTap: () async {
                            await showBarModalBottomSheet(
                              expand: false,
                              context: context,
                              isDismissible: true,
                              bounce: true,
                              backgroundColor: AppColor.primary,
                              builder: (context) => DrowdownListBottomSheet(
                                values: _categoryProvider
                                    .getLstPlaceContactTicketModel,
                                title:
                                    'Chọn ${S.of(context).contactPlace.toLowerCase()}',
                                onSelected: (value) {
                                  if (value is PlaceContactTicketModel) {
                                    _placeContactTicketModel = value;
                                    showCity = this
                                        ._collectionService
                                        .checkShowCity(
                                            _placeContactTicketModel);
                                    if (showCity) {
                                      this._categoryProvider.loadListCity();
                                      showProvince = true;
                                      showWard = true;
                                    } else {
                                      showProvince = false;
                                      showWard = false;
                                    }
                                    setState(() {});
                                  }
                                },
                              ),
                            );
                          },
                          child:
                              DropdownButtonFormField<PlaceContactTicketModel>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: S.of(context).contactPlace + " *",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            isExpanded: true,
                            key: _keyPlaceContact,
                            iconEnabledColor: AppColor.appBar,
                            iconDisabledColor: AppColor.appBar,
                            validator: (val) => Utils.isRequireSelect(
                                context, _placeContactTicketModel),
                            hint: _placeContactTicketModel != null
                                ? Text(
                                    _placeContactTicketModel?.placeName ?? '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                : Text(S
                                    .of(context)
                                    .select), // Not necessary for Option 1
                            items: [],
                            onChanged: (_) {},
                          ),
                        ))),
                Visibility(
                  child: Padding(
                    child: Text(
                        _collectionService.getAddressCustomer(
                            _customerData, _placeContactTicketModel),
                        style: TextStyle(color: AppColor.primary)),
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  visible: _collectionService
                          .isSelectPlaceContact(_placeContactTicketModel) &&
                      showContactPlace,
                ),
                Visibility(
                  visible: showCity,
                  child: InkWell(
                    onTap: () async {
                      Utils.hideKeyboard(context);
                      _navigateAndDisplaySelectionLocality(
                          context, CollectionTicket.CITY);
                    },
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _cityController,
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.arrow_right),
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Tỉnh/Thành phố *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                  ),
                ),
                Visibility(
                    visible: showProvince,
                    child: InkWell(
                      onTap: () async {
                        Utils.hideKeyboard(context);
                        _navigateAndDisplaySelectionLocality(
                            context, CollectionTicket.PROVINCE);
                      },
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _provinceController,
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_right),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Quận/ Huyện/ Thị Xã *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    )),
                Visibility(
                    visible: showWard,
                    child: InkWell(
                      onTap: () async {
                        Utils.hideKeyboard(context);
                        _navigateAndDisplaySelectionLocality(
                            context, CollectionTicket.WARD);
                      },
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _wardController,
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_right),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Xã/ Phường/ Thị Trấn *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    )),
                Visibility(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _addressContacter,
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Địa chỉ *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    visible: showCity),
                TextFormField(
                  validator: (val) => Utils.isRequire(context, val ?? ''),
                  controller: _paymentPerson,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
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
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        showGeneralDialog(
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionDuration: Duration(milliseconds: 300),
                          barrierDismissible: true,
                          context: context,
                          pageBuilder: (_, __, ___) {
                            return PaymentTypeWidget(
                              payment: [],
                              title: 'Chọn phương thức thanh toán',
                              currentSelection: currentPaymentType!,
                              onSelection: (paymentType) => setState(() {
                                currentPaymentType = paymentType;
                              }),
                            );
                          },
                          transitionBuilder: (_, anim, __, child) {
                            return SlideTransition(
                              position:
                                  Tween(begin: Offset(0, 1), end: Offset(0, 0))
                                      .animate(anim),
                              child: child,
                            );
                          },
                        ).then((value) {
                          Get.delete<WalletTypeListController>();
                        });
                      },
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: "Phương thức thanh toán *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        value: currentPaymentType?.providerName!,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        validator: (val) =>
                            Utils.isRequireSelect(context, currentPaymentType),
                        hint: currentPaymentType != null
                            ? Text(
                                currentPaymentType?.providerName ?? '',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                TextFormField(
                  controller: _moneyController,
                  inputFormatters: [NumericMoneyTextFormatter()],
                  textInputAction: TextInputAction.next,
                  enableInteractiveSelection: false,
                  maxLength: 15,
                  onChanged: (value) {
                    readMoney();
                  },
                  keyboardType: TextInputType.number,
                  // validator: (val) => Utils.isRequire(context, val),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).moneyPaymentTake,
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                Visibility(
                  child: Padding(
                      child: Text(ReadMoneyNumber.numberToString(moneyNumber),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColor.primary)),
                      padding:
                          EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0)),
                  visible: moneyNumber > -1,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 5,
                  controller: _noteController,
                  validator: (val) => Utils.isRequire(context, val ?? ''),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).note + " *",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    setState(() {
                      _smsContent.clear();
                      isChangedClientNumber = false;
                    });
                  },
                  enableInteractiveSelection: false,
                  controller: _clientPhone,
                  validator: (val) => Utils.isRequire(context, val ?? ''),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).customerPhone + " *",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                Visibility(
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                        child: InkWell(
                            onTap: () async {
                              await sawContentSMS();
                            },
                            child: Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Nhấn vào đây để xem trước nội dung tin nhắn * ",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: AppColor.primary)),
                                Icon(
                                  Icons.cloud,
                                  color: AppColor.primary,
                                  size: 20.0,
                                )
                              ],
                            )))),
                    visible: showSMSConfirmation),
                TextFormField(
                  style: TextStyle(color: AppColor.primary),
                  keyboardType: TextInputType.multiline,
                  controller: _smsContent,
                  readOnly: true,
                  enabled: false,
                  minLines: 1,
                  maxLines: 5,
                  decoration:
                      InputDecoration(contentPadding: EdgeInsets.all(10.0)),
                ),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: true,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: _categoryProvider.lstCustomerAttitudeModel,
                            title: 'Chọn thái độ khách hàng',
                            onSelected: (value) {
                              if (value is CustomerAttitudeModel) {
                                _customerAttitudeModel = value;
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<CustomerAttitudeModel>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Thái độ khách hàng *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        value: _customerAttitudeModel,
                        validator: (val) => Utils.isRequireSelect(
                            context, _customerAttitudeModel),
                        hint: _customerAttitudeModel != null
                            ? Text(
                                _customerAttitudeModel?.title ?? '',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                Container(
                  child: Text(""),
                  margin: EdgeInsets.only(bottom: 50.0),
                )
              ])))
    ]);
  }

  void readMoney() {
    // try {
    //   if (Utils.checkIsNotNull(_moneyController)) {
    //     if (_moneyController.text.toString().isNotEmpty) {
    //       moneyNumber =
    //           int.tryParse(Utils.repplaceCharacter(_moneyController.text));
    //     } else {
    //       moneyNumber = -1;
    //     }

    //     _smsContent.clear();
    //     isChangedClientNumber = false;

    //     setState(() {});
    //   }
    // } catch (e) {
    //   moneyNumber = -1;
    // }
    try {
    if (Utils.checkIsNotNull(_moneyController)) {
      if (_moneyController.text.toString().isNotEmpty) {
        // Fix 1: Properly handle string to int conversion with null safety
        final String cleanValue = Utils.repplaceCharacter(_moneyController.text);
        moneyNumber = int.tryParse(cleanValue) ?? 0;
      } else {
        moneyNumber = -1;
      }

      _smsContent.clear();
      isChangedClientNumber = false;

      setState(() {});
    }
  } catch (e) {
    print('Error in readMoney: $e'); // Add logging
    moneyNumber = -1;
  }
  }

  // Future<void> sawContentSMS() async {
  //   try {
  //     FocusScope.of(context).requestFocus(new FocusNode());

  //     if (Utils.checkIsNotNull(_clientPhone)) {
  //       if (_clientPhone.text.toString().length == 0) {
  //         WidgetCommon.showSnackbar(
  //             _scaffoldKey, "Vui lòng nhập số điện thoại");
  //         return;
  //       }
  //     }
  //     if (!Utils.isPhoneValid(_clientPhone.text)) {
  //       WidgetCommon.showSnackbar(
  //           _scaffoldKey, "Số điện thoại không đúng định dạng");
  //       return;
  //     }
     
  //     final smsContent = AppState.versionApp;
  //     if (Utils.checkIsNotNull(smsContent)) {
  //       String messageSMS = smsContent['messageSMS'];
  //       if (Utils.checkIsNotNull(messageSMS)) {
  //         String dateFullTime =
  //             Utils.getTimeFromDate(DateTime.now().millisecondsSinceEpoch);
  //         messageSMS =
  //             messageSMS.replaceAll('contractId', ticketModel.contractId);
  //         messageSMS = messageSMS.replaceAll(
  //             'empCode', _userInfoStore.user.moreInfo['empCode']);
  //         messageSMS = messageSMS.replaceAll('payMoney', _moneyController.text);
  //         messageSMS = messageSMS.replaceAll('dateTime', dateFullTime);
  //         messageSMS =
  //             messageSMS.replaceAll('empName', _userInfoStore.user.fullName);
  //         _smsContent.text = messageSMS;
  //         isChangedClientNumber = true;
  //         return;
  //       }
  //     }
  //     WidgetCommon.showSnackbar(
  //         _scaffoldKey, 'Không thể xem nội dung tin nhắn');
  //   } catch (e) {
  //     WidgetCommon.dismissLoading();
  //     WidgetCommon.showSnackbar(
  //         _scaffoldKey, 'Không thể xem nội dung tin nhắn');
  //   }
  // }
  Future<void> sawContentSMS() async {
    try {
      FocusScope.of(context).requestFocus(new FocusNode());

      if (Utils.checkIsNotNull(_clientPhone)) {
        if (_clientPhone.text.toString().length == 0) {
          WidgetCommon.showSnackbar(
              _scaffoldKey, "Vui lòng nhập số điện thoại");
          return;
        }
      }
      if (!Utils.isPhoneValid(_clientPhone.text)) {
        WidgetCommon.showSnackbar(
            _scaffoldKey, "Số điện thoại không đúng định dạng");
        return;
      }
     
      final smsContent = AppState.versionApp;
      if (Utils.checkIsNotNull(smsContent)) {
        String? messageSMS = smsContent['messageSMS'];
        if (Utils.checkIsNotNull(messageSMS)) {
          String? dateFullTime =
              Utils.getTimeFromDate(DateTime.now().millisecondsSinceEpoch) ?? '';
          messageSMS =
              messageSMS?.replaceAll('contractId', ticketModel?.contractId!?.toString() ?? '') ?? '';
          messageSMS = messageSMS.replaceAll(
              'empCode', _userInfoStore?.user?.moreInfo!['empCode']) ?? '';
          messageSMS = messageSMS.replaceAll('payMoney', _moneyController.text);
          messageSMS = messageSMS.replaceAll('dateTime', dateFullTime);
          messageSMS =
              messageSMS.replaceAll('empName', _userInfoStore?.user?.fullName ?? '');
          _smsContent.text = messageSMS;
          isChangedClientNumber = true;
          return;
        }
      }
      WidgetCommon.showSnackbar(
          _scaffoldKey, 'Không thể xem nội dung tin nhắn');
    } catch (e) {
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(
          _scaffoldKey, 'Không thể xem nội dung tin nhắn');
    }
  }

  Widget formDetail() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      // cameraWidget(),
      selfieWidget(),
      Card(
          margin: EdgeInsets.all(7.0),
          child: new Form(
              key: _formLoginKey,
              onChanged: () {},
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
                // TextFormField(
                //   readOnly: true,
                //   enabled: false,
                //   maxLines: 2,
                //   validator: (val) => Utils.isRequire(context, val),
                //   controller: _locationCtr,
                //   onFieldSubmitted: (term) {},
                //   style: TextStyle(fontSize: 16.0, color: Colors.black),
                //   decoration: InputDecoration(
                //       suffixIcon: _collectionService.buildLoadingLocation(
                //           isLoadingLocation, context),
                //       contentPadding: EdgeInsets.all(10.0),
                //       labelText: S.of(context).position + " *",
                //       floatingLabelBehavior: FloatingLabelBehavior.always),
                // ),
                buildLocation(),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: false,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: _categoryProvider.getLstContactByTicketM,
                            title:
                                'Chọn ${S.of(context).contactBy.toLowerCase()}',
                            onSelected: (value) {
                              if (value is ContactByTicketModel) {
                                _contactByTicketModel = value;
                                if (value.modeCode == 'FC' ||
                                    value.modeName.toString().contains(
                                        'Gọi điện thoại cho khách hàng')) {
                                  showContactPlace = false;
                                } else {
                                  showContactPlace = true;
                                }
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<ContactByTicketModel>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: S.of(context).contactBy + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        key: _keyContactByTicketModel,
                        value: _contactByTicketModel,
                        isExpanded: true,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        validator: (val) => Utils.isRequireSelect(
                            context, _contactByTicketModel),
                        hint: (_contactByTicketModel?.modeName != null)
                            ? Text(
                                _contactByTicketModel?.modeName ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: false,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: lstContactPersonTicketModel,
                            title: 'Chọn người liên hệ',
                            onSelected: (value) {
                              if (value is ContactPersonTicketModel) {
                                _contactPersonTicketModel = value;
                                deferment = false;
                                selectPerson(_contactPersonTicketModel);
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<ContactPersonTicketModel>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: S.of(context).contactWith + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        key: _keyContactPerson,
                        isExpanded: true,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        validator: (val) => Utils.isRequireSelect(
                            context, _contactPersonTicketModel),
                        hint: (_contactPersonTicketModel?.personName! != null)
                            ? Text(
                                _contactPersonTicketModel?.personName ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                buildWidgetContacter(AppStateConfigConstant.FULLNAME),
                buildWidgetContacter(AppStateConfigConstant.PHONE),
                buildCheckBoxDeferment(),
                Visibility(
                    visible: _categoryProvider.getLstActionReason.length > 0,
                    child: Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      child: InkWell(
                        onTap: () async {
                          await showBarModalBottomSheet(
                            expand: false,
                            context: context,
                            isDismissible: true,
                            bounce: true,
                            backgroundColor: AppColor.primary,
                            builder: (context) => DrowdownListBottomSheet(
                              values: _categoryProvider.getLstActionReason,
                              title:
                                  'Chọn ${S.of(context).actionCode.toLowerCase()}',
                              onSelected: (value) {
                                if (value is ActionTicketModel) {
                                  _actionTicketModel = value;
                                  selectActionAttributeTicket();
                                  setState(() {});
                                }
                              },
                            ),
                          );
                        },
                        child: DropdownButtonFormField<ActionTicketModel>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: S.of(context).actionCode + " *",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          // value: _actionTicketModel,
                          key: _keyActionTicket,
                          isExpanded: true,
                          isDense: false,
                          itemHeight: 50,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          elevation: 1,
                          validator: (val) => Utils.isRequireSelect(
                              context, _actionTicketModel),
                          hint: (_actionTicketModel?.fetmAction != null)
                              ? Text(
                                  _actionTicketModel
                                          ?.fetmAction['actionValue']?.toString() ??
                                      '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              : Text(S
                                  .of(context)
                                  .select), // Not necessary for Option 1
                          items: [],
                          onChanged: (_) {},
                        ),
                      ),
                    )),
                Visibility(
                  visible: (lstActionAttributeTicketModel?.length ?? 0) > 0,
                  child: Listener(
                      onPointerDown: (_) => FocusScope.of(context).unfocus(),
                      child: InkWell(
                        onTap: () async {
                          await showBarModalBottomSheet(
                            expand: false,
                            context: context,
                            isDismissible: true,
                            bounce: true,
                            backgroundColor: AppColor.primary,
                            builder: (context) => DrowdownListBottomSheet(
                              values: lstActionAttributeTicketModel,
                              title:
                                  'Chọn ${S.of(context).actionAttributeCode.toLowerCase()}',
                              onSelected: (value) {
                                if (value is ActionAttributeTicketModel) {
                                  _actionAttributeTicketModel = value;
                                  setState(() {});
                                }
                              },
                            ),
                          );
                        },
                        child:
                            DropdownButtonFormField<ActionAttributeTicketModel>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: S.of(context).actionAttributeCode + " *",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          key: _keyActionAttributeTicketModel,
                          isExpanded: true,
                          isDense: false,
                          itemHeight: 50,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          elevation: 1,
                          validator: (val) => Utils.isRequireSelect(
                              context, _actionAttributeTicketModel),
                          hint: (_actionAttributeTicketModel != null)
                              ? Text(
                                  _actionAttributeTicketModel?.description ??
                                      '',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )
                              : Text(S.of(context).select),
                          items: [],
                          onChanged: (_) {},
                        ),
                      )),
                ),
                Visibility(
                    visible: showContactPlace,
                    child: Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        child: InkWell(
                          onTap: () async {
                            await showBarModalBottomSheet(
                              expand: false,
                              context: context,
                              isDismissible: true,
                              bounce: true,
                              backgroundColor: AppColor.primary,
                              builder: (context) => DrowdownListBottomSheet(
                                values: _categoryProvider
                                    .getLstPlaceContactTicketModel,
                                title:
                                    'Chọn ${S.of(context).contactPlace.toLowerCase()}',
                                onSelected: (value) {
                                  if (value is PlaceContactTicketModel) {
                                    _placeContactTicketModel = value;
                                    showCity = this
                                        ._collectionService
                                        .checkShowCity(
                                            _placeContactTicketModel);
                                    if (showCity) {
                                      this._categoryProvider.loadListCity();
                                      showProvince = true;
                                      showWard = true;
                                    } else {
                                      showProvince = false;
                                      showWard = false;
                                    }
                                    setState(() {});
                                  }
                                },
                              ),
                            );
                          },
                          child:
                              DropdownButtonFormField<PlaceContactTicketModel>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: S.of(context).contactPlace + " *",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            isExpanded: true,
                            key: _keyPlaceContact,
                            iconEnabledColor: AppColor.appBar,
                            iconDisabledColor: AppColor.appBar,
                            validator: (val) => Utils.isRequireSelect(
                                context, _placeContactTicketModel),
                            hint: _placeContactTicketModel != null
                                ? Text(
                                    _placeContactTicketModel?.placeName ?? '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                : Text(S
                                    .of(context)
                                    .select), // Not necessary for Option 1
                            items: [],
                            onChanged: (_) {},
                          ),
                        ))),
                Visibility(
                  child: Padding(
                    child: Text(
                        _collectionService.getAddressCustomer(
                            _customerData, _placeContactTicketModel),
                        style: TextStyle(color: AppColor.primary)),
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  visible: _collectionService
                          .isSelectPlaceContact(_placeContactTicketModel) &&
                      showContactPlace,
                ),
                Visibility(
                  visible: showCity,
                  child: InkWell(
                    onTap: () async {
                      Utils.hideKeyboard(context);
                      _navigateAndDisplaySelectionLocality(
                          context, CollectionTicket.CITY);
                    },
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _cityController,
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.arrow_right),
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Tỉnh/Thành phố *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                  ),
                ),
                Visibility(
                    visible: showProvince,
                    child: InkWell(
                      onTap: () async {
                        Utils.hideKeyboard(context);
                        _navigateAndDisplaySelectionLocality(
                            context, CollectionTicket.PROVINCE);
                      },
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _provinceController,
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_right),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Quận/ Huyện/ Thị Xã *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    )),
                Visibility(
                    visible: showWard,
                    child: InkWell(
                      onTap: () async {
                        Utils.hideKeyboard(context);
                        _navigateAndDisplaySelectionLocality(
                            context, CollectionTicket.WARD);
                      },
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _wardController,
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.arrow_right),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Xã/ Phường/ Thị Trấn *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    )),
                Visibility(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _addressContacter,
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Địa chỉ *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    visible: showCity),
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
                Visibility(
                    visible: _statusTicketModel?.actionGroupCode ==
                            FieldTicketConstant.PTP ||
                        _statusTicketModel?.actionGroupCode ==
                            FieldTicketConstant.C_PTP,
                    child: TextFormField(
                      controller: _moneyController,
                      enableInteractiveSelection: false,
                      inputFormatters: [NumericMoneyTextFormatter()],
                      keyboardType: TextInputType.number,
                      // validator: (val) => Utils.isRequire(context, val),
                      onChanged: (value) {
                        readMoney();
                      },
                      textInputAction: TextInputAction.next,
                      maxLength: 15,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: S.of(context).moneyPromisePayment,
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    )),
                Visibility(
                    visible: _statusTicketModel?.actionGroupCode ==
                            FieldTicketConstant.C_OTHER ||
                        _statusTicketModel?.actionGroupCode ==
                            FieldTicketConstant.OTHER,
                    child: TextFormField(
                      controller: _moneyController,
                      enableInteractiveSelection: false,
                      inputFormatters: [NumericMoneyTextFormatter()],
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        readMoney();
                      },
                      textInputAction: TextInputAction.next,
                      maxLength: 15,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: S.of(context).moneyPromisePayment,
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    )),
                Visibility(
                  child: Padding(
                      child: Text(ReadMoneyNumber.numberToString(moneyNumber),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColor.primary)),
                      padding:
                          EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0)),
                  visible: moneyNumber > -1,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 5,
                  controller: _noteController,
                  validator: (val) => Utils.isRequire(context, val ?? ''),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).note + " *",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                Listener(
                    onPointerDown: (_) => FocusScope.of(context).unfocus(),
                    child: InkWell(
                      onTap: () async {
                        await showBarModalBottomSheet(
                          expand: false,
                          context: context,
                          isDismissible: true,
                          bounce: true,
                          backgroundColor: AppColor.primary,
                          builder: (context) => DrowdownListBottomSheet(
                            values: _categoryProvider.lstCustomerAttitudeModel,
                            title: 'Chọn thái độ khách hàng',
                            onSelected: (value) {
                              if (value is CustomerAttitudeModel) {
                                _customerAttitudeModel = value;
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<CustomerAttitudeModel>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Thái độ khách hàng *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        value: _customerAttitudeModel,
                        validator: (val) => Utils.isRequireSelect(
                            context, _customerAttitudeModel),
                        hint: _customerAttitudeModel != null
                            ? Text(
                                _customerAttitudeModel?.title ?? '',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            : Text(S
                                .of(context)
                                .select), // Not necessary for Option 1
                        items: [],
                        onChanged: (_) {},
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(bottom: 50), child: Container()),
              ])))
    ]);
  }

  Widget cameraWidget() {
    return Card(
      // margin: EdgeInsets.all(7.0),
      margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0, top: 4.0),

      child: Column(children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 30, top: 0.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(S.of(context).document,
                  style: TextStyle(
                      fontSize: AppFont.fontSize16,
                      fontWeight: FontWeight.bold)),
              TextButton.icon(
                  onPressed: () async {
                    if (OfflineService.isFeatureValid(FEATURE_APP.CAMERA)) {
                      takePicture();
                    }
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                  label:
                      Text("Chụp ảnh", style: TextStyle(color: Colors.black))),
            ],
          ),
        ),
        // Divider(
        //   color: AppColor.blackOpacity,
        // ),
        Visibility(
          child: Divider(
            color: AppColor.blackOpacity,
          ),
          visible: listImage.isNotEmpty,
        ),
        (listImage.isEmpty == true)
            ? Container()
            : ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.0, minHeight: 100.0),
                child: buildListImage(ActionPhone.CAMERA)),
      ]),
    );
  }

  void selectActionAttributeTicket() {
    try {
      if (Utils.checkIsNotNull(_actionTicketModel)) {
        lstActionAttributeTicketModel = [];
        WidgetCommon.resetGlobalFormFieldState(_keyActionAttributeTicketModel);

        _actionAttributeTicketModel = null;
        clearSubActionController();

        // for (ActionAttributeTicketModel attribute
        //     in _categoryProvider.lstActionAttributeTicketModel) {
        //   if (attribute.actionId == _actionTicketModel.fetmAction['id'] &&
        //       attribute.actionGroupId == _statusTicketModel.id) {
        //     lstActionAttributeTicketModel.add(attribute);
        //   }
        // }
        String actionGroupCode = _statusTicketModel?.actionGroupCode ?? '';
        String actionCode = _actionTicketModel?.fetmAction['actionCode']?.toString() ?? '';
        lstActionAttributeTicketModel = this
            ._collectionService
            .getListSelectActionAttributeTicket(_actionTicketModel!,
                actionGroupCode, actionCode, _statusTicketModel?.id!, tenantCode);

        setState(() {});
      }
    } catch (e) {}
  }

  Future<void> takePicture() async {
    try {
      if (listImage.length >= 5) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey, "Chỉ được tải lên tối đa 5 tấm ảnh");
      }
      CameraService cameraService = new CameraService();
      var _image = await cameraService.forceTakePhoto();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String value = _image?.path ?? '';
      if (value.isNotEmpty) {
        WidgetCommon.showLoading();
        final extensionStr = value.split('.').last;
        // final FormData formData = new FormData.fromMap({
        //   "fileName": fileName + "." + extension,
        //   "extension": extension,
        //   "ownerObjName": AppStateConfigConstant.TICKET,
        //   "ownerObjId": ticketModel.id,
        //   "file": await MultipartFile.fromFile(value, filename: fileName)
        // });
        final FormData formData = new FormData.fromMap({
          "cmd": Utils.encodeJSONToString({
            "fileName": fileName + "." + extensionStr,
            "extension": extensionStr
          }),
          "file": await MultipartFile.fromFile(value, filename: fileName)
        });
        final response = await _dmsService.uploadFile(formData);
        WidgetCommon.dismissLoading();
        if (Utils.checkRequestIsComplete(response)) {
          if (response.data['data'] != null) {
            String stringLabel = response.data['data'].toString();
            listImage.add(new FileLocal(stringLabel, "123", _image!));
            setState(() {});
          }
        }
      }
        } catch (e) {
      WidgetCommon.showSnackbar(_scaffoldKey,
          "Vui lòng thử tải ảnh lại, hoặc liên hệ quản trị viên để được hỗ trợ");
      WidgetCommon.dismissLoading();
    }
  }

  Widget buildListImage(String type) {
    List<Widget> lstWidget = [];
    if (type == ActionPhone.CAMERA) {
      for (int index = 0; index < listImage.length; index++) {
        lstWidget.add(ImageSelfieWidget(
          imgList: listImage,
          index: index,
          onRemove: () => removeImage(index, type),
        ));
      }
    } else if (type == ActionPhone.SELFIE) {
      for (int index = 0; index < lstImgSelfie.length; index++) {
        lstWidget.add(
          ImageSelfieWidget(
            imgList: lstImgSelfie,
            index: index,
            onRemove: () => removeImage(index, type),
          ),
        );
      }
    }
    return Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: lstWidget);
  }

  Future<void> removeImage(int index, String type) async {
    WidgetCommon.generateDialogOKCancelGet("Bạn muốn xóa ảnh này",
        callbackOK: () {
      if (type == ActionPhone.CAMERA) {
        this.listImage.removeAt(index);
      } else if (type == ActionPhone.SELFIE) {
        this.lstImgSelfie.removeAt(index);
      }
      setState(() {});
    });
  }

  _navigateAndDisplaySelectionLocality(
      BuildContext context, String _type) async {
    if (_type == CollectionTicket.PROVINCE) {
      if (!Utils.checkIsNotNull(cityModel)) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey, 'Vui lòng chọn Tỉnh/Thành phố');
      }
    } else if (_type == CollectionTicket.WARD) {
      if (!Utils.checkIsNotNull(provinceModel)) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey, 'Vui lòng chọn Quận/ Huyện/ Thị Xã ');
      }
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocalityScreen(
                type: _type,
                cityModel: cityModel,
                provinceModel: provinceModel,
              )),
    );

    if (result != null) {
      if (_type == CollectionTicket.CITY) {
        _cityController.text = result.name.toString();
        cityModel = result;
        provinceModel = null;
        wardModel = null;
        _provinceController.text = '';
        _wardController.text = '';
      } else if (_type == CollectionTicket.PROVINCE) {
        _provinceController.text = result.name.toString();
        provinceModel = result;
        wardModel = null;
        _wardController.text = '';
      } else if (_type == CollectionTicket.WARD) {
        _wardController.text = result.name.toString();
        wardModel = result;
      }
      setState(() {});
    }
  }

  Widget buildWidgetContacter(String type) {
    if (Utils.checkIsNotNull(_contactByTicketModel)) {
      if (_contactByTicketModel?.modeCode == 'FV') {
        if (type == AppStateConfigConstant.FULLNAME) {
          return TextFormField(
            keyboardType: TextInputType.text,
            controller: _fullNameContacter,
            validator: (val) => Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Họ và tên người liên hệ *",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          );
        } else if (type == AppStateConfigConstant.PHONE) {
          return TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phoneContacter,
            validator: (val) => Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Số điện thoại người liên hệ *",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          );
        }
      } else {
        if (type == AppStateConfigConstant.FULLNAME) {
          return TextFormField(
            keyboardType: TextInputType.text,
            controller: _fullNameContacter,
            validator: (val) => Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Họ và tên người liên hệ *",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          );
        } else if (type == AppStateConfigConstant.PHONE) {
          return TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phoneContacter,
            validator: (val) => Utils.isRequire(context, val ?? ''),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Số điện thoại người liên hệ *",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          );
        }
      }
    } else {
      if (type == AppStateConfigConstant.FULLNAME) {
        return TextFormField(
          keyboardType: TextInputType.text,
          controller: _fullNameContacter,
           validator: (val) => Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              labelText: "Họ và tên người liên hệ *",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        );
      } else if (type == AppStateConfigConstant.PHONE) {
        return TextFormField(
          keyboardType: TextInputType.phone,
          controller: _phoneContacter,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              labelText: deferment
                  ? "Số điện thoại người liên hệ *"
                  : "Số điện thoại người liên hệ",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        );
      }
    }
    return Container();
  }

  Widget buildLocation() {
    return InkWell(
        child: TextFormField(
          readOnly: true,
          enabled: false,
          maxLines: 2,
          validator: (val) => Utils.isRequire(context, val ?? ''),
          controller: _locationCtr,
          onFieldSubmitted: (term) {},
          style: TextStyle(fontSize: 16.0, color: Colors.black),
          decoration: InputDecoration(
              suffixIcon: _collectionService.buildLoadingLocation(
                  isLoadingLocation, context),
              contentPadding: EdgeInsets.all(10.0),
              labelText: S.of(context).position + " *",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        onTap: () async {
          if (!isLoadingLocation) {
            Position? position = await PermissionAppService.getCurrentPosition();
            if (position == null) {
              return WidgetCommon.showSnackbar(
                  _scaffoldKey, "Vui lòng cấp quyền định vị");
            }
            if (position.latitude == 0 && position.longitude == 0) {
              return WidgetCommon.showSnackbar(
                  _scaffoldKey, "Vui lòng bật GPS");
            }
            _mapService.openMapViewLocationCheckin(
                _scaffoldKey, _locationCtr.text, context,
                curentMarker: LatLng(position.latitude, position.longitude));
          }
        });
  }

  Future<bool> createComplaint() async {
    // if (deferment) {
    //   final customerComplainService = new CustomerComplainService();
    //   Map<String, dynamic> dataComplaint = {
    //     "customerName": _fullNameContacter.text,
    //     "phoneNumber": _phoneContacter.text,
    //     "customerEmail": ticketModel.customerData['email'] ?? '',
    //     "accountNumber": ticketModel.customerId,
    //     "contractNumber": ticketModel.contractId,
    //     "nationalId": ticketModel.customerData['idno'] ?? '',
    //     "custtypeCode": "EXISTING",
    //     "casetypeCode": "FECredit_Base_CS_Work_SCM_GeneralServiceRequest",
    //     "productCode": "Loan",
    //     "categoryCode": "Request",
    //     "subcategoryCode": "RC42-Hỗ trợ giãn nợ",
    //     "attributeCode": "",
    //     "remarks": "",
    //   };
    //   final Response resComplaint =
    //       await customerComplainService.createComplaintJSON(dataComplaint);
    //   if (Utils.checkRequestIsComplete(resComplaint)) {
    //     var data = Utils.handleRequestData(resComplaint);
    //     if (data != null) {
    //       if (data['caseID'] != null) {
    //         var sys = data['sys'];
    //         if (sys['code'] != 1) {
    //           WidgetCommon.showSnackbar(_scaffoldKey, sys['description']);
    //           return false;
    //         }
    //       }
    //     }
    //   }
    // }
    return true;
  }

  Widget buildCheckBoxDeferment() {
    return Container();
  }

  void setlectActionAttribute(BaseModel value) {
    try {
      WidgetCommon.resetGlobalFormFieldState(_keyActionSubAttributeModel);
      WidgetCommon.resetGlobalFormFieldState(_keyActionIncomeAttributeModel);
      clearSubActionController();
      _actionSubAttributeModel = null;
      _actionIncomeAttributeModel = null;
      actionSubAttributeModels = [];
      actionIncomeAtributeModels = [];
      if (value is ActionAttributeTicketModel) {
        _actionAttributeTicketModel = value;
      }
      for (var subAttribute in _categoryProvider.actionSubAttributeModels) {
        if (subAttribute.actionAttributeId ==
            _actionAttributeTicketModel?.id) {
          if (subAttribute.groupId == 1) {
            actionSubAttributeModels.add(subAttribute);
          } else {
            actionIncomeAtributeModels.add(subAttribute);
          }
        }
      }
      setState(() {});
    } catch (_) {
      setState(() {});
    }
  }

  void clearSubActionController() {
    _currentIncomeAmountController.clear();
    _loanAmountController.clear();
    _lastIncomeAmountController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _checkInProvider.clearData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
