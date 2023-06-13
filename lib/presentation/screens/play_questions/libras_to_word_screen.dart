import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/utils/sound_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/lesson_topbar_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';
import 'package:librino/presentation/widgets/shared/question_title.dart';

class LibrasToWordScreen extends StatelessWidget {
  final Widget? floatingActionButton;
  final bool readOnly;
  final PlayLessonDTO? playLessonDTO;

  const LibrasToWordScreen({
    super.key,
    this.playLessonDTO,
    this.floatingActionButton,
    this.readOnly = false,
  });

  void onButtonPress(BuildContext context) {
    if (playLessonDTO!.questions.isEmpty) {
      Navigator.pop(context);
      SoundUtils.play('win.mp3');
      // TODO: mostrar modal de conclusão
      return;
    }
    final firstStep = playLessonDTO!.questions.removeAt(0);
    Navigator.pushReplacementNamed(
      context,
      lessonTypeToScreenNameMap[firstStep.type]!,
      arguments: playLessonDTO,
    );
    PresentationUtils.showQuestionResultFeedback(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(23, 40, 23, 0),
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  if (!readOnly)
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 26,
                      ),
                      child: const LessonTopBarWidget(
                        lifesNumber: 5,
                        progression: 45,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 64,
                vertical: 16,
              ),
              child: Card(
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: LibrinoColors.borderGray,
                  ),
                ),
                child: Image.network(
                  'https://thumbs.gfycat.com/MiniatureInconsequentialIceblueredtopzebra-size_restricted.gif',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 46),
              padding: const EdgeInsets.symmetric(
                horizontal: 23,
              ),
              child: ListView.separated(
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) => RadioListTile(
                  title: Text('Árvore'),
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(width: 2, color: LibrinoColors.borderGray),
                  ),
                  contentPadding: EdgeInsets.zero,
                  value: index == 3,
                  groupValue: [false, false, false, true],
                  onChanged: (o) {},
                ),
              ),
            ),
            if (!readOnly)
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}
