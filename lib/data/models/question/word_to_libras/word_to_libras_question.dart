// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/question/question.dart';

part 'word_to_libras_question.g.dart';

@JsonSerializable()
class WordToLibrasQuestion extends Question {
  final String? rightChoiceUrl;
  final List<String>? choicesUrls;

  const WordToLibrasQuestion({
    required super.type,
    this.rightChoiceUrl,
    this.choicesUrls,
    super.id,
    required super.statement,
    super.creatorId,
    super.isPublic,
  });

  @override
  List<Object?> get props => [...super.props];

  factory WordToLibrasQuestion.fromJson(Map<String, dynamic> json) =>
      _$WordToLibrasQuestionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WordToLibrasQuestionToJson(this);

  WordToLibrasQuestion copyWith({
    QuestionType? type,
    String? id,
    String? statement,
    String? creatorId,
    bool? isPublic,
    List<String>? choicesUrls,
    String? rightChoiceUrl,
  }) {
    return WordToLibrasQuestion(
      type: type ?? this.type,
      statement: statement ?? this.statement,
      creatorId: creatorId ?? this.creatorId,
      isPublic: isPublic ?? this.isPublic,
      id: id ?? this.id,
      choicesUrls: choicesUrls ?? this.choicesUrls,
      rightChoiceUrl: rightChoiceUrl ?? this.rightChoiceUrl,
    );
  }
}
