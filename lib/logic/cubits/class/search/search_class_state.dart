import 'package:equatable/equatable.dart';
import 'package:librino/data/models/class/class.dart';

abstract class SearchClassState extends Equatable {
  const SearchClassState();
}

class InitialSearchClassState extends SearchClassState {
  @override
  List<Object?> get props => [];
}

class SearchingClassState extends SearchClassState {
  @override
  List<Object?> get props => [];
}

class ClassFoundState extends SearchClassState {
  final Class clazz;

  const ClassFoundState(this.clazz);

  @override
  List<Object?> get props => [clazz];
}

class ClassNotFoundState extends SearchClassState {
  const ClassNotFoundState();

  @override
  List<Object?> get props => [];
}

class SearchClassErrorState extends SearchClassState {
  final String errorMessage;

  const SearchClassErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
