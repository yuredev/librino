import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/data/models/question/libras_to_word/libras_to_word_question.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/utils/sound_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/lesson_topbar_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/question_title.dart';
import 'package:librino/presentation/widgets/shared/video_player_widget.dart';

class LibrasToWordScreen extends StatefulWidget {
  final Widget? floatingActionButton;
  final bool readOnly;
  final PlayLessonDTO playLessonDTO;

  const LibrasToWordScreen({
    super.key,
    required this.playLessonDTO,
    this.floatingActionButton,
    this.readOnly = false,
  });

  @override
  State<LibrasToWordScreen> createState() => _LibrasToWordScreenState();
}

class _LibrasToWordScreenState extends State<LibrasToWordScreen> {
  String? selectedWord;

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

  bool hasMissed() {
    return selectedWord != question.rightChoice;
  }

  LibrasToWordQuestion get question =>
      (widget.playLessonDTO.currentQuestion as LibrasToWordQuestion);

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(23, 40, 23, 0),
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
              margin: const EdgeInsets.only(bottom: 26),
              color: LibrinoColors.backgroundGray,
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 64,
              //   vertical: 16,
              // ),
              // height: 100,
              width: double.infinity,
              child: VideoPlayerWidget(
                videoPath: question.assetUrl!,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 46),
              padding: const EdgeInsets.symmetric(
                horizontal: 23,
              ),
              child: ListView.separated(
                itemCount: question.choices.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) => RadioListTile<String?>(
                  title: Text(question.choices[index]),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(width: 2, color: LibrinoColors.borderGray),
                  ),
                  contentPadding: EdgeInsets.zero,
                  value: question.choices[index],
                  groupValue: selectedWord,
                  onChanged: (value) {
                    setState(() => selectedWord = value);
                  },
                ),
              ),
            ),
            if (!widget.readOnly)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 23,
                ),
                margin: const EdgeInsets.only(
                  bottom: Sizes.defaultScreenBottomMargin,
                ),
                child: ButtonWidget(
                  title: 'Checar',
                  width: double.infinity,
                  height: Sizes.defaultButtonHeight,
                  onPress: () => onButtonPress(context),
                  isEnabled: selectedWord != null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
