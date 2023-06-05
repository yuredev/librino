import 'package:equatable/equatable.dart';
import 'package:librino/data/models/module/module.dart';

abstract class ModuleActionsState extends Equatable {
  const ModuleActionsState();
}

class InitialModuleActionsState extends ModuleActionsState {
  @override
  List<Object?> get props => [];
}

class CreatingModuleState extends ModuleActionsState {
  @override
  List<Object?> get props => [];
}

class ModuleCreatedState extends ModuleActionsState {
  final Module module;

  const ModuleCreatedState(this.module);

  @override
  List<Object?> get props => [module];
}

class CreateModuleErrorState extends ModuleActionsState {
  final String errorMessage;

  const CreateModuleErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
