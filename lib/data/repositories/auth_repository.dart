import 'package:firebase_auth/firebase_auth.dart';

// TODO: 
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
    try {} on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
  }
}
