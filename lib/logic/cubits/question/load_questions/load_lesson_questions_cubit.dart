import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/repositories/question_repository.dart';
import 'package:librino/logic/cubits/question/load_questions/load_questions_state.dart';

class LoadLessonQuestionsCubit extends Cubit<LoadQuestionsState> {
  final QuestionRepository _questionRepository = Bindings.get();

  LoadLessonQuestionsCubit() : super(InitialLoadQuestionsState());

  Future<void> loadFromLesson(Lesson lesson) async {
    try {
      emit(LoadingQuestionsState());
      final questions = await _questionRepository.loadFromLesson(lesson);
      emit(QuestionsLoadedState(questions));
    } catch (e) {
      print(e);
      emit(LoadQuestionsErrorState('Erro ao carregar as questões da lição'));
    }
  }
}
