// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:librino/core/enums/enums.dart';

class QuestionFilter {
  final QuestionType? questionType;
  final String? text;

  const QuestionFilter({
    this.questionType,
    this.text,
  });

  bool get isEmpty => (text == null || text!.isEmpty) && questionType == null;

  QuestionFilter copyWith({
    QuestionType? questionType,
    String? text,
  }) {
    return QuestionFilter(
      questionType: questionType ?? this.questionType,
      text: text ?? this.text,
    );
  }

  QuestionFilter copyWithout({
    bool questionType = false,
    bool text = false,
  }) {
    return QuestionFilter(
      questionType: questionType ? null : this.questionType,
      text: text ? null : this.text,
    );
  }
}
