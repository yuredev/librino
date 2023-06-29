import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/user/firestore_user.dart';
import 'package:librino/data/models/user/librino_user.dart';

// TODO: renomear
class FirestoreUserRepository {
  final _collection = Bindings.get<FirebaseFirestore>().collection('users');
  final Reference _storageRef = Bindings.get();

  Future<FirestoreUser> save(FirestoreUser user) async {
    final docRef = await _collection.add(user.toJson());
    final snapshot = await docRef.get();
    final userData = snapshot.data();
    return FirestoreUser.fromJson(userData!);
  }

  Future<FirestoreUser> getById(String id) async {
    final ref = _collection.where('id', isEqualTo: id).limit(1);
    final snapshot = await ref.get();
    return FirestoreUser.fromJson(snapshot.docs.first.data());
  }

  Future<void> registerProgression(String lessonId, String userId) async {
    try {
      final ref = _collection.where('id', isEqualTo: userId);
      final snapshot = (await ref.get()).docs.first;
      final data = snapshot.data();
      var completedLessonsIds =
          (data['completedLessonsIds'] as List?)?.cast<String>();
      completedLessonsIds ??= <String>[];

      if (completedLessonsIds.contains(lessonId)) return;

      completedLessonsIds.add(lessonId);

      data['completedLessonsIds'] = completedLessonsIds;

      await _collection.doc(snapshot.id).update(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeAccount(String userId) async {
    final ref = _collection.where('id', isEqualTo: userId).limit(1);
    final snap = await ref.get();
    await _collection.doc(snap.docs.first.id).delete();
    try {
      _storageRef.child('questions').child('user_$userId').delete();
      _storageRef.child('users').child(userId).child('profile.jpg').delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> update(LibrinoUser user) async {
    final ref = _collection.where('id', isEqualTo: user.id).limit(1);
    final snap = await ref.get();
    await _collection.doc(snap.docs.first.id).update(
          user.toJson(),
        );
  }
}
