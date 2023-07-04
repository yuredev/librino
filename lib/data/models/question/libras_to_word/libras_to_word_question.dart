// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/question/question.dart';

part 'libras_to_word_question.g.dart';

@JsonSerializable()
class LibrasToWordQuestion extends Question {
  final String rightChoice;
  final List<String> choices;
  final String? assetUrl;

  const LibrasToWordQuestion({
    required this.rightChoice,
    required this.choices,
    this.assetUrl,
    required super.type,
    super.id,
    required super.statement,
    super.creatorId,
    super.isPublic,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        rightChoice,
        choices,
        assetUrl,
      ];

  @override
  String get label => 'Tradução de "$rightChoice"';

  factory LibrasToWordQuestion.fromJson(Map<String, dynamic> json) =>
      _$LibrasToWordQuestionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LibrasToWordQuestionToJson(this);

  LibrasToWordQuestion copyWith({
    String? rightChoice,
    List<String>? choices,
    String? assetUrl,
    bool? isPublic,
    String? statement,
    QuestionType? type,
    String? id,
    String? creatorId,
  }) {
    return LibrasToWordQuestion(
      rightChoice: rightChoice ?? this.rightChoice,
      choices: choices ?? this.choices,
      assetUrl: assetUrl ?? this.assetUrl,
      statement: statement ?? this.statement,
      type: type ?? this.type,
      isPublic: isPublic ?? this.isPublic,
      id: id,
      creatorId: creatorId,
    );
  }
}
