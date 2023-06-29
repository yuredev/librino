import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:librino/core/constants/colors.dart';
import 'package:librino/core/constants/mappings.dart';
import 'package:librino/core/constants/sizes.dart';
import 'package:librino/core/routes.dart';
import 'package:librino/data/models/lesson/lesson.dart';
import 'package:librino/data/models/module/module.dart';
import 'package:librino/data/models/play_lesson_dto.dart';
import 'package:librino/data/models/question/question.dart';
import 'package:librino/logic/cubits/auth/auth_cubit.dart';
import 'package:librino/logic/cubits/auth/auth_state.dart';
import 'package:librino/logic/cubits/question/load_questions/load_lesson_questions_cubit.dart';
import 'package:librino/logic/cubits/question/load_questions/load_questions_state.dart';
import 'package:librino/presentation/widgets/shared/button_widget.dart';
import 'package:librino/presentation/widgets/shared/illustration_widget.dart';
import 'package:librino/presentation/widgets/shared/modal_top_bar_widget.dart';
import 'package:librino/presentation/widgets/shared/progress_bar_widget.dart';

class LessonModalWidget extends StatefulWidget {
  final Lesson lesson;
  final Module module;
  final bool readOnly;

  const LessonModalWidget(
    this.lesson, {
    super.key,
    required this.module,
    required this.readOnly,
  });

  @override
  State<LessonModalWidget> createState() => _LessonModalWidgetState();
}

class _LessonModalWidgetState extends State<LessonModalWidget> {
  late final LoadLessonQuestionsCubit loadQuestionsCubit = context.read();

