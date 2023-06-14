import 'package:flutter/material.dart';
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

class WordToLibrasScreen extends StatelessWidget {
  final PlayLessonDTO playLessonDTO;
  final bool readOnly;
  final Widget? floatingActionButton;

  const WordToLibrasScreen({
    super.key,
    required this.playLessonDTO,
    this.readOnly = false,
    this.floatingActionButton,
  });

  WordToLibrasQuestion get question =>
      playLessonDTO.questions[0] as WordToLibrasQuestion;

  void onButtonPress(BuildContext context) {
    if (playLessonDTO.questions.isEmpty) {
      Navigator.pop(context);
      SoundUtils.play('win.mp3');
      // TODO: mostrar modal de conclusão
      return;
    }
    final firstStep = playLessonDTO.questions.removeAt(0);
    Navigator.pushReplacementNamed(
      context,
      lessonTypeToScreenNameMap[firstStep.type]!,
      arguments: playLessonDTO,
    );
    PresentationUtils.showQuestionResultFeedback(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).viewPadding;
    final height = fullHeight - padding.top - padding.bottom;
    return LibrinoScaffold(
      floatingActionButton: floatingActionButton,
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
            if (!readOnly)
              Container(
                margin: const EdgeInsets.only(
                  bottom: 26,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: LessonTopBarWidget(
                  lifesNumber: playLessonDTO.lives!,
                  progression: 70,
                ),
              ),
            Flexible(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 36),
                    padding: const EdgeInsets.only(right: 20),
                    child: const QuestionTitleWidget(
                      'Qual destes sinais significa "Caminhão"?',
                    ),
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
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
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
                  if (!readOnly) Spacer(),
                  if (!readOnly)
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
          ],
        ),
      ),
    );
  }
}
