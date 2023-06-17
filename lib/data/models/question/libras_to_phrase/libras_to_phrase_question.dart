// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/question/question.dart';

part 'libras_to_phrase_question.g.dart';

@JsonSerializable()
class LibrasToPhraseQuestion extends Question {
  final String? assetUrl;
  final String answerText;
  final List<String> choices;

  const LibrasToPhraseQuestion({
    required super.type,
    super.id,
    required this.answerText,
    required super.statement,
    this.assetUrl,
    super.creatorId,
    required this.choices,
    super.isPublic,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        assetUrl,
        choices,
        answerText,
      ];

  factory LibrasToPhraseQuestion.fromJson(Map<String, dynamic> json) =>
      _$LibrasToPhraseQuestionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LibrasToPhraseQuestionToJson(this);

  LibrasToPhraseQuestion copyWith({
    String? assetUrl,
    String? answerText,
    String? statement,
    QuestionType? type,
    String? creatorId,
    List<String>? choices,
    bool? isPublic,
  }) {
    return LibrasToPhraseQuestion(
      assetUrl: assetUrl ?? this.assetUrl,
      answerText: answerText ?? this.answerText,
      statement: statement ?? super.statement,
      type: type ?? super.type,
      creatorId: creatorId ?? super.creatorId,
      choices: choices ?? this.choices,
      isPublic: isPublic ?? this.isPublic,
    );
  }

  @override
  String get label => 'Tradução: $answerText';
}
