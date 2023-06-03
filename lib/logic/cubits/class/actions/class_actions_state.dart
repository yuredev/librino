import 'package:equatable/equatable.dart';
import 'package:librino/data/models/class/class.dart';

abstract class ClassActionsState extends Equatable {
  const ClassActionsState();
}

class InitialClassActionsState extends ClassActionsState {
  @override
  List<Object?> get props => [];
}

class CreatingClassState extends ClassActionsState {
  @override
  List<Object?> get props => [];
}

class ClassCreatedState extends ClassActionsState {
  final Class clazz;

  const ClassCreatedState(this.clazz);

  @override
  List<Object?> get props => [];
}

class ErrorCreatingClassState extends ClassActionsState {
  final String errorMessage;

  const ErrorCreatingClassState(this.errorMessage);
  
  @override
  List<Object?> get props => [errorMessage];
}
