import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/question/libras_to_phrase/libras_to_phrase_question.dart';
import 'package:librino/data/models/question/libras_to_word/libras_to_word_question.dart';
import 'package:librino/data/models/question/phrase_to_libras/phrase_to_libras_question.dart';
import 'package:librino/data/models/question/word_to_libras/word_to_libras_question.dart';

part 'question.g.dart';

abstract class LabeledQuestion {
  String get label;
}

@JsonSerializable()
class Question extends Equatable implements LabeledQuestion {
  final String statement;
  final QuestionType type;
  final String? id;
  final String? creatorId;
  final bool isPublic;

  const Question({
    required this.statement,
    required this.type,
    this.id,
    this.creatorId,
    this.isPublic = false,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    switch (_$QuestionFromJson(json).type) {
      case QuestionType.librasToWord:
        return LibrasToWordQuestion.fromJson(json);

      case QuestionType.librasToPhrase:
        return LibrasToPhraseQuestion.fromJson(json);

      case QuestionType.wordToLibras:
        return WordToLibrasQuestion.fromJson(json);

      case QuestionType.phraseToLibras:
        return PhraseToLibrasQuestion.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  List<Object?> get props => [type, id, statement, creatorId, isPublic];

  @override
  String get label => statement;
}
