import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/presentation/utils/presentation_utils.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/librino_scaffold.dart';

class SupportContentScreen extends StatelessWidget {
  final PlayLessonDTO playLessonDTO;
  final _mock = '''<div>
    <h1>This is a title</h1>
    <p>This is a <strong>paragraph</strong>.</p>
    <p>I like <i>dogs</i></p>
    <p style='color: red, font-size: 20px'>Red text</p>
    <ul>
        <li>List item 1</li>
        <li>List item 2</li>
        <li>List item 3</li>
    </ul>
    <img style='width: 300, height: 200' src='https://www.kindacode.com/wp-content/uploads/2020/11/my-dog.jpg' />
</div>''';

  const SupportContentScreen({super.key, required this.playLessonDTO});

  void onButtonPress(BuildContext context) {
    if (playLessonDTO.questions.isEmpty) {
      PresentationUtils.showSnackBar(context, 'Concluído');
      Navigator.pop(context);
      return;
    }
    final firstStep = playLessonDTO.questions.removeAt(0);
    Navigator.pushReplacementNamed(
      context,
      lessonTypeToScreenNameMap[firstStep.type]!,
      arguments: playLessonDTO,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LibrinoScaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(
          Sizes.defaultScreenHorizontalMargin,
          0,
          Sizes.defaultScreenHorizontalMargin,
          16,
        ),
        child: ButtonWidget(
          title: 'Começar',
          height: Sizes.defaultButtonHeight,
          width: double.infinity,
          onPress: () => onButtonPress(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Html(data: _mock),
      ),
    );
  }
}
