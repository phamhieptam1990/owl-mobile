import 'dart:async';
import 'dart:io';
// import 'package:quiver/mirrors.dart';
import 'package:athena/models/customer-request/Request.model.dart';
import 'package:athena/models/customer-request/RequestDetail.model.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/tickets/activity.model.dart';
import 'package:athena/screens/collections/collections.service.dart';
import 'package:athena/screens/customer-request/attactment/image_picker_handler.dart';
import 'package:athena/screens/customer-request/customer-request.service.dart';
import 'package:athena/screens/customer-request/list/detail-history/detail-history.dart';
import 'package:athena/screens/customer-request/list/edit-request-moreinfo/edit-request-moreinfo.dart';
import 'package:athena/utils/formatter/numbericMoney.formater.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/utils/services/employee/employee.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:after_layout/after_layout.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:date_field/date_field.dart';
import 'package:athena/getit.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:athena/widgets/common/photo/galleryPhotoViewWrapper.widget.dart';
import 'package:http/http.dart' show get;

class CustomerRequestEditScreen extends StatefulWidget {
  final RequestModel requestModel;
  CustomerRequestEditScreen({required this.requestModel, Key? key})
      : super(key: key);
  @override
  _CustomerRequestScreenState createState() => _CustomerRequestScreenState();
}

