// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:librino/data/models/question/question.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson extends Equatable {
  final int number;
  final int difficulty;
  final String title;
  final List<Question> steps;
  final String? supportContentId;

  const Lesson({
    required this.title,
    required this.number,
    required this.difficulty,
    required this.steps,
    this.supportContentId,
  });

  @override
  List<Object?> get props => [
        number,
        difficulty,
        steps,
        supportContentId,
        title,
      ];

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
