import 'package:json_annotation/json_annotation.dart';
import 'package:librino/data/models/lesson_step/abstract_lesson_step/lesson_step.dart';
import 'package:librino/core/enums/enums.dart';

part 'phrase_to_libras_question.g.dart';

@JsonSerializable()
class PhraseToLibrasQuestion extends LessonStep {
  const PhraseToLibrasQuestion({
    required super.type,
    required super.id,
    required super.number,
  });

  @override
  List<Object?> get props => [...super.props];

  factory PhraseToLibrasQuestion.fromJson(Map<String, dynamic> json) =>
      _$PhraseToLibrasQuestionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhraseToLibrasQuestionToJson(this);
}