class _CustomerRequestScreenState extends State<CustomerRequestEditScreen>
    with TickerProviderStateMixin, ImagePickerListener, AfterLayoutMixin {
  File? _image;
  // String aggId=widget.aggId;
  RequestDetailModel? requestDetail;
  DMSService _dmsService = new DMSService();
  Map<String, dynamic> _paths = {};
  Map<String, dynamic> _pathsHistory = {};
  List<ActivityModel> lstAcivityModel = [];
  List<String> _attachments = [];
  final _collectionService = new CollectionService();
  bool isLoading = false;
  String getAssigneeName = '';
  String getStatusCodeName = '';
  ImagePickerHandler? imagePicker;
  AnimationController? _controller;
  final formKey = new GlobalKey<FormState>();
  final _formLoginKey = new GlobalKey<FormState>();
  bool _loadingPath = true;
  List<FileLocal> galleryItemHistoryLocal = [];
  dynamic attachmentFile = [];
  dynamic dataCategory = [];
  dynamic dataSubCategory = [];
  dynamic itemForm = [];
  dynamic dataFinal, dataFinalFormat;
  dynamic dataList = [];
  dynamic listItemForm;
  dynamic listItemAtt;
  dynamic _count = 0;
  String username = '';
  String fullName = '';
  String empCode = '';
  bool checkAtt = false;
  bool editAction = false;
  String fieldNameAtt = 'File đính kèm';
  List<FileLocal> galleryItemHistoryLocalHistory = [];
  dynamic attachmentFileHistory = [];
  final _userInfoStore = getIt<UserInfoStore>();
  final _employeeService = new EmployeeService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _customerRequestservice = new CustomerRequestService();
  removeFile(String keyValue) {
    setState(() {
      _paths.removeWhere((key, value) => key == keyValue);
      setImageFile();
    });
  }

  userImage(File _image) {
    setState(() {
      // Image.file(_image);
      this._image = _image;

      // _paths
    });
  }

  // @override
  userFile(Map<String, dynamic> paths) {
    setState(() {
      // Image.file(_image);
      if (_paths.isEmpty || _paths.length == 0) {
        _paths = paths;
      } else
        paths.forEach((k, v) => _paths[k] = v);
      // _count++;
      // _paths = paths;
      setImageFile();
    });
  }

  funcattachments(String attachments) {
    setState(() {
      if (this._attachments.isEmpty || this._attachments.length == 0) {
        this._attachments = [attachments];
      } else
        this._attachments.add(attachments);
      // this._attachments.add(attachments);
      // _paths = paths;
    });
  }

  errorttachments(bool error) {
    if (error) {
      WidgetCommon.showSnackbar(_scaffoldKey, "Tải file đính kèm thất bại!");
      return;
    }
  }

  loadingPath(bool loading) {
    setState(() {
      // Image.file(_image);
      this._loadingPath = loading;
    });
  }

  checkAction(statusId, statusCode, assignee) {
    empCode = _userInfoStore.user?.moreInfo?['empCode'] ?? '';
    username = _userInfoStore.user?.username ?? '';
    fullName = _userInfoStore.user?.fullName ?? '';
    if (statusId == 4 &&
        statusCode == 'NEED_MORE_INFO' &&
        assignee == username) {
      return true;
    }
    return false;
  }

  setAtt(attachment) async {
    var lengthAtt = attachment.length;
    var array = [];
    for (var index = 0; index < lengthAtt; index++) {
      array.add('"' + attachment[index].toString() + '"');
    }
    try {
      final Response responseAtt = await _dmsService.getResourcesList(array);
      if (Utils.checkRequestIsComplete(responseAtt)) {
        // var data= responseAtt.data['data'];
        var data = Utils.handleRequestData(responseAtt);
        if (Utils.isArray(data)) {
          Map<String, dynamic> arrayAtt = {};
          for (var i = 0; i < data.length; i++) {
            var string = data[i]['refCode'];
            var dynamicValue = data[i];
            Map<String, dynamic> paths = {};
            paths = {string: dynamicValue};
            if (arrayAtt.isEmpty || arrayAtt.length == 0) {
              arrayAtt = paths;
            } else
              paths.forEach((k, v) => arrayAtt[k] = v);
          }
          setState(() {
            _paths = arrayAtt;
          });
          setImageFile();
        }
      }
    } catch (e) {}
  }

  tblaction(code) {
    var tblaction = {
      'FC_SUPPORT_ASSIGN_TO_ADMIN': 'Chuyển cho admin',
      'FC_SUPPORT_FINISH_TICKET': 'Hoàn thành',
      'FC_SUPPORT_NEED_MORE_INFO': 'Cần thêm thông tin',
      'FC_SUPPORT_REJECT_TICKET': 'Từ chối',
      'FC_SUPPORT_RESUBMIT_TICKET': 'Gửi lại',
      'FC_SUPPORT_RESUBMIT_TICKET.FAIL': 'Thao tác thất bại!',
      'FC_SUPPORT_RESUBMIT_TICKET.SUCCESS': 'Thao tác thành công',
      'FC_SUPPORT_START_PROGRESS': 'Xử lý',
      'Create': 'Tạo mới yêu cầu'
    };
    if (Utils.checkIsNotNull(tblaction[code])) return tblaction[code];
    return code;
  }

  List<Widget> buildFullHistory(item) {
    List<Widget> lst = [];
    lst.add(
      Column(children: [
        Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  S.of(context).history,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ))),
      ]),
    );
    for (ActivityModel action in lstAcivityModel) {
      var actionH = '';
      if (action.target != null && action.target['originalValue'] != null) {
        if (action.target['originalValue']['actionCode'] != null) {
          actionH = action.target['originalValue']['actionCode'];
        } else {
          actionH = action.action ?? '';
        }
      } else {
        actionH = action.action ?? '';
      }
      var entry;
      var noteDetail = '';
      if (Utils.checkIsNotNull(action.target) &&
          action.target['originalValue'] != null) {
        if (action.target['originalValue']['inputData'] != null) {
          entry = action.target['originalValue']['inputData'];
          if (actionH == AppStateConfigConstant.EDIT_LOG) {
            if (entry['fcsp_more_info_note'] != '') {
              noteDetail = entry['fcsp_more_info_note'];
            }
          } else {
            if (entry['note'] != '') {
              noteDetail = entry['note'];
            }
          }
        }
      } else {
        entry = [];
      }

      var actionTitle = tblaction(actionH);
      lst.add(InkWell(
          onTap: () {
            if (entry.length > 0 && actionH != 'Create') {
              Navigator.push(
                context,
                // Create the SelectionScreen in the next step.
                MaterialPageRoute(
                  builder: (context) => DetailHistoryScreen(
                      type: actionH, title: actionTitle, entry: entry),
                ),
              );
            }
            return;
          },
          child: Card(
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
                  child: ListTile(
                      title: Text(
                        actionTitle,
                        style: TextStyle(
                            color: AppColor.black, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new SizedBox(height: 4.0),
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range_rounded,
                                  size: 15.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 6.0),
                                  child: Text(
                                      Utils.getTimeFromDate(
                                          Utils.convertTimeStampToDateEnhance(
                                                  action.published ?? '') ??
                                              0) ?? '',
                                      style: TextStyle(color: AppColor.black)),
                                )
                              ],
                            ),
                            // new SizedBox(height: 4.0),
                            // Row(
                            //   children: [
                            //     Icon(
                            //       Icons.note_add_rounded,
                            //       size: 15.0,
                            //     ),
                            //     Padding(
                            //       padding: EdgeInsets.only(left: 6.0),
                            //       child: Text(noteDetail ?? '',
                            //           style: TextStyle(color: AppColor.black)),
                            //     )
                            //   ],
                            // ),
                          ]),
                      trailing: (action.action ==
                              AppStateConfigConstant.CREATE_VYMO_CALENDAR)
                          ? Icon(null)
                          : Icon(Icons.arrow_forward_ios))))));
      // if (entry['note'] != '') {
      //   lst.add(Column(children: [
      //     Container(
      //       padding: EdgeInsets.only(left: 16, right: 16),
      //       child: TextFormField(
      //         readOnly: true,
      //         // key: GlobalKey<FormFieldState>(),
      //         controller: TextEditingController(text: entry['note']),

      //         textInputAction: TextInputAction.next,
      //         keyboardType: TextInputType.text,
      //         validator: (val) => Utils.isRequire(context, val),
      //         decoration: InputDecoration(
      //             contentPadding: EdgeInsets.all(10.0),
      //             labelText: S.of(context).note + " *",
      //             floatingLabelBehavior: FloatingLabelBehavior.always),
      //       ),
      //     ),
      //   ]));
      // }
      // if (entry['attachments'].length > 0) {
      //   // setAttHistory(entry['attachments']);
      //   // lst.add(buildAttHistory(context));
      // }
      // break;
    }
    return lst;
  }

  Future<void> getTicketHistory(ticketModel) async {
    lstAcivityModel = [];
    try {
      final Response response = await this
          ._collectionService
          .getAcititySteamTicket(
              ticketModel.aggId,
              0,
              Utils.convertToIso8601String(ticketModel?.createDate ?? '') ??
                  '');

      if (Utils.checkRequestIsComplete(response)) {
        var lstData = Utils.handleRequestData2Level(response);
        if (Utils.checkIsNotNull(lstData)) {
          if (Utils.isArray(lstData)) {
            for (var data in lstData) {
              lstAcivityModel.add(new ActivityModel.fromJson(data));
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  getDetail(BuildContext context) async {
    // var a = '1';

    setState(() {
      this.isLoading = true;
    });
    try {
      Response res = await _customerRequestservice
          .getDetail(widget.requestModel.aggId ?? '');
      if (Utils.checkRequestIsComplete(res)) {
        var data = Utils.handleRequestData(res);
        if (data != null) {
          requestDetail = RequestDetailModel.fromJson(data);
          dataFinal['categoryId'] = requestDetail?.categoryId ?? '';
          dataFinal['issueName'] = requestDetail?.issueName ?? '';
          dataFinal['description'] =
              requestDetail?.properties['description'] ?? '';
          editAction = checkAction(requestDetail?.statusId,
              requestDetail?.statusCode, requestDetail?.assignee);
          await getAssignee(requestDetail?.assignee);
          getStatusCodeName = getStatusNameByCode(requestDetail?.statusCode);
          await getTicketHistory(requestDetail);
          for (var item in dataCategory) {
            if (item["id"] == requestDetail?.categoryId) {
              // dataSubCategory = [];
              dataSubCategory = item["children"];
              dataFinal['subCategoryId'] = requestDetail?.subCategoryId;
            }
          }
          _buildItemForm();
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        this.isLoading = false;
      });
    }
  }

  Future<void> afterFirstLayout(BuildContext context) async {
    // getSchemaPivot(context);
    empCode = _userInfoStore.user?.moreInfo?['empCode'] ?? '';
    username = _userInfoStore.user?.username ?? '';
    fullName = _userInfoStore.user?.fullName ?? '';
    await getSupportTicketCategories(context);
    await getCategoriesConfigByIssueType(context);
    await getDetail(context);
  }

  pushData(data) {
    if (dataSubCategory == null ||
        dataSubCategory.isEmpty ||
        dataSubCategory.length == 0) {
      dataSubCategory = [data];
    } else
      dataSubCategory.add(data);
    // this._attachments.add(attachments);
    // _paths = paths;
  }

  _buildItemForm() {
    // return;
    Map<String, Object> fieldsMapOne = Map();
    fieldsMapOne['categoryId'] = dataFinal['categoryId'];
    fieldsMapOne['subCategoryId'] = dataFinal['subCategoryId'];
    fieldsMapOne['issueName'] = dataFinal['issueName'];
    fieldsMapOne['description'] = dataFinal['description'];
    Map<String, Object> dataEmpty = new Map();
    setState(() {
      dataFinal = fieldsMapOne;
      itemForm = [];
      listItemForm = Container();
      listItemAtt = Container();
      dataFinalFormat = dataEmpty;
      checkAtt = false;
      _paths = {};
    });
    for (var item in dataList) {
      if (item["categoryId"] == dataFinal['categoryId']) {
        // setState(() {
        //   galleryItemHistoryLocal = [];
        //   attachmentFile = [];
        // });
        setState(() {
          galleryItemHistoryLocal = [];
          attachmentFile = [];
          // itemForm = [];
          itemForm = item["fieldConfigs"];
          listItemForm = _buildSection1ListItems();
        });
      }
    }
  }

  getCategoriesConfigByIssueType(context) async {
    try {
      final Response response =
          await _customerRequestservice.getCategoriesConfigByIssueType(context);
      if (response.data != null) {
        setState(() {
          if (response.data['data'] != null) {
            dataList = response.data['data'];
          }
        });
      }
    } catch (e) {
      WidgetCommon.showSnackbar(this._scaffoldKey, S.of(context).failed);
    }
  }

  getSupportTicketCategories(context) async {
    try {
      final Response response =
          await _customerRequestservice.getSupportTicketCategories(context,
              supportType: widget.requestModel.productCode ?? 'Athena Owl');
      if (response.data != null) {
        setState(() {
          dataCategory = response.data['data'];
          _loadingPath = false;
        });
        // log(response.data["data"]);
      }
    } catch (e) {
      setState(() {
        _loadingPath = false;
      });
      WidgetCommon.showSnackbar(this._scaffoldKey, S.of(context).failed);
    }
  }

  getSchemaPivot(context) async {
    try {
      final Response response =
          await _customerRequestservice.getSchemaPivot(context);
      if (response.data != null) {
        // log(response.data["data"]);
      }
    } catch (e) {
      WidgetCommon.showSnackbar(this._scaffoldKey, S.of(context).failed);
    }
  }

  String formattedNumber(dynamic number) {
    final formatter = new NumberFormat("#,###");
    return formatter.format(number ?? 0);
  }

  String formattedPrice(dynamic number, {String currency = 'đ'}) {
    return "${formattedNumber(number ?? 0)}$currency";
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );


    imagePicker = ImagePickerHandler(this, _controller!);
    imagePicker?.init();
    Map<String, Object> fieldsMapOne = {};
    fieldsMapOne['categoryId'] = "";
    fieldsMapOne['subCategoryId'] = "";
    fieldsMapOne['issueName'] = "";
    fieldsMapOne['description'] = "";
    dataFinal = fieldsMapOne;
    Map<String, Object> dataEmpty = new Map();

    dataFinalFormat = dataEmpty;
    listItemForm = Container();
    listItemAtt = Container();
  }

  checkCol(col) {
    if (col == 'fcsp_fccode' || col == 'fcsp_fcname') {
      return true;
    }
    return false;
  }

  tblStatus() {
    return {
      'OPEN': S.of(context).STATUS_CODE_OPEN,
      'IN_PROGRESS': S.of(context).STATUS_CODE_IN_PROGRESS,
      'ASSIGNED': S.of(context).STATUS_CODE_ASSIGNED,
      'OPNEED_MORE_INFOEN': S.of(context).STATUS_CODE_NEED_MORE_INFO,
      'REJECTED': S.of(context).STATUS_CODE_REJECTED,
      'DONE': S.of(context).STATUS_CODE_DONE,
      'NEED_MORE_INFO': S.of(context).STATUS_CODE_NEED_MORE_INFO
    };
  }

  getStatusNameByCode(code) {
    var tblStatusCode = tblStatus();
    var name = tblStatusCode[code];
    if (Utils.checkIsNotNull(name)) {
      return tblStatusCode[code];
    }
    return code;
  }

  getAssignee(empCodes) async {
    if (empCodes == null || empCodes == '') {
      getAssigneeName = empCodes;
      return;
    }
    if (empCodes.length > 0) {
      final Response empRes = await _employeeService.getEmployees(empCodes);
      if (Utils.checkRequestIsComplete(empRes)) {
        var fullName = '';
        if (Utils.isArray(empRes.data['data'])) {
          if (empRes.data['data'].length > 0) {
            if (Utils.checkIsNotNull(empRes.data['data'][0]['fullName'])) {
              fullName = empRes.data['data'][0]['fullName'];
            }
          }
        }
        if (Utils.checkIsNotNull(fullName)) {
          getAssigneeName = empCodes + ' - ' + fullName;
        } else
          getAssigneeName = empCodes;
        return;
      } else {
        getAssigneeName = empCodes;
      }
    }
  }

  valuechange(col) {
    // return;
    empCode = _userInfoStore.user?.moreInfo?['empCode'] ?? '';
    username = _userInfoStore.user?.username ?? '';
    fullName = _userInfoStore.user?.fullName ?? '';
    if (col == 'fcsp_fccode') {
      // setState(() {
      dataFinal['fcsp_fccode'] = empCode;
      // });
      return empCode;
    } else if (col == 'fcsp_fcname') {
      // setState(() {
      dataFinal['fcsp_fcname'] = fullName;
      // });
      return fullName;
    }
    return '';
  }

  checkrequired(_required) {
    if (_required) return " *";
    return "";
  }

  Widget _buildSection1ListItems() {
    return itemForm.length > 0
        ? new ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // Let the ListView know how many items it needs to build.
            itemCount: itemForm.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              try {
                final item = itemForm[index];
                final fileCode = item["fieldCode"];
                // final editable = item["editable"];
                // final readOnly = !editAction;
                final editable = false;
                final readOnly = true;
                final fieldName = item["fieldName"];
                final _required = item["required"] || true;

                dataFinal.remove(fileCode);
                dataFinal[fileCode] = requestDetail?.properties[fileCode];
                // final initialValue = valuechange(fileCode);
                // final key = DateTime.now().millisecondsSinceEpoch.toString();
                // dataFinal[fileCode] = '';
                if (item != null && item["valueTypeCode"] == "numeric") {
                  if (dataFinal[fileCode] is double) {
                    dataFinal[fileCode] =
                        dataFinal[fileCode].round().toString();
                  }
                  dataFinalFormat[fileCode] = "numeric";
                  return new Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: new TextField(
                      controller:
                          TextEditingController(text: dataFinal[fileCode]),
                      // key: GlobalKey<FormFieldState>(),
                      readOnly: readOnly,
                      enabled: editable,
                      inputFormatters: [NumericMoneyTextFormatter()],
                      // onSaved: (value) {
                      //   // setState(() {
                      //   dataFinal[fileCode] = value;
                      //   dataFinalFormat[fileCode] = "numeric";
                      //   // });
                      // },
                      onChanged: (value) {
                        // setState(() {
                        dataFinal[fileCode] = value;
                        dataFinalFormat[fileCode] = "numeric";
                        // });
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      // validator: (val) => Utils.isRequire(context, val),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: fieldName + checkrequired(_required),
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                  );
                } else if (item != null && item["valueTypeCode"] == "string") {
                  return new Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: new TextField(
                      // key: GlobalKey<FormFieldState>(),
                      controller:
                          TextEditingController(text: dataFinal[fileCode]),
                      enabled: editable,
                      readOnly: readOnly,
                      // onSaved: (value) {
                      //   // setState(() {
                      //   dataFinal[fileCode] = value;
                      //   // });
                      // },
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        // setState(() {
                        dataFinal[fileCode] = value;
                        // });
                      },
                      // initialValue: initialValue,
                      keyboardType: TextInputType.text,
                      // validator: (val) =>
                      //     Utils.isRequire(context, val),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: fieldName + checkrequired(_required),
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                  );
                } else if (item != null && item["valueTypeCode"] == "date") {
                  // setState(() {
                  dataFinal[fileCode] =
                      Utils.converLongToDate(dataFinal[fileCode]);
                  dataFinalFormat[fileCode] = "date";
                  // var format = 'dd/MM/yyyy  HH:mm:ss';
                  // });
                  var format = new DateFormat('dd/MM/yyyy');
                  return new Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: new DateTimeField(
                        mode: DateTimeFieldPickerMode.date,
                        value: dataFinal[fileCode],
                        onChanged: (DateTime? date) {},

                        // errorText: Utils.isRequire(
                        //     context, dataFinal[item["fieldCode"]]),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: fieldName + checkrequired(_required),
                            hintText: 'Select date *',
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                        // label: "Select date *",

                        // firstDate: DateTime(1900),
                        // lastDate: DateTime(2020),
                        dateFormat: format),
                  );
                } else if (item != null &&
                    item["valueTypeCode"] == "json_array") {
                  if (dataFinal[fileCode].length > 0) {
                    setAtt(dataFinal[fileCode]);
                  }
                  return Container();
                }
              } catch (e) {
                print(e);
              }
              return null;
            })
        : new Container();
  }

  showDialog() {
    FocusScope.of(context).unfocus();
    imagePicker?.showDialog(context);
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                color: Colors.grey[100],
              ),
              // padding: EdgeInsets.only(top: 16),
              child: ListTile(
                  title: Text(
                "Thông tin yêu cầu",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              )),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                // readOnly: !editAction,
                readOnly: true,
                // key: GlobalKey<FormFieldState>(),
                controller: TextEditingController(text: dataFinal['issueName']),
                onSaved: (value) {
                  // setState(() {
                  // dataFinal['issueName'] = value;
                  // });
                },
                onChanged: (value) {
                  // setState(() {
                  // dataFinal['issueName'] = value;
                  // });
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).name + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                // controller: TextEditingController(),
                // key: GlobalKey<FormFieldState>(),
                readOnly: true,
                // readOnly: !editAction,
                controller:
                    TextEditingController(text: dataFinal['description']),
                onSaved: (value) {
                  // setState(() {
                  // dataFinal['description'] = value;
                  // });
                },
                onChanged: (value) {
                  // setState(() {
                  // dataFinal['description'] = value;
                  // });
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).Description + " *",
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(left: 16, right: 16),
            //   child: DropDownFormField(
            //     titleText: S.of(context).labelCategory + ' *',
            //     hintText: S.of(context).hintTextDropdown,
            //     value: dataFinal['categoryId'],
            //     errorText:
            //         Utils.isRequireSelect(context, dataFinal['categoryId']),
            //     onSaved: null,
            //     onChanged: null,
            //     dataSource: dataCategory,
            //     textField: 'name',
            //     filled: false,
            //     valueField: 'id',
            //     required: true,
            //   ),
            // ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                S.of(context).STATUS_CODE,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                readOnly: true,
                // key: GlobalKey<FormFieldState>(),
                controller: TextEditingController(text: getStatusCodeName),
                onSaved: (value) {
                  // setState(() {
                  // dataFinal['issueName'] = value;
                  // });
                },
                onChanged: (value) {
                  // setState(() {
                  // dataFinal['issueName'] = value;
                  // });
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).status,
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                // controller: TextEditingController(),
                // key: GlobalKey<FormFieldState>(),
                readOnly: true,
                controller: TextEditingController(text: getAssigneeName),
                onSaved: (value) {
                  // setState(() {
                  // dataFinal['assignee'] = value;
                  // });
                },
                onChanged: (value) {
                  // setState(() {
                  // dataFinal['description'] = value;
                  // });
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (val) => Utils.isRequire(context, val ?? ''),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).assignee,
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                S.of(context).additionalInformation,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ),

            listItemForm,
            _paths.length > 0
                ? Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Danh sách file đính kèm' +
                          ' (' +
                          (galleryItemHistoryLocal.length +
                                  attachmentFile.length)
                              .toString() +
                          ')',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  )
                : Container(),
            _paths.length > 0 ? buildAtt(context) : Container(),
            // editAction
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildFullHistory(context)),
            //     : Container(),
            // editAction && _pathsHistory.length > 0
            //     ? Container(
            //         padding: EdgeInsets.all(16),
            //         child: Text(
            //           'Danh sách file đính kèm' +
            //               ' (' +
            //               _pathsHistory.length.toString() +
            //               ')',
            //           style: TextStyle(
            //               fontSize: 16.0, fontWeight: FontWeight.w500),
            //         ),
            //       )
            //     : Container(),
            // editAction && _pathsHistory.length > 0
            //     ? buildAttHistory(context)
            //     : Container(),
            SizedBox(height: 200.0)
            // _buildSection1ListItems()
          ],
        ));
  }

  reset(context) {
    final form = _formLoginKey.currentState;
    if (form != null) form.reset();
  }

  bool isNumeric(s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  resetForm() {
    Map<String, Object> fieldsMapOne = Map();
    fieldsMapOne['categoryId'] = dataFinal['categoryId'];
    fieldsMapOne['subCategoryId'] = dataFinal['subCategoryId'];
    fieldsMapOne['issueName'] = dataFinal['issueName'];
    fieldsMapOne['description'] = dataFinal['description'];
    Map<String, Object> dataEmpty = new Map();
    setState(() {
      dataFinal = fieldsMapOne;
      itemForm = [];
      listItemForm = Container();
      listItemAtt = Container();
      dataFinalFormat = dataEmpty;
    });
  }

  check(data) {
    if (data == null || data == '') return true;
    return false;
  }

  handleSendRequest(BuildContext context) async {
    var listFinalAttachment = [];
    if (_paths.length > 10) {
      WidgetCommon.showSnackbar(
          _scaffoldKey, "Số lượng file không được lớn hơn 10");
      return;
    }
    if (_paths.length > 0) {
      for (var i = 0; i < _paths.length; i++) {
        var value = _paths.keys.toList()[i].toString();
        if (listFinalAttachment.isEmpty || listFinalAttachment.length == 0) {
          listFinalAttachment = [value];
        } else
          listFinalAttachment.add(value);
      }
      dataFinal['fcsp_attachment_doc'] = listFinalAttachment;
    }
    try {
      if (check(dataFinal["categoryId"])) {
        WidgetCommon.showSnackbar(
            _scaffoldKey, S.of(context).labelCategory + ' không được trống!');
        return;
      }
      if (check(dataFinal["issueName"])) {
        WidgetCommon.showSnackbar(
            _scaffoldKey, S.of(context).name + ' không được trống!');
        return;
      }
      if (check(dataFinal["description"])) {
        WidgetCommon.showSnackbar(
            _scaffoldKey, S.of(context).Description + ' không được trống!');
        return;
      }
      for (var item in itemForm) {
        final fileCode = item["fieldCode"];
        final fieldName = item["fieldName"];
        final _required = item["required"];
        if (check(dataFinal[fileCode]) && _required) {
          WidgetCommon.showSnackbar(
              _scaffoldKey, fieldName + ' không được trống!');
          return;
        }
      }
      // stateButtonOnlyText = ButtonState.loading;
      // setState(() {
      //   _loadingPath = true;
      // });
      final Response res = await this._customerRequestservice.actionTicket(
          context, dataFinal, requestDetail?.aggId, dataFinalFormat);
      // stateButtonOnlyText = ButtonState.idle;
      // setState(() {});
      if (Utils.checkRequestIsComplete(res)) {
        // setState(() {
        //   _loadingPath = false;
        // });
        // reset(context);
        // resetForm();
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
            backgroundColor: AppColor.blue);
        startTime();

        return;
      }
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
    } catch (e) {
      // stateButtonOnlyText = ButtonState.idle;
      // setState(() {
      //   _loadingPath = false;
      // });
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var bodyProgress = new Container(
      child: new Stack(
        children: <Widget>[
          buildBody(context),
          new Container(
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
          ),
        ],
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
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
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(S.of(context).customerRequestPageDetail),
          // actions: <Widget>[
          //   editAction
          //       ? IconButton(
          //           icon: const Icon(Icons.save),
          //           tooltip: S.of(context).btCreate,
          //           onPressed: () {
          //             // reset(context);
          //             handleSendRequest(context);
          //           },
          //         )
          //       : Container(),
          // ]
        ),
        body: this.isLoading ? bodyProgress : buildBody(context),
        floatingActionButton: new Visibility(
          visible: editAction,
          child: FloatingActionButton(
              backgroundColor: AppColor.appBar,
              onPressed: () async {
                // goDetailtemp(context);
                _navigateAndDisplaySelection(context);
              },
              child: Icon(
                Icons.edit,
                color: AppColor.white,
              )),
        ));
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
        builder: (context) => EditRequestMoreInfoScreen(
          action: AppStateConfigConstant.EDIT_LOG,
          aggId: widget.requestModel.aggId ?? '',
        ),
      ),
    );

    if (result == true) {
      startTime();
    }
  }

  setImageFile() {
    final postAttachment = _paths;

    for (var i = 0; i < postAttachment.length; i++) {
      if (postAttachment.values.toList()[i]['mimeType'].indexOf('image/') >=
          0) {
        var namfirst = DateTime.now().millisecondsSinceEpoch;
        saveFileImage(
            context,
            postAttachment.values.toList()[i]['makerDate'],
            namfirst.toString() + i.toString(),
            postAttachment.values.toList()[i]['refCode']);
      } else {
        if (attachmentFile == null ||
            attachmentFile.isEmpty ||
            attachmentFile.length == 0) {
          attachmentFile = [postAttachment.values.toList()[i]];
        } else
          attachmentFile.add(postAttachment.values.toList()[i]);
      }
    }
  }

  Widget buildAtt(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[buildListImage(), buildListFile()]));
  }

  Widget buildListFile() {
    return new ListView.builder(
      // scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: attachmentFile.length,
      itemBuilder: (context, int index) {
        final item = attachmentFile[index];
        final exp = item['fileName'].toString().split('.').last;
        final mimeType = 'MimeType: ' + item['mimeType'].toString();

        return buildFile(index, exp, mimeType);
      },
    );
  }

  Widget buildListImage() {
    List<Widget> lstWidget = [];
    // galleryItemHistoryLocal[0].file.absolute.
    for (int index = 0; index < galleryItemHistoryLocal.length; index++) {
      //  galleryItemHistoryLocal[index].file.readAsBytes();
      lstWidget.add(Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Container(
              child: Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Container(
                height: 100.0,
                width: 100.0,
                child: TextButton(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Stack(children: <Widget>[
                        Image.file(
                            File(galleryItemHistoryLocal[index].file.path),
                            width: 80.0,
                            height: 80.0),
                        // Positioned(
                        //     right: -5,
                        //     top: -9,
                        //     child: IconButton(
                        //       icon: Icon(
                        //         Icons.cancel,
                        //         color: Colors.red,
                        //         size: 25,
                        //       ),
                        //       onPressed: () {
                        //         // removeList(context,
                        //         //     galleryItemHistoryLocal[index].key);
                        //       },
                        //     )),
                      ])),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          dataPost: [],
                          galleryItems: galleryItemHistoryLocal,
                          initialIndex: index,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    );
                  },
                )),
          ))));
    }
    return Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: lstWidget);
  }

  Widget buildFile(index, exp, mimeType) {
    return Card(
        child: Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey),
      // ),
      // padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () => {
              saveImage(context, attachmentFile[index]['fileName'],
                  attachmentFile[index]['refCode'])
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                exp.toUpperCase(),
                style: TextStyle(fontSize: 12, color: AppColor.white),
              ),
            ),
            title: Text(
              attachmentFile[index]['fileName'],
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
            // subtitle: Text(
            //     item['size'].toString() + ' Byte'),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text('Size: ' +
                      attachmentFile[index]['size'].toString() +
                      ' Byte'),
                  // new Text(mimeType),
                ]),
            // trailing: new InkWell(
            //     onTap: () => removeList(context, _paths.keys.toList()[index]),
            //     child: new Stack(children: <Widget>[Icon(Icons.delete)]))
          )
          // Text(widget.images.values.toList()[index]['fileName']),
          // Text(widget.images.values.toList()[index]['mimeType'].toString()),
          // Text(widget.images.values.toList()[index]['size'].toString()),
        ],
      ),
    ));
  }

  Future<String> get localPath async {
    //  String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    final dir = await getApplicationDocumentsDirectory();
    // var documentDirectory = await getApplicationDocumentsDirectory();
    // String firstPath = documentDirectory.path + "/images";
    return dir.path;
  }

  Future<File> localFile(String filename) async {
    final path = await localPath;
    // var now = 'Test' + '.' + filename.split('.').last;
    // filename = 'test.txt';
    // var now = new DateTime.now().toString() +'.'+ filename.split('.').last;
    return File('$path/$filename');
  }

  void removeList(context, keyValue) {
    WidgetCommon.generateDialogOKCancelGet(S.of(context).deleteFile,
        title: S.of(context).Alert, callbackOK: () {
      removeFile(keyValue);
    },
        callbackCancel: () {},
        textBtnOK: S.of(context).btOk,
        textBtnClose: S.of(context).btExit);
  }

  requestClose(request) {
    return request.close();
  }

  // void saveImage(context, String filename, keyValue) async {
  //   setState(() {
  //     _loadingPath = true;
  //   });
  //   HttpClient client = new HttpClient();
  //   final storageToken =
  //       await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
  //   var _downloadData = List<int>();
  //   var sObject = 'identifer=' + keyValue;
  //   // var url = APP_CONFIG.DOWNLOAD_FILE + sObject;
  //   var url = DMS_SERVICE_URL.DOWNLOAD_FILE'] + sObject;
  //   var namfirst = DateTime.now().millisecondsSinceEpoch;
  //   final fileSave = await localFile(filename);
  //   try {
  //     var request = await client.getUrl(Uri.parse(url));
  //     request.headers
  //         .set("Authorization", APP_CONFIG.KEY_JWT + '$storageToken');
  //     await requestClose(request).then((HttpClientResponse response) {
  //       response.listen((d) => _downloadData.addAll(d), onDone: () {
  //         openFileLocal(fileSave, _downloadData);
  //       });
  //     });
  //   } catch (exception) {
  //     setState(() {
  //       _loadingPath = false;
  //     });
  //     // setState(() => _loadingPath = false);
  //     WidgetCommon.showSnackbar(
  //         this._scaffoldKey, S.of(context).DownloadFileFailed);
  //   }
  // }

  // openFileLocal(fileSave, _downloadData) async {
  //   setState(() {
  //     _loadingPath = false;
  //   });
  //   await fileSave.writeAsBytes(_downloadData);
  //   var pathFile = fileSave.path;

  //   OpenFile.open(pathFile.toString());
  // }

  void saveImage(context, String filename, keyValue) async {
    final storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    var sObject = 'identifer=' + keyValue;
    var url = DMS_SERVICE_URL.DOWNLOAD_FILE + sObject;
    final fileSave = await localFile(filename);
    try {
      var response = await get(Uri.parse(url),
          headers: {'Authorization': APP_CONFIG.KEY_JWT + '$storageToken'});
      if (response.statusCode == 200) {
        openFileLocal(filename, fileSave, response);
      }
    } catch (exception) {
      print(exception);
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).DownloadFileFailed);
    }
  }

  Future<void> openFileLocal(
      String fileName, dynamic fileSave, dynamic _downloadData) async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = documentDirectory.path + "/images";
      String filePathAndName = documentDirectory.path + '/images/' + fileName;
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(_downloadData.bodyBytes); // <-- 3
      setState(() {
        _loadingPath = false;
      });
      OpenFilex.open(filePathAndName.toString());
      // galleryItemHistoryLocal
      //     .add(FileLocal(key.toString(), fileName, File(filePathAndName)));
      // setState(() {});
    } catch (e) {}
  }

  void saveFileImage(context, key, String filename, keyValue) async {
    final storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    var sObject = 'identifer=' + keyValue;
    var url = DMS_SERVICE_URL.DOWNLOAD_FILE + sObject;
    final fileSave = await localFile(filename);
    try {
      var response = await get(Uri.parse(url),
          headers: {'Authorization': APP_CONFIG.KEY_JWT + '$storageToken'});
      if (response.statusCode == 200) {
        handleDownLoadFile(filename, fileSave, response, key, keyValue);
      }
    } catch (exception) {
      print(exception);
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).DownloadFileFailed);
    }
  }

  Future<void> handleDownLoadFile(String fileName, dynamic fileSave,
      dynamic _downloadData, int key, keyValue) async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = documentDirectory.path + "/images";
      String filePathAndName = documentDirectory.path + '/images/' + fileName;
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(_downloadData.bodyBytes); // <-- 3
      setState(() {
        if (galleryItemHistoryLocal.isEmpty ||
            galleryItemHistoryLocal.length == 0) {
          // galleryItemHistory = [File(fileSave.path)];
          galleryItemHistoryLocal = [
            FileLocal(keyValue.toString(), fileName, File(filePathAndName))
          ];
        } else
          galleryItemHistoryLocal.add(
              FileLocal(keyValue.toString(), fileName, File(filePathAndName)));
      });
      // galleryItemHistoryLocal
      //     .add(FileLocal(key.toString(), fileName, File(filePathAndName)));
      // setState(() {});
    } catch (e) {}
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context, true);
  }

  // void saveFileImage(context, key, String filename, keyValue) async {
  //   HttpClient client = new HttpClient();
  //   final storageToken =
  //       await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
  //   var _downloadData = List<int>();
  //   var sObject = 'identifer=' + keyValue;
  //   var url = DMS_SERVICE_URL.DOWNLOAD_FILE'] + sObject;
  //   final fileSave = await localFile(filename);
  //   try {
  //     var request = await client.getUrl(Uri.parse(url));
  //     request.headers
  //         .set("Authorization", APP_CONFIG.KEY_JWT + '$storageToken');
  //     await requestClose(request).then((HttpClientResponse response) {
  //       response.listen((d) => _downloadData.addAll(d), onDone: () {
  //         // fileSave.writeAsBytes(_downloadData);
  //         setFileLocal(
  //             context, key, filename, keyValue, fileSave, _downloadData);
  //       });
  //     });
  //   } catch (exception) {
  //     WidgetCommon.showSnackbar(
  //         this._scaffoldKey, S.of(context).DownloadFileFailed);
  //   }
  // }

  // setFileLocal(
  //     context, key, String filename, keyValue, fileSave, _downloadData) async {
  //   await fileSave.writeAsBytes(_downloadData);
  //   setState(() {
  //     if (galleryItemHistoryLocal == null ||
  //         galleryItemHistoryLocal.isEmpty ||
  //         galleryItemHistoryLocal.length == 0) {
  //       // galleryItemHistory = [File(fileSave.path)];
  //       galleryItemHistoryLocal = [
  //         FileLocal(keyValue.toString(), filename, File(fileSave.path))
  //       ];
  //     } else
  //       galleryItemHistoryLocal
  //           .add(FileLocal(key.toString(), filename, File(fileSave.path)));
  //   });
  // }
  ///// log history
  ///

  Widget buildAttHistory(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          buildListImageHistory(),
          buildListFileHistory()
        ]));
  }

  Widget buildListFileHistory() {
    return new ListView.builder(
      // scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: attachmentFileHistory.length,
      itemBuilder: (context, int index) {
        final item = attachmentFileHistory[index];
        final exp = item['fileName'].toString().split('.').last;
        final mimeType = 'MimeType: ' + item['mimeType'].toString();

        return buildFileHistory(index, exp, mimeType);
      },
    );
  }

  Widget buildListImageHistory() {
    List<Widget> lstWidget = [];
    // galleryItemHistoryLocal[0].file.absolute.
    for (int index = 0;
        index < galleryItemHistoryLocalHistory.length;
        index++) {
      //  galleryItemHistoryLocal[index].file.readAsBytes();
      lstWidget.add(Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: Container(
              child: Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Container(
                height: 100.0,
                width: 100.0,
                child: TextButton(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Stack(children: <Widget>[
                        Image.file(
                            File(galleryItemHistoryLocalHistory[index]
                                .file
                                .path),
                            width: 80.0,
                            height: 80.0),
                      ])),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          dataPost: [],
                          galleryItems: galleryItemHistoryLocalHistory,
                          initialIndex: index,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    );
                  },
                )),
          ))));
    }
    return Wrap(
        alignment: WrapAlignment.start,
        direction: Axis.horizontal,
        children: lstWidget);
  }

  Widget buildFileHistory(index, exp, mimeType) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      // padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () => {
              saveImage(context, attachmentFileHistory[index]['fileName'],
                  attachmentFileHistory[index]['refCode'])
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                exp.toUpperCase(),
                style: TextStyle(fontSize: 12, color: AppColor.white),
              ),
            ),
            title: Text(
              attachmentFileHistory[index]['fileName'],
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
            // subtitle: Text(
            //     item['size'].toString() + ' Byte'),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text('Size: ' +
                      attachmentFileHistory[index]['size'].toString() +
                      ' Byte'),
                  // new Text(mimeType),
                ]),
          )
        ],
      ),
    );
  }

  setAttHistory(attachment) async {
    var lengthAtt = attachment.length;
    var array = [];
    for (var index = 0; index < lengthAtt; index++) {
      array.add('"' + attachment[index].toString() + '"');
    }
    try {
      final Response responseAtt = await _dmsService.getResourcesList(array);
      if (Utils.checkRequestIsComplete(responseAtt)) {
        // var data= responseAtt.data['data'];
        var data = Utils.handleRequestData(responseAtt);
        if (Utils.isArray(data)) {
          Map<String, dynamic> arrayAtt = {};
          for (var i = 0; i < data.length; i++) {
            var string = data[i]['refCode'];
            var dynamicValue = data[i];
            Map<String, dynamic> paths = {};
            paths = {string: dynamicValue};
            if (arrayAtt.isEmpty || arrayAtt.length == 0) {
              arrayAtt = paths;
            } else
              paths.forEach((k, v) => arrayAtt[k] = v);
          }
          setState(() {
            _pathsHistory = arrayAtt;
          });
          setImageFileHistory();
        }
      }
    } catch (e) {}
  }

  setImageFileHistory() {
    final postAttachment = _pathsHistory;
    setState(() {
      galleryItemHistoryLocalHistory = [];
      attachmentFileHistory = [];
    });
    for (var i = 0; i < postAttachment.length; i++) {
      if (postAttachment.values.toList()[i]['mimeType'].indexOf('image/') >=
          0) {
        var namfirst = DateTime.now().millisecondsSinceEpoch;
        saveFileImageHistory(
            context,
            postAttachment.values.toList()[i]['makerDate'],
            namfirst.toString() + i.toString(),
            postAttachment.values.toList()[i]['refCode']);
      } else {
        if (attachmentFileHistory == null ||
            attachmentFileHistory.isEmpty ||
            attachmentFileHistory.length == 0) {
          attachmentFileHistory = [postAttachment.values.toList()[i]];
        } else
          attachmentFileHistory.add(postAttachment.values.toList()[i]);
      }
    }
  }

  void saveFileImageHistory(context, key, String filename, keyValue) async {
    HttpClient client = new HttpClient();
    final storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    var _downloadData = [];
    var sObject = 'identifer=' + keyValue;
    var url = DMS_SERVICE_URL.DOWNLOAD_FILE + sObject;
    final fileSave = await localFile(filename);
    try {
      var request = await client.getUrl(Uri.parse(url));
      request.headers
          .set("Authorization", APP_CONFIG.KEY_JWT + '$storageToken');
      await requestClose(request).then((HttpClientResponse response) {
        response.listen((d) => _downloadData.addAll(d), onDone: () {
          // fileSave.writeAsBytes(_downloadData);
          setFileLocalHistory(
              context, key, filename, keyValue, fileSave, _downloadData);
        });
      });
    } catch (exception) {
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).DownloadFileFailed);
    }
  }

  setFileLocalHistory(
      context, key, String filename, keyValue, fileSave, _downloadData) async {
    await fileSave.writeAsBytes(_downloadData);
    setState(() {
      if (galleryItemHistoryLocalHistory.isEmpty ||
          galleryItemHistoryLocalHistory.length == 0) {
        // galleryItemHistory = [File(fileSave.path)];
        galleryItemHistoryLocalHistory = [
          FileLocal(keyValue.toString(), filename, File(fileSave.path))
        ];
      } else
        galleryItemHistoryLocalHistory
            .add(FileLocal(key.toString(), filename, File(fileSave.path)));
    });
  }
}
