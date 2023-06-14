import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/lesson/actions/lesson_actions_state.dart';

class LessonActionsCubit extends Cubit<LessonActionsState> {
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();
  final LessonRepository _lessonRepository = Bindings.get();

  LessonActionsCubit() : super(InitialLessonActionsState());

  Future<void> create(Lesson lesson) async {
    try {
      emit(CreatingLessonState());
      final lessonSaved = await _lessonRepository.create(lesson);
      _globalAlertCubit.fire('Lição cadastrada com sucesso!');
      emit(LessonCreatedState(lessonSaved));
    } catch (e) {
      print(e);
      _globalAlertCubit.fire('Erro ao cadastrar nova lição');
      emit(CreateLessonErrorState('Erro ao cadastrar nova lição'));
    }
  }

  Future<void> updateListOrder(List<Lesson> lessons) async {
    try {
      emit(UpdatingLessonsOrderState());
      await _lessonRepository.updateList(lessons);
      emit(LessonsOrderUpdatedState());
    } catch (e) {
      print(e);
      _globalAlertCubit.fire(
        'Erro ao atualizar ordem das lições',
        isErrorMessage: true,
      );
      emit(LessonOrderUpdateErrorState('Erro ao atualizar ordem das lições'));
    }
  }
}
