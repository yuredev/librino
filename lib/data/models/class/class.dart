// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class.g.dart';

@JsonSerializable()
class Class extends Equatable {
  final String name;
  final String description;
  final String? id;
  final String? ownerId;
  final String? ownerName;

  const Class({
    required this.description,
    this.id,
    required this.name,
    this.ownerId,
    this.ownerName,
  });

  @override
  List<Object?> get props => [
        description,
        id,
        ownerId,
        name,
        ownerName,
      ];

  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);

  Map<String, dynamic> toJson() => _$ClassToJson(this);

  Class copyWith({
    String? name,
    String? description,
    String? id,
    String? ownerId,
    String? ownerName,
  }) {
    return Class(
      name: name ?? this.name,
      description: description ?? this.description,
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
    );
  }
}
