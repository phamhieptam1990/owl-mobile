// ignore: camel_case_types
class FirebaseRemoteConfigConstant {
  static String IOS_UAT_VERSION = "IOS_UAT_VERSION";
  static String ANDROID_UAT_VERISON = "ANDROID_UAT_VERSION";
  static String IOS_UAT_RELEASE_NOTES = "IOS_UAT_RELEASE_NOTES";
  static String ANDROID_UAT_RELEASE_NOTES = "ANDROID_UAT_RELEASE_NOTES";

  static String IOS_PRODUCTION_VERSION = "IOS_PRODUCTION_VERSION";
  static String ANDROID_PRODUCTION_VERISON = "ANDROID_PRODUCTION_VERSION";
  static String IOS_PRODUCTION_RELEASE_NOTES = "IOS_PRODUCTION_RELEASE_NOTES";
  static String ANDROID_PRODUCTION_RELEASE_NOTES =
      "ANDROID_PRODUCTION_RELEASE_NOTES";
  static String MOCK_LOCATIONS_ANDROID_APP = 'MockLocationsAndroidApp';
}

class FirebaseRemoteConfigService {
  // static RemoteConfig remoteConfig;

  // static FirebaseRemoteConfigService instance = FirebaseRemoteConfigService();

  // FirebaseRemoteConfigService() {}

  // static Future<RemoteConfig> setupRemoteConfig() async {
  //   try {
  //     if (remoteConfig == null) {
  //       remoteConfig = RemoteConfig.instance;
  //       if (Platform.isIOS) {
  //         await remoteConfig.ensureInitialized();
  //       }
  //       RemoteConfigSettings configSettings = new RemoteConfigSettings(
  //           fetchTimeout: Duration(minutes: 3),
  //           minimumFetchInterval: Duration(minutes: 5));
  //       remoteConfig.setConfigSettings(configSettings);
  //       return await fetchAndActivate();
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // static Future<dynamic> fetchAndActivate() async {
  //   try {
  //     await remoteConfig.fetchAndActivate();
  //   } catch (e) {}
  // }

  // static String getIOSVersion() {
  //   if (remoteConfig == null) {
  //     if (IS_PRODUCTION_APP) {
  //       return APP_CONFIG.VERSION_IOS_PROD;
  //     }
  //     return APP_CONFIG.VERSION_IOS;
  //   }
  //   if (IS_PRODUCTION_APP) {
  //     final strProdVersion = remoteConfig
  //         .getString(FirebaseRemoteConfigConstant.IOS_PRODUCTION_VERSION);
  //     if (Utils.checkIsNotNull(strProdVersion)) {
  //       return strProdVersion;
  //     }
  //     return APP_CONFIG.VERSION_IOS_PROD;
  //   }
  //   final strUatVersion =
  //       remoteConfig.getString(FirebaseRemoteConfigConstant.IOS_UAT_VERSION);
  //   if (Utils.checkIsNotNull(strUatVersion)) {
  //     return strUatVersion;
  //   }
  //   return APP_CONFIG.VERSION_IOS;
  // }

  // static String getAndroidVerion() {
  //   if (remoteConfig == null) {
  //     if (IS_PRODUCTION_APP) {
  //       return APP_CONFIG.VERSION_ANDROID_PROD;
  //     }
  //     return APP_CONFIG.VERSION_ANDROID;
  //   }
  //   if (IS_PRODUCTION_APP) {
  //     final strProdVersion = remoteConfig
  //         .getString(FirebaseRemoteConfigConstant.ANDROID_PRODUCTION_VERISON);
  //     if (Utils.checkIsNotNull(strProdVersion)) {
  //       return strProdVersion;
  //     }
  //     return APP_CONFIG.VERSION_ANDROID_PROD;
  //   }
  //   final strUatVersion = remoteConfig
  //       .getString(FirebaseRemoteConfigConstant.ANDROID_UAT_VERISON);
  //   if (Utils.checkIsNotNull(strUatVersion)) {
  //     return strUatVersion;
  //   }
  //   return APP_CONFIG.VERSION_ANDROID;
  // }

  // static String getIOSReleaseNotes() {
  //   if (remoteConfig == null) {
  //     return '';
  //   }
  //   if (IS_PRODUCTION_APP) {
  //     return remoteConfig
  //         .getString(FirebaseRemoteConfigConstant.IOS_PRODUCTION_RELEASE_NOTES);
  //   }
  //   return remoteConfig
  //       .getString(FirebaseRemoteConfigConstant.IOS_UAT_RELEASE_NOTES);
  // }

  // static String getAndroidReleaseNotes() {
  //   if (remoteConfig == null) {
  //     return '';
  //   }
  //   if (IS_PRODUCTION_APP) {
  //     return remoteConfig.getString(
  //         FirebaseRemoteConfigConstant.ANDROID_PRODUCTION_RELEASE_NOTES);
  //   }
  //   return remoteConfig
  //       .getString(FirebaseRemoteConfigConstant.ANDROID_UAT_RELEASE_NOTES);
  // }

  // static getMockLocationsAndroidApp() {
  //   if (remoteConfig == null) {
  //     return '';
  //   }
  //   return remoteConfig
  //       .getString(FirebaseRemoteConfigConstant.MOCK_LOCATIONS_ANDROID_APP);
  // }
}
