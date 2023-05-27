import 'package:equatable/equatable.dart';
import 'package:librino/data/models/class/class.dart';

abstract class LoadDefaultClassState extends Equatable {
  const LoadDefaultClassState();
}

class InitialLoadDefaultClassState extends LoadDefaultClassState {
  @override
  List<Object?> get props => [];
}

class LoadingDefaultClassState extends LoadDefaultClassState {
  @override
  List<Object?> get props => [];
}

class DefaultClassLoadedState extends LoadDefaultClassState {
  final Class clazz;

  const DefaultClassLoadedState(this.clazz);

  @override
  List<Object?> get props => [clazz];
}

class ErrorAtLoadDefaultClassState extends LoadDefaultClassState {
  final String errorMessage;

  const ErrorAtLoadDefaultClassState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
