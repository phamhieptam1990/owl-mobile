import 'firebase/firebase_options_uat.dart' as firebase_uat;
import 'firebase/firebase_options_prod.dart' as firebase_prod;
import 'package:firebase_core/firebase_core.dart';

enum Flavor { uat, prod }

class FlavorConfig {
  static  Flavor? appFlavor;

  static FirebaseOptions get firebaseOptions {
    return appFlavor == Flavor.uat
        ? firebase_uat.DefaultFirebaseOptions.currentPlatform
        : firebase_prod.DefaultFirebaseOptions.currentPlatform;
  }
}
