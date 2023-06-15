import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/data/models/question/word_to_libras/word_to_libras_question.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/utils/sound_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/lesson_topbar_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/question_title.dart';

class WordToLibrasScreen extends StatefulWidget {
  final PlayLessonDTO playLessonDTO;
  final bool readOnly;
  final Widget? floatingActionButton;

  const WordToLibrasScreen({
    super.key,
    required this.playLessonDTO,
    this.readOnly = false,
    this.floatingActionButton,
  });

  @override
  State<WordToLibrasScreen> createState() => _WordToLibrasScreenState();
}

class _WordToLibrasScreenState extends State<WordToLibrasScreen> {
  String? selectedImageUrl;

  WordToLibrasQuestion get question =>
      widget.playLessonDTO.currentQuestion as WordToLibrasQuestion;

  void onButtonPress(BuildContext context) {
    final questions = widget.playLessonDTO.questions;
    final question = questions.removeAt(0);
    late final int lives;
    if (hasMissed()) {
      if (widget.playLessonDTO.lives == 1) {
        Navigator.pop(context);
        SoundUtils.play('loss.mp3');
        // TODO: mostrar modal de perdedor
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
      Navigator.pop(context);
      SoundUtils.play('win.mp3');
      // TODO: mostrar modal de conclusão
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

  bool hasMissed() => selectedImageUrl != question.rightChoiceUrl;

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).viewPadding;
    final height = fullHeight - padding.top - padding.bottom;
    return LibrinoScaffold(
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        height: height,
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
            Flexible(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 36),
                    padding: const EdgeInsets.only(right: 20),
                    child: QuestionTitleWidget(question.statement),
                  ),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: question.choicesUrls!
                        .map(
                          (e) => Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: selectedImageUrl == e
                                      ? LibrinoColors.highlightLightBlue
                                      : Colors.transparent,
                                  width: selectedImageUrl == e ? 7 : 1),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() => selectedImageUrl = e);
                                },
                                child: Ink.image(
                                  image: NetworkImage(e),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  if (!widget.readOnly) Spacer(),
                  if (!widget.readOnly)
                    Container(
                      margin: const EdgeInsets.only(
                        top: 50,
                        bottom: Sizes.defaultScreenBottomMargin,
                      ),
                      child: ButtonWidget(
                        isEnabled: selectedImageUrl != null,
                        title: 'Checar',
                        height: Sizes.defaultButtonHeight,
                        width: double.infinity,
                        onPress: () => onButtonPress(context),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
