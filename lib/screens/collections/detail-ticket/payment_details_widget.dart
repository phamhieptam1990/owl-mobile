import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:athena/screens/vietmap/vietmap.service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/category/action_attribute_ticket.model.dart';
import 'package:athena/models/category/action_sub_attribute_model.dart';
import 'package:athena/models/category/contact_by_ticket.model.dart';
import 'package:athena/models/category/contact_person_ticket.model.dart';
import 'package:athena/models/category/place_contact_ticket.model.dart';
import 'package:athena/models/fileLocal.model.dart';
import 'package:athena/models/tickets/activity.model.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/offline/offline.service.dart';
import 'package:athena/utils/services/category/category.provider.dart';
import 'package:athena/utils/services/category/category.service.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/appbar.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/nodata.widget.dart';
import 'package:athena/widgets/common/photo/galleryPhotoViewWrapper.widget.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

import '../../../common/config/app_config.dart';
import '../../../common/constants/app_cache_image.dart';
import '../../../getit.dart';
import '../../../utils/global-store/user_info_store.dart';

class DetailPaymentWidget extends StatefulWidget {
  final ActivityModel? activityModel;  // Mark as nullable

  const DetailPaymentWidget({Key? key, this.activityModel}) : super(key: key);

  @override
  _DetailPaymentWidgetState createState() => _DetailPaymentWidgetState();
}

