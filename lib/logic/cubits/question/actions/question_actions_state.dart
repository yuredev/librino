import 'package:equatable/equatable.dart';
import 'package:librino/data/models/question/question.dart';

abstract class QuestionActionsState extends Equatable {
  const QuestionActionsState();
}

class InitialQuestionActionsState extends QuestionActionsState {
  @override
  List<Object?> get props => [];
}

class CreatingQuestionState extends QuestionActionsState {
  @override
  List<Object?> get props => [];
}

class QuestionCreatedState extends QuestionActionsState {
  final Question question;

  const QuestionCreatedState(this.question);

  @override
  List<Object?> get props => [question];
}

class CreateQuestionErrorState extends QuestionActionsState {
  final String errorMessage;

  const CreateQuestionErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
