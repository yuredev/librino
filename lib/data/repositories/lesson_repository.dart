import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/lesson/lesson.dart';

class LessonRepository {
  final FirebaseFirestore _fireInstance = Bindings.get();

  // TODO: consertar
  Future<Lesson> getLesson(
    String classId,
    String moduleId,
    int lessonNumber,
  ) async {
    final lessonsRef = _fireInstance
        .collection('classes')
        .doc(classId)
        .collection('modules')
        .doc(moduleId)
        .collection('lessons');
    final lessonMap =
        (await lessonsRef.where('number', isEqualTo: lessonNumber).get())
            .docs
            .first
            .data();
    final lesson = Lesson.fromJson(lessonMap);
    lesson.steps.sort((a, b) => a.number - b.number);
    return lesson;
  }

  Future<Lesson> create(Lesson lesson) async {
    throw UnimplementedError();
  }

  getFromModule(String module) {}
}
