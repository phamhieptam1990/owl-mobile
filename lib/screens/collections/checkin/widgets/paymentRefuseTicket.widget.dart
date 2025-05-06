import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
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
import 'package:athena/models/events.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:athena/models/offline/category/attribute_value_type.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/screens/collections/checkin/checkin.provider.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/collections/checkin/widgets/tutorial.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/common/permission._app.service.dart';
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

import '../../../../models/category/action_sub_attribute_model.dart';
import '../../../../utils/common/tracking_installing_device.dart';
import '../../../../utils/formatter/numbericMoney.formater.dart';
import '../../../../utils/global-store/user_info_store.dart';
import '../../collections.service.dart';
import '../show_toturial_manager.dart';
import 'customerName.widget.dart';
import 'dropdown_list_bottom_sheet.dart';
import 'image_sefie.dart';
import 'locality.widget.dart';

class PaymentRefuseTicketWidget extends StatefulWidget {
  final String? title;
  final TicketModel? ticket;
  final int? actionGroupID;
  final String? actionGroupCode;
  final String? actionGroupName;
  PaymentRefuseTicketWidget(
      {Key? key,
      required this.ticket,
      required this.title,
      required this.actionGroupID,
      required this.actionGroupCode,
      required this.actionGroupName})
      : super(key: key);
  @override
  _PaymentRefuseTicketWidgetState createState() =>
      _PaymentRefuseTicketWidgetState();
}

class _PaymentRefuseTicketWidgetState extends State<PaymentRefuseTicketWidget>
    with AfterLayoutMixin {
  final _collectionService = new CollectionService();
  final _categoryProvider = new CategorySingeton();
  final _mapService = new VietMapService();
  final _checkInProvider = getIt<CheckInProvider>();
  TicketModel? ticketModel;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'PaymentRefuseTicket');
  final _formLoginKey = new GlobalKey<FormState>();
  final _userInfoStore = getIt<UserInfoStore>();

  int? actionGroupID = 2;
  final GlobalKey<FormFieldState> _keyContactPerson =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyContactByTicketModel =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyPlaceContact =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyActionTicket =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyActionReason =
      new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _keyActionAttributeTicketModel =
      new GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _keyActionSubAttributeModel =
      new GlobalKey<FormFieldState>();

  final GlobalKey<FormFieldState> _keyActionIncomeAttributeModel =
      new GlobalKey<FormFieldState>();

  ContactPersonTicketModel? _contactPersonTicketModel;
  ContactByTicketModel? _contactByTicketModel;
  PlaceContactTicketModel? _placeContactTicketModel;
  ActionTicketModel? _actionTicketModel;
  ActionTicketModel? reasonAction;
  ActionAttributeTicketModel? _actionAttributeTicketModel;
  List<ActionAttributeTicketModel> lstActionAttributeTicketModel = [];
  List<ActionSubAttributeModel> actionSubAttributeModels =
      <ActionSubAttributeModel>[];
  List<ActionSubAttributeModel> actionIncomeAtributeModels =
      <ActionSubAttributeModel>[];
  CustomerAttitudeModel? _customerAttitudeModel;
  LocalityModel? cityModel;
  LocalityModel? provinceModel;
  LocalityModel? wardModel;
  bool showCity = false;
  bool showProvince = false;
  bool showWard = false;
  bool showContactPlace = true;
  final TextEditingController _fullNameContacter = TextEditingController();
  final TextEditingController _phoneContacter = TextEditingController();
  final TextEditingController _addressContacter = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();

  //
  final TextEditingController _currentIncomeAmountController =
      TextEditingController();
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _lastIncomeAmountController =
      TextEditingController();

  var _customerData;

  final TextEditingController _noteController = new TextEditingController();
  final TextEditingController _timeScheduleController =
      new TextEditingController();
  final TextEditingController _locationCtr = new TextEditingController();
  List<ContactPersonTicketModel> lstContactPersonTicketModel = [];

  String? actionGroupName = AppStateConfigConstant.REFUSE_TO_PAY;
  String contractId = '';
  String employeeInfomation = '';
  final _dmsService = new DMSService();

  bool isLoading = true;
  bool isLoadingLocation = true;
  List<FileLocal> listImage = [];
  List<FileLocal> lstImgSelfie = [];
  bool isCatchEventCheckin = false;

  // key fetch title location
  GlobalKey keyFetchTitle = GlobalKey();
