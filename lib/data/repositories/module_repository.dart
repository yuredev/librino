import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/module/module.dart';

class ModuleRepository {
  final _collection = Bindings.get<FirebaseFirestore>().collection('modules');
  final Reference _storageRef = Bindings.get();

  Future<List<Module>> getFromClass(String classId) async {
    final ref = _collection.where('classId', isEqualTo: classId);
    final snap = await ref.get();
    final all = snap.docs
        .map((e) => e.data())
        .toList()
        .map((e) => Module.fromJson(e))
        .toList();
    return all;
  }

  Future<Module> create(Module module, XFile? image) async {
    final docRef = await _collection.add(module.toJson());
    final snapshot = await docRef.get();
    final data = snapshot.data()!;
    data.update('id', (_) => docRef.id);
    if (image != null) {
      final imageRef = _storageRef
          .child('module_images')
          .child('${module.classId}_${data['id']}_${DateTime.now()}.jpg');
      final snapshot = await imageRef.putFile(File(image.path));
      final url = await snapshot.ref.getDownloadURL();
      data.update('imageUrl', (_) => url);
    }
    await docRef.update(data);
    return Module.fromJson(data);
  }

  Future<void> updateList(List<Module> lessons) async {
    for (final l in lessons) {
      final docRef = _collection.doc(l.id);
      await docRef.update(l.toJson());
    }
  }
}
