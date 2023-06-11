import 'package:json_annotation/json_annotation.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/core/enums/enums.dart';

part 'libras_to_word_question.g.dart';

@JsonSerializable()
class LibrasToWordQuestion extends Question {
  final String rightChoice;
  final List<String> choices;
  final String assetUrl;

  const LibrasToWordQuestion({
    required this.rightChoice,
    required this.choices,
    required this.assetUrl,
    required super.type,
    super.id,
    required super.statement,
    required super.creatorId,

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
}
