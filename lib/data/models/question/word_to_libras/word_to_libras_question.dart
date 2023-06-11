import 'package:json_annotation/json_annotation.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/core/enums/enums.dart';

part 'word_to_libras_question.g.dart';

@JsonSerializable()
class WordToLibrasQuestion extends Question {
  const WordToLibrasQuestion({
    required super.type,
    super.id,
    required super.statement,
    required super.creatorId,
  });

  @override
  List<Object?> get props => [...super.props];

  factory WordToLibrasQuestion.fromJson(Map<String, dynamic> json) =>
      _$WordToLibrasQuestionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WordToLibrasQuestionToJson(this);
}
