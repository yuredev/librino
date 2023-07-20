import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/question_filter.dart';
import 'package:librino/data/repositories/question_repository.dart';
import 'package:librino/logic/cubits/question/load_questions/load_questions_state.dart';

class LoadQuestionBaseCubit extends Cubit<LoadQuestionsState> {
  final QuestionRepository _questionRepository = Bindings.get();

  LoadQuestionBaseCubit() : super(InitialLoadQuestionsState());

  Future<void> load(QuestionFilter filter) async {
    try {
      emit(LoadingPaginatedQuestionsState());
      final questions = await _questionRepository.getAllPublic(filter);
      emit(
        PaginatedQuestionsLoadedState(questions),
      );
    } catch (e) {
      print(e);
      emit(LoadQuestionsErrorState(
        'Erro ao carregar as questões da base de questões do Librino',
      ));
    }
  }
}
