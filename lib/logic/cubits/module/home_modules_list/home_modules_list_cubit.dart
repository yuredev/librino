import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:librino/data/repository/module_repository.dart';
import 'package:librino/logic/cubits/module/home_modules_list/home_modules_list_state.dart';

class HomeModulesListCubit extends Cubit<HomeModulesListState> {
  final _moduleRepository = GetIt.I.get<ModuleRepository>();

  HomeModulesListCubit() : super(LoadingHomeModulesList());

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
