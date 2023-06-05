import 'package:equatable/equatable.dart';
import 'package:librino/data/models/lesson/lesson.dart';

abstract class LoadLessonState {}

class LoadinglLessonState implements LoadLessonState {}
class InitialLoadLessonState implements LoadLessonState {}

class LessonLoadedState extends Equatable implements LoadLessonState {
  final Lesson lesson;

  const LessonLoadedState(this.lesson);
  
  @override
  List<Object?> get props => [lesson];
}

class LessonLoadError extends Equatable implements LoadLessonState {
  final String message;
  final bool isNetworkError;

  const LessonLoadError({
    required this.message,
    required this.isNetworkError,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}

class LessonsLoadedState extends Equatable implements LoadLessonState {
  final List<Lesson> lessons;

  const LessonsLoadedState(this.lessons);
  
  @override
  List<Object?> get props => [lessons];
}
