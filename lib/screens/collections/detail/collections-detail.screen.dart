import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/collections/detail/models/contracNo.dart';
import 'package:call_log/call_log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart' as GETX;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/getit.dart';
import 'package:athena/models/category/status_ticket.model.dart';
import 'package:athena/models/events.dart';
import 'package:athena/models/generate_job_response.dart';
import 'package:athena/models/line_manager_response.dart';
import 'package:athena/models/survey_constant_response.dart';
import 'package:athena/models/tickets/activity.model.dart';
import 'package:athena/models/tickets/ticket.model.dart';
import 'package:athena/models/tickets/ticketEvent.model.dart';
import 'package:athena/models/userInfo.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/collections/detail-lv1-read/collections-detail.screen.dart';
import 'package:athena/screens/collections/detail-ticket/payment_details_widget.dart';
import 'package:athena/screens/collections/detail/widget/calendarEvent.widget.dart';
import 'package:athena/screens/history_transaction_card/screen/history_transaction_card_new_screen.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/offline/hive.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/category/category.service.dart';
import 'package:athena/utils/services/customer/customer.service.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/floatContainer/floatContainerTicketDetailScreen.dart';
import '../../../utils/navigation/navigation.service.dart';
import '../../../utils/services/geolocation.service.dart';
import '../../download_list/services/download_list_services.dart';
import '../../history_impacting/screen/impacting_history_screen.dart';
import '../../recovery/constant.recovery.dart';
import '../checkPayment/checkPaymentDetail.screen.dart';
import '../collections.service.dart';
import 'collections-detail.provider.dart';
import 'detaill-action-feature.dart';

class CollectionDetailScreen extends StatefulWidget {
  CollectionDetailScreen({Key? key}) : super(key: key);
  @override
  _CollectionDetailScreenState createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen>
    with AfterLayoutMixin, WidgetsBindingObserver {
  final collectionService = CollectionService();
  final _customerService = CustomerService();
  TicketModel? ticketModel;  // Mark as nullable
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'CollectionDetailScreen');
  final collectionDetailProvider = CollectionDetailProvider();
  bool _enablePullUp = true;
  bool isLoading = true;
  bool isFirstEnter = false;
  final _collectionService = CollectionService();
  final _categoryService = CategoryService();
  final _categorySingeton = CategorySingeton();
  int offsetHistory = 0;
  String textDurations = '';
  final _userInfoStore = getIt<UserInfoStore>();
  StreamSubscription? subscription;
  StreamSubscription? subscriptionOfflineUpdateCollection;
  TextEditingController _phoneController = TextEditingController();
  final _appState = AppState();
  DateTime? callFrom;
  var dataCall;
  List<Survey> surveyAssets = <Survey>[];
  SaveFileService _saveFileService = SaveFileService();
  LineManagerResponse _lineManagerResponse = LineManagerResponse();
  @override
  initState() {
    super.initState();

    subscription = eventBus.on<ReloadList>().listen((ReloadList event) async {
      await Future.delayed(Duration(seconds: 2));
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
          backgroundColor: AppColor.blue);
      await handleFetchData();
    });

    subscriptionOfflineUpdateCollection = eventBus
        .on<UpdateDetailCollectionOffline>()
        .listen((UpdateDetailCollectionOffline event) async {
      await Future.delayed(Duration(seconds: 2));
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
          backgroundColor: AppColor.blue);
      await handleUpDateRecord(event);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await handleFetchData();
  }

