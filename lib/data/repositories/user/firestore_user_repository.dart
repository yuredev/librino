import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/user/firestore_user.dart';

class FirestoreUserRepository {
  final _collection = Bindings.get<FirebaseFirestore>().collection('users');

  Future<FirestoreUser> save(FirestoreUser user) async {
    final docRef = await _collection.add(user.toJson());
    final snapshot = await docRef.get();
    final userData = snapshot.data();
    return FirestoreUser.fromJson(userData!);
  }

  Future<FirestoreUser> getById(String id) async {
    final snapshot = await _collection.where('id', isEqualTo: id).get();
    final userData = snapshot.docs.first.data();
    return FirestoreUser.fromJson(userData);
  }
}
