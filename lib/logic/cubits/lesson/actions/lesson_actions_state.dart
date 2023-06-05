import 'package:equatable/equatable.dart';
import 'package:librino/data/models/lesson/lesson.dart';

abstract class LessonActionsState extends Equatable {
  const LessonActionsState();
}

class InitialLessonActionsState extends LessonActionsState {
  @override
  List<Object?> get props => [];
}

class CreatingLessonState extends LessonActionsState {
  @override
  List<Object?> get props => [];
}

class LessonCreatedState extends LessonActionsState {
  final Lesson lesson;

  const LessonCreatedState(this.lesson);

  @override
  List<Object?> get props => [lesson];
}

class CreateLessonErrorState extends LessonActionsState {
  final String errorMessage;

  const CreateLessonErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
