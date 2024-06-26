import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/lesson/lesson.dart';

class LessonRepository {
  final FirebaseFirestore _fireInstance = Bindings.get();

  CollectionReference<Map<String, dynamic>> getCollection(String moduleId) {
    return _fireInstance
        .collection('modules')
        .doc(moduleId)
        .collection('lessons');
  }

  Future<Lesson> create(Lesson lesson) async {
    final docRef = await getCollection(lesson.moduleId).add(lesson.toJson());
    final snapshot = await docRef.get();
    final data = snapshot.data()!;
    data.update('id', (_) => docRef.id);
    await docRef.update(data);
    return Lesson.fromJson(data);
  }

  Future<List<Lesson>> getFromModule(String moduleId) async {
    final snapshot = (await getCollection(moduleId).orderBy('index').get());
    final lessons =
        snapshot.docs.map((e) => Lesson.fromJson(e.data())).toList();
    return lessons;
  }

  Future<void> updateList(List<Lesson> lessons) async {
    for (final l in lessons) {
      final docRef = getCollection(lessons.first.moduleId).doc(l.id);
      await docRef.update(l.toJson());
    }
  }

  Future<void> delete(String moduleId, String id) async {
    await getCollection(moduleId).doc(id).delete();
  }
}
