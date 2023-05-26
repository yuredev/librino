import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/class/class.dart';

class ClassRepository {
  final _collection = Bindings.get<FirebaseFirestore>().collection('classes');

  Future<Class> create(Class clazz) async {
    final docRef = await _collection.add(clazz.toJson());
    final snapshot = await docRef.get();
    final userData = snapshot.data();
    return Class.fromJson(userData!);
  }
}
