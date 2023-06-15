// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:librino/data/models/question/question.dart';

class PlayLessonDTO extends Equatable {
  final int? lives;
  final List<Question> questions;
  final Question currentQuestion;
  final int? totalQuestions;
  final int? index;

  const PlayLessonDTO({
    this.lives,
    this.index,
    this.totalQuestions,
    required this.questions,
    required this.currentQuestion,
  });

  @override
  List<Object?> get props => [
        lives,
        questions,
        currentQuestion,
        totalQuestions,
        index,
      ];

  PlayLessonDTO copyWith({
    int? lives,
    List<Question>? nextQuestions,
    Question? currentQuestion,
    int? totalQuestions,
    int? index,
  }) {
    return PlayLessonDTO(
      lives: lives ?? this.lives,
      questions: nextQuestions ?? this.questions,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      index: index ?? this.index,
    );
  }
}
