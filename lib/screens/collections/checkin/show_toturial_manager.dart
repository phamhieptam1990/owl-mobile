import 'package:athena/utils/storage/storage_helper.dart';

class ShowTutorialManager {
  static String showTutorialPaymentKey = 'showTutorialPaymentKey';
  static String showLocalityKey = 'showLocalityKey';
  static String showActionCode = 'showActionCode';
  static String showReason = 'showReason';

  static String showGetKalapa = 'showGetKalapa';

  static void saveShowTutorialPaymentKey() {
    StorageHelper.setBool(showTutorialPaymentKey, true);
  }

  static Future<bool> getShowedPayment() async {
    bool value = await StorageHelper.getBool(showTutorialPaymentKey) ?? false;
    return value;
  }

  static void saveShowLocalityKey() {
    StorageHelper.setBool(showLocalityKey, true);
  }

  static Future<bool> getShowedLocality() async {
    bool value = await StorageHelper.getBool(showLocalityKey) ?? false;
    return value;
  }

  static void saveActionCodeKey() {
    StorageHelper.setBool(showActionCode, true);
  }

  static Future<bool> getShowedActionCode() async {
    bool value = await StorageHelper.getBool(showActionCode) ?? false;
    return value;
  }

  static void saveReasonKey() {
    StorageHelper.setBool(showReason, true);
  }

  static Future<bool> getShowedReason() async {
    bool value = await StorageHelper.getBool(showReason) ?? false;
    return value;
  }

  static void saveShowGetKalapa() {
    StorageHelper.setBool(showGetKalapa, true);
  }

  static Future<bool> getShowGetKalapa() async {
    bool value = await StorageHelper.getBool(showGetKalapa) ?? false;
    return value;
  }

  static void resetShowTutorialWhenLogin() {
    StorageHelper.setBool(showTutorialPaymentKey, false);
    StorageHelper.setBool(showLocalityKey, false);
    StorageHelper.setBool(showActionCode, false);
    StorageHelper.setBool(showReason, false);
    StorageHelper.setBool(showGetKalapa, false);
  }
}
