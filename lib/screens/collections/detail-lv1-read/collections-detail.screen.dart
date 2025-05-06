import 'package:athena/screens/collections/detail-lv1-read/widget/contractPaysche.widget.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/screens/collections/checkin/widgets/shimmerCheckIn.widget.dart';
import 'package:athena/screens/collections/collection.controller.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/utils.dart';
import '../../../common/constants/functionsScreen.dart';
import '../../../common/constants/general.dart';
import '../../../getit.dart';
import '../../../utils/common/internet_connectivity.dart';
import '../../../utils/global-store/user_info_store.dart';
import '../../../utils/offline/offline.service.dart';
import '../../../widgets/common/nodata.widget.dart';
import '../collections.service.dart';

// ignore: must_be_immutable
class CollectionDetailLv1ReadScreen extends StatelessWidget {
  CollectionDetailCaseController collectionDetailController =
      CollectionDetailCaseController();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(debugLabel: 'CollectionDetailLv1ReadScreen');
  final _userInfoStore = getIt<UserInfoStore>();
  final _collectionService = new CollectionService();
  goMap(String result, BuildContext context) {
    var ticketModel = collectionDetailController?.ticketModelParams;
    if (ticketModel == null) {
      return;
    }
    switch (result) {
      case 'cusFullAddress':
        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
          ticketModel.addressTypeId = ADDRESS_TYPE_ID.cusFullAddress;
          return _collectionService.actionGoVietMapPositionTypeId(
              ticketModel, ActionPhone.DIRECTION, context);
        }
        break;
      case 'permanentAddress':
        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
          ticketModel.addressTypeId = ADDRESS_TYPE_ID.permanentAddress;
          return _collectionService.actionGoVietMapPositionTypeId(
              ticketModel, ActionPhone.DIRECTION, context);
        }
        break;
      case 'companyAddress':
        if (OfflineService.isFeatureValid(FEATURE_APP.MAP)) {
          ticketModel.addressTypeId = ADDRESS_TYPE_ID.companyAddress;
          return _collectionService.actionGoVietMapPositionTypeId(
              ticketModel, ActionPhone.DIRECTION, context);
        }
        break;
      default:
        break;
    }
  }

  Widget customerInfomationWidget(BuildContext context) {
    try {
      if (collectionDetailController?.customerModel == null) {
        return Container();
      }
      return Card(
          child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text('Thông tin khách hàng',
              style: TextStyle(
                  fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
          children: <Widget>[
            TextFormField(
              // // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                      collectionDetailController?.customerModel?.fullName) ??
                  ' tên adđ',
              decoration: InputDecoration(
                  labelText: 'Tên khách hàng',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              readOnly: true,
              initialValue: collectionDetailController!
                  .returnData(collectionDetailController?.customerModel?.code),
              decoration: InputDecoration(
                  labelText: 'Mã khách hàng',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              // // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController?.customerModel?.gender,
                  field: "gender"),
              decoration: InputDecoration(
                  labelText: 'Giới tính',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              // // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.isTenantTnex(_userInfoStore)
                  ? Utils.handleExtrainfoData(
                      collectionDetailController
                          ?.contactNewModel?.extraInfo?.dOB!,
                      'date')
                  : Utils.convertTimeWithoutTime(
                      Utils.convertTimeStampToDateEnhance(
                              collectionDetailController
                                      ?.customerModel?.birthDate ??
                                  '') ??
                          0),
              decoration: InputDecoration(
                  labelText: 'Ngày sinh',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController!
                  .returnData(collectionDetailController?.customerModel?.idno),
              decoration: InputDecoration(
                  labelText: 'Số CMND',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.convertTimeWithoutTime(
                        Utils.convertTimeStampToDateEnhance(
                                collectionDetailController
                                        ?.customerModel?.idnoDate ??
                                    '') ??
                            0),
                    decoration: InputDecoration(
                        labelText: 'Ngày cấp CMND',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: collectionDetailController?.returnData(
                        collectionDetailController?.customerModel?.idnoPlace),
                    decoration: InputDecoration(
                        labelText: 'Nơi cấp CMND',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    initialValue: collectionDetailController?.returnData(
                        collectionDetailController!
                            .contactNewModel?.maritalStatus),
                    decoration: InputDecoration(
                        labelText: 'Tình trạng hôn nhân',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

// CCCD
            Visibility(
                child: TextFormField(
                  readOnly: true,
                  autofocus: false,
                  initialValue: Utils.handleExtrainfoData(
                      collectionDetailController!
                          .contactNewModel?.extraInfo?.CITIZEN_ID_NUMBER,
                      'string'),
                  decoration: InputDecoration(
                      labelText: 'Số CCCD',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                visible: Utils.isTenantTnex(_userInfoStore)),

            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.CITIZEN_ID_ISSUE_DATE,
                        'date'),
                    decoration: InputDecoration(
                        labelText: 'Ngày cấp CCCD',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.CITIZEN_ID_ISSUE_PLACE,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Nơi cấp CCCD',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.FB_NUMBER,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Số hộ khẩu',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.FB_OWNER,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Tên chủ hộ',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.ACT_MOBILE,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Điện thoại khách hàng',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            // Ngghe nghiep
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.cOMPANYNAME,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Tên nghề nghiệp',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.jOBDESCRIPTION,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Loại nghề nghiệp',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.oFFADDRESS,
                        ''),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: AppColor.primary,
                          icon: Icon(Icons
                              .location_city), // You can choose any icon you prefer
                          onPressed: () {
                            // Utils.openGoogleMaps(collectionDetailController
                            //     ?.contactNewModel?.extraInfo?.oFFADDRESS);
                            goMap('companyAddress', context);
                            // Define your action here
                          },
                        ),
                        labelText: 'Địa chỉ công ty',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.aCTADDRESS,
                        ''),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: AppColor.primary,
                          icon: Icon(
                              Icons.map), // You can choose any icon you prefer
                          onPressed: () {
                            goMap('cusFullAddress', context);
                            // Utils.openGoogleMaps(collectionDetailController
                            //     ?.contactNewModel?.extraInfo?.aCTADDRESS);
                            // Define your action here
                          },
                        ),
                        labelText: 'Địa chỉ tạm trú',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.ACT_PROVINCE,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Tỉnh tạm trú',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.aCTWARD,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Phường/Xã tạm trú',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.ACT_DISTRICT,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Quận/Huyện tạm trú',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.REG_ADDRESS,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Địa chỉ hộ khẩu',
                        suffixIcon: IconButton(
                          color: AppColor.primary,
                          icon: Icon(
                              Icons.home), // You can choose any icon you prefer
                          onPressed: () {
                            goMap('permanentAddress', context);
                            // Utils.openGoogleMaps(collectionDetailController
                            //     ?.contactNewModel??.extraInfo?.REG_ADDRESS);
                            // Define your action here
                          },
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.REG_PROVINCE,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Tỉnh hộ khẩu',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.REG_WARD,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Phường/Xã hộ khẩu',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

            Visibility(
                child: TextFormField(
                    readOnly: true,
                    autofocus: false,
                    maxLines: null,
                    initialValue: Utils.handleExtrainfoData(
                        collectionDetailController!
                            .contactNewModel?.extraInfo?.REG_DISTRICT,
                        ''),
                    decoration: InputDecoration(
                        labelText: 'Quận/Huyện hộ khẩu',
                        floatingLabelBehavior: FloatingLabelBehavior.always)),
                visible: Utils.isTenantTnex(_userInfoStore)),

            //

            Visibility(
                child: TextFormField(
                  readOnly: true,
                  initialValue: (Utils.checkIsNotNull(
                          collectionDetailController?.contractDto))
                      ? collectionDetailController?.returnData(
                          collectionDetailController?.contractDto['appId'])
                      : '',
                  decoration: InputDecoration(
                      labelText: 'Số khế ước vay (Mã số hồ sơ thẩm định)',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                visible: !Utils.isTenantTnex(_userInfoStore)),
            Visibility(
                child: TextFormField(
                  // // enabled: false,
                  readOnly: true,
                  autofocus: false,
                  initialValue: collectionDetailController?.returnData(
                      collectionDetailController!
                          .contactNewModel?.extraInfo?.jOBDESCRIPTION),
                  decoration: InputDecoration(
                      labelText: 'Mô tả công việc',
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                visible: !Utils.isTenantTnex(_userInfoStore)),
          ],
        ),
      ));
    } catch (e) {
      return Container();
    }
  }

  Widget infomationContactWidget() {
    if (Utils.isTenantTnex(_userInfoStore)) {
      return Container();
    }
    return Card(
        child: Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: ExpansionTile(
        title: Text('Thông tin liên hệ',
            style: TextStyle(
                fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
        children: [
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController?.customerModel?.fullName),
            decoration: InputDecoration(
                labelText: 'Tên khách hàng',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            readOnly: true,
            autofocus: false,
            minLines: 1,
            maxLines: null,
            initialValue: collectionDetailController?.tmpadd,
            decoration: InputDecoration(
                labelText: 'Địa chỉ tạm trú',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            readOnly: true,
            autofocus: false,
            minLines: 1,
            maxLines: null,
            initialValue: collectionDetailController?.pradd,
            decoration: InputDecoration(
                labelText: 'Địa chỉ hộ khẩu',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          // Divider(color: AppColor.blackOpacity),
          TextFormField(
            readOnly: true,
            autofocus: false,
            minLines: 1,
            maxLines: null,
            initialValue: collectionDetailController?.office,
            decoration: InputDecoration(
                labelText: 'Địa chỉ văn phòng KH',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController?.customerModel?.cellPhone),
            decoration: InputDecoration(
                labelText: 'Điện thoại khách hàng',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController
                    ?.contactNewModel?.extraInfo?.hOMENUM),
            decoration: InputDecoration(
                labelText: 'Điện thoại bàn',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController!
                    .contactNewModel?.extraInfo?.rEGPHONE),
            decoration: InputDecoration(
                labelText: 'Điện thoại 1',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController!
                    .contactNewModel?.extraInfo?.rEGMOBILE),
            decoration: InputDecoration(
                labelText: 'Điện thoại 2',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController!
                    .contactNewModel?.extraInfo?.aCTMPHONE),
            decoration: InputDecoration(
                labelText: 'Điện thoại 3',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController!
                    .contactNewModel?.extraInfo?.aCTMOBILE),
            decoration: InputDecoration(
                labelText: 'Điện thoại 4',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController!
                    .contactNewModel?.extraInfo?.fBNUMBER),
            decoration: InputDecoration(
                labelText: 'Số sổ hộ khẩu',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController
                    ?.contactNewModel?.extraInfo?.fBOWNER),
            decoration: InputDecoration(
                labelText: 'Tên chủ hộ',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController
                    ?.contactNewModel?.extraInfo?.rEMARKS),
            decoration: InputDecoration(
                labelText: 'Ghi chú',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController!
                    .contactNewModel?.extraInfo?.cOMPANYNAME),
            decoration: InputDecoration(
                labelText: 'Tên công ty',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),

          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController!
                .returnData(collectionDetailController?.contractForColure?.dpd),
            decoration: InputDecoration(
                labelText: 'Ngày quá hạn',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ],
      ),
    ));
  }

  Widget infomationLastEvent() {
    if (collectionDetailController?.contractDto == null) {
      return Container();
    }
    return Card(
        child: Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: ExpansionTile(
        title: Text('Thông tin về lần tác động gần nhất',
            style: TextStyle(
                fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
        children: [
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController?.returnData(
                collectionDetailController?.contractDto['assignedTo']),
            decoration: InputDecoration(
                labelText: 'Nhân viên tác động gần nhất',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          // Divider(color: AppColor.blackOpacity),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: Utils.formatPrice(collectionDetailController!
                .returnData(
                    collectionDetailController?.contractDto['totalPaidAmount'],
                    type: 'money')),
            decoration: InputDecoration(
                labelText: 'Tổng số tiền đã trả',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: Utils.formatPrice(collectionDetailController!
                .returnData(
                    collectionDetailController?.contractDto['overduefee'],
                    type: 'money')),
            decoration: InputDecoration(
                labelText: 'Phí quá hạn',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          // Divider(color: AppColor.blackOpacity),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: Utils.convertTimeWithoutTime(
                Utils.convertTimeStampToDateEnhance(collectionDetailController
                            ?.contractDto['lastPaymentDate'] ??
                        '') ??
                    0),
            decoration: InputDecoration(
                labelText: 'Ngày thanh toán gần nhất',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: Utils.formatPrice(collectionDetailController!
                .returnData(
                    collectionDetailController
                        ?.contractDto['lastPaymentAmount'],
                    type: 'money')),
            decoration: InputDecoration(
                labelText: 'Số tiền thanh toán gần nhất',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
          TextFormField(
            // // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController!
                .returnData(collectionDetailController?.contractDto['status']),
            decoration: InputDecoration(
                labelText: 'Trạng thái',
                floatingLabelBehavior: FloatingLabelBehavior.always),
          )
        ],
      ),
    ));
  }

  Widget recoveryInfo() {
    return Visibility(
      visible: _userInfoStore.checkPerimission(ScreenPermission.RECOVERY_FIELD),
      child: Card(
          child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 30, top: 20),
                  child: Text('RECOVERY',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                )),
            Divider(color: AppColor.blackOpacity),
            Visibility(
              visible:
                  collectionDetailController?.recoveryInfoData?.posBom != null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController?.recoveryInfoData?.posBom,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: 'Tổng nợ tại 181 ngày',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Visibility(
              visible:
                  collectionDetailController?.recoveryInfoData?.totalPaid !=
                      null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController?.recoveryInfoData?.totalPaid,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: 'Tổng tiền đã trả',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Visibility(
              visible:
                  collectionDetailController?.recoveryInfoData?.extantPos !=
                      null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController?.recoveryInfoData?.extantPos,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: 'Tổng nợ còn lại',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Visibility(
              visible:
                  collectionDetailController?.recoveryInfoData?.vat != null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController?.recoveryInfoData?.vat,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: 'Thuế giá trị gia tăng',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Visibility(
              visible:
                  collectionDetailController?.recoveryInfoData?.insuranceFee !=
                      null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController!
                            .recoveryInfoData?.insuranceFee,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: 'Phí Bảo hiểm',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Visibility(
              visible: collectionDetailController!
                      .recoveryInfoData?.totalOverdueNopos !=
                  null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController!
                            .recoveryInfoData?.totalOverdueNopos,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: 'Tổng lãi phí phạt',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Visibility(
              visible: collectionDetailController!
                      .recoveryInfoData?.totalOverdueNopos30 !=
                  null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController!
                            .recoveryInfoData?.totalOverdueNopos30,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: '30% tổng lãi phí phạt',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Visibility(
              visible:
                  collectionDetailController?.recoveryInfoData?.emi1 != null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController?.recoveryInfoData?.emi1,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: 'EMI',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
            Visibility(
              visible:
                  collectionDetailController?.recoveryInfoData?.lpi1 != null,
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                minLines: 1,
                maxLines: 3,
                initialValue: Utils.formatPrice(collectionDetailController!
                    .returnData(
                        collectionDetailController?.recoveryInfoData?.lpi1,
                        type: 'money')),
                decoration: InputDecoration(
                    labelText: 'LPI',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget otherInfomation() {
    try {
      List<Widget> listWidget = [];
      listWidget = [
        TextFormField(
          enabled: true,
          readOnly: true,
          autofocus: false,
          initialValue:
              (Utils.checkIsNotNull(collectionDetailController?.contractDto))
                  ? collectionDetailController?.returnData(
                      collectionDetailController?.contractDto['applId'])
                  : '',
          decoration: InputDecoration(
              labelText: 'Số hợp đồng',
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        Visibility(
            child: TextFormField(
              // // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                  collectionDetailController?.contractBasicModel?.product),
              decoration: InputDecoration(
                  labelText: 'Tên sản phẩm',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: (Utils.checkIsNotNull(
                      collectionDetailController?.contractDto))
                  ? collectionDetailController?.returnData(
                      collectionDetailController?.contractDto['appId'])
                  : '',
              decoration: InputDecoration(
                  labelText: 'APP ID',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.sECURITYDEPOSIT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Đưa trước',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        TextFormField(
          // // enabled: false,
          readOnly: true,
          autofocus: false,
          initialValue: Utils.returnData(
              collectionDetailController!
                  .contractDetailModel?.props?.lOANAMOUNT,
              type: 'money'),
          decoration: InputDecoration(
              labelText: 'Số tiền vay',
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        TextFormField(
          // // enabled: false,
          readOnly: true,
          autofocus: false,
          initialValue: Utils.returnData(
              collectionDetailController!
                  .contractDetailModel?.installmentAmtOverdue,
              type: 'money'),
          decoration: InputDecoration(
              labelText: 'Số tiền quá hạn',
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        TextFormField(
          // // enabled: false,
          readOnly: true,
          autofocus: false,
          initialValue: Utils.returnData(
              collectionDetailController!
                  .contractDetailModel?.props?.iNTERESTOVERDUE,
              type: 'money'),
          decoration: InputDecoration(
              labelText: 'Số tiền lãi tới hạn',
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        TextFormField(
          // enabled: false,
          readOnly: true,
          autofocus: false,
          initialValue: Utils.returnData(
              collectionDetailController!
                  .contractDetailModel?.props?.pRINCIPLEOUTSTANDING,
              type: 'money'),
          decoration: InputDecoration(
              labelText: 'Dư nợ gốc',
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractBasicModel?.interestoutstanding,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Dư nợ lãi',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.TO_COLLECT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Số tiền cần thanh toán đến thời điểm hiện tại',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.PERIOD_BUCKET,
                  type: ''),
              decoration: InputDecoration(
                  labelText: 'BUCKET đầu kỳ',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController?.contractDetailModel?.props?.CASA,
                  type: ''),
              decoration: InputDecoration(
                  labelText: 'Số tài khoản đóng tiền',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.INTEREST_PRODUCT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Lãi suất',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.CHANNEL,
                  type: ''),
              decoration: InputDecoration(
                  labelText: 'Kênh',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.RISK_SEGMENT,
                  type: ''),
              decoration: InputDecoration(
                  labelText: 'Phân loại rủi ro',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .briefByContractNo?.props?.PRINCIPLE_OVERDUE,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Gốc quá hạn',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .briefByContractNo?.props?.OTHER_CHARGES,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Khoản thu khác',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        // Visibility(
        //     child: TextFormField(
        //       // enabled: false,
        //       readOnly: true,
        //       autofocus: false,
        //       initialValue: Utils.returnData(
        //           collectionDetailController
        //               .briefByContractNo?.props?.TOTAL_REPAYMENT,
        //           type: 'money'),
        //       decoration: InputDecoration(
        //           labelText: 'Tổng số tiền đã thanh toán trong kỳ',
        //           floatingLabelBehavior: FloatingLabelBehavior.always),
        //     ),
        //     visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractBasicModel?.lastpaymentamount,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Số tiền đóng gần nhất',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractBasicModel?.totalpaidamount,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Tổng số tiền đã thanh toán cho HĐ',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .briefByContractNo?.props?.REMAIN_TOTAL,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Tổng tiền còn lại',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        // Visibility(
        //     child: TextFormField(
        //       // enabled: false,
        //       readOnly: true,
        //       autofocus: false,
        //       initialValue: Utils.returnData(
        //           collectionDetailController
        //               .briefByContractNo?.props?.BALANCE_AMOUNT,
        //           type: 'money'),
        //       decoration: InputDecoration(
        //           labelText: 'Số dư',
        //           floatingLabelBehavior: FloatingLabelBehavior.always),
        //     ),
        //     visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .briefByContractNo?.props?.LAST_PAYMENT_DATE,
                  type: 'date'),
              decoration: InputDecoration(
                  labelText: 'Ngày thanh toán gần nhất',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.END_DATE,
                  type: 'date'),
              decoration: InputDecoration(
                  labelText: 'Ngày kết thúc',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.DUE_DATE,
                  type: 'date'),
              decoration: InputDecoration(
                  labelText: 'Ngày đến hạn',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.NEXT_DUE_DATE,
                  type: 'date'),
              decoration: InputDecoration(
                  labelText: 'Ngày đến hạn tiếp theo',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .briefByContractNo?.props?.FIRST_DUE_DATE,
                  type: 'date'),
              decoration: InputDecoration(
                  labelText: 'Ngày đến hạn đầu tiên',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .briefByContractNo?.props?.DEBT_SALE_DATE,
                  type: 'date'),
              decoration: InputDecoration(
                  labelText: 'Ngày bán nợ',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .briefByContractNo?.props?.BALANCE_AMOUNT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Số dư',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.oTHERCHARGES,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Phí khác',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.pOSTYPE),
              decoration: InputDecoration(
                  labelText: 'Pos Type',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        TextFormField(
          // enabled: false,
          readOnly: true,
          autofocus: false,
          initialValue: collectionDetailController?.returnData(
              collectionDetailController?.contractDetailModel?.props?.tERM),
          decoration: InputDecoration(
              labelText: 'Số kỳ',
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.formatPrice(collectionDetailController!
                  .returnData(
                      collectionDetailController?.contractForColure?.penalty,
                      type: 'money')),
              decoration: InputDecoration(
                  labelText: 'Phí quá hạn',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.sCHEME),
              decoration: InputDecoration(
                  labelText: 'Scheme',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        TextFormField(
          // enabled: false,
          readOnly: true,
          autofocus: false,
          initialValue: Utils.convertTimeWithoutTime(
              Utils.convertTimeStampToDateEnhance(collectionDetailController!
                          .contractDetailModel?.props?.dEALDATE ??
                      '') ??
                  0),
          decoration: InputDecoration(
              labelText: 'Ngày giải ngân',
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.formatPrice(collectionDetailController!
                  .returnData(
                      collectionDetailController!
                          .briefByContractNo?.props?.DISBURSEMENT_AMT,
                      type: 'money')),
              decoration: InputDecoration(
                  labelText: 'Số tiền giải ngân',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                  collectionDetailController?.contractForColure?.dpd),
              decoration: InputDecoration(
                  labelText: 'Ngày quá hạn',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.bUCKET),
              decoration: InputDecoration(
                  labelText: 'Nhóm nợ',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.cCCODE),
              decoration: InputDecoration(
                  labelText: 'CC Code',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.cCNAME),
              decoration: InputDecoration(
                  labelText: 'CC Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.cCPHONE),
              decoration: InputDecoration(
                  labelText: 'CC Phone',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: collectionDetailController?.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.dUEDAY),
              decoration: InputDecoration(
                  labelText: 'Ngày góp hàng tháng',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.iNSTALLMENT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Số tiền góp hàng tháng',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.pENALTY,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Phạt',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.nOOFINSTOVERDUE),
              decoration: InputDecoration(
                  labelText: 'Số kỳ trễ hạn',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.convertTimeWithoutTime(
                  Utils.convertTimeStampToDateEnhance(
                          collectionDetailController!
                                  .contractDetailModel?.props?.fIRSTDUEDATE ??
                              '') ??
                      0),
              decoration: InputDecoration(
                  labelText: 'Kỳ góp đầu tiên',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.convertTimeWithoutTime(
                  Utils.convertTimeStampToDateEnhance(
                          collectionDetailController!
                                  .contractDetailModel?.props?.nEXTDUEDATE ??
                              '') ??
                      0),
              decoration: InputDecoration(
                  labelText: 'Kỳ góp tiếp theo',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.bUCKET),
              decoration: InputDecoration(
                  labelText: 'Bucket',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.pAIDTERM),
              decoration: InputDecoration(
                  labelText: 'Tổng kỳ đã trả',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.tOTALPAID,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Tổng tiền đã trả',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.nOTEDETAILS),
              decoration: InputDecoration(
                  labelText: 'Ghi chú khi duyệt hồ sơ',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.fIELDUW),
              decoration: InputDecoration(
                  labelText: 'Ghi chú khi duyệt hồ sơ (2)',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.pRODUCTGROUP),
              decoration: InputDecoration(
                  labelText: 'Nhóm sản phẩm',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.convertTimeWithoutTime(
                  Utils.convertTimeStampToDateEnhance(
                          collectionDetailController!
                                  .contractDetailModel?.props?.lASTDUEDATE ??
                              '') ??
                      0),
              decoration: InputDecoration(
                  labelText: 'Ngày hết hạn hợp đồng',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.cHARGEOFFFLAG),
              decoration: InputDecoration(
                  labelText: 'Charge off',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.convertTimeWithoutTime(
                  Utils.convertTimeStampToDateEnhance(
                          collectionDetailController!
                                  .contractDetailModel?.props?.cHARGEOFFDATE ??
                              '') ??
                      0),
              decoration: InputDecoration(
                  labelText: 'Ngày charge off',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController?.contractDetailModel?.props?.mOB),
              decoration: InputDecoration(
                  labelText: 'MOB',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.oLDCONTRACT1),
              decoration: InputDecoration(
                  labelText: 'Hợp đồng cũ 1',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.oLDCONTRACT2),
              decoration: InputDecoration(
                  labelText: 'Hợp đồng cũ 2',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.oLDCONTRACT3),
              decoration: InputDecoration(
                  labelText: 'Hợp đồng cũ 3',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.uNITCODE),
              decoration: InputDecoration(
                  labelText: 'Unit Code',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.uNITCODEDESC),
              decoration: InputDecoration(
                  labelText: 'Unit Code Desc',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.xLTamTru),
              decoration: InputDecoration(
                  labelText: 'XL Tam tru',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.fCCODE),
              decoration: InputDecoration(
                  labelText: 'FC Code',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.aGENCYNAME),
              decoration: InputDecoration(
                  labelText: 'Agency name',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.gROUPUSER),
              decoration: InputDecoration(
                  labelText: 'Group user',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.tYPEHD),
              decoration: InputDecoration(
                  labelText: 'Type HD',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.rEMOVEPHONE),
              decoration: InputDecoration(
                  labelText: 'Remove Phone',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.sOKYTT),
              decoration: InputDecoration(
                  labelText: 'SO_KY_TT',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController?.contractDetailModel?.props?.sLTT),
              decoration: InputDecoration(
                  labelText: 'SL TT',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.gROUPSLTT),
              decoration: InputDecoration(
                  labelText: 'Group SLTT',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.eSIGNFLAG),
              decoration: InputDecoration(
                  labelText: 'Esign flag',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.eSIGNTYPE),
              decoration: InputDecoration(
                  labelText: 'Esign type',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.eFFRATE),
              decoration: InputDecoration(
                  labelText: 'EFF rate',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.lASTDUEDAYPAYAMT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Last Dueday Pay Amt',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.nEWSEGMENT),
              decoration: InputDecoration(
                  labelText: 'New segment',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.convertTimeWithoutTime(
                  Utils.convertTimeStampToDateEnhance(
                          collectionDetailController!
                                  .contractDetailModel?.props?.dEBTSALEDATES ??
                              '') ??
                      0),
              decoration: InputDecoration(
                  labelText: 'Debt sale dates',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.cHECKINTPOS),
              decoration: InputDecoration(
                  labelText: 'Kiểm tra điều kiện lãi quá hạn và dư nợ gốc',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.wAIVEINT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Lãi/Phí được giảm',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.nEWINT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Lãi/Phí tính lại',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractDetailModel?.props?.nEWAMOUNT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Tổng nợ mới sau tính toán',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractDetailModel?.props?.resolved_cnt),
              decoration: InputDecoration(
                  labelText: 'Tình trạng thu hồi khoản vay',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.convertTimeWithoutTime(
                  Utils.convertTimeStampToDateEnhance(
                          collectionDetailController!
                                  .contractDetailModel?.props?.fIRSTDUEDATE ??
                              '') ??
                      0),
              decoration: InputDecoration(
                  labelText: 'Nhóm KH First Payment Default',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
        Visibility(
            child: TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: '',
              decoration: InputDecoration(
                  labelText: 'Roll pos',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            visible: !Utils.isTenantTnex(_userInfoStore)),
      ];
      return Card(
          child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: ExpansionTile(
            title: Text('Thông tin hợp đồng',
                style: TextStyle(
                    fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
            children: listWidget),
      ));
    } catch (e) {
      return Container();
    }
  }

  Widget referenceInfomation() {
    try {
      return Card(
          child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: ExpansionTile(
            title: Text('Thông tin tham chiếu',
                style: TextStyle(
                    fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
            children: lstReferenceInfomation()),
      ));
    } catch (e) {
      return Container();
    }
  }

  List<Widget> lstReferenceInfomation() {
    List<Widget> listWidget = [];
    try {
      List<Map<String, dynamic>> fields = [];
      if (Utils.isTenantTnex(_userInfoStore)) {
        fields = [
          {'label': 'Tên người tham chiếu 1', 'data': 'REF1_NAME'},
          {'label': 'Số điện thoại người tham chiếu 1', 'data': 'REF1_NUMBER'},
          {
            'label': 'Mối quan hệ người tham chiếu 1',
            'data': 'REF1_RELATIONSHIP'
          },
          {'label': 'Địa chỉ người tham chiếu 1', 'data': 'REF1_WORKADD'},
          {'label': 'Tên người tham chiếu 2', 'data': 'REF2_NAME'},
          {'label': 'Số điện thoại người tham chiếu 2', 'data': 'REF2_NUMBER'},
          {
            'label': 'Mối quan hệ người tham chiếu 2',
            'data': 'REF2_RELATIONSHIP'
          },
          {'label': 'Địa chỉ người tham chiếu 2', 'data': 'REF2_WORKADD'},
        ];
      } else {
        fields = [
          {'label': 'Số điện thoại người thân 2', 'data': 'FATHER_NUM'},
          {'label': 'Số điện thoại người thân 3', 'data': 'SISTER_NUM'},
          {'label': 'Số điện thoại người thân 4', 'data': 'BROTHER_NUM'},
          {'label': 'Số điện thoại người thân 5', 'data': 'FRIEND_NUM'},
          {'label': 'Số điện thoại người thân 6', 'data': 'BROTHERINLAW_NUM'},
          {'label': 'Số điện thoại người thân 7', 'data': 'MOBILE_NUM'},
          {'label': 'Số điện thoại người thân 8', 'data': 'THIRDPERSON_NUM'},
          {'label': 'Số điện thoại người thân 9', 'data': 'UNCLE_NUM'},
          {'label': 'Số điện thoại người thân 10', 'data': 'OTHERRELATION_NUM'},
          {
            'label': 'Số điện thoại người thân 11',
            'data': 'CLOSEDRELATION_NUM'
          },
          {'label': 'Số điện thoại người thân 12', 'data': 'DAUGHTER_NUM'},
          {'label': 'Số điện thoại người thân 13', 'data': 'SON_NUM'},
          {'label': 'Số điện thoại người thân 14', 'data': 'SPOUSENUM'},
          {'label': 'Số điện thoại người thân 15', 'data': 'PER3RD_NUM'},
          {'label': 'Số điện thoại người thân 16', 'data': 'REL1_NUM'},
          {'label': 'Số điện thoại người thân 17', 'data': 'REL2_NUM'},
          {'label': 'Số điện thoại người thân 18', 'data': 'REL3_NUM'},
          {'label': 'Số điện thoại người thân 19', 'data': 'PHONE_NOTE1'},
          {'label': 'Số điện thoại người thân 20', 'data': 'PHONE_NOTE2'},
          {'label': 'Số điện thoại người thân 21', 'data': 'PHONE_PORTAL1'},
          {'label': 'Số điện thoại người thân 22', 'data': 'PHONE_PORTAL2'},
          {'label': 'Số điện thoại người thân 23', 'data': 'PHONE_MEMO1'},
          {'label': 'Số điện thoại người thân 24', 'data': 'PHONE_MEMO2'},
          {'label': 'Phone all', 'data': 'PHONE_ALL'}
        ];
      }
      fields.forEach((field) {
        // print(field);
        //       print(field['data']);
        //  print(collectionDetailController?.customerModel.extraInfo[field['data']]);
        listWidget.add(TextFormField(
          // enabled: false,
          readOnly: true,
          autofocus: false,
          maxLines: null,
          initialValue: Utils.returnData(collectionDetailController!
              .customerModel?.extraInfo[field['data']]),
          decoration: InputDecoration(
              labelText: field['label'],
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ));
      });

      return listWidget;
    } catch (e) {
      return listWidget;
    }
  }

  Widget tsdbInfomation() {
    try {
      if (Utils.isTenantTnex(_userInfoStore)) {
        return Container();
      }
      return Card(
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: ExpansionTile(
                title: Text('Thông tin TSĐB',
                    style: TextStyle(
                        fontSize: AppFont.fontSize16,
                        fontWeight: FontWeight.bold)),
                children: <Widget>[
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: collectionDetailController?.returnData(
                        collectionDetailController!
                            .contractBasicModel?.props?.pRODUCT),
                    decoration: InputDecoration(
                        labelText: 'Mã sản phẩm',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: collectionDetailController?.returnData(
                        collectionDetailController!
                            .contractBasicModel?.props?.pRODUCTGROUP),
                    decoration: InputDecoration(
                        labelText: 'Product scheme',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.returnData(collectionDetailController!
                        .contractBasicModel?.props?.cDLDESC),
                    decoration: InputDecoration(
                        labelText: 'Mã sản phẩm điện máy',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.returnData(
                        collectionDetailController!
                            .contractBasicModel?.props?.pRICE,
                        type: 'money'),
                    decoration: InputDecoration(
                        labelText: 'Giá',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.returnData(collectionDetailController!
                        .contractBasicModel?.props?.bIKETYPE),
                    decoration: InputDecoration(
                        labelText: 'Loại xe',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.returnData(collectionDetailController!
                        .contractBasicModel?.props?.bIKENAME),
                    decoration: InputDecoration(
                        labelText: 'Tên xe',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.returnData(collectionDetailController!
                        .contractBasicModel?.props?.cOLOR),
                    decoration: InputDecoration(
                        labelText: 'Màu xe',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.returnData(collectionDetailController!
                        .contractBasicModel?.props?.eNGINENO),
                    decoration: InputDecoration(
                        labelText: 'Số máy',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: Utils.returnData(collectionDetailController!
                        .contractBasicModel?.props?.mRCNUMBER),
                    decoration: InputDecoration(
                        labelText: 'Cavet xe',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  TextFormField(
                    // enabled: false,
                    readOnly: true,
                    autofocus: false,
                    initialValue: collectionDetailController?.returnData(
                        collectionDetailController!
                            .contractBasicModel?.props?.mRCSTATUS),
                    decoration: InputDecoration(
                        labelText: 'Tình trạng cavet',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  )
                ],
              )));
    } catch (e) {
      return Container();
    }
  }

  bool showWidgetContractPaysche() {
    if (collectionDetailController?.tenantCode == 'TNEX') {
      return true;
    }
    return false;
  }

  Widget contractPayscheWidget(context) {
    try {
      if ((collectionDetailController?.lstContractPaysche?.length ?? 0) <= 0) {
        return Card(
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: ExpansionTile(
                    title: Text('Lịch thanh toán',
                        style: TextStyle(
                            fontSize: AppFont.fontSize16,
                            fontWeight: FontWeight.bold)),
                    children: [NoDataWidget()])));
      }
      return Card(
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: ExpansionTile(
                  title: Text('Lịch thanh toán',
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                  children: [
                    Container(
                      width: AppState.getWidthDevice(context),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ContactPayscheWidget(
                                value: collectionDetailController!
                                    .lstContractPaysche![index]);
                          },
                          separatorBuilder: (context, index) {
                            return Container();
                          },
                          itemCount: collectionDetailController!
                                  .lstContractPaysche?.length ??
                              0),
                    )
                  ])));
    } catch (e) {
      return NoDataWidget();
    }
  }

  Widget paymentInfomration() {
    try {
      if (Utils.isTenantTnex(_userInfoStore)) {
        return Card(
            child: Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: ExpansionTile(
            title: Text('Thông tin thanh toán',
                style: TextStyle(
                    fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
            children: [
              TextFormField(
                // enabled: false,
                readOnly: true,
                autofocus: false,
                initialValue: Utils.convertTimeWithoutTime(
                    Utils.convertTimeStampToDateEnhance(
                            collectionDetailController!
                                    .contractDetailModel?.props?.nEXTDUEDATE ??
                                '') ??
                        0),
                decoration: InputDecoration(
                    labelText: 'Ngày đến hạn',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextFormField(
                // enabled: false,
                readOnly: true,
                autofocus: false,
                initialValue: Utils.returnData(
                    collectionDetailController!
                        .contractDetailModel?.props?.iNSTALLMENT,
                    type: 'money'),
                decoration: InputDecoration(
                    labelText: 'Số tiền thanh toán hàng tháng',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextFormField(
                // enabled: false,
                readOnly: true,
                autofocus: false,
                initialValue: Utils.returnData(
                    collectionDetailController?.contractDetailModel?.dpd),
                decoration: InputDecoration(
                    labelText: 'Ngày quá hạn',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
              TextFormField(
                // enabled: false,
                readOnly: true,
                autofocus: false,
                initialValue: Utils.returnData(
                    collectionDetailController!
                        .contractDetailModel?.props?.nEWAMOUNT,
                    type: 'money'),
                decoration: InputDecoration(
                    labelText: 'Tổng nợ mới sau tính toán',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
              ),
            ],
          ),
        ));
      }
      return Card(
          child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: ExpansionTile(
          title: Text('Thông tin thanh toán',
              style: TextStyle(
                  fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
          children: [
            TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.convertTimeWithoutTime(
                  Utils.convertTimeStampToDateEnhance(
                          collectionDetailController!
                                  .contractForColure?.props?.lASTPAY ??
                              '') ??
                      0),
              decoration: InputDecoration(
                  labelText: '3 lần trả gần nhất',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractForColure?.props?.lASTPAYMENTAMT,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Số tiền đóng gần nhất',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.convertTimeWithoutTime(
                  Utils.convertTimeStampToDateEnhance(
                          collectionDetailController!
                                  .contractForColure?.props?.lASTPAYDATE ??
                              '') ??
                      0),
              decoration: InputDecoration(
                  labelText: 'Lần đóng tiền gần nhất',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractForColure?.props?.lASTPAY2),
              decoration: InputDecoration(
                  labelText: 'Last pay date 2',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(collectionDetailController!
                  .contractForColure?.props?.nGAYTRAKY1),
              decoration: InputDecoration(
                  labelText: 'Ngày trả kỳ 1',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextFormField(
              // enabled: false,
              readOnly: true,
              autofocus: false,
              initialValue: Utils.returnData(
                  collectionDetailController!
                      .contractForColure?.props?.sOTIENTRAKY1,
                  type: 'money'),
              decoration: InputDecoration(
                  labelText: 'Số tiền trả kỳ 1',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
          ],
        ),
      ));
    } catch (e) {
      return Container();
    }
  }

  Widget contractTypeWidget() {
    return Card(
        child: Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text('Loại hợp đồng',
            style: TextStyle(
                fontSize: AppFont.fontSize16, fontWeight: FontWeight.bold)),
        children: <Widget>[
          TextFormField(
            // enabled: false,
            readOnly: true,
            autofocus: false,
            initialValue: collectionDetailController!
                .returnData(collectionDetailController?.ticketModel?.feType),
            decoration: InputDecoration(
                labelText: 'Loại hợp đồng chi tiết',
                border: InputBorder.none,
                floatingLabelBehavior: FloatingLabelBehavior.always),
          ),
        ],
      ),
    ));
  }

  Widget formDetail(context) {
    try {
      return ListView(children: [
        Card(
            // elevation: 5,
            child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Column(children: [
                  TextFormField(
                    // // // enabled: false,
                    readOnly: true,
                    // autofocus: false,
                    initialValue:
                        collectionDetailController?.ticketModel?.contractId,
                    decoration: InputDecoration(
                        labelText: 'ID',
                        border: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  Visibility(
                      child: TextFormField(
                        // // // enabled: false,
                        readOnly: true,
                        // autofocus: false,
                        initialValue: Utils.retunDataStr(
                            collectionDetailController!
                                .ticketModel?.idCardNumber),
                        decoration: InputDecoration(
                            labelText: 'Card Number',
                            border: InputBorder.none,
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                      visible: Utils.checkIsNotNull(collectionDetailController!
                          .ticketModel?.idCardNumber)),
                ]))),
        contractTypeWidget(),
        customerInfomationWidget(context),
        infomationContactWidget(),
        infomationLastEvent(),
        recoveryInfo(),
        otherInfomation(),
        referenceInfomation(),
        tsdbInfomation(),
        paymentInfomration(),
        Visibility(
          child: contractPayscheWidget(context),
          visible: showWidgetContractPaysche(),
        )
      ]);
    } catch (e) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller nếu chưa có
    collectionDetailController = Get.put(CollectionDetailCaseController());

    final args = Get.arguments;
    final params = args?['params'];
    final params2 = args?['params2'];

    // Gán ticketModelParams nếu chưa có
    collectionDetailController?.ticketModelParams ??= params;

    // Nếu đang offline và chưa có ticketModel, thì gán từ params
    if (MyConnectivity.instance.isOffline &&
        collectionDetailController?.ticketModel == null) {
      collectionDetailController?.ticketModel = params;
    }

    // Gán briefByContractNo nếu chưa có
    collectionDetailController?.briefByContractNo ??= params2;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
        title: const Text('Chi tiết hợp đồng'),
        backgroundColor: AppColor.appBar,
      ),
      body: GetBuilder<CollectionDetailCaseController>(
        id: 'CollectionDetailCaseController',
        builder: (controller) {
          if (controller.isLoading) {
            return SizedBox(
              height: AppState.getHeightDevice(context),
              width: AppState.getWidthDevice(context),
              child: const ShimmerCheckIn(),
            );
          }

          // return formDetail(context);
          return ListView(children: [
            Card(
                // elevation: 5,
                child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      TextFormField(
                        // // // enabled: false,
                        readOnly: true,
                        // autofocus: false,
                        initialValue:
                            collectionDetailController?.ticketModel?.contractId,
                        decoration: InputDecoration(
                            labelText: 'ID',
                            border: InputBorder.none,
                            floatingLabelBehavior:
                                FloatingLabelBehavior.always),
                      ),
                      Visibility(
                          child: TextFormField(
                            // // // enabled: false,
                            readOnly: true,
                            // autofocus: false,
                            initialValue: Utils.retunDataStr(
                                collectionDetailController!
                                    .ticketModel?.idCardNumber),
                            decoration: InputDecoration(
                                labelText: 'Card Number',
                                border: InputBorder.none,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                          visible: Utils.checkIsNotNull(
                              collectionDetailController!
                                  .ticketModel?.idCardNumber)),
                    ]))),
            contractTypeWidget(),
            customerInfomationWidget(context),
            infomationContactWidget(),
            infomationLastEvent(),
            recoveryInfo(),
            otherInfomation(),
            referenceInfomation(),
            tsdbInfomation(),
            paymentInfomration(),
            Visibility(
              child: contractPayscheWidget(context),
              visible: showWidgetContractPaysche(),
            )
          ]);
        },
      ),
    );
  }

  Widget kalapaInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 30, top: 20),
                  child: Text('Thông tin Facebook',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                )),
            Divider(color: AppColor.blackOpacity),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 30, top: 15),
                  child: Text('Thông tin Sổ hộ khẩu',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                )),
            Divider(color: AppColor.blackOpacity),
            //ticket 1293 hide BHXH info
            Visibility(
              visible: false,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 0, right: 30, top: 20),
                        child: Text('Thông tin BHXH',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: AppFont.fontSize16,
                                fontWeight: FontWeight.bold)),
                      )),
                  Divider(color: AppColor.blackOpacity),
                ],
              ),
            ),

            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 30, top: 20),
                  child: Text('Thông tin nhà mạng',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: AppFont.fontSize16,
                          fontWeight: FontWeight.bold)),
                )),
            Divider(color: AppColor.blackOpacity),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmptyData() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 5),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey[350]?.withOpacity(.5),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Text(
            'Không có dữ liệu',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
