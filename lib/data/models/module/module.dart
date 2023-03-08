// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'module.g.dart';

@JsonSerializable()
class Module extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final int number;

  const Module({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.number,
  });

  @override
  List<Object?> get props => [title, imageUrl];

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleToJson(this);

  Module copyWith({
    String? id,
    String? title,
    String? imageUrl,
    int? number,
  }) {
    return Module(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      number: number ?? this.number,
    );
  }
}
