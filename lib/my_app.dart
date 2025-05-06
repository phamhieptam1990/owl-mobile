import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:athena/utils/app_state.dart';
import 'package:athena/utils/global-store/user_info_store.dart';
import 'app.dart';
// import 'common/config/app_link_config.dart';
import 'config/session_timeout/app_session_manage.dart';
import 'flavor_config.dart';
import 'getit.dart';
import 'models/app.model.dart';
import 'screens/notification/notication.app.service.dart';
import 'utils/log/crashlystic_services.dart';

class MyApp {
  static Future<void> run(Flavor? flavor) async {
    WidgetsFlutterBinding.ensureInitialized();

    // 🔥 Lấy FirebaseOptions theo flavor

    await setup();

    AppState.firebaseApp = await safeFirebaseInit();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    CrashlysticServices.instance.initializeFlutterFire();

    Provider.debugCheckInvalidValueType = null;
    AppSessionManager();

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        // statusBarColor: Colors.transparent, // hoặc một màu cụ thể
        statusBarIconBrightness: Brightness.light, // 👈 Icon trắng
        // statusBarBrightness:
        //     Brightness.dark, // iOS: nội dung dưới status bar màu tối
      ),
    );

    final appModel = AppModel();
    final userStore = getIt<UserInfoStore>();

    runApp(
      MultiProvider(
        providers: [
          Provider<AppModel>.value(value: appModel),
          Provider<UserInfoStore>.value(value: userStore),
          ChangeNotifierProvider(create: (_) => userStore),
        ],
        child: AppMain(),
      ),
    );
  }
}

Future<FirebaseApp> safeFirebaseInit() async {
  if (Firebase.apps.isEmpty) {
    return await Firebase.initializeApp(
      name: 'firebaseAthenaOwl',
      options: FlavorConfig.firebaseOptions);
  }
  return Firebase.app();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppState.firebaseApp = await safeFirebaseInit();
  NotificationApp().firebaseMessagingBackgroundHandler(message);
}
