import 'package:equatable/equatable.dart';
import 'package:librino/data/models/class/class.dart';

abstract class ClassCRUDState extends Equatable {
  const ClassCRUDState();
}

class InitialClassCRUDState extends ClassCRUDState {
  @override
  List<Object?> get props => [];
}

class CreatingClassState extends ClassCRUDState {
  @override
  List<Object?> get props => [];
}

class ClassCreatedState extends ClassCRUDState {
  final Class clazz;

  const ClassCreatedState(this.clazz);

  @override
  List<Object?> get props => [];
}

class ErrorCreatingClassState extends ClassCRUDState {
  final String errorMessage;

  const ErrorCreatingClassState(this.errorMessage);
  
  @override
  List<Object?> get props => [errorMessage];
}
