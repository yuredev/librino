import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'load_modules_state.dart';

class LoadModulesCubit extends Cubit<LoadModulesState> {
  final _moduleRepository = GetIt.I.get<ModuleRepository>();

  LoadModulesCubit() : super(LoadingHomeModulesList());

  Future<void> loadFromClass(String classId) async {
    try {
      emit(LoadingHomeModulesList());
      final modules = await _moduleRepository.getFromClass(classId);
      modules.sort((a, b) => a.number - b.number);
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
