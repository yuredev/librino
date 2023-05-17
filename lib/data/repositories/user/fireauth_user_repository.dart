import 'package:firebase_auth/firebase_auth.dart' as fb;

typedef FBUser = fb.User;

class FireAuthUserRepository {
  Future<FBUser> create({
    required String name,
    required String email,
    required String password,
  }) async {
    final auth = fb.FirebaseAuth.instance;
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = userCredential.user;
    await user!.updateDisplayName(name);
    await user.reload();
    user = auth.currentUser;
    return user!;
  }
}
