import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth;
  FirebaseAuthServices._(this._auth);
  static final FirebaseAuthServices _instance =
      FirebaseAuthServices._(FirebaseAuth.instance);

  static FirebaseAuthServices get instance => _instance;

  Future<void> tryToLogin(String email) async {}

  void initialize() async {}

  void logout() {
    _auth.signOut();
  }
}
