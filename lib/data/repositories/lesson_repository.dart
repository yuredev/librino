import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:librino/data/models/lesson/lesson.dart';

class LessonRepository {
  final _fireInstance = GetIt.I.get<FirebaseFirestore>();

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
    return lesson;
  }
}
