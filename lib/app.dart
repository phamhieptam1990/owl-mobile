import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:athena/config/enviroment/enviroment_type.dart';
import 'package:athena/utils/idie/idieActivity.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:athena/utils/idie/idieActivity.service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:athena/common/config/app_config.dart';
import 'package:athena/common/constants/routes.dart';
import 'package:athena/models/events.dart';
import 'package:athena/utils/navigation/navigation.service.dart';
import 'package:athena/utils/services/in_app_update_services.dart';
import 'package:athena/widgets/app_media_query.dart';

import 'app_init.dart';
import 'common/constants.dart';
import 'common/constants/color.dart';
import 'config/enviroment/environment.dart';
import 'generated/l10n.dart';
import 'models/app.model.dart';
import 'utils/common/tracking_installing_device.dart';
import 'widgets/common/custom_animation.dart';

class AppMain extends StatefulWidget {
  @override
  AppMainState createState() => AppMainState();

  static void setLocale(BuildContext context, Locale locale) {
    AppMainState? state = context.findAncestorStateOfType<AppMainState>();
    if (state != null) {
      state.setLocale(locale);
    }
  }

  // static void setOffline(BuildContext context, bool isOffline) {
  //   AppMainState state = context.findAncestorStateOfType<AppMainState>();
  //   if (state != null) {
  //     state.setOffline(isOffline);
  //   }
  // }
}

class AppMainState extends State<AppMain> with AfterLayoutMixin<AppMain> {
  // Locale is already non-nullable, no change needed
  Locale _locale = Locale('vi', 'VN');
  
  // Mark as nullable with ?
  StreamSubscription? subscriptionOffline;
  bool isOffline = false;
  
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setOffline(bool _isOffline) {
    setState(() {
      isOffline = _isOffline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (PointerEvent details) {
          IdieActivity.instance.setTimerModel();
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: _locale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: AppInit(),
          builder: EasyLoading.init(builder: (context, child) {
            return AppMediaQuery(
                showBanner:
                    Environment.value.environmentType == EnvironmentType.uat,
                // showBanner: false,
                child: child ?? const SizedBox());
          }),
          initialRoute: '/',
          routes: RouteList.routesApp,
          // onGenerateRoute: ,
          title: Environment.value.appTitle,
          navigatorObservers: [
            // SentryNavigatorObserver(),
          ],
          theme: getTheme(context),
          navigatorKey: NavigationService.instance.navigationKey,
        ));
  }

  @override
  void initState() {
    configLoading();
    upgradeVersionOnStore();
    subscriptionOffline =
        eventBus.on<TriggerEventOffline>().listen((TriggerEventOffline event) {
      setOffline(event.data);
    });

    Future.delayed(Duration(seconds: 10), () {
      TrackingInstallingDevice().blacklistListen();
    });
    super.initState();
    // FlutterNativeSplash.remove();
  }

  void upgradeVersionOnStore() async {
    if (IS_PRODUCTION_APP && IS_INSTALLED_BY_STORE && Platform.isAndroid) {
      InAppUpdateServices.linkAndroid();
      Future.delayed(Duration(seconds: 2),
          () async => InAppUpdateServices.checkUpdateAndroid(context));
    } else if (IS_PRODUCTION_APP && IS_INSTALLED_BY_STORE && Platform.isIOS) {
      Future.delayed(Duration(seconds: 2),
          () async => InAppUpdateServices.checkUpdateISO(context));
    }
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = true
      ..customAnimation = CustomAnimation();
  }

  ThemeData getTheme(context) {
    if (isOffline == false) {
      return ThemeData(
        scaffoldBackgroundColor: Colors.white, 
        primaryColor: AppColor.appBarOn,
        disabledColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
         cardColor: Colors.white, 
          useMaterial3: true,
        cardTheme: CardTheme(
          color: Colors.white,
        ),
         expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          textColor: Colors.black,
          iconColor: Colors.black,
          collapsedTextColor: Colors.black,
          collapsedIconColor: Colors.black,
        ),
        appBarTheme:
            AppBarTheme(elevation: 0, backgroundColor: AppColor.appBarOn, foregroundColor: AppColor.appBarOn, systemOverlayStyle: SystemUiOverlayStyle.light, 
          iconTheme: IconThemeData(
              color: Colors.white), // thêm nếu cần icon back/menu màu đen
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.0)
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // 👈 Nền trắng cho mọi TextFormField
          hintStyle: TextStyle(color: Colors.white38), // 👉 Hint khi disabled
          labelStyle: TextStyle(color: Colors.black),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Colors.grey),
          // ),
          // disabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Colors.grey), // 👉 Viền khi disabled
          // ),
       
        ),
         textTheme: TextTheme(
          bodyMedium:
              TextStyle(color: Colors.black), // mặc định cho TextFormField
        ),
      );
    }
    return ThemeData(
      scaffoldBackgroundColor: Colors.white, 
      primaryColor: AppColor.danger,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardColor: Colors.white, 
       useMaterial3: true,
      cardTheme: CardTheme(
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(elevation: 0, backgroundColor: AppColor.danger, systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: IconThemeData(
            color: Colors.white), // thêm nếu cần icon back/menu màu đen
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18.0), 
      ),
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          textColor: Colors.black,
          iconColor: Colors.black,
          collapsedTextColor: Colors.black,
          collapsedIconColor: Colors.black,
        ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, // 👈 Nền trắng cho mọi TextFormField/ tuỳ chọn viền
      
        hintStyle: TextStyle(color: Colors.black),

        /// optional
      ),
       textTheme: TextTheme(
        bodyMedium:
            TextStyle(color: Colors.black), // mặc định cho TextFormField
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    // await loadInitData();

    // Future.delayed(Duration(seconds: 2), () {
    //   AppSessionManager.onTimeOutListen();
    // });
  }

  Future<void> loadInitData() async {
    try {
      // appConfig =
      //     await Provider.of<AppModel>(context, listen: false).loadAppConfig();
      _locale = await Provider.of<AppModel>(context, listen: false).getLocale();
    } catch (e) {
      // print(e.toString());
      // print(trace.toString());
    }
  }
}
