import 'package:json_annotation/json_annotation.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/lesson_step/abstract_lesson_step/lesson_step.dart';

part 'libras_to_word_question.g.dart';

@JsonSerializable()
class LibrasToWordQuestion extends LessonStep {
  final String rightChoice;
  final List<String> choices;
  final String assetUrl;

  const LibrasToWordQuestion({
    required this.rightChoice,
    required this.choices,
    required this.assetUrl,
    required super.type,
    required super.id,
    required super.number,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        rightChoice,
        choices,
        assetUrl,
      ];

  factory LibrasToWordQuestion.fromJson(Map<String, dynamic> json) =>
      _$LibrasToWordQuestionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LibrasToWordQuestionToJson(this);
}
