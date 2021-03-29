import 'package:firebase_auth/firebase_auth.dart';

class LoginApi {
  Future<FirebaseAuthException> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return e as FirebaseAuthException;
    }
  }
}
