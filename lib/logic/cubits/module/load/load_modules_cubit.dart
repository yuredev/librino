import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/data/repositories/lesson_repository.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'load_modules_state.dart';

class LoadModulesCubit extends Cubit<LoadModulesState> {
  final ModuleRepository _moduleRepository = Bindings.get();
  final SelectClassCubit _selectClassCubit = Bindings.get();
  final LessonRepository _lessonRepository = Bindings.get();

  LoadModulesCubit() : super(LoadingHomeModulesList()) {
    _selectClassCubit.stream.listen((event) => load());
  }

  Future<void> load() async {
    try {
      emit(LoadingHomeModulesList());
      final selectedClass = _selectClassCubit.state.clazz;
      final modules = selectedClass == null
          ? <Module>[]
          : await _moduleRepository.getFromClass(selectedClass.id!);
      for (var i = 0; i < modules.length; i++) {
        final moduleLessons =
            await _lessonRepository.getFromModule(modules[i].id!);
        modules[i] = modules[i].copyWith(lessons: moduleLessons);
        modules[i].lessons!.sort((a, b) => a.index - b.index);
      }
      final modsWithContent =
          modules.where((m) => m.lessons?.isNotEmpty ?? false).toList();
      modsWithContent.sort((a, b) => a.index - b.index);
      emit(HomeModulesListLoaded(modsWithContent));
    } catch (e) {
      print(e);
      emit(HomeModulesListError(
        message: 'Erro ao buscar os modulos de aprendizado',
        isNetworkError: true,
      ));
    }
  }
}
