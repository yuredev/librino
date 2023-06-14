// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:librino/data/models/question/question.dart';

part 'lesson.g.dart';

@JsonSerializable()
class Lesson extends Equatable {
  final String? id;
  final int index;
  final String title;
  final List<String> questionIds;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final List<Question>? questions;
  final String moduleId;
  final String? supportContentId;

  const Lesson({
    this.questions,
    required this.moduleId,
    this.id,
    required this.title,
    required this.index,
    required this.questionIds,
    this.supportContentId,
  });

  @override
  List<Object?> get props => [
        id,
        index,
        title,
        questions,
        supportContentId,
        ...questionIds,
      ];

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);

  Map<String, dynamic> toJson() => _$LessonToJson(this);

  Lesson copyWith({
    String? id,
    int? index,
    String? title,
    List<String>? questionIds,
    List<Question>? questions,
    String? moduleId,
    String? supportContentId,
  }) {
    return Lesson(
      id: id ?? this.id,
      index: index ?? this.index,
      title: title ?? this.title,
      questionIds: questionIds ?? this.questionIds,
      questions: questions ?? this.questions,
      moduleId: moduleId ?? this.moduleId,
      supportContentId: supportContentId ?? this.supportContentId,
    );
  }
}
