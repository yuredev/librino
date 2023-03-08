import 'package:json_annotation/json_annotation.dart';
import 'package:librino/data/models/lesson_step/abstract_lesson_step/lesson_step.dart';
import 'package:librino/core/enums/enums.dart';

part 'libras_to_phrase_question.g.dart';

@JsonSerializable()
class LibrasToPhraseQuestion extends LessonStep {
  const LibrasToPhraseQuestion({
    required super.type,
    required super.id,
    required super.number,
  });

  @override
  List<Object?> get props => [...super.props];

  factory LibrasToPhraseQuestion.fromJson(Map<String, dynamic> json) =>
      _$LibrasToPhraseQuestionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LibrasToPhraseQuestionToJson(this);
}
