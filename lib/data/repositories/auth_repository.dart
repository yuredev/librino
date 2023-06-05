import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = userCredential.user;
    return user!;
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}
