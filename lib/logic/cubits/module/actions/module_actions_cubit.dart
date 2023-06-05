import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:librino/core/bindings.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/data/repositories/module_repository.dart';
import 'package:librino/logic/cubits/class/select/select_class_cubit.dart';
import 'package:librino/logic/cubits/global_alert/global_alert_cubit.dart';
import 'package:librino/logic/cubits/module/actions/module_actions_state.dart';
import 'package:librino/logic/cubits/module/load/load_modules_cubit.dart';

class ModuleActionsCubit extends Cubit<ModuleActionsState> {
  final LoadModulesCubit _loadModulesCubit = Bindings.get();
  final SelectClassCubit _selectClassCubit = Bindings.get();
  final GlobalAlertCubit _globalAlertCubit = Bindings.get();
  final ModuleRepository _moduleRepository = Bindings.get();

  ModuleActionsCubit() : super(InitialModuleActionsState());

  Future<void> create(Module module, XFile? image) async {
    try {
      emit(CreatingModuleState());
      final moduleSaved = await _moduleRepository.create(module, image);
      _globalAlertCubit.fire('Modulo cadastrado com sucesso!');
      _loadModulesCubit.loadFromClass(_selectClassCubit.state.clazz!.id!);
      emit(ModuleCreatedState(moduleSaved));
    } catch (e) {
      print(e);
      _globalAlertCubit.fire('Erro ao cadastrar novo módulo', isErrorMessage: true);
      emit(CreateModuleErrorState('Erro ao cadastrar novo módulo'));
    }
  }
}
