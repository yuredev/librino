import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/lesson/lesson_state.dart';

class LoadLessonCubit extends Cubit<LessonState> {
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();
  final LessonRepository _lessonRepository = Bindings.get();

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
}
