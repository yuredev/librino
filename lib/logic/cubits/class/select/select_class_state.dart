import 'package:equatable/equatable.dart';
import 'package:librino/data/models/class/class.dart';

class SelectClassState extends Equatable {
  final Class? clazz;

  const SelectClassState(this.clazz);

  @override
  List<Object?> get props => [clazz];
}
