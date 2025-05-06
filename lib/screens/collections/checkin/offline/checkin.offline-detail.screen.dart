import 'dart:async';

import 'package:athena/models/category/action_attribute_ticket.model.dart';
import 'package:athena/models/category/action_ticket.model.dart';
import 'package:athena/screens/collections/checkin/widgets/customerName.widget.dart';
import 'package:athena/screens/collections/checkin/widgets/sawPosition.widget.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/geolocation.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:after_layout/after_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/category/contact_by_ticket.model.dart';
import 'package:athena/models/category/contact_person_ticket.model.dart';
import 'package:athena/models/category/place_contact_ticket.model.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/services/category/category.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/collections/footerButtonOKCANCEL.widget.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'dart:io';
import 'package:athena/common/config/app_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/widgets/common/photo/galleryPhotoViewWrapper.widget.dart';
import 'package:http/http.dart' show get;
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import '../../collections.service.dart';
import 'package:athena/models/offline/action/checkin/checkin.offline.model.dart';

class CheckInOfflineDetailScreen extends StatefulWidget {
  final CheckInOfflineModel activityModel;
  CheckInOfflineDetailScreen({Key? key, required this.activityModel})
      : super(key: key);
  @override
  _CheckInOfflineDetailScreenState createState() =>
      _CheckInOfflineDetailScreenState();
}

