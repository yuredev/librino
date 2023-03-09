import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/logic/cubits/lesson/lesson_state.dart';

class LoadLessonCubit extends Cubit<LessonState> {
  final _lessonRepository = GetIt.I.get<LessonRepository>();

  LoadLessonCubit() : super(LoadinglLesson());

  Future<void> loadLesson(
    String classId,
    String moduleId,
    int lessonNumber,
  ) async {
    try {
      emit(LoadinglLesson());
      final lesson =
          await _lessonRepository.getLesson(classId, moduleId, lessonNumber);
      emit(LessonLoaded(lesson));
    } catch (e) {
      print(e);
      emit(LessonLoadError(
        message: 'Erro de conexão ao buscar a lição',
        isNetworkError: true,
      ));
    }
  }
}
