import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/data/models/question_filter.dart';
import 'package:librino/data/repositories/question_repository.dart';
import 'package:librino/logic/cubits/question/load_questions/load_questions_state.dart';

class LoadQuestionBaseCubit extends Cubit<LoadQuestionsState> {
  final QuestionRepository _questionRepository = Bindings.get();

  LoadQuestionBaseCubit() : super(InitialLoadQuestionsState());

  Future<void> load(QuestionFilter filter, Question? question, int page) async {
    try {
      emit(LoadingPaginatedQuestionsState(page));
      final questions = await _questionRepository.getAll(filter, question);
      emit(PaginatedQuestionsLoadedState(questions, page));
    } catch (e) {
      print(e);
      emit(LoadQuestionsErrorState(
        'Erro ao carregar as questões da base de questões do Librino',
      ));
    }
  }
}
