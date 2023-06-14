import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'load_modules_state.dart';

class LoadModulesCubit extends Cubit<LoadModulesState> {
  final ModuleRepository _moduleRepository = Bindings.get();
  final SelectClassCubit _selectClassCubit = Bindings.get();

  LoadModulesCubit() : super(LoadingHomeModulesList()) {
    _selectClassCubit.stream.listen((event) {
      load();
    });
  }

  Future<void> load() async {
    try {
      emit(LoadingHomeModulesList());
      final selectedClass = _selectClassCubit.state.clazz;
      final modules = selectedClass == null
          ? <Module>[]
          : await _moduleRepository.getFromClass(selectedClass.id!);
      modules.sort((a, b) => a.index - b.index);
      emit(HomeModulesListLoaded(modules));
    } catch (e) {
      print(e);
      emit(HomeModulesListError(
        message: 'Erro ao buscar os modulos de aprendizado',
        isNetworkError: true,
      ));
    }
  }
}
