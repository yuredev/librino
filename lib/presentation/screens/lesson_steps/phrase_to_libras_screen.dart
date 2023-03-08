import 'package:flutter/material.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/presentation/widgets/shared/lesson_topbar_widget.dart';
import 'package:librino/presentation/widgets/shared/question_scaffold.dart';
import 'package:librino/presentation/widgets/shared/question_title.dart';
import 'package:reorderables/reorderables.dart';

class PhraseToLibrasScreen extends StatefulWidget {
  const PhraseToLibrasScreen({super.key});

  @override
  State<PhraseToLibrasScreen> createState() => _PhraseToLibrasScreenState();
}

class _PhraseToLibrasScreenState extends State<PhraseToLibrasScreen> {
  @override
  Widget build(BuildContext context) {
    return QuestionScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.defaultScreenTopMargin,
            horizontal: Sizes.defaultScreenHorizontalMargin,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: const QuestionTitleWidget('Traduza a frase'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 36),
                      child: Text('"Os cachorros comem carne"'),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 22),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: LibrinoColors.lightPurple,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.lightbulb,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Organize os sinais na ordem correta',
                            style: TextStyle(
                              fontSize: 12,
                              color: LibrinoColors.subtitleGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LayoutBuilder(
                      builder: (ctx, constraints) => ReorderableWrap(
                        spacing: 16,
                        runSpacing: 16,
                        onReorder: (oldIndex, newIndex) {},
                        needsLongPressDraggable: false,
                        buildDraggableFeedback: (ctx, consts, widget) {
                          return Material(
                            borderRadius: BorderRadius.circular(25),
                            child: Transform.scale(
                              scaleX: 1.1,
                              scaleY: 1.1,
                              child: widget,
                            ),
                          );
                        },
                        alignment: WrapAlignment.spaceBetween,
                        children: List.generate(
                          7,
                          (index) => Container(
                            clipBehavior: Clip.antiAlias,
                            width: constraints.maxWidth * .301842904,
                            height: constraints.maxWidth * .301842904,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            child: Image.network(
                              'https://thumbs.gfycat.com/MiniatureInconsequentialIceblueredtopzebra-size_restricted.gif',
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.low,
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