  Future<void> handleFetchData() async {
    try {
      this.isLoading = true;
      setState(() {});
      if (MyConnectivity.instance.isOffline) {
        collectionDetailProvider.lstAcivityModel = [];
        if (ticketModel != null &&  ticketModel?.fieldTypeCode == null) {
          if (_categorySingeton.lstStatusTicketModel.length > 0) {
            ticketModel?.fieldTypeCode = [];
            for (StatusTicketModel statusTicketModel
                in _categorySingeton.lstStatusTicketModel) {
              ticketModel?.fieldTypeCode.add(statusTicketModel.toJson());
            }
          } else {
            this._categorySingeton.setStatusTicketModelOffline();
            ticketModel?.fieldTypeCode = [];
            for (StatusTicketModel statusTicketModel
                in _categorySingeton.lstStatusTicketModel) {
              ticketModel?.fieldTypeCode.add(statusTicketModel.toJson());
            }
          }
        } else {
          if (_categorySingeton.lstStatusTicketModel.length > 0) {
            ticketModel?.fieldTypeCode = [];
            for (StatusTicketModel statusTicketModel
                in _categorySingeton.lstStatusTicketModel) {
              ticketModel?.fieldTypeCode.add(statusTicketModel.toJson());
            }
          } else {
            this._categorySingeton.setStatusTicketModelOffline();
            ticketModel?.fieldTypeCode = [];
            for (StatusTicketModel statusTicketModel
                in _categorySingeton.lstStatusTicketModel) {
              ticketModel?.fieldTypeCode.add(statusTicketModel.toJson());
            }
          }
        }

        if (Utils.isArray(ticketModel?.ticketActionLog)) {
          final lstData = ticketModel?.ticketActionLog;
          for (Map<String, dynamic> data in lstData) {
            // ActivityModel act = new ActivityModel
            collectionDetailProvider.getLstAcivityModel
                .add(new ActivityModel.fromJson(data));
          }
        }
        if (Utils.checkIsNotNull(ticketModel?.ticketLastEvent)) {
          ticketModel?.ticketLastEvent = ticketModel?.ticketLastEvent;
          buildTicketLastEvent(ticketModel?.ticketLastEvent);
        }
      } else {
        final Response ticketDetail =
            await _collectionService.getTicketDetail(ticketModel?.aggId ?? '');
        if (Utils.checkRequestIsComplete(ticketDetail)) {
          var ticketDetailTemp = ticketDetail.data['data'];
          ticketModel?.actionGroupName = ticketDetailTemp['actionGroupName'];
          ticketModel?.actionGroupCode = ticketDetailTemp['actionGroupCode'];
          ticketModel?.lastEventDate = ticketDetailTemp['lastEventDate'];
          ticketModel?.lastPaymentDate = ticketDetailTemp['lastPaymentDate'];
          ticketModel?.lastPaymentAmount = ticketDetailTemp['lastPaymentAmount'];
          ticketModel?.assignedDate = ticketDetailTemp['assignedDate'];
          ticketModel?.ticketDetail = ticketDetail.data['data'];
        }
        this.isLoading = false;
        setState(() {});
        if (ticketModel?.fieldTypeCode == null) {
          if (_categorySingeton.lstStatusTicketModel.length > 0) {
            ticketModel?.fieldTypeCode = [];
            for (StatusTicketModel statusTicketModel
                in _categorySingeton.lstStatusTicketModel) {
              ticketModel?.fieldTypeCode.add(statusTicketModel.toJson());
            }
          } else {
            final Response fieldTypeCode =
                await _categoryService.getByFieldTypeCode(ticketModel?.feType ?? '');
            if (Utils.checkRequestIsComplete(fieldTypeCode)) {
              ticketModel?.fieldTypeCode = fieldTypeCode.data['data'];
            }
          }
        }
        if (ticketModel?.customerData == null) {
          final Response resCustomer =
              await _customerService.getContactByAggId(ticketModel?.aggId ?? '');
          if (Utils.checkRequestIsComplete(resCustomer)) {
            final _customerData = Utils.handleRequestData(resCustomer);
            if (Utils.checkIsNull(_customerData)) {
              ticketModel?.customerData = _customerData;
              ticketModel?.contactDetail = _customerData;
            }
          }
        }

        getTicketHistory();
        getLastEvent();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      _refreshController.refreshCompleted();
      setState(() {});
      if (!MyConnectivity.instance.isOffline) {
        if (ticketModel != null) {
          await HiveDBService.updateCollections(ticketModel!);
        } else {
          // Xử lý nếu ticketModel bị null
          print("⚠️ ticketModel is null!");
        }
      }
      GeoPositionBackgroundService geoPositionBackgroundService =
          new GeoPositionBackgroundService();
      geoPositionBackgroundService.getFirstPositionWhenInApp();
    }
  }

  changeCallTypeCode(type) {
    if (type == 'incoming') {
      return 'Incoming call';
    } else if (type == 'outgoing') {
      return 'Bạn đã gọi';
    } else if (type == 'missed') {
      return 'Missed incoming call';
    } else if (type == 'voiceMail') {
      return 'Voicemail call';
    } else if (type == 'rejected') {
      return 'Rejected incoming call';
    } else if (type == 'blocked') {
      return 'Blocked incoming call';
    } else if (type == 'answeredExternally') {
      return 'Todo comment';
    }
    return 'Unknown type of call';
  }

  changeCallType(type) {
    if (type == CallType.incoming) {
      return 'Incoming call';
    } else if (type == CallType.outgoing) {
      return 'Outgoing call';
    } else if (type == CallType.missed) {
      return 'Missed incoming call';
    } else if (type == CallType.voiceMail) {
      return 'Voicemail call';
    } else if (type == CallType.rejected) {
      return 'Rejected incoming call';
    } else if (type == CallType.blocked) {
      return 'Blocked incoming call';
    } else if (type == CallType.answeredExternally) {
      return 'Todo comment';
    }
    return 'Unknown type of call';
  }

  Future<void> handleUpDateRecord(var event) async {
    ticketModel?.actionGroupName = event.data['actionGroupName'];
    ticketModel?.actionGroupCode = event.data['actionGroupCode'];
    if (event.data['lastEventDate'] is String) {
      ticketModel?.lastEventDate = event.data['lastEventDate'];
    } else if (event.data['lastEventDate'] is int) {
      ticketModel?.lastEventDate =
          Utils.converLongToDate(event.data['lastEventDate']).toIso8601String();
    }

    setState(() {});
    HiveDBService.updateCollections(ticketModel!);
  }

  Future<void> getUrlServey() async {
    final response = await _collectionService.getUrlServey();

    if (response.data != null) {
      final data = json.decode(response.data['data']);

      //Get data to survey
      var surveyResponse = SurveyConstantResponse.fromJson(data);
      SurveyUtils.instance.surveys = surveyResponse.surveys ?? [];
    }
  }

  void handleSurveyAssests() {}

  Future<void> getLineManagerRecursive() async {
    final userProfile = this._appState.getMoreInfoUserInfoStore();

    final response =
        await _collectionService.getLineMananer(userProfile['empCode']);

    if (response.data != null) {
      _lineManagerResponse = LineManagerResponse.fromJson(response.data);
    }
  }

  Future<void> getLastEvent() async {
    final ticketId = ticketModel?.aggId;

    final Response response =
        await this._collectionService.getEventLastTicket(ticketId ?? '');

    if (Utils.checkRequestIsComplete(response)) {
      var data = Utils.handleRequestData(response);
      if (data != null) {
        ticketModel?.ticketLastEvent = data;
        buildTicketLastEvent(data);
      }
    }
    setState(() {});
  }

  void buildTicketLastEvent(data) {
    try {
      collectionDetailProvider.setTicketEvent(TicketEventModel.fromJson(data));
      final startDate = Utils.converLongToDate(
          Utils.convertTimeStampToDateEnhance(
              collectionDetailProvider.getTicketEvent?.startDate ?? '') ?? 0);
      final endDate = Utils.converLongToDate(
          Utils.convertTimeStampToDateEnhance(
              collectionDetailProvider.getTicketEvent?.endDate ?? '') ?? 0);
      Duration difference = endDate.difference(startDate);
      this.textDurations =
          Utils.buildTextFromTime(startDate.hour.toString()) +
              ":" +
              Utils.buildTextFromTime(startDate.minute.toString()) +
              " - " +
              Utils.buildTextFromTime(endDate.hour.toString()) +
              ":" +
              Utils.buildTextFromTime(endDate.minute.toString()) +
              " - " +
              difference.inMinutes.toString() +
              " " +
              S.current.mins;
    } catch (e) {
      print(e);
    }
  }

  void getTicketHistory({bool isSetTate = false}) {
    collectionDetailProvider.lstAcivityModel = [];
    try {
      this
          ._collectionService
          .getAcititySteamTicket(ticketModel?.aggId ?? '', offsetHistory,
              Utils.convertToIso8601String(ticketModel?.createDate ?? '') ?? '')
          .then((response) {
        if (Utils.checkRequestIsComplete(response)) {
          if (Utils.checkRequestIsComplete(response)) {
            var lstData = Utils.handleRequestData2Level(response);
            if (Utils.isArray(lstData)) {
              if (lstData.length < APP_CONFIG.LIMIT_QUERY) {
                _enablePullUp = false;
              }
              if (Utils.isArray(lstData)) {
                for (var data in lstData) {
                  collectionDetailProvider.getLstAcivityModel
                      .add(new ActivityModel.fromJson(data));
                }
                setState(() {
                  ticketModel?.ticketActionLog = lstData;
                });
              }
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await handleFetchData();
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 100));
    _refreshController.loadComplete();
  }

  Widget buildItemListView(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildFull(),
    );
  }

  List<Widget> buildFull() {
    List<Widget> lst = [];
    Widget _buildInfoCustomer = buildInfoCustomer(context);
    lst.add(_buildInfoCustomer);
    for (ActivityModel action in collectionDetailProvider.getLstAcivityModel) {
      if (action.action == AppStateConfigConstant.ETL_CREATE_TICKET ||
          action.action == AppStateConfigConstant.RECORD_PLANNED_DATE) {
        continue;
      } else if (action.action == AppStateConfigConstant.EVENT_CHECKIN) {
        String actionGroupCode = '';
        String actionGroupName = '';

        var offlineInfo;
        var dataTime = action.published;
        if (action.target['originalValue'] != null) {
          if (action.target['originalValue']['inputData'] != null)
            actionGroupCode =
                action.target['originalValue']['inputData']['actionGroupCode'];
          actionGroupName =
              action.target['originalValue']['inputData']['actionGroupName'];
          offlineInfo =
              action.target['originalValue']['inputData']['offlineInfo'];

          if (Utils.checkIsNotNull(offlineInfo)) {
            if (Utils.checkIsNotNull(offlineInfo['dataTime'])) {
              if (offlineInfo['dataTime'] is double) {
                dataTime = offlineInfo['dataTime'].toInt();
              }
              if (offlineInfo['dataTime'] is int) {
                dataTime = Utils.converLongToDate(offlineInfo['dataTime'])
                    .toIso8601String();
              } else {
                dataTime = offlineInfo['dataTime'];
              }
            }
          }
        }
        lst.add(InkWell(
          onTap: () async {
            await showBarModalBottomSheet(
                expand: false,
                context: context,
                isDismissible: true,
                bounce: false,
                backgroundColor: AppColor.primary,
                builder: (context) => DetailPaymentWidget(
                      activityModel: action,
                    ));
          },
          child: Card(
              child: ListTile(
            trailing: 
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(child: 
                IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () {
                    exportFileCheckIn(action);
                  },
                ), visible: Utils.isTenantTnex(_userInfoStore)),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed:  () {
                    showBarModalBottomSheet(
                      expand: false,
                      context: context,
                      isDismissible: true,
                      bounce: false,
                      backgroundColor: AppColor.primary,
                      builder: (context) => DetailPaymentWidget(
                            activityModel: action,
                          ));
                  },
                ),
              ],
            ),
            // Icon(Icons.arrow_forward_ios),
            leading: Utils.checkIsNotNull(offlineInfo)
                ? CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.no_cell,
                      color: AppColor.white,
                    ))
                : null,
            title: Text(
              _collectionService.convertActionGroupCode(
                  actionGroupCode, actionGroupName, context),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColor.black),
            ),
            subtitle: Text(
                Utils.getTimeFromDate(
                    Utils.convertTimeStampToDateEnhance(dataTime ?? '') ?? 0) ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColor.black)),
          )),
        ));
      } else if (action.action == AppStateConfigConstant.CALL_LOG) {
        var entry;
        if (action.target['originalValue'] != null) {
          if (action.target['originalValue']['inputData'] != null)
            entry = action.target['originalValue']['inputData'];
        }
        const TextStyle mono = TextStyle(fontSize: 16.0);
        lst.add(
          Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                contentPadding: EdgeInsets.only(
                    top: 8.0, left: 12.0, bottom: 8.0, right: 8.0),
                leading: CircleAvatar(
                  child: Icon(Icons.call_outlined, color: Colors.white),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                title: Text(
                    'Bạn đã gọi số ' + entry['formattedNumber'].toString(),
                    maxLines: 2,
                    style: mono),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_sharp,
                            size: 15.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Text(
                              Utils.convertTime(entry['timestamp'].toInt()),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      new SizedBox(height: 4.0),
                    ]),
              )),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        );
      } else if (action.action == AppStateConfigConstant.SMS_LOG) {
        var entry;
        if (action.target['originalValue'] != null) {
          if (action.target['originalValue']['inputData'] != null)
            entry = action.target['originalValue']['inputData'];
        }
        const TextStyle mono = TextStyle(fontSize: 16.0);
        lst.add(
          Column(
            children: <Widget>[
              Card(
                  child: ListTile(
                contentPadding: EdgeInsets.only(
                    top: 8.0, left: 12.0, bottom: 8.0, right: 8.0),
                trailing: Icon(Icons.info_rounded),
                leading: CircleAvatar(
                  child: Icon(Icons.sms),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                title: Text('Bạn đã gửi tin nhắn', style: mono),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new SizedBox(height: 4.0),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_sharp,
                            size: 15.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.0),
                            child: Text(
                              Utils.convertTime(entry['date']),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      new SizedBox(height: 4.0),
                    ]),
              )),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        );
      } else {
        String actionTitle = action.action ?? '';
        if (action.action == AppStateConfigConstant.CREATE_VYMO_CALENDAR) {
          if (Utils.checkIsNull(action.target)) {
            actionTitle = 'Metting ' + action.target['displayName'];
          }
        } else if (action.action == AppStateConfigConstant.CHECK_PAYMENT) {
          actionTitle = "Kiểm tra thông tin thanh toán";
        } else if (action.action ==
            AppStateConfigConstant.EVENT_CUSTOMER_MULTIPLE_ADDRESS) {
          actionTitle = S.of(context).seeOtherAddressCustomer;
        } else if (action.action == AppStateConfigConstant.PLANNED_LOG) {
          actionTitle = S.of(context).earlyTermination;
        } else if (action.action ==
            AppStateConfigConstant.EVENT_QUERY_LOAN_BASIC_INFO) {
          actionTitle = S.of(context).seeShedulePaymentInfomation;
        } else if (action.action ==
                AppStateConfigConstant.EVENT_QUERY_LOAN_SEC_INFO ||
            action.action ==
                AppStateConfigConstant.EVENT_QUERY_CARD_PAYMENT_INFO) {
          actionTitle = S.of(context).seeHistoryInfomationPayment;
        }

        lst.add(InkWell(
            onTap: () {
              if (action.action == AppStateConfigConstant.CHECK_PAYMENT) {
                NavigationService.instance.navigateToRoute(MaterialPageRoute(
                  builder: (context) =>
                      CheckPaymentDetailScreen(activityModel: action),
                ));
                return;
              }
            },
            child: Card(
                child: ListTile(
                    title: Text(
                      actionTitle,
                      style: TextStyle(color: AppColor.black),
                    ),
                    subtitle: Text(
                        Utils.getTimeFromDate(
                            Utils.convertTimeStampToDateEnhance(
                                action.published ?? '') ?? 0) ?? '',
                        style: TextStyle(color: AppColor.black)),
                    trailing: (action.action ==
                            AppStateConfigConstant.CREATE_VYMO_CALENDAR)
                        ? Icon(null)
                        : Icon(Icons.arrow_forward_ios)))));
      }
    }
    return lst;
  }

  String buildFullName(String fullName) {
    if (fullName == '') {
      return '';
    }
    return ticketModel?.fullName![0]??'';
  }

  String buildFullName2(String fullName) {
    if (fullName == '') {
      return '';
    }
    return ticketModel?.fullName ?? '';
  }

  btCancel() async {
    Navigator.pop(context);
  }

  Timer? _debounce;
  Function? modalSetStateCallback;
  btOk(type) async {
    if (_phoneController.text.length == 0) {
      return WidgetCommon.showSnackbar(_scaffoldKey,
          'Hợp đồng không có số điện thoại, vui lòng liên hệ quản trị viên');
    }
    if (Utils.checkIsNotNull(_phoneController.text)) {
      if (!Utils.isPhoneValidExt(_phoneController.text)) {
        return WidgetCommon.showSnackbar(_scaffoldKey,
            'Số điện thoại phải có 10 chữ số và bắt đầu bằng số 0');
      }
    }
    Navigator.pop(context);

    callFrom = DateTime.now();
    this.dataCall = null;
    await callPhone(_phoneController.text);
  }

  callPhone(String phone) async {
    Map<String, dynamic> dataJson = {
      'aggId': this.ticketModel?.aggId ?? '',
      'duration': 0,
      'formattedNumber': phone,
      'number': phone,
      'timestamp': DateTime.now().microsecondsSinceEpoch,
      'callType': 'outgoing',
    };
    this
        ._collectionService
        .recordUserCallLog(context, dataJson, this.ticketModel?.aggId, true);

    await FlutterPhoneDirectCaller.callNumber(phone);
  }

  handleSmsCallLog(action, ticketModel, type) async {
    var status;
    if (type == ActionPhone.CALL) {
      status = await Permission.phone.request();
    } else {
      status = await Permission.sms.request();
    }
    if (status == PermissionStatus.denied) {
      WidgetCommon.generateDialogOKGet(
          content: 'Vui lòng cấp quyền cho chức năng gửi SMS');
      return false;
    }
    String phone = ticketModel.customerData['cellPhone'] ??
        ticketModel.customerData['homePhone'];
    // phone = '84'+ phone;
    if (Utils.checkIsNotNull(phone)) {
      if ((phone[0] + phone[1]) == '84') {
        phone = '0' + phone.replaceFirst(RegExp(r'84'), '');
      } else if ((phone[0] + phone[1] + phone[2] == '+84')) {
        phone = '0' + phone.replaceFirst(RegExp(r'+84'), '');
      } else if (phone[0] != '0') {
        phone = '0' + phone;
      }
    }
    _phoneController.text = phone;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nhập số điện thoại cần liên lạc'),
            content: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Hủy bỏ'),
                onPressed: () async {
                  await btCancel();
                },
              ),
              TextButton(
                child: Text('Gọi'),
                onPressed: () async {
                  callFrom = DateTime.now();
                  btOk(type);
                },
              ),
            ],
          );
        });
  }

  Widget buildInfoCustomer(BuildContext context) {
    return Column(children: [
      Card(
          child: Column(
        children: [
          InkWell(
            onTap: () async {
              if (!MyConnectivity.instance.isOffline) {
                ModelBriefByContractNo model;
                final Response response =
                    await _collectionService.getContractInfo(ticketModel?.aggId ?? '');
                if (Utils.checkRequestIsComplete(response)) {
                  final contactData = Utils.handleRequestData(response);
                  if (Utils.checkIsNotNull(contactData)) {
                    model = ModelBriefByContractNo.fromJson(contactData);
                    GETX.Get.to(() => CollectionDetailLv1ReadScreen(),
                        arguments: {'params': ticketModel, 'params2': model});
                    return;
                  }
                }
              }
              GETX.Get.to(() => CollectionDetailLv1ReadScreen(), arguments: {
                'params': ticketModel,
                'ModelBriefByContractNo': null
              });
            },
            child: ListTile(
                contentPadding: EdgeInsets.all(5.0),
                leading: CircleAvatar(
                  child: Text(
                    buildFullName(ticketModel?.fullName ?? ''),
                    style: TextStyle(color: AppColor.white),
                  ),
                  backgroundColor: ticketModel != null
                      ? _collectionService.isRecordItem(context, ticketModel!)
                      : Colors.grey, // hoặc một màu mặc định nào đó
                  // backgroundColor: _collectionService.isRecordNew(
                  //     Utils.converLongToDate(
                  //         Utils.convertTimeStampToDateEnhance(
                  //             ticketModel?.createDate)),
                  //     Utils.converLongToDate(
                  //         Utils.convertTimeStampToDateEnhance(
                  //             ticketModel?.assignedDate)),
                  //     context,
                  //     ticketModel),
                ),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(buildFullName2(ticketModel?.fullName ?? ''),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    ticketModel != null
                        ? this._collectionService.buildLateCall(ticketModel!)
                        : SizedBox.shrink(), 
                  ],
                ),
                subtitle: ticketModel != null
                    ? _buildLeadingTile(ticketModel)
                    : const SizedBox.shrink(),
                trailing: Icon(Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor)),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            color: Colors.black45,
            height: 1.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async =>
                    {handleSmsCallLog(null, ticketModel, ActionPhone.CALL)},
                child: Column(
                  children: <Widget>[
                    Icon(Icons.phone, color: Theme.of(context).primaryColor),
                    Text(S.of(context).phone,
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                    showActionSheetLocation();
                    // if (Utils.checkIsNotNull(ticketModel.cusFullAddress)) {
                    //   if (ticketModel.cusFullAddress != 'null') {
                    //     return _collectionService.actionPhone(
                    //         ticketModel, ActionPhone.DIRECTION, context);
                    //   }
                    // }
                    // WidgetCommon.showSnackbar(_scaffoldKey,
                    //     'Hợp đồng không có địa chỉ, vui lòng liên hệ quản trị viên');
                  }
                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.near_me,
                      color: collectionService.colorDisableAction(
                          ticketModel, context),
                    ),
                    Text(S.of(context).direction,
                        style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
              // Visibility(child:
              // TextButton(
              //   onPressed: () async => {
              //     handleSmsCallLog(null, ticketModel, ActionPhone.SMS)
              //   },
              //   child: Column(
              //     children: <Widget>[
              //       Icon(
              //         Icons.sms,
              //         color: collectionService.colorDisableAction(
              //             ticketModel, context,
              //             type: AppStateConfigConstant.PHONE),
              //       ),
              //       Text(S.of(context).SMS,
              //           style: TextStyle(color: Colors.black))
              //     ],
              //   ),
              // ), visible: this.collectionService.showSMSConfirmation(this._userInfoStore, this._userInfoStore.getTenantCode())),
              TextButton(
                onPressed: () async => {await showActionSheet()},
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.more_vert,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text('Khác', style: TextStyle(color: Colors.black))
                  ],
                ),
              ),
            ],
          ),
          // SizedBox(
          //   height: 10.0,
          // ),
        ],
      )),
      Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
                visible: collectionDetailProvider.getTicketEvent != null
                    ? _collectionService.isTicketActionDetailExist(
                        collectionDetailProvider.getTicketEvent)
                    : false,
                child: ListTile(
                  title: buildCalendarItem(),
                  trailing: Icon(Icons.location_on),
                )),
          ],
        ),
      ),
      Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                S.of(context).history,
                textAlign: TextAlign.left,
                style: new TextStyle(fontSize: 18.0, color: Colors.black),
              ))),
    ]);
  }

  Widget buildCalendarItem() {
    DateTime date = Utils.converLongToDate(Utils.convertTimeStampToDateEnhance(
            collectionDetailProvider.getTicketEvent?.startDate) ??
        DateTime.now().millisecondsSinceEpoch);
    return InkWell(
      onTap: () async {
        // Utils.pushName(null, RouteList.MAP_SCREEN,
        //     params: collectionDetailProvider.getTicketEvent);
      },
      child: Row(
        children: [
          CalendarEventWidget(
            date: date,
          ),
          Padding(
            padding: EdgeInsets.only(left: 7.0, right: 7.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(S.of(context).nextMeeting),
                ]),
                SizedBox(height: 4.0),
                Row(children: [
                  Text(
                    this.textDurations,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeadingTile(TicketModel? detail) {
    try {
      String lastPaymentAmount = '';
      if (Utils.checkIsNotNull(detail?.lastPaymentAmount)) {
        if (Utils.checkValueIsDouble(detail?.lastPaymentAmount)) {
          lastPaymentAmount = Utils.formatPrice(Utils.repplaceCharacter(
              (detail?.lastPaymentAmount ?? 0).round().toString()));
        } else {
          lastPaymentAmount = Utils.formatPrice(
              Utils.repplaceCharacter((detail?.lastPaymentAmount ?? 0).toString()));
        }
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // SizedBox(height: 4.0),
          Text(
            (detail?.actionGroupCode != null)
                ? _collectionService.convertActionGroupCode(
                    detail?.actionGroupCode, detail?.actionGroupName, context)
                : _collectionService.convertStatusCode(
                    detail?.statusCode, context),
            style: TextStyle(fontSize: 14.0, color: Colors.black54),
          ),
          // SizedBox(height: 4.0),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 15.0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Text( ( Utils.checkIsNotNull(detail?.empFullName)
                            ? 
                                detail?.empFullName ?? ''
                            : '') +' - '+
                        _collectionService.getAssisneeData(detail),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                     style: TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 4.0),
          // Visibility(
          //     visible: Utils.checkIsNotNull(detail?.empFullName),
          //     child: Row(
          //       children: [
          //         Icon(
          //           Icons.person_add_alt,
          //           size: 15.0,
          //         ),
          //         Flexible(
          //           child: Padding(
          //             padding: EdgeInsets.only(left: 6.0),
          //             child: Text(
          //               Utils.checkIsNotNull(detail?.empFullName)
          //                   ? S.of(context).allocationFor +
          //                       ": " +
          //                       detail?.empFullName
          //                   : '',
          //               overflow: TextOverflow.ellipsis,
          //               maxLines: 2,
          //               style: TextStyle(fontSize: 12.0),
          //             ),
          //           ),
          //         )
          //       ],
          //     )),
          // SizedBox(height: 4.0),
          Visibility(
              visible: Utils.checkIsNotNull(detail?.cusFullAddress),
              child: Row(
                children: [
                  Icon(
                    Icons.home,
                    size: 15.0,
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Text(
                        Utils.checkIsNotNull(detail?.cusFullAddress)
                            ? detail?.cusFullAddress ?? ''
                            : '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                         style: TextStyle(fontSize: 14.0, color: Colors.black54),
                      ),
                    ),
                  )
                ],
              )),
          // SizedBox(height: 4.0),
          Row(
            children: [
              Icon(
                Icons.event,
                size: 15.0,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Text(
                    S.of(context).lastUpdate +
                        ": " +
                        Utils.convertTime(Utils.convertTimeStampToDateEnhance(
                            detail?.lastEventDate ?? '') ?? 0),
                    maxLines: 2,
                     style: TextStyle(fontSize: 14.0, color: Colors.black54),
                  ),
                ),
              )
            ],
          ),
          // SizedBox(height: 4.0),
          Visibility(
              visible: detail?.lastPaymentDate != null,
              child: Row(
                children: [
                  Icon(
                    Icons.note,
                    size: 15.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Text(Utils.convertTimeWithoutTime(
                              Utils.convertTimeStampToDateEnhance(
                                  detail?.lastPaymentDate ?? '') ?? 0) +
                          ", " +
                          lastPaymentAmount.toString() + " VNĐ",  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                    ),  )
                ],
              )),
          this._collectionService.buildCustomerAttitude(detail),
          this._collectionService.buildManager(detail),
          this._collectionService.buildCaseExpirationDate(detail),
          // _buildCustomerComlainInfo(lastestCustomerComplainResponse?.data),
          // SizedBox(
          //   height: 8,
          // ),
          Visibility(
            visible: detail?.mustPay != 0.0,
            child: Text(
                'Số tiền quá hạn: ' +
                    Utils.formatPrice(
                        detail?.mustPay?.round().toString() ?? '') +
                    ' VNĐ',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold)),
          ),
        ],
      );
    } catch (e) {
      return Container();
    }
  }

  Widget buildMainScreen(BuildContext context) {
    if (isLoading) {
      return ShimmerCheckIn(
        height: 60.0,
        countLoop: 8,
      );
    }
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _enablePullUp,
      footer: CustomFooter(
        builder: (context, status) {
          Widget body;
          if (status == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (status == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (status == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (status == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (c, i) => buildItemListView(i),
        itemCount: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ticketModel == null) {
      final route = ModalRoute.of(context);
      if (route != null && route.settings.arguments is TicketModel) {
        ticketModel = route.settings.arguments as TicketModel;
      }
      ticketModel?.feType = ActionPhone.LOAN;
    }
    return ChangeNotifierProvider<CollectionDetailProvider>(
      create: (context) => collectionDetailProvider,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBarCommon(
          title: S.of(context).detail,
          lstWidget: [],
        ),
        floatingActionButton: Visibility(
          visible: !isLoading,
          child:
              FloatContainerTicketDetailScreen(ticketModel: this.ticketModel),
        ),
        body: Scrollbar(child: buildMainScreen(context)),
      ),
    );
  }

  Future<void> showActionSheetLocation() async {
    List<SheetAction<dynamic>> lstShettActionFinal = [];
    List<SheetAction<dynamic>> lstSheetAction = [];
    lstSheetAction.add(SheetAction(
      icon: Icons.location_city,
      label: 'Địa chỉ công ty',
      key: 'companyAddress',
    ));
    lstSheetAction.add(SheetAction(
      icon: Icons.home,
      label: 'Địa chỉ thường trú',
      key: 'permanentAddress',
    ));
    lstSheetAction.add(SheetAction(
      icon: Icons.map,
      label: 'Địa chỉ tạm trú',
      key: 'cusFullAddress',
    ));

    lstSheetAction = lstSheetAction.reversed.toList();
    lstShettActionFinal.addAll(lstSheetAction);
    final result = await showModalActionSheet(
      context: context,
      title: 'Vui lòng chọn chức năng',
      materialConfiguration: MaterialModalActionSheetConfiguration(
          initialChildSize: 0.6, minChildSize: 0.25, maxChildSize: 0.9),
      actions: lstShettActionFinal,
    );
    switch (result) {
      case 'cusFullAddress':
        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
          // if (Utils.checkIsNotNull(ticketModel.cusFullAddress)) {
          //   if (ticketModel.cusFullAddress != 'null') {
              ticketModel?.addressTypeId = ADDRESS_TYPE_ID.cusFullAddress;
              return _collectionService.actionGoVietMapPositionTypeId(
                  ticketModel!, ActionPhone.DIRECTION , context);
          //   }
          // }
          // WidgetCommon.showSnackbar(
          //     _scaffoldKey, 'Hợp đồng không có địa chỉ tạm trú');
        }
        break;
      case 'permanentAddress':
        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
          // if (Utils.checkIsNotNull(ticketModel.permanentAddress)) {
          //   if (ticketModel.permanentAddress != 'null') {
              ticketModel?.addressTypeId = ADDRESS_TYPE_ID.permanentAddress;
              return _collectionService.actionGoVietMapPositionTypeId(
                  ticketModel!, ActionPhone.DIRECTION, context);
        //     }
        //   }
        //   WidgetCommon.showSnackbar(_scaffoldKey,
        //       'Hợp đồng không có địa chỉ thường trú, vui lòng liên hệ quản trị viên');
        }
        break;
      case 'companyAddress':
        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
          // if (Utils.checkIsNotNull(ticketModel.companyAddress)) {
          //   if (ticketModel.companyAddress != 'null') {
              ticketModel?.addressTypeId = ADDRESS_TYPE_ID.companyAddress;
              return _collectionService.actionGoVietMapPositionTypeId(
                  ticketModel!, ActionPhone.DIRECTION, context);
          //   }
          // }
          // WidgetCommon.showSnackbar(_scaffoldKey,
          //     'Hợp đồng không có địa chỉ công ty, vui lòng liên hệ quản trị viên');
        }
        break;
      default:
        break;
    }
  }

  Future<void> showActionSheet() async {
    List<SheetAction<dynamic>> lstShettActionFinal = [];
    List<SheetAction<dynamic>> lstSheetAction = [];
    if (!MyConnectivity.instance.isOffline) {
      // lstSheetAction.add(SheetAction(
      //   icon: Icons.add_road,
      //   label: S.of(context).seeOtherAddressCustomer,
      //   key: ActionPhone.CHECK_ADDRESS,
      // ));
      lstSheetAction.add(SheetAction(
        icon: Icons.assignment,
        label: 'Tài liệu/ hình ảnh của hợp đồng',
        key: ActionPhone.VIEW_OMNI_DOCS,
      ));
      lstSheetAction.add(SheetAction(
        icon: Icons.payment,
        label: 'Lịch sử thanh toán của hợp đồng',
        key: ActionPhone.CHECK_PAYMENT,
      ));
      // if (this.ticketModel.feType == ActionPhone.LOAN) {
      //   lstSheetAction.add(SheetAction(
      //     icon: Icons.attach_money,
      //     label: S.of(context).seeHistoryInfomationPayment,
      //     key: ActionPhone.CHECK_HISTORY_PAYMENT,
      //   ));
      // } else if (this.ticketModel.feType == ActionPhone.CARD) {
      //   lstSheetAction.add(SheetAction(
      //     icon: Icons.attach_money,
      //     label: S.of(context).seeHistoryInfomationPayment,
      //     key: ActionPhone.CHECK_HISTORY_PAYMENT_CARD,
      //   ));
      // }
      // lstSheetAction.add(SheetAction(
      //   icon: Icons.account_box,
      //   label: S.of(context).seeKalapaInfomation,
      //   key: ActionPhone.CHECK_KALAPA_INFOMATION,
      // ));
      // lstSheetAction.add(SheetAction(
      //   icon: Icons.calendar_today,
      //   label: S.of(context).seeShedulePaymentInfomation,
      //   key: ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY,
      // ));
      lstSheetAction.add(SheetAction(
        icon: Icons.payments,
        label: S.of(context).earlyTermination,
        key: ActionPhone.EARLY_TERMINATION,
      ));

      // lstSheetAction.add(SheetAction(
      //   icon: Icons.question_answer,
      //   label: 'Xem lịch sử giao dịch thẻ',
      //   key: ActionPhone.HISTORY_TRANSACTION_CARD,
      // ));
      // lstSheetAction.add(SheetAction(
      //   icon: Icons.access_time_outlined,
      //   label: 'Xem lịch sử tác động',
      //   key: ActionPhone.HISTORY_PROMISE_PAYMENT,
      // ));

      // lstSheetAction.add(SheetAction(
      //   icon: Icons.question_answer,
      //   label: 'Xem lịch sử giao dịch ví điện tử',
      //   key: ActionPhone.HISTORY_TRANSACTION_EWALLET,
      // ));
      // if (this._userInfoStore.checkPerimission(ScreenPermission.SURVEY) &&
      //     (SurveyUtils.instance?.surveys?.length ?? 0) != 0 &&
      //     (_lineManagerResponse?.lineManagers?.length ?? 0) != 0) {
      //   lstSheetAction.add(SheetAction(
      //     icon: Icons.question_answer,
      //     label: S.of(context).survey,
      //     key: ActionPhone.SURVEY,
      //   ));
      // }

      // if (this
      //     ._userInfoStore
      //     .checkPerimission(ScreenPermission.FUNCTION_EXPORT_DKK)) {
      //   lstSheetAction.add(SheetAction(
      //     icon: Icons.download,
      //     label: 'Tải thông báo khởi kiện',
      //     key: ActionPhone.DOWNLOAD_TBKK,
      //   ));
      // }

      // lstSheetAction.add(SheetAction(
      //   icon: Icons.flag_rounded,
      //   label: 'Lịch sử khiếu nại',
      //   key: ActionPhone.HISTORY_COMPLAIN,
      // ));
    }

    lstSheetAction = lstSheetAction.reversed.toList();
    lstShettActionFinal.addAll(lstSheetAction);
    final result = await showModalActionSheet(
      context: context,
      title: 'Vui lòng chọn chức năng',
      materialConfiguration: MaterialModalActionSheetConfiguration(
          initialChildSize: 0.6, minChildSize: 0.25, maxChildSize: 0.9),
      actions: lstShettActionFinal,
    );
    switch (result) {
      case ActionPhone.VIEW_OMNI_DOCS:
        Utils.pushName(context, RouteList.VIEW_OMNI_DOCS, params: ticketModel);
        break;
      case ActionPhone.CHECK_ADDRESS:
        Utils.pushName(context, RouteList.CHECK_PAYMENT_SCREEN, params: {
          'ticketModel': ticketModel,
          'type': ActionPhone.CHECK_ADDRESS,
          'title': S.of(context).seeOtherAddressCustomer,
          'message':
              'Vui lòng chọn "Xem địa chỉ" để xem các địa chỉ khác của khách hàng'
        });
        break;
      case ActionPhone.CHECK_PAYMENT:
        Utils.pushName(context, RouteList.CHECK_PAYMENT_SCREEN, params: {
          'ticketModel': ticketModel,
          'type': ActionPhone.CHECK_PAYMENT,
          'title': 'Lịch sử thanh toán của hợp đồng',
          'message': 'Vui lòng nhấn "Cập nhật" để kiểm tra thông tin thanh toán'
        });
        break;
      case ActionPhone.CHECK_HISTORY_PAYMENT:
        Utils.pushName(context, RouteList.CHECK_HISTORY_PAYMENT_SCREEN, params: {
          'ticketModel': ticketModel,
          'type': ActionPhone.CHECK_HISTORY_PAYMENT,
          'title': S.of(context).seeHistoryInfomationPayment,
          'message': 'Vui lòng nhấn "Cập nhật" để ' +
              S.of(context).seeHistoryInfomationPayment.toLowerCase()
        });
        break;
      case ActionPhone.CHECK_HISTORY_PAYMENT_CARD:
        Utils.pushName(context, RouteList.CHECK_HISTORY_PAYMENT_SCREEN, params: {
          'ticketModel': ticketModel,
          'type': ActionPhone.CHECK_HISTORY_PAYMENT_CARD,
          'title': S.of(context).seeHistoryInfomationPayment,
          'message': 'Vui lòng nhấn "Cập nhật" để ' +
              S.of(context).seeHistoryInfomationPayment.toLowerCase()
        });
        break;
      // case ActionPhone.CHECK_KALAPA_INFOMATION:
      //   Utils.pushName(null, RouteList.CHECK_HISTORY_PAYMENT_SCREEN,
      //       params: {
      //         'ticketModel': ticketModel,
      //         'type': ActionPhone.CHECK_KALAPA_INFOMATION,
      //         'title': S.of(context).seeKalapaInfomation,
      //         'message': 'Vui lòng chọn "Cập nhật" để ' +
      //             S.of(context).seeKalapaInfomation.toLowerCase()
      //       });
      //   break;
      case ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY:
        Utils.pushName(context, RouteList.CHECK_HISTORY_PAYMENT_SCREEN, params: {
          'ticketModel': ticketModel,
          'type': ActionPhone.SEE_SCHEDULE_PAYMENT_HISTORY,
          'title': S.of(context).seeShedulePaymentInfomation,
          'message': 'Vui lòng nhấn "Cập nhật" để ' +
              S.of(context).seeShedulePaymentInfomation.toLowerCase()
        });
        break;
      case ActionPhone.EARLY_TERMINATION:
        Utils.pushName(context, RouteList.CHECK_HISTORY_PAYMENT_SCREEN, params: {
          'ticketModel': ticketModel,
          'type': ActionPhone.EARLY_TERMINATION,
          'title': S.of(context).earlyTermination,
          'message': 'Vui lòng nhấn "Cập nhật" để ' +
              S.of(context).earlyTermination.toLowerCase()
        });
        break;

      case ActionPhone.HISTORY_TRANSACTION_CARD:
        {
          GETX.Get.to(() => HistoryTransactionCardNewScreen(data: ticketModel!));
        }
        break;
      case ActionPhone.HISTORY_PROMISE_PAYMENT:
        {
          GETX.Get.to(() => HistoryPromisePaymentScreen(data: ticketModel!));
        }
        break;

      // case ActionPhone.HISTORY_TRANSACTION_EWALLET:
      //   {
      //     GETX.Get.to(() => HistoryTransactionEWalletScreen(data: ticketModel));
      //   }
      //   break;

      // // case ActionPhone.DOWNLOAD_TBKK:
      // //   {
      // //     donwloadTbkk();
      // //   }
      // //   break;
      // case ActionPhone.HISTORY_COMPLAIN:
      //   {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 CustomerComplainHistoriesScreen(data: ticketModel)));
      //   }

      default:
        break;
    }
  }

  void donwloadTbkk() async {
    WidgetCommon.showLoading(dismissOnTap: false);

    try {
      var params = {
            "templateCode": "WORKING_RP",
            "params": {
                "cstbIssueAggId": "40257802-1df0-4a61-9b78-dc23628ad70a"
            }
        };

      final response = await _saveFileService.postTequestDownLoadFile(
          IcollectConst.generateReportVisitForm, params);
      final generateJobResponse =
          GenerateJobResponse.fromJson(jsonDecode(response?.body ??''));
      if (generateJobResponse.status == 0) {
        var dataZip = await _saveFileService.getDownLoadFile(IcollectConst
                .dowwnloadJobVF +
            'fileName=${generateJobResponse.data?.fileName}&pathByCurrentDate=${generateJobResponse.data?.pathByCurrentDate}');
        if (dataZip == null) {
          await Future.delayed(Duration(seconds: 5));
          dataZip = await _saveFileService.getDownLoadFile(IcollectConst
                  .dowwnloadJobVF +
              'fileName=${generateJobResponse.data?.fileName}&pathByCurrentDate=${generateJobResponse.data?.pathByCurrentDate}');

          if (dataZip == null) {
            WidgetCommon.dismissLoading();

            WidgetCommon.generateDialogOKGet(
                content:
                    'Quá trình xuất file đang được hệ thống xử lý. Vui lòng kiểm tra trạng thái file ${generateJobResponse.data?.fileName} tại mục (Cấu Hình -> Danh sách tải về)',
                textBtnClose: 'Đã hiểu',
                callback: () {
                  Utils.navigateToReplacement(
                      context, RouteList.DOWNLOAD_LIST_SCREEN);
                });
            return;
          }
        }
        if (Utils.checkIsNotNull(dataZip)) {
          String fileName = generateJobResponse.data?.fileName ?? 'unknow.zip';
          if (dataZip != null && dataZip.bodyBytes != null) {
            final status = await SaveFileService().downloadAndPrintFile(
                Platform.isAndroid ? 'Athena Owl' : 'TBKKs',
                fileName,
                dataZip?.bodyBytes,
                contractId: ticketModel?.contractId);
            if (status == DownloadStatus.successed) {
              WidgetCommon.dismissLoading();

              return WidgetCommon.showSnackbar(
                  _scaffoldKey,
                  'Tải về thành công, Vui lòng Kiểm tra trong thư mục ' +
                      (Platform.isAndroid ? '/Download/Athena/' : 'TBKKs') +
                      '$fileName',
                  backgroundColor: AppColor.appBar,
                  seconds: 20);
            }
            if (status == DownloadStatus.saveFileFailed) {
              WidgetCommon.dismissLoading();

              return WidgetCommon.showSnackbar(
                  _scaffoldKey, 'Đã có lỗi xảy ra trong quá trình lưu file!');
            }

            if (status == DownloadStatus.noPerrmission) {
              WidgetCommon.dismissLoading();

              return WidgetCommon.showSnackbar(_scaffoldKey,
                  'Vui lòng cung cấp quyền lưu trữ để thực hiện tính năng này');
            }
          }
        }
      }

      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(_scaffoldKey,
          'Dữ liệu bị lỗi, vui lòng liên hệ nhóm hỗ trợ hệ thống!');
    } catch (_) {
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(_scaffoldKey, 'Đã có lỗi xảy ra!');
    }
  }

  bool checkContainRole(List<String> serverRoles, List<Authority> userRoles) {
    for (var _ in serverRoles) {
      for (var userRole in userRoles) {
        if (serverRoles.contains(userRole.authority) ?? false) return true;
      }
    }
    return false;
  }

  Future<void> getCallHistoryExt(String phone) async {
    // try {
    //   if (_debounce?.isActive ?? false) _debounce.cancel();
    //   _debounce = Timer(const Duration(seconds: 2), () async {
    //     if (Utils.checkIsNotNull(this.dataCall)) {
    //       return false;
    //     }
    //     if (Platform.isIOS) {
    //       Map<String, dynamic> dataJson = {
    //         'aggId': this.ticketModel.aggId,
    //         'duration': 0,
    //         'formattedNumber': phone,
    //         'number': phone,
    //         'timestamp': DateTime.now().toIso8601String(),
    //         'callType': changeCallType('outgoing'),
    //       };
    //       if (Utils.checkIsNotNull(this.dataCall)) {
    //         final Response res = await this
    //             ._collectionService
    //             .recordUserCallLog(
    //                 context, dataJson, this.ticketModel.aggId, true);
    //         if (Utils.checkRequestIsComplete(res)) {
    //           getTicketHistory();
    //         }
    //       }
    //       return false;
    //     }
    //     DateTime callTo = DateTime.now();
    //     final Iterable<CallLogEntry> result = await CallLog.query(
    //         number: phone,
    //         dateFrom: callFrom.millisecondsSinceEpoch,
    //         dateTo: callTo.millisecondsSinceEpoch);
    //     for (CallLogEntry entry in result) {
    //       this.dataCall = entry;
    //     }
    //     if (Utils.checkIsNotNull(this.dataCall)) {
    //       final Response res = await this._collectionService.recordUserCallLog(
    //           context, this.dataCall, this.ticketModel.aggId, false);
    //       if (Utils.checkRequestIsComplete(res)) {
    getTicketHistory();
    //       }
    //     }
    //   });
    // } catch (e) {
    //   this.dataCall = null;
    // }
  }

  void navigatorToCollectionsDetails(String type, TicketModel ticketModel,
      String title, dynamic target) async {
    await showBarModalBottomSheet(
        expand: false,
        context: context,
        isDismissible: true,
        bounce: false,
        backgroundColor: AppColor.primary,
        builder: (context) => DetailActionFeatureScreen(
            type: type,
            ticketModel: ticketModel,
            title: title,
            target: target));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(seconds: 2), () async {
          getCallHistoryExt(_phoneController.text);
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
        case AppLifecycleState.hidden:
        break;
    }
  }

  void exportFileCheckIn(ActivityModel action ) async {
   WidgetCommon.showLoading(status: 'Đang tải file', dismissOnTap: false);
      var applId =  action.object['newValue']['contractId'];
        try {
          var params = {
        "templateCode": "WORKING_RP",
        "params": {
            "applId": applId,
            "fieldCheckinId": action.object['newValue']['fieldCheckinId']
        }
    };

      final response = await _saveFileService.postTequestDownLoadFile(
          IcollectConst.GENERATE_REPORT_CHECKIN, params);
      final generateJobResponse =
          GenerateJobResponse.fromJson(jsonDecode(response?.body ?? ''));
      if (generateJobResponse.status == 0) {
          await Future.delayed(Duration(seconds: 5));
        final filterModel = {
          "jobExecutionId": {
            "type": "equals",
            "filter": generateJobResponse.data?.jobExecutionId,
            // "filter": "mcrisgdbrp#f7f54e60-1647-4c11-b678-9b2b1db93cb5",
            "filterType": "text"
          }
        };
      var dataZip = await DownloadListServices()
            .getContactDocs(0, rowLength: 1, filterModel: filterModel);
        final checkInItem = dataZip?.data?.checkinItems![0];
        onDownload(checkInItem?.jobContext?.filePath, applId + '_'+checkInItem?.jobName);
        return;
              
      }

      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(_scaffoldKey,
          'Dữ liệu bị lỗi, vui lòng liên hệ nhóm hỗ trợ hệ thống!');
    } catch (_) {
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(_scaffoldKey, 'Đã có lỗi xảy ra!');
    }
  }

  @override
  void dispose() {
    collectionDetailProvider.clearData();
    Utils.cancelSubscription(subscription);
    Utils.cancelSubscription(subscriptionOfflineUpdateCollection);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  void onDownload(path, fileName) async {
    WidgetCommon.showLoading(dismissOnTap: false);

    try {
      final status =
          await DownloadListServices.downloadCheckinItemPath(path, fileName);

      if (status['status'] == DownloadStatus.successed) {
        WidgetCommon.dismissLoading();
        await WidgetCommon.generateDialogOKCancelGet("Bạn muốn mở file?",
            callbackOK: () {
          try {
            OpenFilex.open(status['filePathAndName']);
          } catch (e) {
            WidgetCommon.showSnackbarErrorGet('Mở file thất bại!');
          }
        }, callbackCancel: () {});
        WidgetCommon.showSnackbar(
          _scaffoldKey,
          'Tải về thành công, Vui lòng kiểm tra trong thư mục ' +
              (Platform.isAndroid ? '/Download/Athena/' : 'downloads'),
          backgroundColor: AppColor.appBar,
        );
      }
      if (status['status'] == DownloadStatus.saveFileFailed) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(
            _scaffoldKey, 'Đã có lỗi xảy ra trong quá trình lưu file!');
      }
      if (status == DownloadStatus.callFailed) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(
            _scaffoldKey, 'Đã có lỗi xảy ra, vui lòng liên hệ phòng IT!');
      }
      if (status['status'] == DownloadStatus.noPerrmission) {
        WidgetCommon.dismissLoading();
        WidgetCommon.showSnackbar(_scaffoldKey,
            'Vui lòng cung cấp quyền lưu trữ để thực hiện tính năng này');
      }
    } catch (_) {
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbar(
          _scaffoldKey, 'Đã có lỗi xảy ra, vui lòng liên hệ phòng IT!');
    }
  }
}
