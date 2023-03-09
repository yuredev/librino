import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/lesson_step/libras_to_phrase/libras_to_phrase_question.dart';
import 'package:librino/data/models/lesson_step/libras_to_word/libras_to_word_question.dart';
import 'package:librino/data/models/lesson_step/phrase_to_libras/phrase_to_libras_question.dart';
import 'package:librino/data/models/lesson_step/support_content/support_content.dart';
import 'package:librino/data/models/lesson_step/word_to_libras/word_to_libras_question.dart';

part 'lesson_step.g.dart';

@JsonSerializable()
class LessonStep extends Equatable {
  final LessonStepType type;
  final String id;
  final int number;

  const LessonStep({
    required this.type,
    required this.id,
    required this.number,
  });

  factory LessonStep.fromJson(Map<String, dynamic> json) {
    switch (_$LessonStepFromJson(json).type) {
      case LessonStepType.librasToWord:
        return LibrasToWordQuestion.fromJson(json);

      case LessonStepType.librasToPhrase:
        return LibrasToPhraseQuestion.fromJson(json);

      case LessonStepType.wordToLibras:
        return WordToLibrasQuestion.fromJson(json);

      case LessonStepType.phraseToLibras:
        return PhraseToLibrasQuestion.fromJson(json);

      case LessonStepType.supportContent:
        return SupportContent.fromJson(json);
    }
  }

  @override
  List<Object?> get props => [type, id, number];
}