  void onButtonPress(BuildContext context, List<Question> questions) async {
    final first = questions[0];

    await Navigator.pushReplacementNamed(
      context,
      lessonTypeToScreenNameMap[first.type]!,
      arguments: PlayLessonDTO(
        lives: 3,
        questions: questions,
        currentQuestion: first,
        totalQuestions: widget.lesson.questionIds.length,
        index: 0,
        lessonId: widget.lesson.id,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadQuestionsCubit.loadFromLesson(widget.lesson);
  }

  int getCompletedsCount(List<Lesson> all, List<String> completed) {
    return all.where((l) => completed.contains(l.id)).length;
  }

  void _onAddContentPress(BuildContext context) async {
    await Navigator.pushReplacementNamed(
      context,
      Routes.addLessonsToModule,
      arguments: {
        'module': widget.module,
        'hasContent': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const edgeInsets = EdgeInsets.only(
      top: Sizes.modalBottomSheetDefaultTopPadding,
      bottom: Sizes.modalBottomSheetDefaultBottomPadding,
      left: Sizes.defaultScreenHorizontalMargin,
      right: Sizes.defaultScreenHorizontalMargin,
    );
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is LoggedInState,
      builder: (context, authState) {
        final completedIds =
            (authState as LoggedInState).user.completedLessonsIds;
        return BlocBuilder<LoadLessonQuestionsCubit, LoadQuestionsState>(
          builder: (context, questionsState) {
            if (questionsState is LoadQuestionsErrorState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.62,
                child: Padding(
                  padding: edgeInsets,
                  child: Column(
                    children: [
                      ModalTopBarWidget(),
                      Container(
                        margin: const EdgeInsets.only(
                          top: Sizes.modalBottomSheetDefaultTopPadding,
                        ),
                        child: IllustrationWidget(
                          illustrationName: 'error.json',
                          isAnimation: true,
                          imageWidth: MediaQuery.of(context).size.width * 0.6,
                          title: questionsState.errorMessage,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final percentage =
                (getCompletedsCount(widget.module.lessons!, completedIds) /
                    widget.module.lessons!.length *
                    100);
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: edgeInsets,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.module.imageUrl == null
                            ? Image.asset(
                                'assets/images/generic-module.png',
                                width: MediaQuery.of(context).size.width * 0.28,
                              )
                            : Image.network(
                                widget.module.imageUrl!,
                                width: MediaQuery.of(context).size.width * 0.28,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/generic-module.png',
                                    width: MediaQuery.of(context).size.width *
                                        0.28,
                                  );
                                },
                                // loadingBuilder:
                                //     (context, child, loadingProgress) {
                                //   return ShimmerWidget(
                                //     child: GrayBarWidget(
                                //       height:
                                //           MediaQuery.of(context).size.width *
                                //               0.28,
                                //       width: MediaQuery.of(context).size.width *
                                //           0.28,
                                //     ),
                                //   );
                                // },
                              ),
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Text(
                            widget.module.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${percentage.truncate()}'
                                  '% concluído',
                                ),
                                Text(
                                  '${getCompletedsCount(widget.module.lessons!, completedIds)}/${widget.module.lessons!.length} '
                                  '${getCompletedsCount(widget.module.lessons!, completedIds) == 1 ? 'Lição concluída' : 'Lições concluídas'}',
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              child: ProgressBarWidget(
                                color: LibrinoColors.main,
                                height: 15,
                                progression: percentage,
                              ),
                            ),

                            if (percentage < 100)
                              Container(
                                margin: const EdgeInsets.only(top: 24),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Lição atual: ',
                                    style: TextStyle(
                                      color: LibrinoColors.textLightBlack,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: widget.lesson.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Exercícios na lição: ',
                                  style: TextStyle(
                                    color: LibrinoColors.textLightBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.lesson.questionIds.length
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: const EdgeInsets.only(top: 12),
                            //   child: RichText(
                            //     text: TextSpan(
                            //       text: 'Descrição: ',
                            //       style: TextStyle(
                            //         color: LibrinoColors.textLightBlack,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //       children: [
                            //         TextSpan(
                            //           text: widget.module.description,
                            //           style: TextStyle(
                            //             fontWeight: FontWeight.w400,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // Flexible(
                    //   flex: 15,
                    //   child: Container(
                    //     margin: const EdgeInsets.only(top: 24),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             // Text(
                    //             //   'Dificuldade: ',
                    //             //   style: TextStyle(
                    //             //     color: LibrinoColors.textLightBlack,
                    //             //   ),
                    //             // ),
                    //             // Icon(
                    //             //   Icons.star,
                    //             //   size: 18,
                    //             //   color: LibrinoColors.starGold,
                    //             //   shadows: [
                    //             //     BoxShadow(
                    //             //       blurRadius: 1,
                    //             //       color: Colors.black.withOpacity(0.4),
                    //             //     ),
                    //             //   ],
                    //             // ),
                    //             // Icon(
                    //             //   Icons.star,
                    //             //   size: 18,
                    //             //   color: lesson.difficulty > 0
                    //             //       ? LibrinoColors.starGold
                    //             //       : LibrinoColors.disabledGray,
                    //             //   shadows: [
                    //             //     BoxShadow(
                    //             //       blurRadius: 1,
                    //             //       color: Colors.black.withOpacity(0.4),
                    //             //     ),
                    //             //   ],
                    //             // ),
                    //             // Icon(
                    //             //   Icons.star,
                    //             //   size: 18,
                    //             //   color: lesson.difficulty > 1
                    //             //       ? LibrinoColors.starGold
                    //             //       : LibrinoColors.disabledGray,
                    //             //   shadows: [
                    //             //     BoxShadow(
                    //             //       blurRadius: 1,
                    //             //       color: Colors.black.withOpacity(0.4),
                    //             //     ),
                    //             //   ],
                    //             // ),
                    //           ],
                    //         ),

                    //       ],
                    //     ),
                    //   ),
                    // ),
                    if (authState.user.isInstructor)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ButtonWidget(
                          onPress: () => _onAddContentPress(context),
                          title: 'Adicionar conteúdo',
                          height: Sizes.defaultButtonHeight,
                          width: double.infinity,
                          leftIcon: Icon(
                            Icons.add,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    if (!widget.readOnly)
                      ButtonWidget(
                        onPress: () => questionsState is QuestionsLoadedState
                            ? onButtonPress(context, questionsState.questions)
                            : null,
                        title: 'Jogar',
                        height: Sizes.defaultButtonHeight,
                        width: double.infinity,
                        leftIcon: Icon(
                          Icons.gamepad,
                          color: authState.user.isInstructor
                              ? LibrinoColors.main
                              : null,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        loadingText: 'Carregando...',
                        isLoading: questionsState is! QuestionsLoadedState,
                        isEnabled: questionsState is QuestionsLoadedState,
                        color: authState.user.isInstructor
                            ? Colors.white
                            : LibrinoColors.main,
                        borderColor: authState.user.isInstructor
                            ? LibrinoColors.main
                            : null,
                        textColor: authState.user.isInstructor
                            ? LibrinoColors.main
                            : Colors.white,
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
