import 'dart:async';
import 'dart:io';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/customer-request/attactment-image/image_picker_handler-image.dart';
import 'package:athena/screens/customer-request/attactment/image_picker_handler.dart';
import 'package:athena/screens/customer-request/customer-request.service.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/formatter/numbericMoney.formater.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:after_layout/after_layout.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/getit.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:athena/widgets/common/photo/galleryPhotoViewWrapper.widget.dart';
import 'package:http/http.dart' show get;

import 'dropwdown_form_constans.dart';

class CustomerRequestScreen extends StatefulWidget {
  CustomerRequestScreen({Key? key}) : super(key: key);
  @override
  CustomerRequestScreenState createState() => CustomerRequestScreenState();
}

class CustomerRequestScreenState extends State<CustomerRequestScreen>
    with
        TickerProviderStateMixin,
        ImagePickerListener,
        ImagePickerListenerImage,
        AfterLayoutMixin {
  File? _image;
  bool checkFileDinhKem = false;
  Map<String, dynamic> _paths = {};
  List<String> _attachments = [];
   ImagePickerHandler? imagePicker;
  bool _loadingPath = true;
  dynamic attachmentFile = [];
  bool checkAtt = false;
  String fieldNameAtt = 'File đính kèm';
  bool _requiredFileDinhkem = false;
  String fieldNameFiledinhkem = 'File đính kèm';
  List<FileLocal> galleryItemHistoryLocal = [];
  ///////
  File? _imageImage;
  bool checkFileDinhKemImage = false;
  Map<String, dynamic> _pathsImage = {};
  List<String> _attachmentsImage = [];
   ImagePickerHandlerImage? imagePickerImage;
  bool _loadingPathImage = true;
  List<FileLocal> attachmentFileImage = [];
  bool checkAttImage = false;
  String fieldNameAttImage = 'File đính kèm';
  bool _requiredFileDinhkemImage = false;
  String fieldNameFiledinhkemImage = 'File đính kèm';
  List<FileLocal> galleryItemHistoryLocalImage = [];
   AnimationController? _controller;
  final formKey = new GlobalKey<FormState>();
  final _formLoginKey = new GlobalKey<FormState>();

  dynamic dataCategory = [];
  dynamic dataSubCategory = [];
  dynamic itemForm = [];
  dynamic dataFinal, dataFinalFormat;
  dynamic dataList = [];
  List<Widget> listItemForm = [];
  dynamic listItemAtt;
  dynamic _count = 0;
  String username = '';
  String fullName = '';
  String empCode = '';
   Map<String, TextEditingController>? _controllerList;
  String descriptionRecovery = '';
  DropdownFormItem formItem = DropdownFormConstans.list[0];
  final _userInfoStore = getIt<UserInfoStore>();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'CustomerRequestScreenState');
  final _customerRequestservice = CustomerRequestService();
  removeFile(String keyValue) {
    setState(() {
      _paths.removeWhere((key, value) => key == keyValue);
      setImageFile();
    });
  }

  userImage(File _image) {
    setState(() {
      this._image = _image;
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

  errorttachmentsImage(bool error) {
    if (error) {
      WidgetCommon.showSnackbar(_scaffoldKey, "Tải file đính kèm thất bại!");
      return;
    }
  }

  loadingPath(bool loading) {
    // _controllerList['issueName'] = dataFinal['issueName'];
    // _controllerList['description'] = dataFinal['description'];
    setState(() {
      // Image.file(_image);

      this._loadingPath = loading;
    });
  }

///////
  removeFileImage(String keyValue) {
    setState(() {
      _pathsImage.removeWhere((key, value) => key == keyValue);
      setImageFileImage();
    });
  }

  userImageImage(File _image) {
    setState(() {
      this._imageImage = _image;
    });
  }

  // @override
  userFileImage(Map<String, dynamic> paths) {
    setState(() {
      // Image.file(_image);
      if (_pathsImage.isEmpty || _pathsImage.length == 0) {
        _pathsImage = paths;
      } else
        paths.forEach((k, v) => _pathsImage[k] = v);
      // _count++;
      // _paths = paths;
      setImageFileImage();
    });
  }

  funcattachmentsImage(String attachments) {
    setState(() {
      if (this._attachmentsImage.isEmpty ||
          this._attachmentsImage.length == 0) {
        this._attachmentsImage = [attachments];
      } else
        this._attachmentsImage.add(attachments);
      // this._attachments.add(attachments);
      // _paths = paths;
    });
  }

  loadingPathImage(bool loading) {
    // _controllerList['issueName'] = dataFinal['issueName'];
    // _controllerList['description'] = dataFinal['description'];
    setState(() {
      // Image.file(_image);
      this._loadingPath = loading;
      this._loadingPathImage = loading;
    });
  }

  void afterFirstLayout(BuildContext context) {
    // getSchemaPivot(context);
    empCode = _userInfoStore.user?.moreInfo?['empCode'] ?? '';
    username = _userInfoStore.user?.username ?? '';
    fullName = _userInfoStore.user?.fullName ?? '';
    getSupportTicketCategories(context, formItem);
    getCategoriesConfigByIssueType(context);
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

  void _buildItemForm() {
    // return;
    Map<String, Object> fieldsMapOne = Map();
    fieldsMapOne['categoryId'] = dataFinal['categoryId'];
    fieldsMapOne['subCategoryId'] = dataFinal['subCategoryId'];
    fieldsMapOne['issueName'] = dataFinal['issueName'];
    fieldsMapOne['description'] = dataFinal['description'];
    fieldsMapOne['fcsp_productcode'] = formItem?.supportType ?? '';

    Map<String, Object> dataEmpty = new Map();
    setState(() {
      dataFinal = fieldsMapOne;
      itemForm = [];
      listItemForm = [];
      listItemAtt = Container();
      dataFinalFormat = dataEmpty;
      checkAtt = false;
      _paths = {};
      _pathsImage = {};
    });
    for (var item in dataList) {
      if (item["categoryId"] == dataFinal['categoryId']) {
        setState(() {
          // itemForm = [];
          checkFileDinhKem = false;
          checkFileDinhKemImage = false;
          itemForm = item["fieldConfigs"];

          _controllerList?.forEach((key, value) {
            if (key == 'issueName' || key == 'description') {
            } else {
              value.clear();
            }
          });

          _controllerList = Map<String, TextEditingController>();
          if (Utils.checkIsNotNull(dataFinal['issueName'])) {
            _controllerList!['issueName'] = TextEditingController();
            setController(
                dataFinal['issueName'], _controllerList!['issueName']!);
          }
          // _controllerList['issueName'].text = dataFinal['issueName'];
          if (Utils.checkIsNotNull(dataFinal['description'])) {
            _controllerList!['description'] = new TextEditingController();
            setController(
                dataFinal['description'], _controllerList!['description']!);
          }

          // _controllerList['description'].text = dataFinal['description'];
          listItemForm = buildFullList();
        });
      }
    }
  }

  setController(String value, TextEditingController control) async {
    control.value = TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
    );
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

  getSupportTicketCategories(context, DropdownFormItem valueForm) async {
    try {
      final Response response =
          await _customerRequestservice.getSupportTicketCategories(context,
              supportType: valueForm.supportType ?? '');
      if (response.data != null) {
        setState(() {
          dataCategory = response.data['data'];
          _loadingPath = false;
        });
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
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller!);
    imagePicker?.init();
    imagePickerImage = new ImagePickerHandlerImage(this, _controller!);
    imagePickerImage?.init();
    Map<String, Object> fieldsMapOne = Map();
    fieldsMapOne['categoryId'] = "";
    fieldsMapOne['subCategoryId'] = "";
    fieldsMapOne['issueName'] = "";
    fieldsMapOne['description'] = "";
    fieldsMapOne['fcsp_productcode'] = formItem.supportType ?? '';

    dataFinal = fieldsMapOne;
    Map<String, Object> dataEmpty = new Map();

    dataFinalFormat = dataEmpty;
    listItemForm = [];
    listItemAtt = Container();
    _controllerList = new Map<String, TextEditingController>();
    _controllerList!['issueName'] = new TextEditingController();
    _controllerList!['description'] = new TextEditingController();
  }

  checkCol(col) {
    if (col == 'fcsp_fccode' || col == 'fcsp_fcname') {
      return true;
    }
    return false;
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

  List<Widget> buildFullList() {
    List<Widget> lst = [
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
          // key: GlobalKey<FormFieldState>(),
          controller: _controllerList!['issueName'],
          onSaved: (value) {
            // setState(() {
            dataFinal['issueName'] = value;
            // });
          },
          onChanged: (value) {
            // setState(() {
            dataFinal['issueName'] = value;
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
          controller: _controllerList!['description'],
          onSaved: (value) {
            // setState(() {
            dataFinal['description'] = value;
            // });
          },
          onChanged: (value) {
            // setState(() {
            dataFinal['description'] = value;
            // });
          },
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          minLines: 3,
          maxLines: 20,
          validator: (val) => Utils.isRequire(context, val ?? ''),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              labelText: S.of(context).Description + " *",
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
      ),
      Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          color: Colors.grey[100],
        ),
        // padding: EdgeInsets.only(top: 16),
        child: ListTile(
            title: Text(
          S.of(context).additionalInformation,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        )),
      ),
    ];
    for (var index = 0; index < itemForm.length; index++) {
      try {
        var item = itemForm[index];
        var fileCode = item["fieldCode"];
        var editable = item["editable"];
        var readOnly = !editable;
        var fieldName = item["fieldName"];
        var _required = item["required"];
        // dataFinal.remove(fileCode);
        var initialValue = valuechange(fileCode);
        Map<String, TextEditingController> fieldsController = Map();
        fieldsController[fileCode] = new TextEditingController();
        if (_controllerList == null || (_controllerList??{}).isEmpty) {
          _controllerList = fieldsController;
        } else
          fieldsController.forEach((k, v) => _controllerList![k] = v);
        if (item != null && item["valueTypeCode"] == "numeric") {
          dataFinalFormat[fileCode] = "numeric";
          lst.add(Column(children: [
            new Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                controller: _controllerList![fileCode],
                readOnly: readOnly,
                // enabled: editable,
                inputFormatters: [NumericMoneyTextFormatter()],
                // controller: TextEditingController(),
                // key: GlobalKey<FormFieldState>(),
                onSaved: (value) {
                  dataFinal[fileCode] = value;
                  dataFinalFormat[fileCode] = "numeric";
                },
                onChanged: (value) {
                  dataFinal[fileCode] = value;
                  dataFinalFormat[fileCode] = "numeric";
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    _required ? Utils.isRequire(context, val ?? '') : _required,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: fieldName + checkrequired(_required),
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            )
          ]));
        } else if (item != null && item["valueTypeCode"] == "string") {
          _controllerList![fileCode]?.text = dataFinal[fileCode];
          lst.add(Column(children: [
            new Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: _controllerList![fileCode],
                  // initialValue: dataFinal[fileCode],
                  readOnly: readOnly,
                  // enabled: editable,
                  // controller: TextEditingController(),
                  // key: GlobalKey<FormFieldState>(),
                  onSaved: (value) {
                    dataFinal[fileCode] = value;
                  },
                  onChanged: (value) {
                    dataFinal[fileCode] = value;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: (val) => _required
                      ? Utils.isRequire(context, val ?? '')
                      : _required,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: fieldName + checkrequired(_required),
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ))
          ]));
        } else if (item != null && item["valueTypeCode"] == "date") {
          // dataFinal[fileCode] = new DateTime.now();
          // DateTime value = new DateTime.now();
          dataFinalFormat[fileCode] = "date";
          lst.add(Column(children: [
            InkWell(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      onChanged: (date) {}, onConfirm: (date) {
                    setState(() {
                      dataFinal[fileCode] = date;
                      dataFinalFormat[fileCode] = "date";
                    });
                  }, locale: LocaleType.vi);
                },
                child: new Container(
                  padding: EdgeInsets.only(left: 10, right: 16),
                  child: ListTile(
                    title: Text(
                      fieldName,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    subtitle: Text(
                      (dataFinal[fileCode] == null)
                          ? " "
                          : Utils.convertTimeWithoutTime(
                              dataFinal[fileCode].millisecondsSinceEpoch),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                  ),
                ))
          ]));
        } else if (item != null && item["valueTypeCode"] == "json_array") {
          if (fileCode == 'fcsp_attachment_doc') {
            checkFileDinhKem = true;
            fieldNameFiledinhkem = fieldName;
            _requiredFileDinhkem = _required;
          } else if (fileCode == 'fcsp_attachment_img') {
            checkFileDinhKemImage = true;
            fieldNameFiledinhkemImage = fieldName;
            _requiredFileDinhkemImage = _required;
          }

          // lst.add(Container());
        }
      } catch (e) {
        lst.add(Container());
      }
    }
    return lst;
  }

  showDialog() {
    FocusScope.of(context).unfocus();
    imagePicker?.showDialog(context);
  }

  showDialogImage() {
    FocusScope.of(context).unfocus();
    imagePickerImage?.showDialog(context);
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 12,
            )
          ],
        ));
  }

  Widget recoveryForm() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          TextFormField(
            // controller: TextEditingController(),
            // key: GlobalKey<FormFieldState>(),
            controller: _controllerList!['description'],
            onSaved: (value) {
              // setState(() {
              dataFinal['description'] = value;
              // });
            },
            onChanged: (value) {
              // setState(() {
              dataFinal['description'] = value;
              // });
            },
            minLines: 3,
            maxLines: 15,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            validator: (val) => Utils.isRequire(context, val ?? ''),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                hintText:
                    'FC vui lòng cung cấp đầy đủ thông tin user và pass/ code FC !',
                hintStyle: TextStyle(
                  color: AppColor.orange,
                ),
                labelText: S.of(context).Description + " *",
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ],
      ),
    );
  }

  Widget iCollectForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(children: buildFullList()),
        checkFileDinhKem == true
            ? Container(
                // height: 500,
                padding: EdgeInsets.all(16),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Text(fieldNameFiledinhkem +
                              checkrequired(_requiredFileDinhkem))),
                      new InkWell(
                        child: new Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(5.0),
                            color: Colors.black12,
                          ),
                          width: AppState.getWidthDevice(context),
                          child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.add_box_rounded,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                        onTap: () async {
                          showDialog();
                        },
                      )
                    ]))
            : Container(),
        _paths.length > 0 && checkFileDinhKem == true
            ? Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Danh sách file đính kèm' +
                      ' (' +
                      _paths.length.toString() +
                      ')',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              )
            : Container(),
        _paths.length > 0 ? buildAtt(context) : Container(),
        checkFileDinhKemImage == true
            ? Container(
                // height: 500,
                padding: EdgeInsets.all(16),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Text(fieldNameFiledinhkemImage +
                              checkrequired(_requiredFileDinhkemImage))),
                      new InkWell(
                        child: new Container(
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(5.0),
                            color: Colors.black12,
                          ),
                          width: AppState.getWidthDevice(context),
                          child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.add_box_rounded,
                                color: Theme.of(context).primaryColor,
                              )),
                        ),
                        onTap: () async {
                          showDialogImage();
                        },
                      )
                    ]))
            : Container(),
        _pathsImage.length > 0 && checkFileDinhKemImage == true
            ? Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Danh sách file đính kèm' +
                      ' (' +
                      _pathsImage.length.toString() +
                      ')',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              )
            : Container(),
        _pathsImage.length > 0 && checkFileDinhKemImage == true
            ? buildAttImage(context)
            : Container(),
        SizedBox(height: 200.0)
        // _buildSection1ListItems()
      ],
    );
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
    dataFinal['fcsp_productcode'] = formItem.supportType;

    Map<String, Object> dataEmpty = new Map();
    setState(() {
      dataFinal['categoryId'] = null;
      dataFinal['subCategoryId'] = null;

      itemForm = [];
      listItemForm = <Widget>[];
      // listItemForm = Container();
      listItemAtt = Container();
      dataFinalFormat = dataEmpty;
    });
  }

  check(data) {
    if (data == null || data == '') return true;
    return false;
  }

  handleSendRequestICL(BuildContext context) async {
    var listFinalAttachment = [];
    if (_paths.length > 10) {
      WidgetCommon.showSnackbar(_scaffoldKey,
          "Số lượng file " + fieldNameFiledinhkem + " không được lớn hơn 10");
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
    } else {
      dataFinal['fcsp_attachment_doc'] = [];
    }
    var listFinalAttachmentImage = [];
    if (_pathsImage.length > 10) {
      WidgetCommon.showSnackbar(
          _scaffoldKey,
          "Số lượng file " +
              fieldNameFiledinhkemImage +
              " không được lớn hơn 10");
      return;
    }
    if (_pathsImage.length > 0) {
      for (var i = 0; i < _pathsImage.length; i++) {
        var value = _pathsImage.keys.toList()[i].toString();
        if (listFinalAttachmentImage.isEmpty ||
            listFinalAttachmentImage.length == 0) {
          listFinalAttachmentImage = [value];
        } else
          listFinalAttachmentImage.add(value);
      }
      dataFinal['fcsp_attachment_img'] = listFinalAttachmentImage;
    } else {
      dataFinal['fcsp_attachment_img'] = [];
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
        if (check(dataFinal[fileCode]) &&
            _required &&
            fileCode != 'fcsp_attachment_doc' &&
            fileCode != 'fcsp_attachment_img') {
          WidgetCommon.showSnackbar(
              _scaffoldKey, fieldName + ' không được trống!');
          return;
        } else if (fileCode == 'fcsp_attachment_doc' &&
            dataFinal['fcsp_attachment_doc'].length <= 0 &&
            _required) {
          WidgetCommon.showSnackbar(
              _scaffoldKey, fieldName + ' không được trống!');
          return;
        } else if (fileCode == 'fcsp_attachment_img' &&
            dataFinal['fcsp_attachment_img'].length <= 0 &&
            _required) {
          WidgetCommon.showSnackbar(
              _scaffoldKey, fieldName + ' không được trống!');
          return;
        }
      }
      // if (_pathsImage.length <= 0 || _paths.length <= 0) {
      //   WidgetCommon.showSnackbar(_scaffoldKey, 'Vui lòng đính kèm File!');
      // }
      final Response res = await this
          ._customerRequestservice
          .createTicket(context, dataFinal, username, dataFinalFormat);
      if (Utils.checkRequestIsComplete(res)) {
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
            backgroundColor: AppColor.blue);
        startTime();

        return;
      }
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
    } catch (e) {
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
          title: Text(S.of(context).customerRequestPage),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: S.of(context).btCreate,
              onPressed: () {
                formItem.dropdownFormType == DropdownFormType.icollect
                    ? handleSendRequestICL(context)
                    : sendRequestRecovery();
              },
            ),
          ]),
      body: _loadingPath ? bodyProgress : buildBody(context),
    );
  }

  void sendRequestRecovery() async {
    try {
      if (check(dataFinal["categoryId"])) {
        WidgetCommon.showSnackbar(_scaffoldKey, 'Tiêu đề không được trống!');
        return;
      }
      if (check(dataFinal["description"])) {
        WidgetCommon.showSnackbar(
            _scaffoldKey, S.of(context).Description + ' không được trống!');
        return;
      }
      for (var item in dataCategory) {
        if (dataFinal["categoryId"] == item['id']) {
          dataFinal['issueName'] = item['name'];
        }
      }
      final Response res = await this
          ._customerRequestservice
          .createTicket(context, dataFinal, username, dataFinalFormat);
      if (Utils.checkRequestIsComplete(res)) {
        WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_sucess,
            backgroundColor: AppColor.blue);
        startTime();

        return;
      }
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
    } catch (e) {
      WidgetCommon.showSnackbar(_scaffoldKey, S.of(context).update_failed);
      return;
    }
  }

  setImageFile() {
    final postAttachment = _paths;
    setState(() {
      galleryItemHistoryLocal = [];
      attachmentFile = [];
    });
    for (var i = 0; i < postAttachment.length; i++) {
      FileLocal imageFile = postAttachment.values.toList()[i];
      var key = imageFile.file.path.split('/').last;
      final exp = key.split('.').last;
      if (Utils.checkIsImage(exp)) {
        galleryItemHistoryLocal.add(imageFile);
      } else {
        attachmentFile.add(imageFile);
      }
      // if (postAttachment.values.toList()[i]['mimeType'].indexOf('image/') >=
      //     0) {
      //   var namfirst = DateTime.now().millisecondsSinceEpoch;
      //   saveFileImage(
      //       context,
      //       postAttachment.values.toList()[i]['makerDate'],
      //       namfirst.toString() + i.toString(),
      //       postAttachment.values.toList()[i]['refCode']);
      // } else {
      //   if (attachmentFile == null ||
      //       attachmentFile.isEmpty ||
      //       attachmentFile.length == 0) {
      //     attachmentFile = [postAttachment.values.toList()[i]];
      //   } else
      //     attachmentFile.add(postAttachment.values.toList()[i]);
      // }
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
      shrinkWrap: true,
      itemCount: attachmentFile.length,
      itemBuilder: (context, int index) {
        final imageFile = attachmentFile[index];
        var key = imageFile.file.path.split('/').last;
        final exp = key.split('.').last;
        return buildFile(index, exp);
      },
    );
  }

  Widget buildListImage() {
    List<Widget> lstWidget = [];
    for (int index = 0; index < galleryItemHistoryLocal.length; index++) {
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
                        Positioned(
                            right: -5,
                            top: -9,
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 25,
                              ),
                              onPressed: () {
                                removeList(context,
                                    galleryItemHistoryLocal[index].key);
                              },
                            )),
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

  Widget buildFile(index, exp) {
    final imageFile = attachmentFile[index];
    var fileName = imageFile.file.path.split('/').last;
    final exp = fileName.split('.').last;
    final sizeFile = imageFile.file.lengthSync();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
              onTap: () => {
                    openFileLocalPath(imageFile.file.path)
                    // saveImage(context, attachmentFile[index]['fileName'],
                    //     attachmentFile[index]['refCode'])
                  },
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  exp.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: AppColor.white),
                ),
              ),
              title: Text(
                fileName,
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text('Size: ' + sizeFile.toString() + ' Byte'),
                  ]),
              trailing: new InkWell(
                  onTap: () => removeList(context, _paths.keys.toList()[index]),
                  child: new Stack(children: <Widget>[Icon(Icons.delete)])))
        ],
      ),
    );
  }

  setImageFileImage() {
    final postAttachment = _pathsImage;
    setState(() {
      galleryItemHistoryLocalImage = [];
      attachmentFileImage = [];
    });
    for (var i = 0; i < postAttachment.length; i++) {
      FileLocal imageFile = postAttachment.values.toList()[i];
      var key = imageFile.file.path.split('/').last;
      final exp = key.split('.').last;
      if (Utils.checkIsImage(exp)) {
        galleryItemHistoryLocalImage.add(imageFile);
      } else {
        attachmentFileImage.add(imageFile);
      }
      // if (postAttachment.values.toList()[i]['mimeType'].indexOf('image/') >=
      //     0) {
      //   var namfirst = DateTime.now().millisecondsSinceEpoch;
      //   saveFileImageImgae(
      //       context,
      //       postAttachment.values.toList()[i]['makerDate'],
      //       namfirst.toString() + i.toString(),
      //       postAttachment.values.toList()[i]['refCode']);
      // } else {
      //   if (attachmentFileImage == null ||
      //       attachmentFileImage.isEmpty ||
      //       attachmentFileImage.length == 0) {
      //     attachmentFileImage = [postAttachment.values.toList()[i]];
      //   } else
      //     attachmentFileImage.add(postAttachment.values.toList()[i]);
      // }
    }
  }

  Widget buildAttImage(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[buildListImageImage(), buildListFileImage()]));
  }

  Widget buildListFileImage() {
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: attachmentFileImage.length,
      itemBuilder: (context, int index) {
        final imageFile = attachmentFileImage[index];
        var key = imageFile.file.path.split('/').last;
        final exp = key.split('.').last;
        // final exp = item['fileName'].toString().split('.').last;
        // final mimeType = 'MimeType: ' + item['mimeType'].toString();

        return buildFileImage(index, exp);
      },
    );
  }

  Widget buildListImageImage() {
    List<Widget> lstWidget = [];
    for (int index = 0; index < galleryItemHistoryLocalImage.length; index++) {
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
                            File(galleryItemHistoryLocalImage[index].file.path),
                            width: 80.0,
                            height: 80.0),
                        Positioned(
                            right: -5,
                            top: -9,
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 25,
                              ),
                              onPressed: () {
                                removeListImage(context,
                                    galleryItemHistoryLocalImage[index].key);
                              },
                            )),
                      ])),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                          dataPost: [],
                          galleryItems: galleryItemHistoryLocalImage,
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

  openFileLocalPath(path) {
    try {
      OpenFilex.open(path.toString());
    } catch (e) {}
  }

  Widget buildFileImage(index, exp) {
    final imageFile = attachmentFileImage[index];
    var fileName = imageFile.file.path.split('/').last;
    final exp = fileName.split('.').last;
    final sizeFile = imageFile.file.lengthSync();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
              onTap: () => {
                    openFileLocalPath(attachmentFileImage[index].file.path)
                    // saveImageImage(
                    //     context,
                    //     attachmentFileImage[index]['fileName'],
                    //     attachmentFileImage[index]['refCode'])
                  },
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  exp.toUpperCase(),
                  style: TextStyle(fontSize: 12, color: AppColor.white),
                ),
              ),
              title: Text(
                fileName,
                overflow: TextOverflow.clip,
                maxLines: 2,
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Text('Size: ' + sizeFile.toString() + ' Byte'),
                  ]),
              trailing: new InkWell(
                  onTap: () => removeListImage(
                      context, _pathsImage.keys.toList()[index]),
                  child: new Stack(children: <Widget>[Icon(Icons.delete)])))
        ],
      ),
    );
  }

  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> localFile(String filename) async {
    final path = await localPath;
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

  void removeListImage(context, keyValue) {
    WidgetCommon.generateDialogOKCancelGet(S.of(context).deleteFile,
        title: S.of(context).Alert, callbackOK: () {
      removeFileImage(keyValue);
    },
        callbackCancel: () {},
        textBtnOK: S.of(context).btOk,
        textBtnClose: S.of(context).btExit);
  }

  requestClose(request) {
    return request.close();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context, true);
  }

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

  void saveImageImage(context, String filename, keyValue) async {
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

  void saveFileImageImgae(context, key, String filename, keyValue) async {
    final storageToken =
        await StorageHelper.getString(AppStateConfigConstant.JWT) ?? '';
    var sObject = 'identifer=' + keyValue;
    var url = DMS_SERVICE_URL.DOWNLOAD_FILE + sObject;
    final fileSave = await localFile(filename);
    try {
      var response = await get(Uri.parse(url),
          headers: {'Authorization': APP_CONFIG.KEY_JWT + '$storageToken'});
      if (response.statusCode == 200) {
        handleDownLoadFileImage(filename, fileSave, response, key, keyValue);
      }
    } catch (exception) {
      print(exception);
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).DownloadFileFailed);
    }
  }

  Future<void> handleDownLoadFileImage(String fileName, dynamic fileSave,
      dynamic _downloadData, int key, keyValue) async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = documentDirectory.path + "/images";
      String filePathAndName = documentDirectory.path + '/images/' + fileName;
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(_downloadData.bodyBytes); // <-- 3
      setState(() {
        if (galleryItemHistoryLocalImage.isEmpty ||
            galleryItemHistoryLocalImage.length == 0) {
          // galleryItemHistory = [File(fileSave.path)];
          galleryItemHistoryLocalImage = [
            FileLocal(keyValue.toString(), fileName, File(filePathAndName))
          ];
        } else
          galleryItemHistoryLocalImage.add(
              FileLocal(keyValue.toString(), fileName, File(filePathAndName)));
      });
      // galleryItemHistoryLocal
      //     .add(FileLocal(key.toString(), fileName, File(filePathAndName)));
      // setState(() {});
    } catch (e) {}
  }
}
