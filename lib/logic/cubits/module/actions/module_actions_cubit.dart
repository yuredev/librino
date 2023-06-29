import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_state.dart';
import 'package:librino/logic/cubits/module/load/load_modules_cubit.dart';

class ModuleActionsCubit extends Cubit<ModuleActionsState> {
  final LoadModulesCubit _loadModulesCubit = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();
  final ModuleRepository _moduleRepository = Bindings.get();

  ModuleActionsCubit() : super(InitialModuleActionsState());

  Future<void> create(Module module, XFile? image) async {
    try {
      emit(CreatingModuleState());
      final moduleSaved = await _moduleRepository.create(module, image);
      _globalAlertCubit.fire('Modulo cadastrado com sucesso!');
      _loadModulesCubit.load();
      emit(ModuleCreatedState(moduleSaved));
    } catch (e) {
      print(e);
      _globalAlertCubit.fire('Erro ao cadastrar novo módulo',
          isErrorMessage: true);
      emit(CreateModuleErrorState('Erro ao cadastrar novo módulo'));
    }
  }

  Future<void> reorder(
      List<Module> modules, List<String> removedModuleIds) async {
    try {
      emit(UpdatingModulesOrderState());
      for (final mId in removedModuleIds) {
        await _moduleRepository.delete(mId);
      }
      await _moduleRepository.updateList(modules);
      _globalAlertCubit.fire('Ordem dos módulos alterada!');
      emit(ModulesOrderUpdatedState());
      _loadModulesCubit.load();
    } catch (e) {
      print(e);
      _globalAlertCubit.fire(
        'Erro ao atualizar ordem dos módulos',
        isErrorMessage: true,
      );
      emit(ModuleOrderUpdateErrorState('Erro ao atualizar ordem dos módulos'));
    }
  }
}
