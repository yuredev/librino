import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:librino/core/enums/enums.dart';

part 'lesson_step.g.dart';

@JsonSerializable()
class LessonStep extends Equatable {
  final LessonStepType type;
  final String id;
  final int number;

  const LessonStep({
    required this.type,
    required this.id,
    required this.number,
  });

  factory LessonStep.fromJson(Map<String, dynamic> json) =>
      _$LessonStepFromJson(json);

  Map<String, dynamic> toJson() => _$LessonStepToJson(this);

  @override
  List<Object?> get props => [type, id, number];
}
