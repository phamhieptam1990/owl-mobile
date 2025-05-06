import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/models/events.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/services/camera.service.dart';
import 'package:athena/utils/services/dms.service.dart';
import 'package:athena/utils/services/savefile.service.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/camera/camera.screen.dart';
import 'package:athena/widgets/common/common.dart';
import '../../common/config/app_config.dart';
import '../../utils/log/crashlystic_services.dart';
import '../../utils/storage/storage_helper.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AfterLayoutMixin {
  final _appState = new AppState();
  final _ticketService = new DMSService();
  final _cameraService = new CameraService();
  final _saveFileService = new SaveFileService();
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'ProfileScreen');
  bool isLoadComplete = false;
  static final String path = AppStateConfigConstant.PLACE_HOLDER_IMAGE;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: WidgetCommon.flexibleSpaceAppBar(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  // FutureBuilder<String>(
                  //   future: _getInitAvatar(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot?.connectionState == ConnectionState.done) {
                  //       return Container(
                  //         width: double.infinity,
                  //         child: AvatarImgNetwork(
                  //             baseImgUrl: DMS_SERVICE_URL.GET_AVARTAR,
                  //             isShowProgress: false,
                  //             identify: snapshot?.data,
                  //             hasIdentifyer: false,
                  //             fit: BoxFit.fill,
                  //             errorWidget: (_, __, ___) => Image.asset(
                  //                   AppStateConfigConstant.PLACE_HOLDER_IMAGE,
                  //                 )),
                  //       );
                  //     }
                  //     return SizedBox();
                  //   },
                  // ),
                  Align(
                    alignment: Alignment(0, 0.8),
                    child: MaterialButton(
                      minWidth: 0,
                      elevation: 0.5,
                      color: Colors.white,
                      child: Icon(
                        Icons.camera,
                        color: AppColor.primary,
                        size: 35,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: () async {
                        await selfie();
                      },
                    ),
                  ),
                ],
              ),
            ),
            UserInfo(),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              child: Text("Thoát"),
              color: AppColor.primary,
              onPressed: () {
                Utils.popPage(context);
              },
              textColor: Colors.white,
              minWidth: 300.0,
              padding: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future selfie() async {
    try {
      final result = await NavigationService.instance.navigateToRoute(
        MaterialPageRoute(builder: (context) => CameraScreen(false, true)),
      );
      if (Utils.checkIsNotNull(result)) {
        cropImage(result);
      }
    } catch (e) {}
  }

  Future<String> _getInitAvatar() async {
    final userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    return '?username=' + userName;
  }

  Future<Null> cropImage(File image) async {
    try {
      final croppedFile = await this._saveFileService.cropImage(image);
      WidgetCommon.showLoading();
      var key = croppedFile?.path.split('/').last;
      var value = croppedFile?.path ?? '';
      final FormData formData = new FormData.fromMap({
        "fileName": key,
        "file": await MultipartFile.fromFile(value, filename: key)
      });
      // final resposeCheckFace = await responseCheckFace(croppedFile);
      final resposeCheckFace = true;
      if (resposeCheckFace) {
        final response = await _ticketService.uploadFileAvartar(formData);
        WidgetCommon.dismissLoading();
        if (response.data != null && response.data['status'] == 0) {
          this._appState.pathFileAvatar = value;
          this._appState.isCheckShowAvatarComplete = true;
          this.isLoadComplete = true;
          await CachedNetworkImage.evictFromCache(await _avtUrl());

          eventBus.fire(ReloadAvatar(true));
          setState(() {});
          return;
        } else {
          WidgetCommon.showSnackbar(_scaffoldKey, 'Không thể upload avatar');
        }
      } else {
        WidgetCommon.dismissLoading();
      }
        } catch (e) {
      WidgetCommon.dismissLoading();
      CrashlysticServices.instance.log(e.toString());
    }
  }

  Future<String> _avtUrl() async {
    final userName =
        await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
    return DMS_SERVICE_URL.GET_AVARTAR + '?username=' + userName;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    if (this._appState.isCheckShowAvatarComplete) {
      if (this._appState.pathFileAvatar.isEmpty) {
        this._appState.pathFileAvatar =
            await _saveFileService.getPathFileAvatar();
      }
      isLoadComplete = true;
      setState(() {});
    }
  }
}

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = new AppState();
    final userInfo = appState.getUserInfoStore();
    final moreInfo = appState.getMoreInfoUserInfoStore();
    try {
      if (Utils.checkIsNotNull(moreInfo) && Utils.checkIsNotNull(userInfo)) {
        return Container(
          padding: EdgeInsets.all(7),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                alignment: Alignment.topLeft,
                child: Text(
                  "Thông tin",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Card(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ...ListTile.divideTiles(
                            color: Colors.grey,
                            tiles: [
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                leading: Icon(Icons.person),
                                title: Text("Họ và tên"),
                                subtitle: Text(userInfo.fullName),
                              ),
                              ListTile(
                                leading: Icon(Icons.email),
                                title: Text("Email"),
                                subtitle: Text(userInfo.username),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_balance),
                                title: Text("Mã nhân viên"),
                                subtitle: Text(moreInfo['empCode']),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
      return Container();
    } catch (e) {
      return Container();
    }
  }
}
