import 'package:json_annotation/json_annotation.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/core/enums/enums.dart';

part 'phrase_to_libras_question.g.dart';

@JsonSerializable()
class PhraseToLibrasQuestion extends Question {
  final List<String>? answerUrls;

  const PhraseToLibrasQuestion({
    required super.type,
    super.id,
    required super.statement,
    super.creatorId,
    super.isPublic,
    this.answerUrls,
  });

  @override
  List<Object?> get props => [...super.props];

  factory PhraseToLibrasQuestion.fromJson(Map<String, dynamic> json) =>
      _$PhraseToLibrasQuestionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PhraseToLibrasQuestionToJson(this);

  PhraseToLibrasQuestion copyWith({
    QuestionType? type,
    String? id,
    String? statement,
    String? creatorId,
    bool? isPublic,
    List<String>? answerUrls,
  }) {
    return PhraseToLibrasQuestion(
      type: type ?? this.type,
      statement: statement ?? this.statement,
      creatorId: creatorId ?? this.creatorId,
      isPublic: isPublic ?? this.isPublic,
      id: id ?? this.id,
      answerUrls: answerUrls ?? this.answerUrls,
    );
  }
}
