import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/lesson/load/load_lesson_state.dart';

class LoadSingleLessonCubit extends Cubit<LoadLessonState> {
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();
  final LessonRepository _lessonRepository = Bindings.get();

  LoadSingleLessonCubit() : super(InitialLoadLessonState());

  Future<void> loadLesson(
    String classId,
    String moduleId,
    int lessonNumber,
  ) async {
    try {
      emit(LoadinglLessonState());
      final lesson =
          await _lessonRepository.getLesson(classId, moduleId, lessonNumber);
      emit(LessonLoadedState(lesson));
    } catch (e) {
      print(e);
      _globalAlertCubit.fire(
        'Não foi possível abrir a lição!',
        isErrorMessage: true,
      );
      emit(LessonLoadError(
        message: 'Não foi possível abrir a lição',
        isNetworkError: true,
      ));
    }
  }

  void load() {}
}
