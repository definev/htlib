import 'package:firebase_auth/firebase_auth.dart';

class LoginApi {
  Future<FirebaseAuthException?> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      // await FirebaseAuth.instance.signInWithPhoneNumber('phoneNumber');
      return null;
    } catch (e) {
      return e as FirebaseAuthException;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
