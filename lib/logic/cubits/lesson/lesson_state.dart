import 'package:equatable/equatable.dart';
import 'package:librino/data/models/lesson/lesson.dart';

abstract class LessonState {}

class LoadinglLesson implements LessonState {}

class LessonLoaded extends Equatable implements LessonState {
  final Lesson lesson;

  const LessonLoaded(this.lesson);
  
  @override
  List<Object?> get props => [lesson];
}

class LessonLoadError extends Equatable implements LessonState {
  final String message;
  final bool isNetworkError;

  const LessonLoadError({
    required this.message,
    required this.isNetworkError,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}
