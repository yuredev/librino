// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:librino/data/models/lesson_step/abstract_lesson_step/lesson_step.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson extends Equatable {
  final int number;
  final int difficulty;
  final List<LessonStep> steps;

  const Lesson({
    required this.number,
    required this.difficulty,
    required this.steps,
  });

  @override
  List<Object> get props => [number, difficulty, steps];

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);

  Lesson copyWith({
    int? number,
    int? difficulty,
    List<LessonStep>? steps,
  }) {
    return Lesson(
      number: number ?? this.number,
      difficulty: difficulty ?? this.difficulty,
      steps: steps ?? this.steps,
    );
  }
}
