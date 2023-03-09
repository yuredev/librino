import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:librino/data/repositories/module_repository.dart';
import './module_state.dart';

class LoadModulesCubit extends Cubit<ModuleState> {
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
      // TODO: verificar quando é erro de conexão
      // O firebase não usa DIO :|
      emit(HomeModulesListError(
        message: 'Erro de conexão ao buscar os modulos',
        isNetworkError: true,
      ));
    }
  }
}
