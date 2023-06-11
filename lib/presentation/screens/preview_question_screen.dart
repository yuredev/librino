import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/enums/enums.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/presentation/screens/play_questions/libras_to_phrase_screen.dart';
import 'package:librino/presentation/screens/play_questions/libras_to_word_screen.dart';
import 'package:librino/presentation/screens/play_questions/phrase_to_libras_screen.dart';
import 'package:librino/presentation/screens/play_questions/word_to_libras_screen.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';

class PreviewQuestionScreen extends StatelessWidget {
  final Question question;

  const PreviewQuestionScreen({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    late final Widget questionScreen;

    final button = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.defaultScreenHorizontalMargin,
        vertical: Sizes.defaultScreenHorizontalMargin * 0.75,
      ),
      child: ButtonWidget(
        title: 'Adicionar',
        width: double.infinity,
        height: Sizes.defaultButtonHeight,
        onPress: () {
          Navigator.pop(context, true);
        },
      ),
    );

    switch (question.type) {
      case QuestionType.librasToPhrase:
        questionScreen = LibrasToPhraseScreen(
          readOnly: true,
          floatingActionButton: button,
        );
        break;
      case QuestionType.librasToWord:
        questionScreen = LibrasToWordScreen();
        break;
      case QuestionType.wordToLibras:
        questionScreen = WordToLibrasScreen();
        break;
      case QuestionType.phraseToLibras:
        questionScreen = PhraseToLibrasScreen();
        break;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LibrinoColors.deepBlue,
        centerTitle: true,
        title: const Text(
          'Adicionar questão?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: questionScreen,
    );
  }
}
