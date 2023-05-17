// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:librino/data/models/lesson_step/abstract_lesson_step/lesson_step.dart';

class PlayLessonDTO extends Equatable {
  final int lives;
  final List<LessonStep> steps;

  const PlayLessonDTO({
    required this.lives,
    required this.steps,
  });

  PlayLessonDTO copyWith({
    int? lives,
    List<LessonStep>? steps,
  }) {
    return PlayLessonDTO(
      lives: lives ?? this.lives,
      steps: steps ?? this.steps,
    );
  }

  @override
  List<Object?> get props => [lives, steps];
}
