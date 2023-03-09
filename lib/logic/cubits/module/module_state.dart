// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:librino/data/models/module/module.dart';

abstract class ModuleState {}

class LoadingHomeModulesList implements ModuleState {}

class HomeModulesListLoaded extends Equatable implements ModuleState {
  final List<Module> modules;

  const HomeModulesListLoaded(
    this.modules,
  );

  @override
  List<Object?> get props => [modules];
}

class HomeModulesListError extends Equatable implements ModuleState {
  final String message;
  final bool isNetworkError;

  const HomeModulesListError({
    required this.message,
    required this.isNetworkError,
  });

  @override
  List<Object?> get props => [message, isNetworkError];
}
