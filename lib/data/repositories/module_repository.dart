import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:librino/data/models/module/module.dart';

class ModuleRepository {
  final _fireInstance = GetIt.I.get<FirebaseFirestore>();

  Future<List<Module>> getFromClass(String classId) async {
    final collectionRef =
        _fireInstance.collection('classes').doc(classId).collection('modules');
    final querySnap = await collectionRef.get();
    final all = querySnap.docs
        .map((e) => e.data()..putIfAbsent('id', () => e.id))
        .toList()
        .map((e) {
          return Module.fromJson(e);
        })
        .toList();
    return all;
  }
}
