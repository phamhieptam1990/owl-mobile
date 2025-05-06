import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/instance_manager.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
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
import 'package:athena/models/collections/checkin_error_data.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/checkin.provider.dart';
import 'package:athena/screens/collections/checkin/widgets/customerName.widget.dart';
import 'package:athena/screens/collections/checkin/widgets/dropdown_list_bottom_sheet.dart';
import 'package:athena/screens/collections/checkin/widgets/payment_type_widget.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/collections/checkin/widgets/tutorial.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/formatter/numbericMoney.formater.dart';
import 'package:athena/utils/formatter/numberstrmoney.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/camera.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/utils/services/geolocation.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/coach_tutorial/custom_tutorial_coach_mark.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/loading-button.widget.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../../../../models/wallet_list/ewallet_payment_info.dart';
import '../../../../models/wallet_list/overral_by_emp_code_with_balance.dart';
import '../../../../utils/common/tracking_installing_device.dart';
import '../../../../utils/storage/storage_helper.dart';
import '../../../wallet_list/wallet_type_list_controller.dart';
import '../../collections.service.dart';
import '../calendar.screen.dart';
import '../show_toturial_manager.dart';
import 'image_sefie.dart';
import 'locality.widget.dart';

class PaymentTicketWidget extends StatefulWidget {
  final String? title;
  final TicketModel? ticket;
  final int? actionGroupID;
  final String? actionGroupCode;
  final String? actionGroupName;
  final bool? enableDefaultActiveTime;
  final bool? isPromisePayment;

  PaymentTicketWidget(
      {Key? key,
      required this.ticket,
      required this.title,
      required this.actionGroupID,
      required this.actionGroupCode,
      required this.actionGroupName,
      this.enableDefaultActiveTime = true,
      this.isPromisePayment = false})
      : super(key: key);
  @override
  _PaymentTicketWidgetState createState() => _PaymentTicketWidgetState();
}

class _PaymentTicketWidgetState extends State<PaymentTicketWidget>
    with AfterLayoutMixin, TickerProviderStateMixin {
  final _collectionService = new CollectionService();
  final _mapService = new VietMapService();
  final _dmsService = new DMSService();
  final _categoryProvider = new CategorySingeton();
  final _checkInProvider = getIt<CheckInProvider>();
  final _userInfoStore = getIt<UserInfoStore>();
  TicketModel? ticketModel;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'PaymentTicket');
  final _formLoginKey = new GlobalKey<FormState>();

  final GlobalKey<FormFieldState> _keyContactPerson =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyContactByTicketModel =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyPlaceContact =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyActionTicket =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyActionAttributeTicketModel =
      new GlobalKey<FormFieldState>();

  ContactPersonTicketModel? _contactPersonTicketModel;
  ContactByTicketModel? _contactByTicketModel;
  CustomerAttitudeModel? _customerAttitudeModel;
  PlaceContactTicketModel? _placeContactTicketModel;
  ActionTicketModel? _actionTicketModel;
  ActionAttributeTicketModel? _actionAttributeTicketModel;
  bool isLoading = true;
  bool isLoadingLocation = true;
  final TextEditingController _moneyController = new TextEditingController();
  final TextEditingController _noteController = new TextEditingController();
  final TextEditingController _timeScheduleController =
      new TextEditingController();
  final TextEditingController _paymentPerson = new TextEditingController();
  final TextEditingController _clientPhone = new TextEditingController();
  final TextEditingController _smsContent = new TextEditingController();
  final TextEditingController _locationCtr = new TextEditingController();
  var _customerData;
  int moneyNumber = -1;
  List<ActionAttributeTicketModel> lstActionAttributeTicketModel = [];
  List<ContactPersonTicketModel> lstContactPersonTicketModel = [];
  String contractId = '';
  String employeeInfomation = '';

  LocalityModel? cityModel;
  LocalityModel? provinceModel;
  LocalityModel? wardModel;
  bool showCity = false;
  bool showProvince = false;
  bool showWard = false;
  bool showContacter = true;
  bool deferment = false;
  bool showContactPlace = true;
  final TextEditingController _fullNameContacter = new TextEditingController();
  final TextEditingController _phoneContacter = new TextEditingController();
  final TextEditingController _addressContacter = new TextEditingController();
  final TextEditingController _cityController = new TextEditingController();
  final TextEditingController _provinceController = new TextEditingController();
  final TextEditingController _wardController = new TextEditingController();

  bool isShowTypeCheckIn = false;
  CustomerAttitudeModel? _checkInType;
  final TextEditingController _overdueReasonController =
      new TextEditingController();
  final TextEditingController _financialSituationController =
      new TextEditingController();
  final TextEditingController _relativeIncomeController =
      new TextEditingController();

  List<ContactByTicketModel> lstContactByTicketNew = [];

  List<FileLocal> listImage = [];
  List<FileLocal> lstImgSelfie = [];
  // LOCATION.Location location = new LOCATION.Location();

  // Không cho checkin nhiều lần
  bool isCatchEventCheckin = false;

  // key fetch title location
  GlobalKey keyFetchTitle = GlobalKey();