class _DetailPaymentWidgetState extends State<DetailPaymentWidget>
    with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'DetailTicketScreen');
  bool isLoading = true;
  final _categoryService = CategoryService();
  final _categoryProvider = CategorySingeton();

  dynamic target;
  ActivityModel? activityModel;  // Mark as nullable

  String? address;  // Mark as nullable
  String? paymentBy;  // Mark as nullable
  String? actionName;  // Mark as nullable
  String? clientPhone;  // Mark as nullable
  String? description;  // Mark as nullable
  String? actionGroupName;  // Mark as nullable
  String? paymentAmount;  // Mark as nullable
  String actionAttributeName = '';
  String contactName = '';
  String contactMobile = '';
  String? ward = '';
  String? city = '';
  String? province = '';
  String contactAddress = '';
  String customerAttidute = '';

  String overdueReason = '';
  String financialSituation = '';
  String relativeIncome = '';
  String checkInTypeName = '';
  bool isShowCheckInType = false;

  bool showCity = false;
  PlaceContactTicketModel? placeContactTicketModel;
  ContactPersonTicketModel? contactPersonTicketModel;
  ContactByTicketModel? contactByTicketModel;
  ActionAttributeTicketModel? actionAttributeTicketModel;
  ActionSubAttributeModel? _actionSubAttributeModel;
  ActionSubAttributeModel? _actionIncomeAttributeModel;

  double? paymentUnit;
  DMSService _dmsService = DMSService();
  List<FileLocal> galleryItemHistoryLocal = [];
  List<FileLocal> gallerySelfieHistoryLocal = [];
  dynamic postAttachment = [];
  dynamic postSelfie = [];
  List<String> lstImage = [];
  List<String> lstSelfie = [];
  String? published;
  final _mapService = VietMapService();

  var offlineInfo;
  LatLng? position;

  String? providerNo;
  String? transRefNo;
  final _userInfoStore = getIt<UserInfoStore>();

  List<String?>? documentList = [];
  List<String> selfieList = [];
  @override
  initState() {
    activityModel = widget.activityModel;
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await handleFetchData();
  }

  Future<void> handleFetchData() async {
    try {
      await Future.delayed(Duration(milliseconds: 100));
      target = activityModel?.target;
      if (Utils.checkIsNull(activityModel?.published)) {
        published = activityModel?.published;
      }
      if (Utils.checkIsNull(target)) {
        target = target['originalValue'];
      }
      if (Utils.checkIsNull(target)) {
        target = target['inputData'];
      }
      var attachments = [];
      var selfies;

      if (Utils.checkIsNull(target)) {
        offlineInfo = target['offlineInfo'];
        placeContactTicketModel = new PlaceContactTicketModel();
        contactPersonTicketModel = new ContactPersonTicketModel();
        contactByTicketModel = new ContactByTicketModel();
        address = '';
        paymentBy = Utils.retunDataStr(target['paymentBy']);
        clientPhone = Utils.retunDataStr(target['clientPhone']);
        description = Utils.retunDataStr(target['description']);
        actionName = Utils.retunDataStr(target['actionName']);
        actionGroupName = Utils.retunDataStr(target['actionGroupName']);
        customerAttidute = Utils.retunDataStr(target['customerAttitude']);

        overdueReason = Utils.retunDataStr(target['overdueReason']);
        financialSituation = Utils.retunDataStr(target['financialSituation']);
        relativeIncome = Utils.retunDataStr(target['relativeIncome']);
        checkInTypeName = Utils.retunDataStr(target['checkInTypeName']);

        if (Utils.checkIsNotNull(checkInTypeName)) {
          isShowCheckInType = true;
        }

        providerNo = Utils.retunDataStr(target['providerNo']);
        transRefNo = Utils.retunDataStr(target['transRefNo']);

        if (Utils.checkIsNull(target['paymentAmount'])) {
          if (target['paymentAmount'] is int) {
            paymentAmount =
                Utils.formatPrice(target['paymentAmount'].toString());
          } else {
            paymentAmount =
                Utils.formatPrice(target['paymentAmount'].round().toString());
          }
        } else {
          paymentAmount = '';
        }

        paymentUnit = Utils.checkIsNull(target['paymentUnit'])
            ? target['paymentUnit']
            : null;

        if (target['fieldGeo'] != null) {
          address = Utils.retunDataStr(target['fieldGeo']['address']);
          // double lat = Utils.
          var latitude;
          var longitude;
          if (Utils.checkIsNotNull(target['fieldGeo']['latitude'])) {
            latitude = target['fieldGeo']['latitude'];
          }
          if (Utils.checkIsNotNull(target['fieldGeo']['longitude'])) {
            longitude = target['fieldGeo']['longitude'];
          }
          if (Utils.checkIsNotNull(latitude) &&
              Utils.checkIsNotNull(longitude)) {
            position = new LatLng(latitude, longitude);
          }
        }
        if (Utils.checkIsNotNull(target['attachment'])) {
          attachments = target['attachment'];
          documentList = (target['attachment'] as List?)
              ?.map((item) => item as String?)
              ?.toList();
        }
        if (Utils.checkIsNotNull(target['selfie'])) {
          List<String> selfiesTemp = [];
          if (target['selfie'].toString().contains('###')) {
            selfiesTemp = target['selfie'].split('###');
            selfieList = selfiesTemp;
            selfies = target['selfie'];
          } else {
            selfies = target['selfie'];
            selfieList.add(target['selfie']);
          }
        }
        Response response;
        var lstData;
        double? contactPlaceId = Utils.retunDataDouble(target['contactPlaceId']);
        if (Utils.checkIsNull(contactPlaceId)) {
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
        double? contactModeId = Utils.retunDataDouble(target['contactModeId']);
        if (Utils.checkIsNull(contactModeId)) {
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
        double? contactPersonId =
            Utils.retunDataDouble(target['contactPersonId']);
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

        double? actionAttributeId =
            Utils.retunDataDouble(target['actionAttributeId']);
        if (Utils.checkIsNull(actionAttributeId)) {
          if (_categoryProvider.getLstActionAttributeTicketModel.isNotEmpty) {
            getAttributeActionModel(
                _categoryProvider.getLstActionAttributeTicketModel,
                actionAttributeId);
          }
        }

        if (target['subAttributeId'] != null) {
          if (_categoryProvider?.actionSubAttributeModels?.isNotEmpty ??
              false) {
            getSubAttributeActionModel(
                _categoryProvider?.actionSubAttributeModels,
                target['subAttributeId']);
          }
        }
        if (target['subAttributeGroupId'] != null) {
          if (_categoryProvider?.actionSubAttributeModels?.isNotEmpty ??
              false) {
            getIncomeAttributeModell(
                _categoryProvider?.actionSubAttributeModels,
                target['subAttributeGroupId']);
          }
        }

        contactName = Utils.retunDataStr(target['contactName']);
        contactMobile = Utils.retunDataStr(target['contactMobile']);

        double? cityId = Utils.retunDataDouble(target['contactProvinceId']);
        double? provinceId = Utils.retunDataDouble(target['contactDistrictId']);
        double? wardId = Utils.retunDataDouble(target['contactWardId']);
        contactAddress = Utils.retunDataStr(target['contactAddress']);
        if ((Utils.checkIsNotNull(cityId) &&
            Utils.checkIsNotNull(provinceId))) {
          showCity = true;
          int? cityIdi = cityId!.toInt();
          int? provinceIdi = provinceId!.toInt();
          int? wardIdi;
          if (Utils.checkIsNotNull(wardId)) {
            wardIdi = wardId!.toInt();
          }
          var provinceData = this
              ._categoryProvider
              .getDataCityProvinceWard(cityIdi, provinceIdi, wardIdi);
          if (Utils.checkIsNotNull(provinceData)) {
            city = provinceData['city'];
            province = provinceData['province'];
            ward = provinceData['ward'];
          }
        }
      }
      isLoading = false;
      if (Utils.isArray(attachments) && !MyConnectivity.instance.isOffline) {
        lstImage.add('attachments');
      }
      if (Utils.isArray(selfies) && !MyConnectivity.instance.isOffline) {
        lstSelfie.add('selfies');
      }
      setState(() {});
      // if (Utils.isArray(attachments) && !MyConnectivity.instance.isOffline) {
      //   await getFileImages(attachments, ActionPhone.CAMERA);
      // }
      // if (Utils.isArray(selfies) && !MyConnectivity.instance.isOffline) {
      //   await getFileImages([selfies], ActionPhone.SELFIE);
      // }
    } catch (e) {
      isLoading = false;
      setState(() {});
      print(e);
    } finally {}
  }

  void getContactByPerson(lstData, double? contactPersonId) {
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

  void getAttributeActionModel(lstData, double? attributeId) {
    for (var data in lstData) {
      ActionAttributeTicketModel contact;
      if (data is ActionAttributeTicketModel) {
        contact = data;
      } else {
        contact = ActionAttributeTicketModel.fromJson(data);
      }
      if (contact.id == attributeId) {
        actionAttributeTicketModel = contact;
        actionAttributeName = actionAttributeTicketModel?.description ?? '';
        break;
      }
    }
  }

  void getSubAttributeActionModel(
      List<ActionSubAttributeModel>? lstData, double subAttributeId) {
    try {
      _actionSubAttributeModel =
          lstData?.lastWhere((element) => element.id == subAttributeId);
    } catch (_) {}
  }

  void getIncomeAttributeModell(
      List<ActionSubAttributeModel>? lstData, double subAttributeId) {
    try {
      _actionIncomeAttributeModel =
          lstData?.lastWhere((element) => element.id == subAttributeId);
    } catch (_) {}
  }

  void getContactByTicket(lstData, double? contactModeId) {
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

  void getPlaceContact(lstData, double? contactPlaceId) {
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

  requestClose(request) {
    return request.close();
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
    return documentList?.isNotEmpty ?? false
        ? Card(
            margin: EdgeInsets.only(left: 10, right: 10, top: 4.0, bottom: 0.0),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: Column(children: [
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 30, top: 0.0, bottom: 8.0),
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
              // (galleryItemHistoryLocal.isEmpty == true && lstImage.isEmpty == true)
              //     ? Container()
              //     : ConstrainedBox(
              //         constraints: BoxConstraints(maxHeight: 300.0, minHeight: 100.0),
              //         child: buildListImage(ActionPhone.CAMERA)),
              buildListImage(ActionPhone.CAMERA)
            ]),
          )
        : SizedBox();
  }

  Widget selfieWidget() {
    return selfieList.isNotEmpty ?? false
        ? Card(
            margin: EdgeInsets.only(left: 10, right: 10, top: 4.0, bottom: 0.0),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: Column(children: [
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 30, top: 0.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(S.of(context).selfie_check_in,
                        style: TextStyle(
                            fontSize: AppFont.fontSize16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Divider(
                color: AppColor.blackOpacity,
              ),
              ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: 300.0, minHeight: 100.0),
                  child: buildListImage(ActionPhone.SELFIE)),
            ]),
          )
        : SizedBox();
  }

  String? imageData;
  bool dataLoaded = false;

  Widget buildDocumentList() {
    return Visibility(
        visible: documentList?.isNotEmpty ?? false,
        child: Card(
          margin: EdgeInsets.only(left: 10, right: 10, top: 4.0, bottom: 0.0),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: new BorderRadius.circular(30.0),
          ),
          child: Column(children: [
            Container(
              margin:
                  EdgeInsets.only(left: 20, right: 30, top: 0.0, bottom: 8.0),
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
            buildListImage(ActionPhone.CAMERA)
          ]),
        ));
  }

  void _onViewAllPhotos(List<String?>? urls, int index) async {
    if (urls?.isEmpty ?? true) return;

    List<FileLocal> localFiles = [];
    for (var url in urls ??[]) {
      final file = await DefaultCacheManager().getFileFromMemory(
        url!,
      );
     if (file != null) {
        localFiles
            .add(FileLocal(file.originalUrl, file.originalUrl, file.file));
      }
    }

    NavigationService.instance.navigateToRoute(
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          dataPost: [],
          galleryItems: localFiles,
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget buildListImage(String type) {
    List<Widget> lstWidget = [];
    if (type == ActionPhone.CAMERA) {
      for (int index = 0; index < (documentList?.length??0); index++) {
        lstWidget.add(Padding(
            padding: EdgeInsets.only(left: 0.0, bottom: 8.0),
            child: Container(
                child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: InkWell(
                        onTap: () async {
                          _onViewAllPhotos(documentList, index);
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: AppCacheImage(
                                baseImgUrl: DMS_SERVICE_URL.DOWNLOAD_FILE,
                                identify: documentList![index]??'')),
                      ),
                    )))));
      }
    } else if (type == ActionPhone.SELFIE) {
      for (int index = 0; index < selfieList.length; index++) {
        lstWidget.add(Padding(
            padding: EdgeInsets.only(left: 0.0, bottom: 8.0),
            child: Container(
                child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: InkWell(
                        onTap: () async {
                          _onViewAllPhotos(selfieList, index);
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: AppCacheImage(
                                baseImgUrl: DMS_SERVICE_URL.DOWNLOAD_FILE,
                                identify: selfieList[index])),
                      ),
                    )))));
      }
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
      print(e);
      return NoDataWidget();
    }
  }

  Widget formDetailPayment(var target) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // cameraWidget(),
          selfieWidget(),
          Card(
              margin: EdgeInsets.all(7.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
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
                      // enabled: false,
                      initialValue: showTimeCheckIn(),
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'Thời gian checkin',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    InkWell(
                      child: TextFormField(
                        readOnly: true,
                        // enabled: false,
                        minLines: 1,
                        maxLines: 2,
                        initialValue: address,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.location_on,
                                color: Theme.of(context).primaryColor),
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: S.of(context).position,
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                      onTap: () async {
                        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
                          await _mapService.openMapViewLocationCheckin(
                            _scaffoldKey,
                            address ?? '',
                            context,
                            curentMarker: position,
                          );
                        }
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
                      initialValue: contactByTicketModel?.modeName,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: S.of(context).contactBy,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
                      initialValue: contactPersonTicketModel?.personName,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: S.of(context).contactWith,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
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
                      // enabled: false,
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
                      // enabled: false,
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
                        visible: actionAttributeName.length > 0,
                        child: TextFormField(
                          readOnly: true,
                          // enabled: false,
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
                    Visibility(
                      visible: _actionSubAttributeModel != null,
                      child: TextFormField(
                        readOnly: true,
                        // enabled: false,
                        initialValue: _actionSubAttributeModel?.description,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Nguyên nhân cụ thể thứ cấp',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isShowFieldAmount(target['loanAmount']),
                      child: TextFormField(
                        readOnly: true,
                        // enabled: false,
                        initialValue: parseAmountToString(target['loanAmount']),
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Thu nhập lúc mở khoản vay',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isShowFieldAmount(target['currentIncomeAmount']),
                      child: TextFormField(
                        readOnly: true,
                        // enabled: false,
                        initialValue:
                            parseAmountToString(target['currentIncomeAmount']),
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Thu nhập hiện tại',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _actionIncomeAttributeModel != null,
                      child: TextFormField(
                        readOnly: true,
                        // enabled: false,
                        initialValue: _actionIncomeAttributeModel?.description,
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText:
                              'Nguồn thu nhập/nghề nghiệp hiện tại của khách hàng',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isShowFieldAmount(target['lastIncomeAmount']),
                      child: TextFormField(
                        readOnly: true,
                        // enabled: false,
                        initialValue:
                            parseAmountToString(target['lastIncomeAmount']),
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Số tiền KH nhận từ khoản vay',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
                      initialValue: placeContactTicketModel?.placeName,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: S.of(context).contactPlace,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    Visibility(
                        visible: showCity,
                        child: TextFormField(
                            readOnly: true,
                            // enabled: false,
                            initialValue: city,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              labelText: 'Tỉnh/Thành phố *',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ))),
                    Visibility(
                        visible: showCity,
                        child: TextFormField(
                            readOnly: true,
                            // enabled: false,
                            initialValue: province,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              labelText: 'Quận/ Huyện/ Thị Xã',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ))),
                    Visibility(
                        visible: showCity,
                        child: TextFormField(
                            readOnly: true,
                            // enabled: false,
                            initialValue: ward,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              labelText: 'Xã/ Phường/ Thị Trấn',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ))),
                    Visibility(
                        child: TextFormField(
                          readOnly: true,
                          // enabled: false,
                          initialValue: contactAddress,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              labelText: "Địa chỉ ",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                        ),
                        visible: showCity),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
                      initialValue: paymentBy,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Họ tên",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    Visibility(
                        child: TextFormField(
                          readOnly: true,
                          // enabled: false,
                          initialValue: providerNo ?? '',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              labelText: "Phương thức thanh toán",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                        ),
                        visible: Utils.checkIsNotNull(providerNo)),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
                      initialValue: transRefNo ?? '',
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Mã giao dịch",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
                      initialValue: paymentAmount,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: "Số tiền",
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
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
                      // enabled: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: S.of(context).customerPhone,
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    TextFormField(
                      initialValue: customerAttidute,
                      readOnly: true,
                      // enabled: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Thái độ khách hàng',
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),
                    Visibility(child: TextFormField(
                      initialValue: overdueReason,
                      readOnly: true,
                      // enabled: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Nguyên nhân quá hạn',
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),visible:  Utils.isTenantTnex(_userInfoStore) ),
                    Visibility(child: TextFormField(
                      initialValue: financialSituation,
                      readOnly: true,
                      // enabled: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Tình trạng kinh tế hiện tại',
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),visible:  Utils.isTenantTnex(_userInfoStore) ),
                    Visibility(child: TextFormField(
                      initialValue: relativeIncome,
                      readOnly: true,
                      // enabled: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10.0),
                          labelText: 'Thông tin thu nhập của người thân',
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                    ),visible:  Utils.isTenantTnex(_userInfoStore) ),
                    Visibility(
                        child: TextFormField(
                          initialValue: checkInTypeName,
                          readOnly: true,
                          // enabled: false,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              labelText: 'Nguồn tiền thanh toán',
                              border: InputBorder.none,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                        ),
                        visible: isShowCheckInType),
                  ]))),
          Visibility(
            visible: offlineInfo != null,
            child: Card(
              margin: EdgeInsets.all(7.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: new BorderRadius.circular(30.0),
              ),
              child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 30, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(S.of(context).infomation + ' offline',
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
                      // enabled: false,
                      initialValue: handleOffInfoDataTime(),
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'Thời gian checkin ',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    TextFormField(
                      readOnly: true,
                      // enabled: false,
                      initialValue: handleOffInfoSubmitTime(),
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: 'Thời gian cập nhật lên hệ thống ',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: InputBorder.none,
                      ),
                    )
                  ])),
            ),
          )
        ]);
  }

  String handleOffInfoSubmitTime() {
    if (Utils.checkIsNotNull(offlineInfo)) {
      if (Utils.checkIsNotNull(offlineInfo['submitTime'])) {
        var submitTime = offlineInfo['submitTime'];
        if (submitTime is double) {
          submitTime = submitTime.toInt();
        }
        return Utils.convertTime(submitTime);
      }
    }
    return '';
  }

  String handleOffInfoDataTime() {
    if (Utils.checkIsNotNull(offlineInfo)) {
      if (Utils.checkIsNotNull(offlineInfo['dataTime'])) {
        var dataTime = offlineInfo['dataTime'];
        if (dataTime is double) {
          dataTime = dataTime.toInt();
        }
        return Utils.convertTime(dataTime);
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBarCommon(
            title: S.of(context).detail,
            lstWidget: [],
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
                  : formDetail(),
            ),
          ));
    } catch (e) {
      return Container();
    }
  }

  bool isShowFieldAmount(dynamic field) {
    try {
      int val = 0;
      if (field is int) {
        val = field;
      }
      if (field is double) {
        val = field.toInt();
      }

      if (field != null && val != 0) return true;

      return false;
    } catch (_) {
      return false;
    }
  }

  String showTimeCheckIn() {
    String offlineTime = this.handleOffInfoDataTime();
    if (offlineTime.isNotEmpty) {
      return offlineTime;
    }
    
    // Fix 2: Handle potential null or empty published value
    if (published == null || (published?.isEmpty ?? true)) {
      return '';
    }
    
    // Fix 3: Handle nullable return from convertTimeStampToDateEnhance
    int? convertedDate = Utils.convertTimeStampToDateEnhance(published?.toString()  ?? '');
    if (convertedDate == null) {
      return '';
    }
    
    // Fix 4: Handle nullable return from getTimeFromDate
    String? time = Utils.getTimeFromDate(convertedDate);
    return time ?? '';
  }

  String parseAmountToString(dynamic field) {
    try {
      if (field == null) {
        return '';
      }
      
      String amount;
      if (field is int) {
        amount = Utils.formatPrice(field.toString(), hasVND: true);
      } else if (field is double) {
        amount = Utils.formatPrice(field.round().toString(), hasVND: true);
      } else if (field is String && field.isNotEmpty) {
        // Try to parse as number if it's a string
        final num? parsedNum = num.tryParse(field);
        if (parsedNum != null) {
          amount = Utils.formatPrice(parsedNum.round().toString(), hasVND: true);
        } else {
          amount = field;
        }
      } else {
        // For any other type
        amount = field.toString();
      }
      
      return amount;
    } catch (e) {
      print('Error in parseAmountToString: $e');
      return '';
    }
  }

  @override
  void dispose() {
    galleryItemHistoryLocal = [];
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
