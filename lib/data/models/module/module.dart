// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

@JsonSerializable()
class Module extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String? imageUrl;
  final int index;
  final String classId;

  const Module({
    this.id,
    this.imageUrl,
    required this.title,
    required this.description,
    required this.index,
    required this.classId,
  });

  @override
  List<Object?> get props => [
        id,
        imageUrl,
        title,
        description,
        index,
        classId,
      ];

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  Module copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? index,
    String? classId,
  }) {
    return Module(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      index: index ?? this.index,
      classId: classId ?? this.classId,
    );
  }
}
