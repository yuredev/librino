import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/progress_bar_widget.dart';

class LessonModalWidget extends StatelessWidget {
  final Lesson lesson;
  final Module module;

  const LessonModalWidget(
    this.lesson, {
    super.key,
    required this.module,
  });

  void onButtonPress(BuildContext context) async {
    final steps = lesson.steps;
    final firstStep = steps.removeAt(0);

    Navigator.pushReplacementNamed(
      context,
      lessonTypeToScreenNameMap[firstStep.type]!,
      arguments: PlayLessonDTO(
        lives: 3,
        questions: steps,
      ),
    );
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
                    child: module.imageUrl == null
                        ? Image.asset('assets/images/hand.png')
                        : Image.network(module.imageUrl!),
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
                      color: LibrinoColors.main,
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
              height: Sizes.defaultButtonHeight,
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
