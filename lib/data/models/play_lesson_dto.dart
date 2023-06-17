// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:librino/data/models/question/question.dart';

class PlayLessonDTO extends Equatable {
  final int? lives;
  final List<Question> questions;
  final Question currentQuestion;
  final int? totalQuestions;
  final int? index;
  final String? lessonId;

  const PlayLessonDTO({
    this.lives,
    this.index,
    this.totalQuestions,
    this.lessonId,
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
        lessonId,
      ];

  PlayLessonDTO copyWith({
    int? lives,
    List<Question>? questions,
    Question? currentQuestion,
    int? totalQuestions,
    int? index,
    String? lessonId,
  }) {
    return PlayLessonDTO(
      lives: lives ?? this.lives,
      questions: questions ?? this.questions,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      index: index ?? this.index,
      lessonId: lessonId ?? this.lessonId,
    );
  }
}
