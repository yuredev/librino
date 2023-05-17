import 'package:json_annotation/json_annotation.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/lesson_step/abstract_lesson_step/lesson_step.dart';

part 'word_to_libras_question.g.dart';

@JsonSerializable()
class WordToLibrasQuestion extends LessonStep {
  const WordToLibrasQuestion({
    required super.type,
    required super.id,
    required super.number,
  });

  @override
  List<Object?> get props => [...super.props];

  factory WordToLibrasQuestion.fromJson(Map<String, dynamic> json) =>
      _$WordToLibrasQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$WordToLibrasQuestionToJson(this);
}
