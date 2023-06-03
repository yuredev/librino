import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/core/constants/firebase_constants.dart';
import 'package:librino/data/models/class/class.dart';

class ClassRepository {
  final _collection = Bindings.get<FirebaseFirestore>().collection('classes');

  Future<Class> create(Class clazz) async {
    final docRef = await _collection.add(clazz.toJson());
    final snapshot = await docRef.get();
    final data = snapshot.data()!;
    data.update('id', (_) => docRef.id);
    await docRef.update(data);
    return Class.fromJson(data);
  }

  Future<Class> getDefault() async {
    final classes = _collection
        .where(
          'id',
          isEqualTo: FirebaseConstants.defaultClassId,
        )
        .limit(1);
    final querySnap = await classes.get();
    final all = querySnap.docs.map((e) => Class.fromJson(e.data())).toList();
    return all.first;
  }

  Future<List<Class>> getFromInstructor(String instructorId) async {
    final classes = _collection.where('ownerId', isEqualTo: instructorId);
    final querySnap = await classes.get();
    final all = querySnap.docs.map((e) => Class.fromJson(e.data())).toList();
    return all;
  }

  Future<Class?> getById(String id) async {
    if (id == FirebaseConstants.defaultClassId) return null;
    final classes = _collection.where('id', isEqualTo: id);
    try {
      final querySnap = await classes.get();
      final all = querySnap.docs.map((e) => Class.fromJson(e.data())).toList();
      return all.first;
    } catch (e) {
      if (e is StateError && e.message == 'No element') {
        return null;
      } else {
        print(e);
        rethrow;
      }
    }
  }
}
