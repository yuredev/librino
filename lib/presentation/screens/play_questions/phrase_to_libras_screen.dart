import 'dart:math';

import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/core/utils/array_utils.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/data/models/question/phrase_to_libras/phrase_to_libras_question.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/utils/sound_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/lesson_topbar_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:reorderables/reorderables.dart';

class PhraseToLibrasScreen extends StatefulWidget {
  final bool readOnly;
  final Widget? floatingActionButton;
  final PlayLessonDTO playLessonDTO;

  const PhraseToLibrasScreen({
    super.key,
    required this.playLessonDTO,
    this.readOnly = false,
    this.floatingActionButton,
  });

  @override
  State<PhraseToLibrasScreen> createState() => _PhraseToLibrasScreenState();
}

class _PhraseToLibrasScreenState extends State<PhraseToLibrasScreen> {
  late final List<String> userAnswer;

  void onButtonPress(BuildContext context) {
    final questions = widget.playLessonDTO.questions;
    questions.removeAt(0);
    late final int lives;
    if (hasMissed()) {
      if (widget.playLessonDTO.lives == 1) {
        SoundUtils.play('loss.mp3');
        Navigator.pushReplacementNamed(
          context,
          Routes.lessonResult,
          arguments: {
            'hasFailed': true,
            'lessonId': widget.playLessonDTO.lessonId!,
          },
        );
        return;
      } else {
        PresentationUtils.showQuestionResultFeedback(context, false);
      }
      lives = widget.playLessonDTO.lives! - 1;
    } else {
      lives = widget.playLessonDTO.lives!;
      PresentationUtils.showQuestionResultFeedback(context, true);
    }
    if (questions.isEmpty) {
      SoundUtils.play('win.mp3');
      Navigator.pushReplacementNamed(
        context,
        Routes.lessonResult,
        arguments: {
          'hasFailed': false,
          'lessonId': widget.playLessonDTO.lessonId!,
        },
      );
      return;
    } else {
      Navigator.pushReplacementNamed(
        context,
        lessonTypeToScreenNameMap[questions[0].type]!,
        arguments: widget.playLessonDTO.copyWith(
          index: widget.playLessonDTO.index! + 1,
          lives: lives,
          currentQuestion: questions[0],
        ),
      );
    }
  }

  bool hasMissed() {
    for (int i = 0; i < userAnswer.length; i++) {
      if (userAnswer[i] != question.answerUrls![i]) {
        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    userAnswer = ArrayUtils.shuffle([...question.answerUrls!]);
  }

  PhraseToLibrasQuestion get question =>
      widget.playLessonDTO.currentQuestion as PhraseToLibrasQuestion;

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).viewPadding;
    return LibrinoScaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.floatingActionButton,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 40,
          left: Sizes.defaultScreenHorizontalMargin,
          right: Sizes.defaultScreenHorizontalMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.readOnly)
              Container(
                margin: const EdgeInsets.only(
                  bottom: 26,
                ),
                child: LessonTopBarWidget(
                  lifesNumber: widget.playLessonDTO.lives!,
                  progression: (widget.playLessonDTO.index! /
                          widget.playLessonDTO.totalQuestions!) *
                      100,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 36, top: 22),
                    child: Text(
                      question.statement,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (!widget.readOnly)
                    Container(
                      margin: const EdgeInsets.only(bottom: 22),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: LibrinoColors.lightPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.lightbulb,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Organize os sinais na ordem correta',
                            style: TextStyle(
                              fontSize: 12,
                              color: LibrinoColors.subtitleGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  LayoutBuilder(
                    builder: (ctx, constraints) => ReorderableWrap(
                      spacing: 16,
                      runSpacing: 16,
                      onReorder: (oldIndex, newIndex) {
                        final aux = userAnswer[oldIndex];
                        setState(() {
                          userAnswer[oldIndex] = userAnswer[newIndex];
                          userAnswer[newIndex] = aux;
                        });
                      },
                      needsLongPressDraggable: false,
                      buildDraggableFeedback: (ctx, consts, widget) {
                        return Material(
                          borderRadius: BorderRadius.circular(25),
                          child: Transform.scale(
                            scaleX: 1.1,
                            scaleY: 1.1,
                            child: widget,
                          ),
                        );
                      },
                      alignment: WrapAlignment.spaceBetween,
                      children: userAnswer
                          .map(
                            (e) => Container(
                              clipBehavior: Clip.antiAlias,
                              width: constraints.maxWidth * .45,
                              height: constraints.maxWidth * .45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              child: Image.network(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            if (!widget.readOnly)
              Container(
                margin: const EdgeInsets.only(
                  top: 50,
                  bottom: Sizes.defaultScreenBottomMargin,
                ),
                child: ButtonWidget(
                  title: 'Checar',
                  height: Sizes.defaultButtonHeight,
                  width: double.infinity,
                  onPress: () => onButtonPress(context),
                ),
              )
          ],
        ),
      ),
    );
  }
}
