// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:librino/data/models/question/question.dart';

class PlayLessonDTO extends Equatable {
  final int? lives;
  final List<Question> questions;

  const PlayLessonDTO({
    this.lives,
    required this.questions,
  });

  PlayLessonDTO copyWith({
    int? lives,
    List<Question>? questions,
  }) {
    return PlayLessonDTO(
      lives: lives ?? this.lives,
      questions: questions ?? this.questions,
    );
  }

  @override
  List<Object?> get props => [lives, questions];
}
