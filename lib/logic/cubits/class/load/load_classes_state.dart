import 'package:equatable/equatable.dart';
import 'package:librino/data/models/class/class.dart';

abstract class LoadClassesState extends Equatable {
  const LoadClassesState();
}

class InitialLoadClassesState extends LoadClassesState {
  @override
  List<Object?> get props => [];
}

class LoadingClassesState extends LoadClassesState {
  @override
  List<Object?> get props => [];
}

class ClassesLoadedState extends LoadClassesState {
  final List<Class> classes;

  const ClassesLoadedState(this.classes);

  @override
  List<Object?> get props => [...classes];
}

class ErrorAtLoadClassesState extends LoadClassesState {
  final String errorMessage;

  const ErrorAtLoadClassesState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
