import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/core/utils/array_utils.dart';
import 'package:librino/core/utils/string_utils.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/data/models/question/libras_to_phrase/libras_to_phrase_question.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/utils/sound_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/lesson_topbar_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/question_title.dart';
import 'package:librino/presentation/widgets/shared/video_player_widget.dart';
import 'package:reorderables/reorderables.dart';

class LibrasToPhraseScreen extends StatefulWidget {
  final PlayLessonDTO playLessonDTO;
  final Widget? floatingActionButton;
  final bool readOnly;

  const LibrasToPhraseScreen({
    super.key,
    this.floatingActionButton,
    required this.playLessonDTO,
    this.readOnly = false,
  });

  @override
  State<LibrasToPhraseScreen> createState() => _LibrasToPhraseScreenState();
}

class _LibrasToPhraseScreenState extends State<LibrasToPhraseScreen> {
  final selectedWords = <String>[];
  late final List<String> words;

  @override
  void initState() {
    super.initState();
    initializeWords();
  }

  void initializeWords() {
    words = ArrayUtils.shuffle([
      ...question.choices,
      ...question.answerText
          .trim()
          .replaceAll('  ', ' ')
          .replaceAll('   ', ' ')
          .replaceAll('    ', ' ')
          .split(' ')
          .map((e) => StringUtils.toTitle(e)),
    ]);
  }

  LibrasToPhraseQuestion get question =>
      widget.playLessonDTO.currentQuestion as LibrasToPhraseQuestion;

  void onButtonPress(BuildContext context) {
    final questions = widget.playLessonDTO.questions;
    final question = questions.removeAt(0);
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

  bool hasMissed() =>
      selectedWords.join(' ').toLowerCase() !=
      question.answerText.toLowerCase();

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: widget.floatingActionButton,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: Sizes.defaultScreenBottomMargin * (widget.readOnly ? 4 : 1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(
                Sizes.defaultScreenHorizontalMargin,
                40,
                Sizes.defaultScreenHorizontalMargin,
                0,
              ),
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
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
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: const QuestionTitleWidget(
                      'Qual a tradução deste sinal em português?',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              color: LibrinoColors.backgroundGray,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: VideoPlayerWidget(
                        videoPath: question.assetUrl!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(23, 0, 23, 0),
              child: Column(
                children: [
                  if (selectedWords.isEmpty)
                    LayoutBuilder(
                      builder: (context, constraints) => Container(
                        margin: const EdgeInsets.only(bottom: 26),
                        width: constraints.maxWidth * .7,
                        child: Text(
                          'Toque nas palavras abaixo para formar a frase'
                          ' correspondente ao sinal do vídeo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LibrinoColors.subtitleGray,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.only(bottom: 26),
                      child: ReorderableWrap(
                        needsLongPressDraggable: false,
                        buildDraggableFeedback: (ctx, consts, widget) {
                          return Material(
                            borderRadius: BorderRadius.circular(25),
                            child: Transform.scale(
                              scaleX: 1.15,
                              scaleY: 1.15,
                              child: widget,
                            ),
                          );
                        },
                        spacing: 7,
                        runSpacing: -4,
                        onReorder: (int oldIndex, int newIndex) {
                          final aux = selectedWords[oldIndex];
                          setState(() {
                            selectedWords[oldIndex] = selectedWords[newIndex];
                            selectedWords[newIndex] = aux;
                          });
                        },
                        children: selectedWords
                            .map(
                              (e) => Theme(
                                data: ThemeData(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedWords.remove(e);
                                    });
                                  },
                                  child: Chip(
                                    backgroundColor:
                                        LibrinoColors.backgroundWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                        color: LibrinoColors.borderGray,
                                      ),
                                    ),
                                    label: Text(
                                      e,
                                      style: TextStyle(
                                        color: LibrinoColors.textLightBlack,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(bottom: 26),
                    child: const Divider(height: 0, thickness: 1),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 7,
                    runSpacing: -4,
                    children: words.map(
                      (e) {
                        final isDisabled = selectedWords.contains(e);
                        return Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (!selectedWords.contains(e)) {
                                setState(() {
                                  selectedWords.add(e);
                                });
                              }
                            },
                            child: Chip(
                              backgroundColor: isDisabled
                                  ? LibrinoColors.disabledGray
                                  : LibrinoColors.backgroundWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  color: LibrinoColors.borderGray,
                                ),
                              ),
                              label: Text(
                                e,
                                style: TextStyle(
                                  color: isDisabled
                                      ? LibrinoColors.disabledGray
                                      : LibrinoColors.textLightBlack,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  if (!widget.readOnly)
                    Container(
                      margin: const EdgeInsets.only(
                        top: 50,
                      ),
                      child: ButtonWidget(
                        title: 'Checar',
                        height: Sizes.defaultButtonHeight,
                        width: double.infinity,
                        onPress: () => onButtonPress(context),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