class _CheckInOfflineDetailScreenState extends State<CheckInOfflineDetailScreen>
    with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'CheckInOfflineDetailScreen');
  bool isLoading = true;
  final _categoryService = new CategoryService();
  final _categoryProvider = new CategorySingeton();
  final _mapService = new VietMapService();
  var target;

  String? address;
  String? paymentBy;
  String? actionName;
  String? clientPhone;
  String? description;
  String? actionGroupName;
  String? paymentAmount;
  String? actionAttributeName = '';
  PlaceContactTicketModel? placeContactTicketModel;
  ContactPersonTicketModel? contactPersonTicketModel;
  ContactByTicketModel? contactByTicketModel;
  ActionTicketModel? actionTicketModel;
  ActionAttributeTicketModel? actionAttributeTicketModel;
  int? paymentUnit;
  DMSService _dmsService = new DMSService();
  List<FileLocal> galleryItemHistoryLocal = [];
  dynamic postAttachment = [];
  final _collectionService = new CollectionService();

  String? contactName = '';
  String? contactMobile = '';
  String? ward = '';
  String? city = '';
  String? province = '';
  String? contactAddress = '';
  bool? showCity = false;
  LatLng? position;
  @override
  initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await handleFetchData();
  }

  Future<void> handleFetchData() async {
    try {
      target = widget.activityModel;
      var attachments = [];
      if (target != null && Utils.checkIsNotNull(target)) {
        if (
            widget.activityModel.latitude != null &&
            widget.activityModel.longitude != null &&
            Utils.checkIsNotNull(widget.activityModel.latitude) &&
            Utils.checkIsNotNull(widget.activityModel.longitude)) {
          position = new LatLng(
              widget.activityModel.latitude!, widget.activityModel.longitude!);
        }
        placeContactTicketModel = new PlaceContactTicketModel();
        contactPersonTicketModel = new ContactPersonTicketModel();
        contactByTicketModel = new ContactByTicketModel();
        paymentBy = Utils.retunDataStr(target.paymentBy);
        clientPhone = Utils.retunDataStr(target.clientPhone);
        description = Utils.retunDataStr(target.description);
        actionGroupName = Utils.retunDataStr(target.actionGroupName);
        actionName = Utils.retunDataStr(target.actionName);
        paymentAmount = Utils.checkIsNotNull(target.paymentAmount)
            ? target.paymentAmount.toString()
            : null;

        paymentAmount = Utils.formatPrice(paymentAmount ?? '0');

        if (Utils.isArray(target.attachments)) {
          attachments = target.attachments;
        }
        Response response;
        var lstData;
        int contactPlaceId = target.contactPlaceId;
        if (Utils.checkIsNotNull(contactPlaceId)) {
          if (_categoryProvider.getLstPlaceContactTicketModel.isNotEmpty) {
            getPlaceContact(_categoryProvider.getLstPlaceContactTicketModel,
                contactPlaceId);
          } else {
            response = await _categoryService.getPlaceContact();
            if (Utils.checkRequestIsComplete(response)) {
              lstData = Utils.handleRequestData(response);
              getPlaceContact(_categoryProvider.getLstPlaceContactTicketModel,
                  contactPlaceId);
            }
          }
        }
        int contactModeId = target?.contactModeId;
        if (Utils.checkIsNotNull(contactModeId)) {
          if (_categoryProvider.getLstContactByTicketM.isNotEmpty) {
            getContactByTicket(
                _categoryProvider.getLstContactByTicketM, contactModeId);
          } else {
            response = await _categoryService.getContactByTicket();
            if (Utils.checkRequestIsComplete(response)) {
              getContactByTicket(
                  Utils.handleRequestData(response), contactModeId);
            }
          }
        }
        int contactPersonId = target?.contactPersonId;
        if (Utils.checkIsNull(contactPersonId)) {
          if (_categoryProvider.getLstContactPersonTicketModel.isNotEmpty) {
            getContactByPerson(_categoryProvider.getLstContactPersonTicketModel,
                contactPersonId);
          } else {
            response = await _categoryService.getContactByPerson();
            if (Utils.checkRequestIsComplete(response)) {
              getContactByPerson(
                  Utils.handleRequestData(response), contactPersonId);
            }
          }
        }

        int attributeActionId = target?.actionAttributeId;
        if (Utils.checkIsNull(attributeActionId)) {
          if (_categoryProvider.getLstActionAttributeTicketModel.isNotEmpty) {
            getAttributeActionModel(
                _categoryProvider.getLstActionAttributeTicketModel,
                attributeActionId);
          }
        }
      }

      if (target.address != null) {
        if (MyConnectivity.instance.isOffline) {
          address = target.address;
        } else {
          String _address = target.address;
          if (_address == S.of(context).addressCantGetWhenOffline) {
            address = await _mapService.getAddressFromLongLatVMap(
                target.latitude, target.longitude, context);
          }
        }
      }

      contactName = Utils.retunDataStr(target.contactName);
      contactMobile = Utils.retunDataStr(target.contactMobile);

      int cityId = Utils.checkIsNotNull(target.contactProvinceId)
          ? target.contactProvinceId
          : null;
      int provinceId = Utils.checkIsNotNull(target.contactDistrictId)
          ? target.contactDistrictId
          : null;
      int wardId = Utils.checkIsNotNull(target.contactWardId)
          ? target.contactWardId
          : null;
      contactAddress = Utils.retunDataStr(target.contactAddress);
      if ((Utils.checkIsNotNull(cityId) && Utils.checkIsNotNull(provinceId))) {
        showCity = true;
        var provinceData = this
            ._categoryProvider
            .getDataCityProvinceWard(cityId, provinceId, wardId);
        if (Utils.checkIsNotNull(provinceData)) {
          city = provinceData['city'];
          if (city == '') {
            city = cityId.toString();
          }
          province = provinceData['province'];
          if (province == '') {
            province = provinceId.toString();
          }
          ward = provinceData['ward'];
          if (ward == ' ') {
            ward = wardId.toString();
          }
        }
      }

      isLoading = false;
      setState(() {});
      if (Utils.isArray(attachments) && !MyConnectivity.instance.isOffline) {
        await getFileImages(attachments);
      }
    } catch (e) {
      isLoading = false;
      setState(() {});
      print(e);
    } finally {}
  }

  void getContactByPerson(lstData, int contactPersonId) {
    for (var data in lstData) {
      ContactPersonTicketModel contact;
      if (data is ContactPersonTicketModel) {
        contact = data;
      } else {
        contact = ContactPersonTicketModel.fromJson(data);
      }
      if (contact.id == contactPersonId) {
        contactPersonTicketModel = contact;
        break;
      }
    }
  }

  void getAttributeActionModel(lstData, int attributeId) {
    for (var data in lstData) {
      ActionAttributeTicketModel contact;
      if (data is ActionAttributeTicketModel) {
        contact = data;
      } else {
        contact = ActionAttributeTicketModel.fromJson(data);
      }
      if (contact.id == attributeId) {
        actionAttributeTicketModel = contact;
        // actionAttributeName = actionAttributeTicketModel.attributeCode?.toString() +
        //     ' ' +
        //     actionAttributeTicketModel.attributeName?.toString();
        // Alternative fix: Only concatenate when both values exist
    actionAttributeName = actionAttributeTicketModel?.attributeCode != null && 
                     actionAttributeTicketModel?.attributeName != null
    ? "${actionAttributeTicketModel?.attributeCode} ${actionAttributeTicketModel?.attributeName}"
    : "";
        break;
      }
    }
  }

  void getFieldAction(lstData, int acionId) {
    for (var data in lstData) {
      ActionTicketModel contact;
      if (data is ActionTicketModel) {
        contact = data;
      } else {
        contact = ActionTicketModel.fromJson(data);
      }
      if (contact.id == acionId) {
        actionTicketModel = contact;
        actionName = contact.actionName;
        break;
      }
    }
  }

  void getContactByTicket(lstData, int contactModeId) {
    for (var data in lstData) {
      ContactByTicketModel contact;
      if (data is ContactByTicketModel) {
        contact = data;
      } else {
        contact = ContactByTicketModel.fromJson(data);
      }
      if (contact.id == contactModeId) {
        contactByTicketModel = contact;
        break;
      }
    }
  }

  void getPlaceContact(lstData, int contactPlaceId) {
    for (var data in lstData) {
      PlaceContactTicketModel place;
      if (data is PlaceContactTicketModel) {
        place = data;
      } else {
        place = PlaceContactTicketModel.fromJson(data);
      }
      if (place.id == contactPlaceId) {
        placeContactTicketModel = place;
        break;
      }
    }
  }

  Future<void> getFileImages(attachment) async {
    if (attachment != null && attachment.length > 0) {
      var lengthAtt = attachment.length;
      var array = [];
      for (var index = 0; index < lengthAtt; index++) {
        array.add('"' + attachment[index].toString() + '"');
      }

      try {
        final Response responseAtt = await _dmsService.getResourcesList(array);
        if (Utils.checkRequestIsComplete(responseAtt)) {
          postAttachment = Utils.handleRequestData(responseAtt);
          galleryItemHistoryLocal = [];
          // });
          for (var i = 0; i < postAttachment.length; i++) {
            if (postAttachment[i]['mimeType'] != null) {
              if (postAttachment[i]['mimeType'].indexOf('image/') >= 0)
                saveFileImage(
                    context,
                    postAttachment[i]['makerDate'],
                    postAttachment[i]['fileName'],
                    postAttachment[i]['refCode']);
            }
          }
        } else {
          setState(() {
            this.postAttachment = [];
          });
        }
      } catch (e) {}
    } else {
      setState(() {
        this.postAttachment = [];
      });
    }
  }

  requestClose(request) {
    return request.close();
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
        handleDownLoadFile(filename, fileSave, response, key);
      }
        } catch (exception) {
      print(exception);
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).DownloadFileFailed);
    }
  }

  Future<void> handleDownLoadFile(
      String fileName, dynamic fileSave, dynamic _downloadData, int key) async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      String firstPath = documentDirectory.path + "/images";
      String filePathAndName = documentDirectory.path + '/images/' + fileName;
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(_downloadData.bodyBytes); // <-- 3
      galleryItemHistoryLocal
          .add(FileLocal(key.toString(), fileName, File(filePathAndName)));
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void downloadFile(context, index, keyValue) async {
    final Response response = await _dmsService.downloadFile(keyValue);
    if (response.data != null) {
      postAttachment[index]['dataImage'] = response.data;
    } else {
      WidgetCommon.showSnackbar(
          this._scaffoldKey, S.of(context).DownloadFileFailed);
      return;
    }
  }

  @override
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> localFile(String filename) async {
    final path = await localPath;
    return File('$path/$filename');
  }

  Future<String> writeData(String filename, data) async {
    final file = await localFile(filename);
    file.writeAsBytes(data);
    return file.path;
  }

  Widget cameraWidget() {
    return Card(
      margin: EdgeInsets.all(7.0),
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
            ],
          ),
        ),
        Divider(
          color: AppColor.blackOpacity,
        ),
        (galleryItemHistoryLocal.isEmpty == true)
            ? Container()
            : ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.0, minHeight: 100.0),
                child: buildListImage()),
      ]),
    );
  }

  bool dataLoaded = false;

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
                      // child: Image.file(File(imageData),
                      child: Image.file(
                          File(galleryItemHistoryLocal[index].file.path),
                          width: 80.0,
                          height: 80.0)),
                  onPressed: () {
                    NavigationService.instance.navigateToRoute(
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
        runAlignment: WrapAlignment.start,
        children: lstWidget);
  }

  Widget formDetail() {
    try {
      if (Utils.checkIsNull(target)) {
        return formDetailPayment(target);
      }
      return NoDataWidget();
    } catch (e) {
      return NoDataWidget();
    }
  }

  Widget formDetailPayment(var target) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          (galleryItemHistoryLocal.length > 0) ? cameraWidget() : Container(),
          Card(
              margin: EdgeInsets.all(7.0),
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
                  initialValue: Utils.getTimeFromDate(
                      widget.activityModel.offlineInfo['dataTime']),
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Thời gian checkin offline',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                InkWell(
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    minLines: 1,
                    maxLines: 2,
                    initialValue: address,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.location_on,
                            color: Theme.of(context).primaryColor),
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: S.of(context).position,
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  onTap: () {
                    if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                      if (position != null) {  // Use direct null check instead of Utils helper
                        NavigationService.instance.navigateToRoute(
                          MaterialPageRoute(
                            builder: (context) => SawPositionCheckin(position: position!)  // Add ! to assert non-null
                          )
                        );
                        return;
                      }
                      WidgetCommon.showSnackbar(
                          _scaffoldKey, 'Không tìm thấy tọa độ check in');
                    }
                  },
                ),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  initialValue: contactByTicketModel?.modeName!,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).contactBy,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  initialValue: contactPersonTicketModel?.personName!,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).contactWith,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  initialValue: contactName,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Họ và tên người liên hệ',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  initialValue: contactMobile,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Số điện thoại người liên hệ',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  minLines: 1,
                  maxLines: 2,
                  initialValue: actionName,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).actionCode,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                Visibility(
                    visible: (actionAttributeName?.length ??0) > 0,
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      initialValue: actionAttributeName,
                      minLines: 1,
                      maxLines: 2,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: S.of(context).actionAttributeCode,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    )),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  initialValue: placeContactTicketModel?.placeName!,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: S.of(context).contactPlace,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                Visibility(
                    visible: showCity!,
                    child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        initialValue: city,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Tỉnh/Thành phố *',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ))),
                Visibility(
                    visible: showCity!,
                    child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        initialValue: province,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Quận/ Huyện/ Thị Xã',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ))),
                Visibility(
                    visible: showCity!,
                    child: TextFormField(
                        readOnly: true,
                        enabled: false,
                        initialValue: ward,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Xã/ Phường/ Thị Trấn',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ))),
                Visibility(
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      initialValue: contactAddress,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Địa chỉ ",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    visible: showCity ?? false),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  initialValue: paymentBy,
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: "Họ tên",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  initialValue: paymentAmount,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: "Số tiền",
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                TextFormField(
                  readOnly: true,
                  enabled: false,
                  minLines: 1,
                  maxLines: 5,
                  initialValue: description,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).note,
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                TextFormField(
                  initialValue: clientPhone,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: S.of(context).customerPhone,
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                )
              ]))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBarCommon(
          title: S.of(context).detail,
          lstWidget: [],
        ),
        bottomNavigationBar: FooterButonOKCANCELWidget(
          callbackOK: () async {
            if (MyConnectivity.instance.isOffline) {
              WidgetCommon.showSnackbar(
                  _scaffoldKey, S.of(context).featureCantRunOffline);
              return;
            }
            try {
              String address = await this._mapService.getAddressFromLongLatVMap(
                  widget.activityModel.latitude!,
                  widget.activityModel.longitude!,
                  context);
              if (address.isNotEmpty) {
                widget.activityModel.address = address;
              } else {
                return WidgetCommon.generateDialogOKGet(
                    content: 'Không lấy được địa chỉ checkin');
              }
              Response res;
              if (widget.activityModel.actionGroupName ==
                  AppStateConfigConstant.REFUSE_TO_PAY) {
                res = await this
                    ._collectionService
                    .checkInRefuse(widget.activityModel.toJson());
              } else {
                res = await this
                    ._collectionService
                    .checkIn(widget.activityModel.toJson());
              }

              if (Utils.checkRequestIsComplete(res)) {
                if (res.data['data'] == null) {
                  Navigator.pop(context, true);
                  GeoPositionBackgroundService geoPositionBackgroundService =
                      new GeoPositionBackgroundService();
                  geoPositionBackgroundService.getFirstPositionWhenInApp();
                }
              } else {
                var dataError = Utils.handleRequestData(res);
                if (Utils.isArray(dataError)) {
                  if (Utils.checkIsNotNull(dataError['validateResult']) &&
                      Utils.checkIsNotNull(dataError['messages'])) {
                    if (Utils.isArray(dataError['validateResult'])) {
                      final validateResult = dataError['validateResult'];
                      String errorMsg = '';
                      if (Utils.checkIsNotNull(validateResult['offlineUuid'])) {
                        Navigator.pop(context, true);
                      } else {
                        validateResult.forEach((key, value) {
                          errorMsg += value + ' ';
                        });
                      }
                      if (errorMsg.isNotEmpty) {
                        WidgetCommon.generateDialogOKGet(content: errorMsg);
                      }
                    }
                  }
                }
              }
            } catch (e) {
              // var dataError = Utils.handleRequestDataLV1(e.response);
                // Fix 1: Add proper null-safe error handling
              var dataError;
              if (e is DioError && e.response != null) {
                // Handle Dio errors with response
                dataError = Utils.handleRequestDataLV1(e.response!);
              } else {
                // Handle other errors without response data
                print('Error during check-in: $e');
                WidgetCommon.generateDialogOKGet(content: 'Có lỗi xảy ra, vui lòng thử lại sau.');
                return;
              }
              if (Utils.isArray(dataError)) {
                var validation = dataError['validation'];
                if (Utils.checkIsNotNull(validation['validationResults']) &&
                    Utils.checkIsNotNull(validation['messages'])) {
                  if (Utils.isArray(validation['validationResults'])) {
                    final validateResult = validation['validationResults'];
                    String errorMsg = '';
                    if (Utils.checkIsNotNull(validateResult['offlineUuid'])) {
                      Navigator.pop(context, true);
                    } else {
                      validateResult.forEach((key, value) {
                        errorMsg += value + ' ';
                      });
                    }
                    if (errorMsg.isNotEmpty) {
                      WidgetCommon.generateDialogOKGet(content: errorMsg);
                    }
                  }
                }
              }
            }
          },
          callbackCancel: () async {
            WidgetCommon.generateDialogOKCancelGet(
                'Bạn muốn xóa dòng dữ liệu này', callbackOK: () {
              Navigator.pop(context, true);
            });
          },
          titleCancel: S.of(context).btDelete,
          titleOK: S.of(context).update,
        ),
        body: Container(
          height: AppState.getHeightDevice(context),
          width: AppState.getWidthDevice(context),
          child: SingleChildScrollView(
              child: (isLoading == true)
                  ? Container(
                      height: AppState.getHeightDevice(context),
                      width: AppState.getWidthDevice(context),
                      child: ShimmerCheckIn())
                  // : formDetail(),
                  : Column(children: [
                      CustomerNameCheckInWidget(
                          customerFullName: target.customerName),
                      formDetail()
                    ])),
        ));
  }

  @override
  void dispose() {
    galleryItemHistoryLocal = [];
    super.dispose();
  }
}
