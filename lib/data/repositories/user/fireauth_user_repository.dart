import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/user/librino_user.dart';

typedef FBUser = fb.User;

class FireAuthUserRepository {
  final Reference _storageRef = Bindings.get();

  Future<FBUser> create({
    required String name,
    required String email,
    required String password,
    XFile? photo,
  }) async {
    final auth = fb.FirebaseAuth.instance;
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = userCredential.user;
    await user!.updateDisplayName(name);
    if (photo != null) {
      final imageRef =
          _storageRef.child('users').child(user.uid).child('profile.jpg');
      final snapshot = await imageRef.putFile(File(photo.path));
      final url = await snapshot.ref.getDownloadURL();
      await user.updatePhotoURL(url);
    }
    await user.reload();
    user = auth.currentUser;

    return user!;
  }

  Future<void> removeAccount() async {
    final auth = fb.FirebaseAuth.instance;
    await auth.currentUser!.delete();
    await auth.signOut();
  }

  Future<String?> update(LibrinoUser user, XFile? photo) async {
    String? url;
    if (photo != null) {
      final imageRef =
          _storageRef.child('users').child(user.id).child('profile.jpg');
      final snapshot = await imageRef.putFile(File(photo.path));
      url = await snapshot.ref.getDownloadURL();
    }
    final auth = fb.FirebaseAuth.instance;
    await auth.currentUser!.updateDisplayName(user.name);
    await auth.currentUser!.updatePhotoURL(url);
    return url;
  }
}
