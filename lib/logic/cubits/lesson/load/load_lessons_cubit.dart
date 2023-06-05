import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/logic/cubits/lesson/load/load_lesson_state.dart';

class LoadLessonsCubit extends Cubit<LoadLessonState> {
  final LessonRepository _lessonRepository = Bindings.get();

  LoadLessonsCubit() : super(InitialLoadLessonState());

  Future<void> loadFromModule(String moduleId) async {
    try {
      emit(LoadinglLessonState());
      final lessons = await _lessonRepository.getFromModule(moduleId);
      emit(LessonsLoadedState(lessons));
    } catch (e) {
      print(e);
      emit(LessonLoadError(
        isNetworkError: true,
        message: 'Erro ao listar as lições deste módulo',
      ));
    }
  }
}
