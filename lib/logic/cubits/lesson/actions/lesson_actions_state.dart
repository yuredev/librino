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

class UpdatingLessonsOrderState extends LessonActionsState {
  @override
  List<Object?> get props => [];
}
class LessonsOrderUpdatedState extends LessonActionsState {
  @override
  List<Object?> get props => [];
}
class LessonOrderUpdateErrorState extends LessonActionsState {
  final String errorMessage;

  const LessonOrderUpdateErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

abstract class AbstractFinishLessonState extends LessonActionsState {
  const AbstractFinishLessonState();
}

class FinishingLessonState extends AbstractFinishLessonState {

  const FinishingLessonState();

  @override
  List<Object?> get props => [];
}

class LessonFinishedState extends AbstractFinishLessonState {

  const LessonFinishedState();

  @override
  List<Object?> get props => [];
}

class FinishLessonErrorState extends AbstractFinishLessonState {

  const FinishLessonErrorState();

  @override
  List<Object?> get props => [];
}



class DeletingLessonState extends LessonActionsState {

  const DeletingLessonState();

  @override
  List<Object?> get props => [];
}

class LessonDeletedState extends LessonActionsState {

  const LessonDeletedState();

  @override
  List<Object?> get props => [];
}

class DeleteLessonErrorState extends LessonActionsState {

  const DeleteLessonErrorState();

  @override
  List<Object?> get props => [];
}
