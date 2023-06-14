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
  final int page;

  const LoadingPaginatedQuestionsState(this.page);

  @override
  List<Object?> get props => [page];
}

class QuestionsLoadedState extends LoadQuestionsState {
  final List<Question> questions;

  const QuestionsLoadedState(this.questions);

  @override
  List<Object?> get props => [questions];
}

class PaginatedQuestionsLoadedState extends LoadQuestionsState {
  final List<Question> questions;
  final int page;

  const PaginatedQuestionsLoadedState(this.questions, this.page);

  @override
  List<Object?> get props => [questions, page];
}

class LoadQuestionsErrorState extends LoadQuestionsState {
  final String errorMessage;

  const LoadQuestionsErrorState(this.errorMessage);

  @override
  List<Object?> get props => [];
}