// key fetch title location
  GlobalKey keyLocation = GlobalKey();

  List<TargetFocus> getTitleCheckinTargets1 = <TargetFocus>[];
  List<TargetFocus> getTitleCheckinTargets2 = <TargetFocus>[];
  List<TargetFocus> actionCodeTarget = <TargetFocus>[];
  List<TargetFocus> reasonTarget = <TargetFocus>[];

  //
  bool isChangedClientNumber = false;
  bool showSMSConfirmation = true;
  String? tenantCode;
  final _trackingAppsInstalled = TrackingInstallingDevice();

  OverallByEmpCodeWithBalanceData? currentPaymentType;
  final _defaultPaymentType = OverallByEmpCodeWithBalanceData(
      providerCode: "CASH",
      providerName: 'Tiền mặt',
      tenantCode: 'FECREDIT',
      appCode: 'VYMO',
      methodCode: 'CASH',
      methodName: 'Tiền mặt');

  @override
  initState() {
    super.initState();
    _customerAttitudeModel = new CustomerAttitudeModel('Bình Thường', 1);
    _contactByTicketModel = this
        ._categoryProvider
        .setDefaultContactByTicketModel(
            actionGroupCode: widget?.actionGroupCode ?? '');
    currentPaymentType = _defaultPaymentType; // Initialize with default payment type
    if (widget.actionGroupCode == FieldTicketConstant.OTHER_CALL) {
      if (_contactByTicketModel != null && _contactPersonTicketModel != null) {
        showContacter = _collectionService.checkShowAddress(
          _contactByTicketModel!,
          _contactPersonTicketModel!,
        );
      } else {
        showContacter = false; // hoặc xử lý mặc định khác
      }
      if (_contactByTicketModel?.modeCode == 'FC' ||
          (_contactByTicketModel?.modeName ??'')
              .toString()
              .contains('Gọi điện thoại cho khách hàng')) {
        showContactPlace = false;
      } else {
        showContactPlace = true;
      }
      setState(() {});
    }
    if (widget.actionGroupCode == FieldTicketConstant.PAY ||
        widget.actionGroupCode == FieldTicketConstant.C_PAY) {
      for (int i = 0;
          i < _categoryProvider.getLstContactByTicketM.length;
          i++) {
        if (_categoryProvider.getLstContactByTicketM[i].modeCode == 'FV') {
          lstContactByTicketNew
              .add(_categoryProvider.getLstContactByTicketM[i]);
          break;
        }
      }
    }
    if (widget.actionGroupCode == FieldTicketConstant.PTP) {
      isShowTypeCheckIn = true;
      _checkInType =
          new CustomerAttitudeModel('Hoạt động Kinh doanh của Khách hàng', '1');
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    tenantCode =
        await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE) ??
            APP_CONFIG.COMPANY_CODE;
    ticketModel = widget.ticket;
    lstContactPersonTicketModel =
        this._categoryProvider.initDataListContactPerson(widget?.actionGroupID! ?? 0);
    await handleData();
    _timeScheduleController.text = S.of(context).select;
    if (Utils.checkIsNotNull(_contactByTicketModel)) {
      _keyContactByTicketModel.currentState?.setValue(_contactByTicketModel);
    }

    bool isShowed = await ShowTutorialManager.getShowedPayment();
    if (!isShowed) {
      // showTutorial();
    }
    // if (widget.actionGroupCode != FieldTicketConstant.OTHER) {
      initDateTimePicker();
    // }
  }

  void initDateTimePicker() {
    if (widget.enableDefaultActiveTime == true) {
      _checkInProvider.durations = {'value': 5, 'isChecked': true};
      _checkInProvider.checkIn = DateTime.now().add(Duration(days: 1));

      String timeSubmit = Utils.convertTime(
              _checkInProvider.checkIn.millisecondsSinceEpoch,
              timeFormat: 'HH:mm') +
          " - " +
          _checkInProvider.durations['value'].toString() +
          " " +
          S.of(context).mins;
      _timeScheduleController.text = timeSubmit;
    }
    if (widget.actionGroupCode == FieldTicketConstant.OTHER_CALL) {
      _timeScheduleController.text = S.of(context).select;
    }
  }

  Future<void> getCurrentPosition(
      bool isCheckPermission, bool reloadPosition) async {
    Position? lastPosition = PermissionAppService.lastPosition;
    String address = '';
    Position? position;
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
        if ( lastPosition != null &&
            Utils.checkIsNotNull(lastPosition) &&
            isCheckPermission == false &&
            reloadPosition == false) {
          position = lastPosition;
          address = await this._mapService.getAddressFromLongLatVMap(
              lastPosition.latitude, lastPosition.longitude, context);
        } else {
          if (reloadPosition) {
            position = await PermissionAppService.getCurrentPosition();
          } else {
            position = await PermissionAppService.getLastKnowPosition();
          }
          address = await this._mapService.getAddressFromLongLatVMap(
              position?.latitude ?? 0.0, position?.longitude ?? 0.0, context);
        }
        // tracking apps installed
        _trackingAppsInstalled.writeAppInstalled(recordType: 'checkin');
      }
    } catch (e) {
      isLoadingLocation = false;
    } finally {
      if (address.isNotEmpty && Utils.checkIsNotNull(position)) {
        _checkInProvider.position = {
          'latitude': position?.latitude ?? 0.0,
          'longitude': position?.longitude ?? 0.0,
          'accuracy': position?.accuracy ?? 0.0,
          'address': address
        };
        _locationCtr.text = address;
      } else {
        _locationCtr.text = '';
        _checkInProvider.position =  {
    'latitude': 0.0,
    'longitude': 0.0,
    'accuracy': 0.0,
    'address': ''
  };;
      }
      isLoadingLocation = false;
      setState(() {});
    }
  }

  Future<void> handleData() async {
    try {
      await this._categoryProvider.initAllCateogyData();
      _customerData = ticketModel?.customerData ?? {};
      _clientPhone.text = ticketModel?.cusMobilePhone?.toString() ?? '';
      final tenantCode =
          await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE);
      if (!_collectionService.showSMSConfirmation(_userInfoStore, tenantCode)) {
        isChangedClientNumber = true;
        showSMSConfirmation = false;
        setState(() {});
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    await getCurrentPosition(false, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBarCommon(title: widget.title, lstWidget: [
        Container(
          key: keyLocation,
          child: IconButton(
              icon: Icon(Icons.location_on, color: Colors.white),
              onPressed: () async {
                await getCurrentPosition(true, true);
              }),
        )
      ]),
      body: buildForm(),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: LoadingButtonWidget(
          height: 62,
          title: S.of(context).checkIn,
          callbackOK: () async {
            submitForm(context).then((value) {
              stateButtonOnlyText = ButtonState.idle;
              isCatchEventCheckin = false;
              setState(() {});
            });
          },
        ),
      ),
    );
  }

  Future<void> submitForm(BuildContext context) async {
    if (isCatchEventCheckin || stateButtonOnlyText == ButtonState.loading) {
      return;
    }
    if (widget.actionGroupCode == FieldTicketConstant.OTHER_CALL) {
    } else {
      if (lstImgSelfie.isEmpty ?? false) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey, 'Bạn chưa chụp hình checkin!');
      }
    }
    stateButtonOnlyText = ButtonState.loading;
    setState(() {});
    final tenantCode =
        await StorageHelper.getString(AppStateConfigConstant.TENANT_CODE);
    if (!_collectionService.showSMSConfirmation(_userInfoStore, tenantCode)) {
      isChangedClientNumber = true;
    }
    this.isCatchEventCheckin = true;

    if (!Utils.isCheckInTimeValid()) {
      return WidgetCommon.showSnackbar(
          _scaffoldKey, S.of(context).checkInTimeInvalid);
    }
    if (!AppState.checkVersionCanSubmitRequest(context)) {
      return;
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
    if (form != null && form.validate()) {  // Add null check here
      form.save();
      if (widget.actionGroupCode == FieldTicketConstant.PAY ||
          widget.actionGroupCode == FieldTicketConstant.C_PAY) {
        if (_smsContent.text.length == 0 &&
            !isChangedClientNumber &&
            _userInfoStore
                .checkPerimission(ScreenPermission.SMS_CONFIRMATION)) {
          return WidgetCommon.showSnackbar(
              _scaffoldKey, 'Vui lòng chọn Xem nội dung tin nhắn');
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
          return WidgetCommon.showSnackbar(_scaffoldKey,
              'Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại');
        }
      }
      if (lstActionAttributeTicketModel.isNotEmpty &&
          _actionAttributeTicketModel == null) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey,
            S.of(context).pleaseChoose +
                S.of(context).actionAttributeCode.toLowerCase());
      }
      final fakeCheckIn = _collectionService.checkPositionError(
          (_checkInProvider.position['latitude'] as num).toDouble(),
          (_checkInProvider.position['longitude'] as num).toDouble());
      if (fakeCheckIn != null && !fakeCheckIn) {
        return;
      }

      try {
        int money = -1;
        if (_moneyController.text.isNotEmpty) {
          money = int.parse(Utils.repplaceCharacter(_moneyController.text));
        }
        String _dateShedule = "";
        String _timeSchedule = "";
        String _durationMins = "";
        if (Utils.isTenantTnex(_userInfoStore)) {
        } else {
          if (_checkInProvider.checkIn == null) {
            return WidgetCommon.showSnackbar(
                _scaffoldKey,
                widget.isPromisePayment ?? false
                    ? 'Vui lòng chọn ngày hứa thanh toán'
                    : 'Vui lòng chọn Thời Gian Tác động');
          }
          _dateShedule =
              _collectionService.getDateSchedule(_checkInProvider.checkIn);
          _timeSchedule =
              _collectionService.getTimeSchedule(_checkInProvider.checkIn);
          _durationMins =
              _collectionService.getDurationMin(_checkInProvider.durations);
        }

        String address = '';
        if (Utils.checkIsNotNull(_checkInProvider.position)) {
          address = _checkInProvider.position['address']?.toString() ?? '';
        }
        if (address.isEmpty || _locationCtr.text.toString().isEmpty) {
          return WidgetCommon.generateDialogOKGet(
              content: 'Vui lòng cấp quyền cho Athena Owl truy cập vị trí');
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

        String _paymentName =
            (widget.actionGroupCode == FieldTicketConstant.C_PAY ||
                    widget.actionGroupCode == FieldTicketConstant.PAY)
                ? _paymentPerson.text
                : '';

        String clientPhone = '';
        String actionGroupName = widget.actionGroupName ?? '';

        if ((widget.actionGroupCode == FieldTicketConstant.C_PAY ||
            widget.actionGroupCode == FieldTicketConstant.PAY)) {
          clientPhone = _clientPhone.text;
          _fullNameContacter.text = '';
          _phoneContacter.text = '';
        } else {
          clientPhone = '';
        }
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
            selfies.add(img.key);
          }
        }
        var actionAttributeId;
        if (Utils.checkIsNotNull(_actionAttributeTicketModel)) {
          actionAttributeId = _actionAttributeTicketModel?.id; // Add null check
        }
        if (!showContactPlace) {
          _placeContactTicketModel = PlaceContactTicketModel(id: 3);
        }
        final extraInfo = await Utils().getExtrainInfo();
        var data = {
          "aggId": ticketModel?.aggId,
          "contactModeId": _contactByTicketModel?.id,
          "contactPlaceId": _placeContactTicketModel?.id, // Add null check here
          "contactPersonId": _contactPersonTicketModel?.id, // Add null check here
          "paymentAmount": money,
          "paymentBy": _paymentName,
          "paymentUnit": 1,
          "clientPhone": clientPhone,
          "description": _noteController.text,
          "fieldActionId": _actionTicketModel?.id, // Add null check here
          "actionAttributeId": actionAttributeId,
          "address": address,
          "longitude": (_checkInProvider.position['longitude'] as num).toDouble(),
          "latitude": (_checkInProvider.position['latitude'] as num).toDouble(),
          "accuracy": (_checkInProvider.position['accuracy'] as num).toDouble(),
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
          "customerAttitude": _customerAttitudeModel?.title,
          "contactFullAddress": _collectionService.builFullAddress(
              cityModel, provinceModel, wardModel, _addressContacter.text),
          'extraInfo': extraInfo ?? {},
          'ewalletPaymentInfo': currentPaymentType == null
              ? null
              : EWalletPaymentInfo(
                      aggId: currentPaymentType?.aggId ?? '',
                      isEwalletPayment: currentPaymentType?.isWallet ?? false)
                  .toJson(),
          "overdueReason": _overdueReasonController.text,
          "financialSituation": _financialSituationController.text,
          "otherTrace": '',
          "relativeIncome": _relativeIncomeController.text,
          "checkInTypeCode": isShowTypeCheckIn ? _checkInType?.value : '',
          "checkInTypeName": isShowTypeCheckIn ? _checkInType?.title : '',
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
          this.isCatchEventCheckin = false;
          data["customerName"] = ticketModel?.issueName!;
          data["actionName"] =
              _actionTicketModel?.fetmAction['actionValue'] ?? '';
          data['contractId'] = contractId;
          data['employeeInfomation'] = employeeInfomation;
          data['actionGroupCode'] = widget.actionGroupCode;
          bool isCheckIn = await this._collectionService.checkInOffline(data);
          if (!isCheckIn) {
            return WidgetCommon.showSnackbar(
                _scaffoldKey, S.of(context).update_failed);
          }
          eventBus.fire(UpdateDetailCollectionOffline({
            'actionGroupName': widget.actionGroupName,
            'actionGroupCode': widget.actionGroupCode,
            'lastEventDate': DateTime.now().microsecondsSinceEpoch
          }));
          Utils.popPage(context);
          GeoPositionBackgroundService geoPositionBackgroundService =
              new GeoPositionBackgroundService();
          geoPositionBackgroundService.getFirstPositionWhenInApp();
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

        final Response res = await this._collectionService.checkIn(data);
        stateButtonOnlyText = ButtonState.idle;
        this.isCatchEventCheckin = false;
        if (Utils.checkRequestIsComplete(res)) {
          if (res.data['data'] == null) {
            eventBus.fire(ReloadList('DETAIL_SCREEN'));
            eventBus.fire(ReloadHomeScreen('HOME_SCREEN'));
            Utils.popPage(context);
            GeoPositionBackgroundService geoPositionBackgroundService =
                new GeoPositionBackgroundService();
            geoPositionBackgroundService.getFirstPositionWhenInApp();
            return;
          } else {
            try {
              final errorData = CheckinErrorData.fromJson(res.data['data']);
              if (errorData.errorType == 'question') {
                await WidgetCommon.generateDialogOKCancelGet(
                    errorData.errorMessage ?? 'Đã có lỗi xảy ra!',
                    callbackOK: () async {
                  setState(() {
                    currentPaymentType = _defaultPaymentType;
                  });

                  //resubmit when fail with payment smart pay
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
                    'Dữ liệu đã thay đổi vui lòng đồng bộ lại dữ liệu mới nhất!';
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

  Widget buildForm() {
    Widget buildFormDetail;
    if (widget.actionGroupCode == FieldTicketConstant.C_OTHER ||
        widget.actionGroupCode == FieldTicketConstant.OTHER ||
        widget.actionGroupCode == FieldTicketConstant.PTP ||
        widget.actionGroupCode == FieldTicketConstant.C_PTP ||
        widget.actionGroupCode == FieldTicketConstant.OTHER_CALL) {
      buildFormDetail = formDetail();
    } else {
      buildFormDetail = formDetailPayment();
    }
    return (isLoading == true)
        ? ShimmerCheckIn()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                CustomerNameCheckInWidget(
                    customerFullName: ticketModel?.fullName! ?? ''),
                Expanded(
                    child: ListView(
                  children: [buildFormDetail],
                )),
              ]);
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalendarTicketScreen()),
    );

    if (result != null) {
      _timeScheduleController.text = result.toString();
    }
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

  void selectPerson(ContactPersonTicketModel? contactPersonTicketModel) async {
    try {
      _categoryProvider.lstActionReason = [];
      _actionTicketModel = null;
      WidgetCommon.resetGlobalFormFieldState(_keyActionTicket);
      lstActionAttributeTicketModel = [];
      WidgetCommon.resetGlobalFormFieldState(_keyActionAttributeTicketModel);
      _actionAttributeTicketModel = null;
      WidgetCommon.showLoading();
      int contactPersonId = contactPersonTicketModel?.id ?? -1;
      int actionGroupID = widget.actionGroupID ?? -1;
      for (FieldActions data in _categoryProvider.getLstFieldActions) {
        if (data.contactPersonId == contactPersonId &&
            actionGroupID == data.actionGroupId) {
          ActionTicketModel abc = ActionTicketModel.fromJson(data.toJson());
          // if (widget.actionGroupCode == 'PAY' ||
          //     widget.actionGroupCode == 'C-PAY') {
          _categoryProvider.getLstActionReason.add(abc);
          // } else {
          //   _categoryProvider.getLstActionReason.add(abc);
          //   // _categoryProvider.getLstActionReason
          //   //     .add(ActionTicketModel.fromJson(abc));
          // }
                }
      }

      if (contactPersonTicketModel?.personCode == CollectionTicket.CLIENT) {
        _fullNameContacter.text = ticketModel?.fullName ?? '';
      } else {
        _fullNameContacter.text = '';
      }
    } catch (e) {
    } finally {
      setState(() {});
      await Future.delayed(Duration(milliseconds: 100));
      WidgetCommon.dismissLoading();
    }
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
      String value = _image?.path ??'';
      if (value.isNotEmpty) {
        WidgetCommon.showLoading();
        final extensionStr = value.split('.').last;
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

  Future<void> takePictureSelfie() async {
    try {
      if (lstImgSelfie.length >= 5) {
        return WidgetCommon.showSnackbar(
            _scaffoldKey, "Chỉ được tải lên tối đa 5 ảnh check in");
      }

      CameraService cameraService = new CameraService();
      var _image = await cameraService.forceSelfie();
      WidgetCommon.showLoading();
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String pathImage = _image?.path ??'';
      if (pathImage.isNotEmpty) {
        final extensionFile = pathImage.split('.').last;
        // final FormData formData = new FormData.fromMap({
        //   "fileName": fileName + "." + extensionFile,
        //   "ticketAggId": ticketModel.aggId,
        //   "file": await MultipartFile.fromFile(pathImage, filename: fileName)
        // });
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
          final _retryResponse = await _dmsService
              .uploadFileSelfie(isRetryAWSFailed: true, jsonData: {
            "fileName": fileName + "." + extensionFile,
            "ticketAggId": ticketModel?.aggId,
            "base64Content": bytes ?? ''
          });
          WidgetCommon.dismissLoading();
          if (_retryResponse != null && Utils.checkRequestIsComplete(_retryResponse)) {
            if (_retryResponse?.data['data'] != null) {
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
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(_scaffoldKey,
          "Vui lòng thử tải ảnh lại, hoặc liên hệ quản trị viên để được hỗ trợ");
    } finally {
      WidgetCommon.dismissLoading();
    }
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

  Widget cameraWidget() {
    return Card(
      // margin: EdgeInsets.fromLTRB(7.0, 4.0, 7.0, 4.0),
      margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0),
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
                      await takePicture();
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

  Widget selfieWidget() {
    return Card(
      margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0),
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

  Widget formDetailPayment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // cameraWidget(),
        selfieWidget(),
        Card(
            margin:
                EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0, top: 0.0),
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
                  InkWell(
                      child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        maxLines: 2,
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        controller: _locationCtr,
                        onFieldSubmitted: (term) {},
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                            suffixIcon: buildLoadingLocation(
                                isLoadingLocation, context),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: S.of(context).position + " *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                      onTap: () async {
                        if (!isLoadingLocation) {
                          Position? position =
                              await PermissionAppService.getCurrentPosition();
                          if (position == null ||
                              position.latitude == null ||
                              position.longitude == null) {
                            return WidgetCommon.generateDialogOKGet(
                                content:
                                    'Vui lòng cấp quyền cho Athena Owl truy cập vị trí');
                          }
                          _mapService.openMapViewLocationCheckin(
                              _scaffoldKey, _locationCtr.text, context,
                              curentMarker: LatLng(
                                  position.latitude, position.longitude));
                        }
                      }),
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
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          key: _keyContactByTicketModel,
                          value: _contactByTicketModel,
                          validator: (val) => Utils.isRequireSelect(
                              context, _contactByTicketModel),
                          hint: (_contactByTicketModel?.modeName != null)
                              ? Text(
                                  _contactByTicketModel?.modeName ??'',
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
                                  selectPerson(_contactPersonTicketModel);
                                  // showTutorialAction();
                                }
                              },
                            ),
                          );
                        },
                        child:
                            DropdownButtonFormField<ContactPersonTicketModel>(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
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
                                  (_contactPersonTicketModel?.personName! ?? ''),
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
                              fillColor: Colors.white,
                              filled: true,
                              labelText: S.of(context).actionCode + " *",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            key: _keyActionTicket,
                            value: _actionTicketModel,
                            isExpanded: true,
                            iconEnabledColor: AppColor.appBar,
                            iconDisabledColor: AppColor.appBar,
                            isDense: false,
                            itemHeight: 50,
                            elevation: 1,
                            validator: (val) => Utils.isRequireSelect(
                                context, _actionTicketModel),
                            hint: (_actionTicketModel?.fetmAction != null)
                                ? Text(
                                    _actionTicketModel
                                            ?.fetmAction['actionValue'] ??
                                        '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
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
                      visible: lstActionAttributeTicketModel.length > 0,
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
                          child: DropdownButtonFormField<
                              ActionAttributeTicketModel>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText:
                                  S.of(context).actionAttributeCode + " *",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
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
                      visible: showContactPlace,
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
                            child: DropdownButtonFormField<
                                PlaceContactTicketModel>(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
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
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
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
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
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
                          labelText: (widget.isPromisePayment ?? false
                                  ? "Ngày hứa thanh toán"
                                  : S.of(context).timeScheduleNext) +
                              " *",
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
                                position: Tween(
                                        begin: Offset(0, 1), end: Offset(0, 0))
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
                          value: currentPaymentType?.providerName,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          validator: (val) => Utils.isRequireSelect(
                              context, currentPaymentType),
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
                    keyboardType: TextInputType.number,
                    enableInteractiveSelection: false,
                    // validator: (val) => Utils.isRequire(context, val),
                    textInputAction: TextInputAction.next,
                    maxLength: 15,
                    onChanged: (value) {
                      changeValueMoney();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: S.of(context).moneyPaymentTake + " *",
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
                    enableInteractiveSelection: false,
                    controller: _clientPhone,
                    textInputAction: TextInputAction.next,
                    validator: (val) => Utils.isRequire(context, val ?? ''),
                    onChanged: (text) {
                      setState(() {
                        _smsContent.clear();
                        isChangedClientNumber = false;
                      });
                    },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Nhấn vào đây để xem trước nội dung tin nhắn * ",
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          TextStyle(color: AppColor.primary)),
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
                              values:
                                  _categoryProvider.lstCustomerAttitudeModel,
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
                            fillColor: Colors.white,
                            filled: true,
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
                  Visibility(
                      child: TextFormField(
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        controller: _overdueReasonController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Nguyên nhân quá hạn *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                      visible: Utils.isTenantTnex(_userInfoStore)),
                  Visibility(
                      child: TextFormField(
                        validator: (val) => Utils.isRequire(context, val ?? ''),
                        controller: _financialSituationController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Tình trạng kinh tế hiện tại *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                      visible: Utils.isTenantTnex(_userInfoStore)),
                  Visibility(
                      child: TextFormField(
                        // validator: (val) => Utils.isRequire(context, val),
                        controller: _relativeIncomeController,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: "Thông tin thu nhập của người thân",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                      visible: Utils.isTenantTnex(_userInfoStore)),
                  Visibility(
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
                                builder: (context) => DrowdownListBottomSheet(
                                  values: _categoryProvider.lstCheckInType,
                                  title: 'Chọn Nguồn tiền thanh toán',
                                  onSelected: (value) {
                                    if (value is CustomerAttitudeModel) {
                                      _checkInType = value;
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            },
                            child:
                                DropdownButtonFormField<CustomerAttitudeModel>(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                labelText: "Nguồn tiền thanh toán *",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              isExpanded: true,
                              value: _customerAttitudeModel,
                              iconEnabledColor: AppColor.appBar,
                              iconDisabledColor: AppColor.appBar,
                              validator: (val) =>
                                  Utils.isRequireSelect(context, _checkInType),
                              hint: _customerAttitudeModel != null
                                  ? Text(
                                      _checkInType?.title ?? '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  : Text(S
                                      .of(context)
                                      .select), // Not necessary for Option 1
                              items: [],
                              onChanged: (_) {},
                            ),
                          )),
                      visible: isShowTypeCheckIn),
                  Padding(
                      padding: EdgeInsets.only(bottom: 50), child: Container()),
                ])))
      ],
    );
  }

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
                InkWell(
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      maxLines: 2,
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      controller: _locationCtr,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          suffixIcon:
                              buildLoadingLocation(isLoadingLocation, context),
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: S.of(context).position + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    onTap: () async {
                      if (!isLoadingLocation) {
                        Position? position =
                            await PermissionAppService.getCurrentPosition();
                        if (position == null) {
                          return;
                        }
                        _mapService.openMapViewLocationCheckin(
                            _scaffoldKey, _locationCtr.text, context,
                            curentMarker: LatLng(
                                position.latitude, position.longitude));
                      }
                    }),
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
                                showContacter = this
                                    ._collectionService
                                    .checkShowAddress(_contactByTicketModel!,
                                        _contactPersonTicketModel);
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
                        items: [],
                        decoration: InputDecoration(
                          fillColor: Colors.white,
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
                                // showTutorialAction();
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<ContactPersonTicketModel>(
                        items: [],
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: S.of(context).contactWith + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        key: _keyContactPerson,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        value: _contactPersonTicketModel,
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
                        onChanged: (_) {},
                      ),
                    )),
                buildWidgetContacter(AppStateConfigConstant.FULLNAME),
                buildWidgetContacter(AppStateConfigConstant.PHONE),
                Visibility(
                  visible: _categoryProvider.getLstActionReason.isNotEmpty ??
                      false,
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
                                  // showReason();
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
                          key: _keyActionTicket,
                          value: _actionTicketModel,
                          isExpanded: true,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          isDense: false,
                          itemHeight: 50,
                          validator: (val) => Utils.isRequireSelect(
                              context, _actionTicketModel),
                          hint: (_actionTicketModel?.fetmAction != null)
                              ? Text(
                                  _actionTicketModel
                                          ?.fetmAction['actionValue'] ??
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
                  visible: lstActionAttributeTicketModel.length > 0,
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
                          // itemHeight: 100,
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
                              fillColor: Colors.white,
                              filled: true,
                              labelText: S.of(context).contactPlace + " *",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            key: _keyPlaceContact,
                            iconEnabledColor: AppColor.appBar,
                            iconDisabledColor: AppColor.appBar,
                            isExpanded: true,
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
                Visibility(
                    visible: widget.actionGroupCode !=
                            FieldTicketConstant.OTHER_CALL &&
                        Utils.isTenantTnex(_userInfoStore),
                    child: InkWell(
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
                        // validator: (val) => Utils.isRequire(context, val),
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.arrow_right,
                              color: AppColor.appBar,
                            ),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: (widget.isPromisePayment ?? false
                                ? "Ngày hứa thanh toán"
                                : S.of(context).timeScheduleNext),
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    )),
                Visibility(
                    visible: widget.actionGroupCode !=
                            FieldTicketConstant.OTHER_CALL &&
                        !Utils.isTenantTnex(_userInfoStore),
                    child: InkWell(
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
                            suffixIcon: Icon(
                              Icons.arrow_right,
                              color: AppColor.appBar,
                            ),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: (widget.isPromisePayment ?? false
                                    ? "Ngày hứa thanh toán"
                                    : S.of(context).timeScheduleNext) +
                                " *",
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                    )),
                Visibility(
                  visible:
                      widget.actionGroupCode == FieldTicketConstant.C_OTHER ||
                          widget.actionGroupCode == FieldTicketConstant.OTHER,
                  child: TextFormField(
                    controller: _moneyController,
                    enableInteractiveSelection: false,
                    inputFormatters: [NumericMoneyTextFormatter()],
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: S.of(context).moneyPromisePayment,
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    maxLength: 15,
                    onChanged: (value) {
                      changeValueMoney();
                    },
                  ),
                ),
                Visibility(
                  // visible: widget.actionGroupID == 1,
                  visible: widget.actionGroupCode == FieldTicketConstant.PTP ||
                      widget.actionGroupCode == FieldTicketConstant.C_PTP,

                  child: TextFormField(
                    controller: _moneyController,
                    enableInteractiveSelection: false,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [NumericMoneyTextFormatter()],
                    keyboardType: TextInputType.number,
                    // validator: (val) => Utils.isRequire(context, val),
                    maxLength: 15,
                    onChanged: (value) {
                      changeValueMoney();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: S.of(context).moneyPromisePayment,
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
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
                Visibility(
                    child: TextFormField(
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      controller: _overdueReasonController,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Nguyên nhân quá hạn *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    visible: Utils.isTenantTnex(_userInfoStore)),
                Visibility(
                    child: TextFormField(
                      validator: (val) => Utils.isRequire(context, val ?? ''),
                      controller: _financialSituationController,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Tình trạng kinh tế hiện tại *",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    visible: Utils.isTenantTnex(_userInfoStore)),
                Visibility(
                    child: TextFormField(
                      // validator: (val) => Utils.isRequire(context, val),
                      controller: _relativeIncomeController,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Thông tin thu nhập của người thân",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    visible: Utils.isTenantTnex(_userInfoStore)),
                Visibility(
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
                                values: _categoryProvider.lstCheckInType,
                                title: 'Chọn Nguồn tiền thanh toán',
                                onSelected: (value) {
                                  if (value is CustomerAttitudeModel) {
                                    _checkInType = value;
                                    setState(() {});
                                  }
                                },
                              ),
                            );
                          },
                          child: DropdownButtonFormField<CustomerAttitudeModel>(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: "Nguồn tiền thanh toán *",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            isExpanded: true,
                            value: _customerAttitudeModel,
                            iconEnabledColor: AppColor.appBar,
                            iconDisabledColor: AppColor.appBar,
                            validator: (val) =>
                                Utils.isRequireSelect(context, _checkInType),
                            hint: _customerAttitudeModel != null
                                ? Text(
                                    _checkInType?.title ?? '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                : Text(S
                                    .of(context)
                                    .select), // Not necessary for Option 1
                            items: [],
                            onChanged: (_) {},
                          ),
                        )),
                    visible: isShowTypeCheckIn),
                Padding(
                    padding: EdgeInsets.only(bottom: 50), child: Container()),
              ])))
    ]);
  }

  Widget buildLoadingLocation(bool isLoading, BuildContext context) {
    if (!isLoading) {
      if (MyConnectivity.instance.isOffline) {
        return Container(
            key: keyFetchTitle,
            child:
                Icon(Icons.location_on, color: Theme.of(context).primaryColor));
      }
      return Container(
          key: keyFetchTitle,
          child:
              Icon(Icons.location_on, color: Theme.of(context).primaryColor));
    }
    return WidgetCommon.buildCircleLoading(
        widthSB: 20.0, heightSB: 20.0, pWidth: 20.0);
  }

    // Fix the changeValueMoney method with proper null safety
  changeValueMoney() {
    try {
      if (Utils.checkIsNotNull(_moneyController)) {
        if (_moneyController.text.toString().isNotEmpty) {
          // Fix 1: Remove unnecessary null assertion and fix null coalescing
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
      print('Error in changeValueMoney: $e'); // Add logging
      moneyNumber = -1;
    }
  }

  void selectActionAttributeTicket() {
    try {
      if (Utils.checkIsNotNull(_actionTicketModel)) {
        lstActionAttributeTicketModel = [];
        WidgetCommon.resetGlobalFormFieldState(_keyActionAttributeTicketModel);
        _actionAttributeTicketModel = null;
        String? actionGroupCode = widget.actionGroupCode ?? '';
        String? actionCode = _actionTicketModel?.fetmAction['actionCode'] ?? '';
        lstActionAttributeTicketModel = this
            ._collectionService
            .getListSelectActionAttributeTicket(_actionTicketModel,
                actionGroupCode, actionCode, widget.actionGroupID, tenantCode);
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Widget buildWidgetContacter(String type) {
    if (Utils.checkIsNotNull(_contactByTicketModel)) {
      if (_contactByTicketModel?.modeCode == 'FV') {
        if (type == AppStateConfigConstant.FULLNAME) {
          return TextFormField(
            keyboardType: TextInputType.text,
            controller: _fullNameContacter,
            validator: (val) =>
                Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Họ và tên người liên hệ *",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          );
        } else if (type == AppStateConfigConstant.PHONE) {
          return TextFormField(
            keyboardType: TextInputType.phone,
            controller: _phoneContacter,
            validator: (val) =>
                Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
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
            validator: (val) =>
                Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
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
          validator: (val) =>
              Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              labelText: "Họ và tên người liên hệ *",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        );
      } else if (type == AppStateConfigConstant.PHONE) {
        return TextFormField(
          keyboardType: TextInputType.phone,
          controller: _phoneContacter,
          validator: (val) =>
              Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              labelText: "Số điện thoại người liên hệ *",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        );
      }
    }
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    _categoryProvider.lstActionReason = [];
    _checkInProvider.clearData();
    listImage = [];
    WidgetCommon.disposeGlobalFormFieldState(_keyActionTicket);
    WidgetCommon.disposeGlobalFormFieldState(_keyContactByTicketModel);
    WidgetCommon.disposeGlobalFormFieldState(_keyContactPerson);
    WidgetCommon.disposeGlobalFormFieldState(_keyPlaceContact);
    WidgetCommon.disposeGlobalFormFieldState(_keyActionAttributeTicketModel);
    PermissionAppService.lastPosition = null;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void showTutorial() {
    initTargets1();

    CustomTutorialCoachMark.show(
      context,
      targets: getTitleCheckinTargets1,
      onFinish: () {
        initTargets2();
        CustomTutorialCoachMark.show(context, targets: getTitleCheckinTargets2,
            onFinish: () {
          ShowTutorialManager.saveShowTutorialPaymentKey();
        }, onSkip: () {
          ShowTutorialManager.saveShowTutorialPaymentKey();
        });
      },
      onClickTarget: (target) {},
      onSkip: () {},
      onClickOverlay: (target) {},
    );
  }

  void initTargets1() {
    getTitleCheckinTargets1.add(
      TargetFocus(
        identify: "keyFetchTitle",
        keyTarget: keyFetchTitle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return ToturialWidget(
                title: 'Nhấn vào đây',
                description: 'Xem bản đồ vị trí checkin',
              );
            },
          ),
        ],
      ),
    );
  }

  void initTargets2() {
    getTitleCheckinTargets2.add(TargetFocus(
      identify: "keyLocation",
      keyTarget: keyLocation,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return ToturialWidget(
              title: 'Hoặc nhấn vào đây',
              description: 'Cập nhật lại địa điểm checkin',
            );
          },
        ),
      ],
    ));
  }

  void showTutorialAction() async {
    final value = await ShowTutorialManager.getShowedReason();
    if (value) return;
    initTargetActionCode();
    CustomTutorialCoachMark.show(
      context,
      targets: actionCodeTarget,
      onFinish: () {
        // CustomTutorialCoachMark.show(context, targets: targetActionCode,
        //     onFinish: () {
        //   ShowTutorialManager.saveShowTutorialPaymentKey();
        // }, onSkip: () {
        //   ShowTutorialManager.saveShowTutorialPaymentKey();
        // });
      },
      onClickTarget: (target) {},
      onSkip: () {},
      onClickOverlay: (target) {},
    );
    ShowTutorialManager.saveActionCodeKey();
  }

  void initTargetActionCode() {
    actionCodeTarget.add(TargetFocus(
      identify: "keyActionTicket",
      keyTarget: _keyActionTicket,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return ToturialWidget(
              title: 'Vui lòng chọn',
              description: 'Mã hoạt động',
            );
          },
        ),
      ],
    ));
  }

  void showReason() async {
    final value = await ShowTutorialManager.getShowedReason();
    if (value) return;

    initTargetReason();
    CustomTutorialCoachMark.show(
      context,
      targets: reasonTarget,
      onFinish: () {
        // initTargets2();
        // CustomTutorialCoachMark.show(context, targets: targetActionCode,
        //     onFinish: () {
        //   ShowTutorialManager.saveShowTutorialPaymentKey();
        // }, onSkip: () {
        //   ShowTutorialManager.saveShowTutorialPaymentKey();
        // });
      },
      onClickTarget: (target) {},
      onSkip: () {
        // initTargets2();
        // CustomTutorialCoachMark.show(
        //   context,
        //   targets: targetActionCode,
        // );
        // ShowTutorialManager.saveShowTutorialPaymentKey();
      },
      onClickOverlay: (target) {},
    );
    ShowTutorialManager.saveReasonKey();
  }

  void initTargetReason() {
    reasonTarget.add(TargetFocus(
      identify: "keyActionAttributeTicketModel",
      keyTarget: _keyActionAttributeTicketModel,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return ToturialWidget(
              title: 'Vui lòng chọn',
              description: 'Nguyên nhân cụ thể',
            );
          },
        ),
      ],
    ));
  }
}
