// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:librino/core/enums/enums.dart';

class QuestionFilter {
  final QuestionType? questionType;
  final String? text;

  const QuestionFilter({
    this.questionType,
    this.text,
  });

  QuestionFilter copyWith({
    QuestionType? questionType,
    String? text,
  }) {
    return QuestionFilter(
      questionType: questionType ?? this.questionType,
      text: text ?? this.text,
    );
  }
}