// key fetch title location
  GlobalKey keyLocation = GlobalKey();

  List<TargetFocus> getTitleCheckinTargets1 = <TargetFocus>[];
  List<TargetFocus> getTitleCheckinTargets2 = <TargetFocus>[];
  List<TargetFocus> actionCodeTarget = <TargetFocus>[];
  List<TargetFocus> reasonTarget = <TargetFocus>[];

  //init tracking apps installed
  final _trackingAppsInstalled = TrackingInstallingDevice();

  ActionSubAttributeModel? _actionSubAttributeModel = ActionSubAttributeModel();
  ActionSubAttributeModel? _actionIncomeAttributeModel =
      ActionSubAttributeModel();
  final _formKey = GlobalKey<FormState>();

  bool isShowTypeCheckIn = false;
  CustomerAttitudeModel? _checkInType;
  final TextEditingController _overdueReasonController =
      new TextEditingController();
  final TextEditingController _financialSituationController =
      new TextEditingController();
  final TextEditingController _relativeIncomeController =
      new TextEditingController();

  @override
  initState() {
    super.initState();
    _customerAttitudeModel = new CustomerAttitudeModel('Bình Thường', 1);
    actionGroupID = widget.actionGroupID;
    actionGroupName = widget.actionGroupName;
    _contactByTicketModel =
        this._categoryProvider.setDefaultContactByTicketModel();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    ticketModel = widget.ticket;
    lstContactPersonTicketModel =
        this._categoryProvider.initDataListContactPerson(actionGroupID);
    await handleData();
    _timeScheduleController.text = S.of(context).select;
    if (Utils.checkIsNotNull(_contactByTicketModel)) {
      _keyContactByTicketModel.currentState?.setValue(_contactByTicketModel);
    }
    bool isShowed = await ShowTutorialManager.getShowedPayment();
    if (!isShowed) {
      // showTutorial();
    }
    if (widget.actionGroupCode == FieldTicketConstant.PTP) {
      isShowTypeCheckIn = true;
      _checkInType =
          new CustomerAttitudeModel('Hoạt động Kinh doanh của Khách hàng', '1');
    }
  }

  Future<void> getCurrentPosition(
      bool isCheckPermission, bool reloadPosition) async {
    Position? lastPosition = PermissionAppService.lastPosition;
    if(lastPosition == null) {
      return;
    }
    if(lastPosition.latitude == 0 && lastPosition.longitude == 0) {
      return;
    }
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
        if (Utils.checkIsNotNull(lastPosition) &&
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
        _trackingAppsInstalled.writeAppInstalled(recordType: 'checkin');
      }
    } catch (e) {
    } finally {
      if (address.isNotEmpty && Utils.checkIsNotNull(position)) {
        _checkInProvider.position = {
          'latitude': position?.latitude ?? 0.0,
          'longitude': position?.longitude ?? 0.0,
          'accuracy': position?.accuracy ??0.0,
          'address': address
        };
        _locationCtr.text = address;
      } else {
        _locationCtr.text = '';
        _checkInProvider.position = {
    'latitude': 0.0,
    'longitude': 0.0,
    'accuracy': 0.0,
    'address': ''
  };
      }
      isLoadingLocation = false;
      setState(() {});
    }
  }

  Future<void> handleData() async {
    try {
      await this._categoryProvider.initAllCateogyData();
      await this._categoryProvider.initActionModel();
      _customerData = ticketModel?.customerData;
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
    ticketModel = widget.ticket;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar:
          AppBarCommon(title: widget.title ?? 'Không thanh toán', lstWidget: [
        IconButton(
            key: keyLocation,
            icon: Icon(Icons.location_on, color: Colors.white),
            onPressed: () async {
              await getCurrentPosition(true, true);
            })
      ]),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: buildForm(),
      ),
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
    stateButtonOnlyText = ButtonState.loading;
    setState(() {});

    this.isCatchEventCheckin = true;

    if (lstImgSelfie.isEmpty ?? false) {
      return WidgetCommon.showSnackbar(
          _scaffoldKey, 'Bạn chưa chụp hình checkin!');
    }
    if (!Utils.isCheckInTimeValid()) {
      return WidgetCommon.showSnackbar(
          _scaffoldKey, S.of(context).checkInTimeInvalid);
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
  final bool? fakePosition = _collectionService.checkPositionError(
    _checkInProvider?.position['latitude'] != null ? 
        double.tryParse((_checkInProvider?.position['latitude']??0.0).toString()) ?? 0.0 : 0.0,
    _checkInProvider.position['longitude'] != null ? 
        double.tryParse((_checkInProvider?.position['longitude']??0.0).toString()) ?? 0.0 : 0.0) ?? false;
   // Fix: Fix position access in checkPositionError call
if (_checkInProvider.position['latitude'] != null && 
    _checkInProvider.position['longitude'] != null &&
    _checkInProvider.position['latitude'] == 0.0 &&
    _checkInProvider.position['longitude'] == 0.0 && 
    fakePosition != null && !fakePosition) {
  return;
}

    final form = _formLoginKey.currentState;
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey?.currentState?.validate() == false) {
      return;
    }
    if (form!.validate()) {
      form?.save();
      try {
        String address = '';
        if (Utils.checkIsNotNull(_checkInProvider.position)) {
          address = _checkInProvider.position['address']?.toString() ?? '';
        }
        if (address.isEmpty || _locationCtr.text.toString().isEmpty) {
          return WidgetCommon.generateDialogOKGet(
              content: 'Không tìm thấy địa chỉ check in');
        }
        if (lstActionAttributeTicketModel.isNotEmpty &&
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
          "actionGroupName": actionGroupName,
          "durationInMins": null,
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
          "customerAttitude": _customerAttitudeModel?.title!,
          "subAttributeId": _actionSubAttributeModel?.id,
          "subAttributeGroupId": _actionIncomeAttributeModel?.id,
          "currentIncomeAmount": Utils.parseDoubleStringToInt(_currentIncomeAmountController.text),
          "loanAmount":
              Utils.parseDoubleStringToInt(_loanAmountController.text),
          "lastIncomeAmount":
              Utils.parseDoubleStringToInt(_lastIncomeAmountController.text),
          'extraInfo': extraInfo ?? {},
          "overdueReason": _overdueReasonController.text,
          "financialSituation": _financialSituationController.text,
          "otherTrace": '',
          "relativeIncome": _relativeIncomeController.text,
          "checkInTypeCode": isShowTypeCheckIn ? _checkInType?.value : '',
          "checkInTypeName":  isShowTypeCheckIn ? _checkInType?.title : '',
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
          data['actionGroupCode'] = widget.actionGroupCode;
          data['isRefusePayment'] = true;
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
          return;
        }
        // if (!AppState.checkVersionCanSubmitRequest(context)) {
        //   return;
        // }
        final bool checkIn = await AppState.checkTime(context, () {
          Utils.pushAndRemoveUntil(RouteList.LOGIN_IDILE_SCREEN);
        });
        if (!checkIn) {
          this.isCatchEventCheckin = false;
          return;
        }

        final Response? res = await this._collectionService.checkInRefuse(data);
        stateButtonOnlyText = ButtonState.idle;
        setState(() {});
        this.isCatchEventCheckin = false;
        if (Utils.checkRequestIsComplete(res)) {
          if (res?.data['data'] == null) {
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
                    'Dữ liệu của bạn đã cũ vui lòng đồng bộ lại dữ liệu mới nhất và thực hiện checkin lại!';
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
        print(e);
        setState(() {});
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
      }
    }
  }

  Widget formDetail() {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      // cameraWidget(),
      selfieWidget(),
      Card(
          margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0, top: 0.0),
          child: new Form(
              key: _formLoginKey,
              onChanged: () {
                // final form = _formLoginKey.currentState;
                // if (form.validate()) {
                //   form.save();
                // }
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
                      if (position.latitude == 0 &&
                          position.longitude == 0) {
                        return;
                      }

                      _mapService.openMapViewLocationCheckin(
                          _scaffoldKey, _locationCtr.text, context,
                          curentMarker:
                              LatLng(position.latitude, position.longitude));
                    }
                  },
                ),
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
                          fillColor: Colors.white,
                          filled: true,
                          labelText: S.of(context).contactBy + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        isExpanded: true,
                        key: _keyContactByTicketModel,
                        value: _contactByTicketModel,
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
                                selectPerson(_contactPersonTicketModel);
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      child: DropdownButtonFormField<ContactPersonTicketModel>(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: S.of(context).contactWith + " *",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        isExpanded: true,
                        iconEnabledColor: AppColor.appBar,
                        iconDisabledColor: AppColor.appBar,
                        key: _keyContactPerson,
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
                buildWidgetContacter(AppStateConfigConstant.FULLNAME),
                buildWidgetContacter(AppStateConfigConstant.PHONE),
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
                            fillColor: Colors.white,
                            filled: true,
                            labelText: S.of(context).actionCode + " *",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          isExpanded: true,
                          isDense: false,
                          itemHeight: 50,
                          elevation: 1,
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          key: _keyActionTicket,
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
                                setlectActionAttribute(value);
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
                          iconEnabledColor: AppColor.appBar,
                          iconDisabledColor: AppColor.appBar,
                          itemHeight: 50,
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
                                      values: actionSubAttributeModels ?? [],
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
                                  labelText: "Thu nhập lúc mở khoản vay",
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
                              enableInteractiveSelection: false,
                              keyboardType: TextInputType.number,
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
                Visibility(child: 
                  TextFormField(
                    validator: (val) => Utils.isRequire(context, val ?? ''),
                    controller: _overdueReasonController,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: "Nguyên nhân quá hạn *",
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                ), visible: Utils.isTenantTnex(_userInfoStore) ),
                Visibility(child: TextFormField(
                  validator: (val) => Utils.isRequire(context, val ?? ''),
                  controller: _financialSituationController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: "Tình trạng kinh tế hiện tại *",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ), visible: Utils.isTenantTnex(_userInfoStore) ),
                  Visibility(child:TextFormField(
                  // validator: (val) => Utils.isRequire(context, val),
                  controller: _relativeIncomeController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: "Thông tin thu nhập của người thân",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),visible: Utils.isTenantTnex(_userInfoStore) ),
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
                  child: Container(),
                  padding: EdgeInsets.only(bottom: 300.0),
                )
              ])))
    ]);
  }

  void selectPerson(ContactPersonTicketModel? contactPersonTicketModel) async {
    try {
      WidgetCommon.showLoading();
      _categoryProvider.lstActionReason = [];
      WidgetCommon.resetGlobalFormFieldState(_keyActionTicket);
      _actionTicketModel = null;
      WidgetCommon.resetGlobalFormFieldState(_keyActionReason);
      this.reasonAction = null;
      lstActionAttributeTicketModel = [];
      WidgetCommon.resetGlobalFormFieldState(_keyActionAttributeTicketModel);
      _actionAttributeTicketModel = null;
      WidgetCommon.resetGlobalFormFieldState(_keyActionSubAttributeModel);
      _actionSubAttributeModel = null;
      WidgetCommon.resetGlobalFormFieldState(_keyActionIncomeAttributeModel);
      _actionIncomeAttributeModel = null;
      clearSubActionController();

      int contactPersonId = contactPersonTicketModel?.id ?? -1;
      for (FieldActions data in _categoryProvider.getLstFieldActions) {
        if (data.contactPersonId == contactPersonId &&
            actionGroupID == data.actionGroupId) {
          Map<dynamic, dynamic> abc = data.toJson();
          _categoryProvider.getLstActionReason
              .add(ActionTicketModel.fromJson(abc));
                }
      }

      if (contactPersonTicketModel?.personCode == CollectionTicket.CLIENT) {
        _fullNameContacter.text = ticketModel?.fullName?.toString() ?? '';
      } else {
        _fullNameContacter.text = '';
      }
    } catch (e) {
    } finally {
      setState(() {});
      await Future.delayed(Duration(milliseconds: 300));
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
                CustomerNameCheckInWidget(
                    customerFullName: ticketModel?.fullName),
                Expanded(
                  child: ListView(
                    children: [formDetail()],
                  ),
                )
              ]);
  }

  Widget cameraWidget() {
    return Card(
      // margin: EdgeInsets.all(7.0),
      margin: EdgeInsets.only(left: 7.0, right: 7.0, bottom: 4.0, top: 0.0),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 30, top: 0.0, bottom: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(S.of(context).document,
                  style: TextStyle(
                      fontSize: AppFont.fontSize16,
                      color: Colors.black,
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
                  label: Text(
                    "Chụp ảnh",
                    style: TextStyle(color: Colors.black),
                  )),
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
        final FormData formData = new FormData.fromMap({
          // "fileName": fileName + "." + extension,
          // "extension": extension,
          // "ownerObjName": AppStateConfigConstant.TICKET,
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

  void selectActionAttributeTicket() {
    try {
      if (Utils.checkIsNotNull(_actionTicketModel)) {
        lstActionAttributeTicketModel = [];
        clearSubActionController();

        WidgetCommon.resetGlobalFormFieldState(_keyActionAttributeTicketModel);
        _actionAttributeTicketModel = null;
        WidgetCommon.resetGlobalFormFieldState(_keyActionSubAttributeModel);
        _actionSubAttributeModel = null;
        WidgetCommon.resetGlobalFormFieldState(_keyActionIncomeAttributeModel);
        _actionIncomeAttributeModel = null;
        for (ActionAttributeTicketModel attribute
            in _categoryProvider.lstActionAttributeTicketModel) {
          if (attribute.actionId == _actionTicketModel?.fetmAction['id'] &&
              attribute.actionGroupId == actionGroupID) {
            lstActionAttributeTicketModel.add(attribute);
          }
        }
        setState(() {});
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    _categoryProvider.lstActionReason = [];
    _checkInProvider.clearData();
    WidgetCommon.disposeGlobalFormFieldState(_keyActionReason);
    WidgetCommon.disposeGlobalFormFieldState(_keyActionTicket);
    WidgetCommon.disposeGlobalFormFieldState(_keyContactByTicketModel);
    WidgetCommon.disposeGlobalFormFieldState(_keyPlaceContact);
    WidgetCommon.disposeGlobalFormFieldState(_keyContactPerson);
    PermissionAppService.lastPosition = null;
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
          validator: (val) => Utils.isRequireForTenant(context, val ?? '', _userInfoStore),
          controller: _phoneContacter,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              labelText: "Số điện thoại người liên hệ *",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        );
      }
    }
    return Container();
  }

  Widget selfieWidget() {
    return Card(
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
      String pathImage = _image?.path??'';
      if (pathImage.isNotEmpty) {
        final extensionStr = pathImage.split('.').last;
        final FormData formData = new FormData.fromMap({
          "cmd": Utils.encodeJSONToString({
            "fileName": fileName + "." + extensionStr,
            "extension": extensionStr
          }),
          "file": await MultipartFile.fromFile(pathImage, filename: fileName)
        });

        final response = await _dmsService.uploadFile(formData);

        if (response.statusCode == 403) {
          final imgBytes = File(pathImage).readAsBytesSync();
          final bytes = base64Encode(imgBytes);
          final _retryResponse = await _dmsService
              .uploadFileSelfie(isRetryAWSFailed: true, jsonData: {
            "fileName": fileName + ".",
            "ticketAggId": ticketModel?.aggId,
            "base64Content": bytes
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
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(_scaffoldKey,
          "Vui lòng thử tải ảnh lại, hoặc liên hệ quản trị viên để được hỗ trợ");
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
      onSkip: () {
        initTargets2();
        CustomTutorialCoachMark.show(
          context,
          targets: getTitleCheckinTargets2,
        );
        ShowTutorialManager.saveShowTutorialPaymentKey();
      },
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void showTutorialAction() async {
    final value = await ShowTutorialManager.getShowedReason();
    if (value) return;
    initTargetActionCode();
    CustomTutorialCoachMark.show(
      context,
      targets: actionCodeTarget,
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
}
