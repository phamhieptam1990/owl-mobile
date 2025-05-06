import 'dart:convert';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/screens/login/components/background.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:athena/common/config/fonts.dart';
import 'package:athena/common/constants/color.dart';
import 'package:athena/common/constants/general.dart';
import 'package:athena/common/constants/loading.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/generated/l10n.dart';
import 'package:athena/screens/home/home.provider.dart';
import 'package:athena/screens/login/login.service.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/common/permission._app.service.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'package:athena/utils/idie/idieActivity.service.dart';
import 'package:athena/utils/storage/storage_helper.dart';
import 'package:athena/utils/utils.dart';
import 'package:athena/widgets/common/common.dart';
import 'package:athena/widgets/common/login_animation.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:geolocator/geolocator.dart';

import '../../getit.dart';
import '../../models/deviceInfo.model.dart';
import '../../utils/common/tracking_installing_device.dart';

class IdileLogin extends StatefulWidget {
  IdileLogin({Key? key}) : super(key: key);

  @override
  IdileLoginState createState() => new IdileLoginState();
}

class IdileLoginState extends State<IdileLogin>
    with TickerProviderStateMixin, AfterLayoutMixin {
  final _appState = new AppState();

  AnimationController? _loginButtonController;
  final _homeProvider = getIt<HomeProvider>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formLoginKey = new GlobalKey<FormState>();
  final _loginService = new LoginService();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'IdileLoginState');
  final _userInfoStore = getIt<UserInfoStore>();

  final FocusNode focusNodePasswordLogin = FocusNode();
  bool isLoading = false;
  bool isVisiblePassword = false;
  int countLogin = 0;
  bool isLoginFingerPrint = false;
  bool isDontSupportBiometric = false;

  TrackingInstallingDevice _trackingInstallingDevice =
      TrackingInstallingDevice();
  @override
  void initState() {
    super.initState();
    _loginButtonController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    // AppSessionManager.stopListening();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    try {
      final username =
          await StorageHelper.getString(AppStateConfigConstant.USER_NAME)??'';
      isDontSupportBiometric =
          await StorageHelper.getBool(AppStateConfigConstant.FINGER_LOGIN) ??
              false;
      IdieActivity.instance.isLoginPage = true;
      if (this._appState.isShowTitleUpdate &&
          this._appState.titleUpdateApp.length > 0) {
        this._appState.isShowTitleUpdate = false;
        // this._appState.titleUpdateApp = '';
        WidgetCommon.generateDialogOKGet(
            title: S.of(context).update_newversion,
            content: this._appState.titleUpdateApp,
            callback: () {
              this._appState.titleUpdateApp = '';
              if (Platform.isAndroid) {
                if (IS_PRODUCTION_APP) {
                  WidgetCommon.openPage(
                      Utils.getLinkDownLoadAppAndroid(), _scaffoldKey);
                } else {
                  FlutterExitApp.exitApp(iosForceExit: true);
                }
              } else if (Platform.isIOS) {
                FlutterExitApp.exitApp(iosForceExit: true);
                // WidgetCommon.openPage(
                //     Utils.getLinkDownLoadAppIOS(), _scaffoldKey);
              }
            },
            textBtnClose: S.of(context).btOk);
        _usernameController.text = username ?? '';
        setState(() {});
        return;
      }
      _usernameController.text = username ?? '';
      setState(() {});
      if (!Utils.checkIsNotNull(username)) {
          Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
        return;
      }
    
    } catch (e) {
      print(e);
      Utils.pushAndRemoveUntil(RouteList.LOGIN_SCREEN);
    }
  }

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

  Future<dynamic> onLogin() async {
    String username = _usernameController.text.trim().toLowerCase();
    String password = _passwordController.text;
    if (this.isLoginFingerPrint == false) {
      password = this._passwordController.text;
      if (username == '' || password == '') {
        return null;
      }
    } else {
      password =
          await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN) ??
              '';
    }
    if (username == '' || password == '') {
      return null;
    }
    try {
      FocusScope.of(context).unfocus();
      await _playAnimation();
      final res = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
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
      await onGetToken();
    } on AuthException catch (e) {
      if (e.message.contains('is already a user signed in') ||
          e.message.contains('is already a user which is signed in') || e.message.contains('signed in')) {
        await Amplify.Auth.signOut(
            options: const SignOutOptions(globalSignOut: false));
        await onLogin();
        return;
      } else if (e.message.contains('user is not authorized.') ||
          e.message.contains('Incorrect username or password.')) {
        await _stopAnimation();
        WidgetCommon.showSnackbarErrorGet(
            'Vui lòng kiểm tra thông tin đăng nhập!');
        return;
      } else {
        await _stopAnimation();
        await Amplify.Auth.signOut(
            options: const SignOutOptions(globalSignOut: false));
        // await onLogin();
        return;
      }
    } catch (e) {
      await _stopAnimation();
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
          await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN) ??
              '';
      final deviceInfo =
          await StorageHelper.getString(AppStateConfigConstant.DEVICE_INFO);
      DeviceInfo? deviceInfoTemp = null;
      if (deviceInfo != null) {
        deviceInfoTemp =
            DeviceInfo.fromJson(Utils.decodeJSONToString(deviceInfo));
        AppState.setDeviceInfo(deviceInfoTemp);
      }
      Position? positionTemp = null;
      // Position positionTemp =
      //     await PermissionAppService.getCurrentPositionLogin();
      // if (positionTemp == null) {
      //   await _stopAnimation();
      //   return null;
      // }
      final dataToken = await _loginService.getToken(context, _appState.idToken,
          _appState.accessToken, deviceInfoTemp, positionTemp);
      // await WidgetCommon.dismissLoading();
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
          var userInfoTemo = Utils.setUserInfo(responseUserInfo);
          if (userInfoTemo == null) {
            return;
          }
          _userInfoStore.updateUser(userInfoTemo);
          var newJson = jsonEncode(responseUserInfo.data);
          await StorageHelper.setString(
              AppStateConfigConstant.USER_INFO, newJson);
          await StorageHelper.setString(AppStateConfigConstant.TENANT_CODE,
              responseUserInfo.data['moreInfo']['tenantCode']);
          await StorageHelper.setString(
              AppStateConfigConstant.USER_NAME, username);
          IdieActivity.instance.initIdieActivity();
          await StorageHelper.setString(
              AppStateConfigConstant.USER_TOKEN, password);
          StorageHelper.setInt(AppStateConfigConstant.LOGIN_TIME,
              DateTime.now().millisecondsSinceEpoch);
          StorageHelper.setInt(AppStateConfigConstant.COUNT_LOGIN_OFFLINE, 1);

          // Login o create a user to collection data on firebase store
          // await FirebaseAuthServices.instance.tryToLogin(username);

          _homeProvider.setIsLogined = true;
          // IdieActivity.instance.setTimerModel();
          IdieActivity.instance.isLogout = false;
          IdieActivity.instance.isLoginPage = false;
          // AppSessionManager.startListening();

          final bool time = await AppState.checkTime(context, null);
          if (!time) {
            await _stopAnimation();
            return;
          }
          Utils.pushAndRemoveUntil(RouteList.TAB_SCREEN);
          return;
        }

        Utils.pushAndRemoveUntil(RouteList.TAB_SCREEN);
      }
    } catch (e) {
      await _stopAnimation();
      WidgetCommon.dismissLoading();
      WidgetCommon.showSnackbarErrorGet('Vui lòng thử lại!');
      print(e);
    }
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
                            Center(
                                child: Text(_usernameController.text.toString(),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white))),
                            const SizedBox(height: 15.0),
                            Stack(children: <Widget>[
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                focusNode: focusNodePasswordLogin,
                                controller: _passwordController,
                                obscureText: isVisiblePassword ? false : true,
                                validator: (val) {
                                  if (val == null || val.length < 8) {
                                    return S.of(context).Pass_vaditor_char;
                                  }
                                  return null;
                                },
                                style: TextStyle(
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
                                  hintText: S.of(context).password,
                                  hintStyle: TextStyle(fontSize: 17.0),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.lock),
                                  ),
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
                                  onLogin();
                                },
                              )
                            ]),
                            const SizedBox(
                              height: 15,
                            ),
                            StaggerAnimation(
                              titleButton: S.of(context).signIn,
                              buttonController: _loginButtonController!,
                              onTap: () {
                                if (!isLoading) {
                                  final form = _formLoginKey.currentState;
                                  if (form != null && form.validate()) {
                                    form.save();
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    // _login(context);
                                    onLogin();
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Visibility(
                                visible: isDontSupportBiometric == true,
                                child: TextButton(
                                  onPressed: () async {
                                    await loginBiometric();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.qr_code_scanner_rounded,
                                        color: AppColor.primary,
                                        size: 22.0,
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'Mở khóa bằng vân tay',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 52, 131, 79),
                                            fontSize: AppFont.fontSize16),
                                      ),
                                    ],
                                  ),
                                )),
                            Visibility(
                                visible: isDontSupportBiometric == true,
                                child: SizedBox(
                                  height: 15.0,
                                )),
                            TextButton(
                                onPressed: () {
                                  WidgetCommon.generateDialogOKCancelGet(
                                      'Bạn sẽ mất dữ liệu, khi đăng xuất ra khỏi thiết bị?',
                                      title: 'Cảnh báo',
                                      callbackOK: () {
                                        this._appState.logOutNew();
                                        // FirebaseAuthServices.instance.logout();
                                        Utils.pushAndRemoveUntil(
                                            RouteList.LOGIN_SCREEN);
                                      },
                                      callbackCancel: () => {});
                                },
                                child: Text(
                                  'Đăng nhập bằng tài khoản khác',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 52, 131, 79),
                                      fontSize: AppFont.fontSize16),
                                )),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Text(
                                S.of(context).copy_right +
                                    " - " +
                                    Utils.showVersionApp(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 52, 131, 79)),
                              ),
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

  @override
  Widget build(BuildContext context) {
    return body(context);
    // return Scaffold(
    //   key: _scaffoldKey,
    //   // resizeToAvoidBottomPadding: false,
    //   resizeToAvoidBottomInset: false,
    //   body: Container(
    //     height: AppState.getHeightDevice(context),
    //     child: Stack(
    //       children: [
    //         ClipPath(
    //           clipper: OvalBottomBorderClipper(),
    //           child: Container(
    //             height: 250,
    //             decoration: BoxDecoration(
    //                 gradient: LinearGradient(
    //                     begin: Alignment.topCenter,
    //                     colors: [
    //                   Colors.green[900],
    //                   Colors.green[600],
    //                   Colors.green[400]
    //                 ])),
    //             child: Center(
    //               child: _title(),
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //             top: 150,
    //             height: 500,
    //             width: MediaQuery.of(context).size.width,
    //             child: Container(
    //               decoration: BoxDecoration(
    //                   color: AppColor.backgroundGrey,
    //                   borderRadius: const BorderRadius.only(
    //                       topLeft: Radius.circular(40),
    //                       topRight: Radius.circular(40))),
    //               child: new Form(
    //                 key: _formLoginKey,
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   child: Column(
    //                     children: <Widget>[
    //                       Padding(
    //                         padding: EdgeInsets.all(20.0),
    //                         child: Column(children: [
    //                           SizedBox(height: 10.0),
    //                           Center(
    //                               child: Text(
    //                             "Phiên đăng nhập",
    //                             style: TextStyle(
    //                                 fontSize: 25,
    //                                 color: AppColor.primary,
    //                                 fontWeight: FontWeight.w700),
    //                           )),
    //                           SizedBox(height: 30.0),
    //                           Center(
    //                               child: Text(
    //                                   _usernameController.text.toString(),
    //                                   style: TextStyle(
    //                                       fontSize: 16.0,
    //                                       color: Color(0xff11998e)))),
    //                           SizedBox(height: 20.0),
    //                           Stack(children: <Widget>[
    //                             TextFormField(
    //                               textInputAction: TextInputAction.done,
    //                               focusNode: focusNodePasswordLogin,
    //                               controller: _passwordController,
    //                               obscureText: isVisiblePassword ? false : true,
    //                               validator: (val) => val.length < 8
    //                                   ? S.of(context).Pass_vaditor_char
    //                                   : null,
    //                               style: TextStyle(
    //                                   fontSize: 16.0, color: Colors.black),
    //                               decoration: InputDecoration(
    //                                 icon: Icon(
    //                                   Icons.lock,
    //                                   size: 22.0,
    //                                   color: AppColor.appBarOn,
    //                                 ),
    //                                 hintText: S.of(context).password,
    //                                 hintStyle: TextStyle(fontSize: 17.0),
    //                                 suffixIcon: GestureDetector(
    //                                   onTap: toggleShowPassword,
    //                                   child: Icon(
    //                                     isVisiblePassword
    //                                         ? Icons.visibility_off
    //                                         : Icons.visibility,
    //                                     size: 20.0,
    //                                     color: AppColor.appBarOn,
    //                                   ),
    //                                 ),
    //                               ),
    //                               onFieldSubmitted: (term) {
    //                                 // _login(context);
    //                                 onLogin();
    //                               },
    //                             )
    //                           ]),
    //                           SizedBox(
    //                             height: 30.0,
    //                           ),
    //                           StaggerAnimation(
    //                             titleButton: S.of(context).signIn,
    //                             buttonController: _loginButtonController.view,
    //                             onTap: () {
    //                               if (!isLoading) {
    //                                 final form = _formLoginKey.currentState;
    //                                 if (form.validate()) {
    //                                   form.save();
    //                                   FocusScope.of(context)
    //                                       .requestFocus(new FocusNode());
    //                                   // _login(context);
    //                                   onLogin();
    //                                 }
    //                               }
    //                             },
    //                           ),
    //                           SizedBox(
    //                             height: 20.0,
    //                           ),
    //                           Visibility(
    //                               visible: isDontSupportBiometric == true,
    //                               child: TextButton(
    //                                 onPressed: () async {
    //                                   await loginBiometric();
    //                                 },
    //                                 child: Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.center,
    //                                   children: [
    //                                     Icon(
    //                                       Icons.fingerprint,
    //                                       // color: AppColor.primary,
    //                                       size: 22.0,
    //                                     ),
    //                                     Text(
    //                                       'Mở khóa bằng vân tay',
    //                                       style: TextStyle(
    //                                           color: Theme.of(context)
    //                                               .primaryColor,
    //                                           fontSize: AppFont.fontSize16),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               )),
    //                           Visibility(
    //                               visible: isDontSupportBiometric == true,
    //                               child: SizedBox(
    //                                 height: 20.0,
    //                               )),
    //                           TextButton(
    //                               onPressed: () {
    //                                 WidgetCommon.generateDialogOKCancel(context,
    //                                     title: 'Cảnh báo',
    //                                     content:
    //                                         'Bạn sẽ mất hết dữ liệu, khi đăng xuất khỏi thiết bị ?',
    //                                     callbackOK: () {
    //                                       this._appState.logOutNew(context);
    //                                       FirebaseAuthServices.instance
    //                                           .logout();
    //                                       Utils.pushAndRemoveUntil(
    //                                           context, RouteList.LOGIN_SCREEN);
    //                                     },
    //                                     callbackCancel: () => {});
    //                               },
    //                               child: Text(
    //                                 'Đăng nhập bằng tài khoản khác',
    //                                 style: TextStyle(
    //                                     color: Theme.of(context).primaryColor,
    //                                     fontSize: AppFont.fontSize16),
    //                               ))
    //                         ]),
    //                       ),
    //                       Container(
    //                         child: Text(S.of(context).copy_right +
    //                             " - " +
    //                             Utils.showVersionApp()),
    //                         alignment: Alignment.bottomCenter,
    //                         padding: EdgeInsets.only(bottom: 10.0),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             )),
    //       ],
    //     ),
    //   ),
    // );
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

  Future<void> loginBiometric() async {
    try {
      if (this.isLoading) {
        return;
      }
      bool permission =
          await PermissionAppService.checkServiceLoginBiometric(context);
      if (permission == true) {
        final password =
            await StorageHelper.getString(AppStateConfigConstant.USER_TOKEN) ??
                '';
        if (password.isNotEmpty) {
          this.isLoginFingerPrint = true;
          return await onLogin();
        }
      } else {
        this.isLoginFingerPrint = false;
      }
    } catch (e) {
      print(e);
      this.isLoginFingerPrint = false;
    }
  }

  Widget _title() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Image(
                    image: AssetImage('assets/images/app_logo.png'),
                    height: 40.0,
                    width: 40.0,
                  ),
                  // AssetImage('assets/images/logo.vng'),
                  SizedBox(width: 7),
                  Text.rich(TextSpan(
                      text: "Athena ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w700),
                      children: <InlineSpan>[
                        TextSpan(
                          text: "Owl",
                          style: TextStyle(
                              color: Colors.blue[400],
                              fontSize: 35,
                              fontWeight: FontWeight.w700),
                        ),
                      ])),
                ]))
          ],
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
