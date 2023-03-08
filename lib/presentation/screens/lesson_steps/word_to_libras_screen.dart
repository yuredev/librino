import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/presentation/widgets/shared/lesson_topbar_widget.dart';
import 'package:librino/presentation/widgets/shared/question_scaffold.dart';
import 'package:librino/presentation/widgets/shared/question_title.dart';

class WordToLibrasScreen extends StatelessWidget {
  const WordToLibrasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 23,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 26,
                ),
                child: LessonTopBarWidget(lifesNumber: 5, progression: 70),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                      children: List.generate(
                        4,
                        (index) => Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: index == 1
                                ? BorderSide(
                                    color: LibrinoColors.highlightLightBlue,
                                    width: 4.5,
                                  )
                                : BorderSide.none,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: Ink.image(
                                image: NetworkImage(
                                  'https://thumbs.gfycat.com/MiniatureInconsequentialIceblueredtopzebra-size_restricted.gif',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
