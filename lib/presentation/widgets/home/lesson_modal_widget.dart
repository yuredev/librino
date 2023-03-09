import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/logic/cubits/lesson/lesson_state.dart';
import 'package:librino/presentation/visual_alerts.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/modal_top_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/progress_bar_widget.dart';

class LessonModalWidget extends StatelessWidget {
  final Lesson lesson;
  final Module module;

  const LessonModalWidget(
    this.lesson, {
    super.key,
    required this.module,
  });

  static const _navigationMapping = {
    LessonStepType.librasToWord: Routes.librasToWordQuestion,
    LessonStepType.librasToPhrase: Routes.librasToPhraseQuestion,
    LessonStepType.wordToLibras: Routes.wordToLibrasQuestion,
    LessonStepType.phraseToLibras: Routes.phraseToLibrasQuestion,
    LessonStepType.supportContent: Routes.phraseToLibrasQuestion,
  };

  void onButtonPress(BuildContext context) {
    final steps = lesson.steps;
    steps.sort((a, b) {
      return a.number - b.number;
    });
    final firstStep = steps.removeAt(0);
    Navigator.pushReplacementNamed(
      context,
      _navigationMapping[firstStep.type]!,
      arguments: {'steps': steps},
    );

    switch (firstStep.type) {
      case LessonStepType.librasToWord:
        Navigator.pushReplacementNamed(context, Routes.librasToWordQuestion);
        break;
      case LessonStepType.librasToPhrase:
        Navigator.pushReplacementNamed(context, Routes.librasToPhraseQuestion);
        break;
      case LessonStepType.wordToLibras:
        Navigator.pushReplacementNamed(context, Routes.wordToLibrasQuestion);
        break;
      case LessonStepType.phraseToLibras:
        Navigator.pushReplacementNamed(context, Routes.phraseToLibrasQuestion);
        break;
      case LessonStepType.supportContent:
        // TODO:
        Navigator.pushReplacementNamed(context, Routes.librasToWordQuestion);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.51,
      child: Padding(
        padding: const EdgeInsets.only(
          top: Sizes.modalBottomSheetDefaultTopPadding,
          bottom: Sizes.modalBottomSheetDefaultBottomPadding,
          left: Sizes.defaultScreenHorizontalMargin,
          right: Sizes.defaultScreenHorizontalMargin,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  Flexible(
                    child: Image.network(module.imageUrl),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Text(
                      module.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('70% concluído'), Text('4/8 exercícios')],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 6),
                    child: ProgressBarWidget(
                      color: LibrinoColors.mainOrange,
                      height: 15,
                      progression: 70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Dificuldade: ',
                        style: TextStyle(
                          color: LibrinoColors.textLightBlack,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        size: 18,
                        color: LibrinoColors.starGold,
                        shadows: [
                          BoxShadow(
                            blurRadius: 1,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.star,
                        size: 18,
                        color: lesson.difficulty > 0
                            ? LibrinoColors.starGold
                            : LibrinoColors.disabledGray,
                        shadows: [
                          BoxShadow(
                            blurRadius: 1,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.star,
                        size: 18,
                        color: lesson.difficulty > 1
                            ? LibrinoColors.starGold
                            : LibrinoColors.disabledGray,
                        shadows: [
                          BoxShadow(
                            blurRadius: 1,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                        text: 'N° de exercícios: ',
                        style: TextStyle(
                          color: LibrinoColors.textLightBlack,
                        ),
                        children: [
                          TextSpan(text: lesson.steps.length.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            ButtonWidget(
              onPress: () => onButtonPress(context),
              title: 'Praticar',
              height: Sizes.defaultButtonSize,
              width: double.infinity,
              leftIcon: Icon(
                Icons.gamepad,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
