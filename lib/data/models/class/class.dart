import 'package:equatable/equatable.dart';

class Class extends Equatable {
  final String name;
  final String description;
  final String id;

  const Class({
    required this.description,
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
        description,
        id,
      ];

  Class copyWith({
    String? description,
    String? id,
    String? name,
  }) {
    return Class(
      description: description ?? this.description,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
