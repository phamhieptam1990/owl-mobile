import 'dart:convert';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:athena/screens/login/components/background.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/loading.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/models/deviceInfo.model.dart';
import 'package:athena/screens/collections/checkin/show_toturial_manager.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/login/login.service.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/internet_connectivity.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/idie/idieActivity.service.dart';
import 'package:athena/utils/services/geolocation.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/login_animation.dart';

import '../../getit.dart';
import '../../utils/common/tracking_installing_device.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin, AfterLayoutMixin {
  AnimationController? _loginButtonController;
  String? username, password;
  final _homeProvider = getIt<HomeProvider>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formLoginKey = new GlobalKey<FormState>();
  final _loginService = new LoginService();
  final _appState = AppState();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'LoginScreenState');
  final _userInfoStore = getIt<UserInfoStore>();
  bool autovalidate = false;
  final FocusNode focusNodeEmailLogin = FocusNode();
  final FocusNode focusNodePasswordLogin = FocusNode();
  bool isLoading = false;
  bool isAvailableApple = false;
  bool isVisiblePassword = false;
  bool isAndroid = true;
  String typeOS = APP_CONFIG.ANDROID;
  String imei = '';
  DeviceInfo? deviceInfo ;
  GeoPositionBackgroundService _geoPositionBackgroundService =
      new GeoPositionBackgroundService();

  TrackingInstallingDevice _trackingInstallingDevice =
      TrackingInstallingDevice();
  @override
  void initState() {
    super.initState();
    _loginButtonController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    if (Platform.isIOS) {
      isAndroid = false;
    }
    typeOS = isAndroid ? APP_CONFIG.ANDROID : APP_CONFIG.IOS;
    IdieActivity.instance.isLogout = true;
    IdieActivity.instance.isLoginPage = true;
    // AppSessionManager.stopListening();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    try {
      isAvailableApple = false;
      final userName =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME);
      // final token =
      //     await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN);
      await StorageHelper.setBool(AppStateConfigConstant.IS_FIRST_ENTER, true);
      // if (Utils.checkIsNotNull(userName) && Utils.checkIsNotNull(token)) {
      //   Utils.pushAndRemoveUntil( RouteList.LOGIN_IDILE_SCREEN);
      //   return;
      // }
      if (userName != null) {
        _usernameController.text = userName.toString();
      }

      // Future.delayed(Duration(seconds: 1), () {
      //   handleCheckinLocation();
      // });
    } catch (e) {}
  }

  Future<void> checkLogin() async {}

  @override
  void dispose() {
    _loginButtonController?.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController?.forward();
    } on TickerCanceled {}
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController?.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {}
  }

  Future<void> handleCheckinLocation() async {
    if (_geoPositionBackgroundService.initTracking == false) {
      final isInitBackground = await StorageHelper.getBool(
          AppStateConfigConstant.INIT_BACKGROUND_PERMISSION);
      if (!Utils.checkIsNotNull(isInitBackground)) {
        WidgetCommon.generateDialogOKCancelGet(
          'Athena Owl thu nhập dữ liệu vị trí của bạn để tính toán quãng đường bạn di chuyển từ đó sẽ đề ra những hợp đồng phù hợp với bạn nhất sau này.',
          callbackOK: () async {
            await StorageHelper.setBool(
                AppStateConfigConstant.INIT_BACKGROUND_PERMISSION, true);
            await _geoPositionBackgroundService.handlePermission();
          },
        );
      }
    }
  }

  Future<dynamic> onLogin(BuildContext context) async {
    String username = _usernameController.text.trim().toLowerCase();
    String password = _passwordController.text;

    if (username == '' || password == '') {
      return null;
      // return null;
    }

    try {
      FocusScope.of(context).unfocus();
      bool checkdevice = await buildDetectSomething(context);
      if (!checkdevice) {
        return null;
      }
      Position positionTemp;
      // Position positionTemp =
      //     await PermissionAppService.getCurrentPositionLogin();
      // if (positionTemp == null) {
      //   return null;
      // }
      await _playAnimation();
      final res = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      // await _stopAnimation();
      if (res.isSignedIn) {
        await StorageHelper.setString(
            AppStateConfigConstant.USER_NAME, username);
        await StorageHelper.setString(
            AppStateConfigConstant.USER_TOKEN, password);
        await setToken();
      }
      if (Utils.checkIsNotNull(res.nextStep)) {
        final nextStep = res.nextStep;
        if (nextStep?.signInStep == 'CONFIRM_SIGN_IN_WITH_NEW_PASSWORD') {
          final resConfirm =
              await Amplify.Auth.confirmSignIn(confirmationValue: password);
          if (Utils.checkIsNotNull(resConfirm.isSignedIn)) {
            await StorageHelper.setString(
                AppStateConfigConstant.USER_NAME, username);
            await StorageHelper.setString(
                AppStateConfigConstant.USER_TOKEN, password);
            await setToken();
          }
        }
      }

      // await _stopAnimation();
      await StorageHelper.setString(AppStateConfigConstant.USER_NAME, username);
      await StorageHelper.setString(
          AppStateConfigConstant.USER_TOKEN, password);
      await onGetToken(positionTemp: null);
    } on AuthException catch (e) {
      if (e.message.contains('is already a user signed in') ||
          e.message.contains('is already a user which is signed in') ||
          e.message.contains('signed in')) {
        await Amplify.Auth.signOut(
            options: const SignOutOptions(globalSignOut: false));
        await onLogin(context);
        return;
      } else if (e.message.contains('user is not authorized.') ||
          e.message.contains('Incorrect username or password.')) {
        await _stopAnimation();
        WidgetCommon.showSnackbarErrorGet(
            'Thông tin đăng nhập không đúng, vui lòng kiểm tra lại!');
        return;
      } else {
        await _stopAnimation();
        await Amplify.Auth.signOut(
            options: const SignOutOptions(globalSignOut: false));
        // onLogin();
      }
      // return WidgetCommon.showSnackbarErrorGet(context,S.of(context).tryagain);
    } catch (e) {
      await _stopAnimation();
      print(e);
    }
  }

 Future<void> setToken() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      if (session is CognitoAuthSession && session.isSignedIn) {
        final tokens = session.userPoolTokensResult.value;

        _appState.accessToken = tokens.accessToken.raw;
        _appState.idToken = tokens.idToken.raw;
        _appState.refreshToken = tokens.refreshToken;
_appState.isFirstEnter = true;
        await StorageHelper.setString(
            TokenConstant.ACCESS_TOKEN, tokens.accessToken.raw);
        await StorageHelper.setString(
            TokenConstant.ID_TOKEN, tokens.idToken.raw);
        await StorageHelper.setString(
            TokenConstant.REFRESH_TOKEN, tokens.refreshToken);
      } else {
        debugPrint("User chưa đăng nhập hoặc session không hợp lệ");
      }
    } catch (e, stack) {
      debugPrint("Lỗi lấy token: $e\n$stack");
    }
  }

  Future onGetToken({String picture = '', Position? positionTemp}) async {
    // await isSignedIn();
    try {
      String username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME) ?? '';
      String password =
          await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN) ?? '';
      final dataToken = await _loginService.getToken(context, _appState.idToken,
          _appState.accessToken, deviceInfo, positionTemp);
      if (Utils.checkIsNotNull(dataToken)) {
        final data = dataToken.data;
        _appState.serverToken = data['id_token'].trim();
        await StorageHelper.setString(
            TokenConstant.SERVER_TOKEN, _appState.serverToken);

        await StorageHelper.setString(
            AppStateConfigConstant.JWT, _appState.serverToken);
        Response responseUserInfo = await this
            ._loginService
            .getUserInfo(username, _appState.serverToken);
        if (responseUserInfo.data != null) {
          await _stopAnimation();
          final userInfoTemo = Utils.setUserInfo(responseUserInfo);
          if (userInfoTemo == null) {
            return;
          }
          _userInfoStore.updateUser(userInfoTemo);
          final newJson = jsonEncode(responseUserInfo.data);
          await StorageHelper.setString(
              AppStateConfigConstant.USER_INFO, newJson);
          await StorageHelper.setString(AppStateConfigConstant.TENANT_CODE,
              responseUserInfo.data['moreInfo']['tenantCode']);
          await StorageHelper.setString(
              AppStateConfigConstant.USER_NAME, username);
          await StorageHelper.setString(
              AppStateConfigConstant.USER_TOKEN, password);
          StorageHelper.setInt(AppStateConfigConstant.LOGIN_TIME,
              DateTime.now().millisecondsSinceEpoch);
          StorageHelper.setInt(AppStateConfigConstant.COUNT_LOGIN_OFFLINE, 1);
          IdieActivity.instance.initIdieActivity();
          //Login o create a user to collection data on firebase store
          // await FirebaseAuthServices.instance.tryToLogin(username);

          _homeProvider.setIsLogined = true;
          // IdieActivity.instance.setTimerModel();
          IdieActivity.instance.isLogout = false;
          IdieActivity.instance.isLoginPage = false;
          // AppSessionManager.startListening();

          ShowTutorialManager.resetShowTutorialWhenLogin();

          final bool time = await AppState.checkTime(context, null);
          if (!time) {
            await _stopAnimation();
            return;
          }
          GeoPositionBackgroundService geoPositionBackgroundService =
              new GeoPositionBackgroundService();
          geoPositionBackgroundService.getFirstPositionWhenInApp();
          // _trackingInstallingDevice.writeAppInstalled();
          Utils.pushAndRemoveUntil(RouteList.TAB_SCREEN);

          return;
        }

        Utils.pushAndRemoveUntil(RouteList.TAB_SCREEN);
      }
    } catch (e) {
      WidgetCommon.dismissLoading();
      await _stopAnimation();
      WidgetCommon.showSnackbarErrorGet('Vui lòng thử lại!');
      print(e);
    }
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
            child: Container(
          padding: EdgeInsets.all(50.0),
          child: kLoadingWidget(context),
        ));
      },
    );
  }

  void hideLoading() {
    Navigator.of(context).pop();
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void toggleShowPassword() {
    setState(() {
      isVisiblePassword = !isVisiblePassword;
    });
  }

  Widget body(context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 5,
                          child: Image.asset("assets/images/logo_text.png"),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: 32),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Expanded(
                      flex: 8,
                      child: Form(
                        key: _formLoginKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              focusNode: focusNodeEmailLogin,
                              controller: _usernameController,
                              validator: (val) => Utils.isRequire(context, val ?? ''),
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (term) {
                                fieldFocusChange(context, focusNodeEmailLogin,
                                    focusNodePasswordLogin);
                                onLogin(context);
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 215, 233, 216),
                                  iconColor: Color.fromRGBO(56, 142, 60, 1),
                                  prefixIconColor:
                                      Color.fromRGBO(56, 142, 60, 1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.person),
                                  ),
                                  hintText: S.of(context).email,
                                  hintStyle: TextStyle(fontSize: 17.0)),
                            ),
                            const SizedBox(height: 15.0),
                            Stack(children: <Widget>[
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                focusNode: focusNodePasswordLogin,
                                controller: _passwordController,
                                obscureText: isVisiblePassword ? false : true,
                                validator: (val) => val == null || val.length < 8
                                    ? "Mật khẩu không được ít hơn 8 ký tự"
                                    : null,
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 215, 233, 216),
                                  iconColor: Color.fromRGBO(56, 142, 60, 1),
                                  prefixIconColor:
                                      Color.fromRGBO(56, 142, 60, 1),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.lock),
                                  ),
                                  hintText: S.of(context).password,
                                  hintStyle: const TextStyle(fontSize: 17.0),
                                  suffixIcon: GestureDetector(
                                    onTap: toggleShowPassword,
                                    child: Icon(
                                      isVisiblePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20.0,
                                      color: AppColor.appBarOn,
                                    ),
                                  ),
                                ),
                                onFieldSubmitted: (term) {
                                  // _login(context);
                                  onLogin(context);
                                },
                              )
                            ]),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: () async {
                                    WidgetCommon.openPage(
                                        APP_CONFIG.LINK_CHANGE_PASS,
                                        _scaffoldKey);
                                  },
                                  child: Text(
                                    "Quên mật khẩu",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontWeight: FontWeight.w700,
                                        fontSize: AppFont.fontSize15),
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            StaggerAnimation(
                              titleButton: S.of(context).login.toUpperCase(),
                              buttonController: _loginButtonController?.view
                                  as AnimationController,
                              onTap: () {
                                onLogin(context);
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Text(S.of(context).copy_right +
                                  " - " +
                                  Utils.showVersionApp()),
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(bottom: 10.0),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
Future<bool> buildDetectSomething(BuildContext context) async {
    if (!await PermissionAppService.detectAppMockLocation(
      context,
    )) return false;

    if (!kDebugMode) {
      if (await PermissionAppService.isDeveloperMode()) return false;
    }
    if (deviceInfo == null) {
     final  deviceInfoTemp  = await Utils.getDeviceInfo(isAndroid);
      final udid = await FlutterUdid.udid;

      // Kiểm tra null và device thật (chỉ khi release mode)
      if (Utils.checkIsNotNull(deviceInfoTemp)) {
        if (deviceInfoTemp?.isPhysicalDevice == false && kReleaseMode) {
          await WidgetCommon.generateDialogOKGet(
            content: 'Ứng dụng không hỗ trợ thiết bị của bạn',
          );
          return false;
        }
      }

      String version = '';
      String manufacturer = '';
      String? iosModel;

      if (isAndroid == true) {
        const flatform = 'isAndroid';
        final model = deviceInfoTemp?.model ?? '';
        final hardware = deviceInfoTemp?.hardware ?? '';
        final metaData = 'UserDevice($flatform, $model, $hardware, $username)';
        final bytesImei = utf8.encode(metaData);
        final hashImei = sha256.convert(bytesImei);

        imei = hashImei.toString();
        version = deviceInfoTemp?.version?.release ?? '';
        manufacturer = deviceInfoTemp?.manufacturer ?? '';
      } else {
        const flatform = 'isIphone';
        final machineId = deviceInfoTemp?.utsname?.machine ?? 'iPhone';
        iosModel = machineId;

        imei = udid;
        version = deviceInfoTemp?.systemVersion ?? '';
        manufacturer = deviceInfoTemp?.systemName ?? '';
      }

      deviceInfo = DeviceInfo(
        imei: imei,
        model: iosModel ?? deviceInfoTemp?.model ?? '',
        typeOS: typeOS,
        manufacter: manufacturer,
        deviceModel: iosModel ?? deviceInfoTemp?.model ?? '',
        version: version,
      );

      AppState.setDeviceInfo(deviceInfo);

      await StorageHelper.setString(
        AppStateConfigConstant.DEVICE_INFO,
        Utils.encodeJSONToString(deviceInfo),
      );
       return true;
    }


    if (MyConnectivity.instance.isOffline) {
      final passwordS =
          await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN);
      if (Utils.checkIsNotNull(passwordS)) {
        // Gioi han so lan login offline
        bool isLoginSuccess = false;
        final loginTime =
            await StorageHelper.getInt(AppStateConfigConstant.LOGIN_TIME);
        int? limtCountLoginOffline = await StorageHelper.getInt(
            AppStateConfigConstant.COUNT_LOGIN_OFFLINE)??0;
        if (Utils.checkIsNotNull(limtCountLoginOffline)) {
          if (limtCountLoginOffline > APP_CONFIG.LIMIT_LOGIN_OFFLINE) {
            WidgetCommon.showSnackbar(
                this._scaffoldKey, S.of(context).Login_Offline_Over_Limit);
            return false;
          }
          limtCountLoginOffline += 1;
        }
        if (Utils.checkIsNotNull(loginTime)) {
          DateTime now = DateTime.now();
          final dateLoginTime = Utils.converLongToDate(loginTime!);
          if (now.day != dateLoginTime.day ||
              now.month != dateLoginTime.month) {
             WidgetCommon.showSnackbar(
                this._scaffoldKey, S.of(context).Login_Offline_Failed);
                return false;
          }
        }
        final usernameS =
            await StorageHelper.getString(AppStateConfigConstant.USER_NAME);
        if (password == passwordS && username == usernameS) {
          isLoginSuccess = true;
        }
        if (isLoginSuccess) {
          await StorageHelper.setInt(AppStateConfigConstant.COUNT_LOGIN_OFFLINE,
              limtCountLoginOffline);
          _homeProvider.setIsLogined = true;
          IdieActivity.instance.isLogout = false;
          IdieActivity.instance.isFirstTime = true;
          IdieActivity.instance.isLoginPage = false;

          Utils.pushAndRemoveUntil(RouteList.TAB_SCREEN);
          return false;
        } else {
          WidgetCommon.showSnackbar(
              this._scaffoldKey, S.of(context).Login_Failed);
        }
        return false;
      } else {
        WidgetCommon.showSnackbar(this._scaffoldKey,
            'Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại');
        return false;
      }
    }

    return true;
  }
  // Future<bool> buildDetectSomething(BuildContext context) async {
  //   if (!await PermissionAppService.detectAppMockLocation(
  //     context,
  //   )) return false;

  //   if (!kDebugMode) {
  //     if (await PermissionAppService.isDeveloperMode()) return false;
  //   }

  //   if (MyConnectivity.instance.isOffline) {
  //     final passwordS =
  //         await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN);
  //     if (Utils.checkIsNotNull(passwordS)) {
  //       // Gioi han so lan login offline
  //       bool isLoginSuccess = false;
  //       final loginTime =
  //           await StorageHelper.getInt(AppStateConfigConstant.LOGIN_TIME);
  //       int limtCountLoginOffline = await StorageHelper.getInt(
  //           AppStateConfigConstant.COUNT_LOGIN_OFFLINE) ?? 0;
  //       if (Utils.checkIsNotNull(limtCountLoginOffline)) {
  //         if (limtCountLoginOffline > APP_CONFIG.LIMIT_LOGIN_OFFLINE) {
  //           WidgetCommon.showSnackbar(
  //               this._scaffoldKey, S.of(context).Login_Offline_Over_Limit);
  //           return false;
  //         }
  //         limtCountLoginOffline += 1;
  //       }
  //       if (loginTime != null && Utils.checkIsNotNull(loginTime)) {
  //         DateTime now = DateTime.now();
  //         final dateLoginTime = Utils.converLongToDate(loginTime);
  //         if (now.day != dateLoginTime.day ||
  //             now.month != dateLoginTime.month) {
  //           WidgetCommon.showSnackbar(
  //               _scaffoldKey, S.of(context).Login_Offline_Failed);
  //           return false;
  //         }
  //       }
  //       final usernameS =
  //           await StorageHelper.getString(AppStateConfigConstant.USER_NAME);
  //       if (password == passwordS && username == usernameS) {
  //         isLoginSuccess = true;
  //       }
  //       if (isLoginSuccess) {
  //         await StorageHelper.setInt(AppStateConfigConstant.COUNT_LOGIN_OFFLINE,
  //             limtCountLoginOffline);
  //         _homeProvider.setIsLogined = true;
  //         IdieActivity.instance.isLogout = false;
  //         IdieActivity.instance.isFirstTime = true;
  //         IdieActivity.instance.isLoginPage = false;

  //         Utils.pushAndRemoveUntil(RouteList.TAB_SCREEN);
  //         return false;
  //       } else {
  //         WidgetCommon.showSnackbar(
  //             this._scaffoldKey, S.of(context).Login_Failed);
  //       }
  //       return false;
  //     } else {
  //       WidgetCommon.showSnackbar(this._scaffoldKey,
  //           'Bạn hiện không có kết nối mạng, vui lòng kiểm tra lại');
  //       return false;
  //     }
  //   }

  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
