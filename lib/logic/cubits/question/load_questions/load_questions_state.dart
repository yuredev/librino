import 'package:equatable/equatable.dart';
import 'package:librino/data/models/question/question.dart';

abstract class LoadQuestionsState extends Equatable {
  const LoadQuestionsState();
}

class InitialLoadQuestionsState extends LoadQuestionsState {
  const InitialLoadQuestionsState();

  @override
  List<Object?> get props => [];
}

class LoadingQuestionsState extends LoadQuestionsState {
  const LoadingQuestionsState();

  @override
  List<Object?> get props => [];
}

class LoadingPaginatedQuestionsState extends LoadQuestionsState {
  const LoadingPaginatedQuestionsState();

  @override
  List<Object?> get props => [];
}

class QuestionsLoadedState extends LoadQuestionsState {
  final List<Question> questions;

  const QuestionsLoadedState(this.questions);

  @override
  List<Object?> get props => [questions];
}

class PaginatedQuestionsLoadedState extends LoadQuestionsState {
  final List<Question> questions;

  const PaginatedQuestionsLoadedState(this.questions);

  @override
  List<Object?> get props => [questions];
}

class LoadQuestionsErrorState extends LoadQuestionsState {
  final String errorMessage;

  const LoadQuestionsErrorState(this.errorMessage);

  @override
  List<Object?> get props => [];
}
